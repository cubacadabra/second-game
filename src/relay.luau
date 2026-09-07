local SignalRelay = {}
SignalRelay.__index = SignalRelay

local STATE_CHANNEL = "signal-run-round"
local OVERDRIVE_SECONDS = 5.5
local NODE_IDS = { "node-1", "node-2", "node-3", "node-4" }
local NODE_POSITIONS = {
    { -15, 0, 10 },
    { 15, 0, 1 },
    { -15, 0, -8 },
    { 15, 0, -17 },
}
local UPLINK_POSITION = { 0, 0, -31 }

local function copy_captured(source)
    local result = {}
    if type(source) ~= "table" then
        return result
    end
    for _, id in ipairs(NODE_IDS) do
        if source[id] == true then
            result[id] = true
        end
    end
    return result
end

local function empty_payload(round, links)
    return {
        version = 1,
        round = round,
        phase = "running",
        nextNode = 1,
        captured = {},
        links = links,
        lastAction = { type = "round_reset", round = round },
    }
end

local function node_index(id)
    for index, node_id in ipairs(NODE_IDS) do
        if id == node_id then
            return index
        end
    end
    return nil
end

function SignalRelay.create()
    return setmetatable({
        round = 1,
        phase = "running",
        nextNode = 1,
        captured = {},
        links = 0,
        sequence = 0,
        message = "Follow the pulsing gate. The relay is shared.",
        hasSnapshot = false,
        pendingNode = nil,
        pendingUplink = false,
        resetPending = false,
        resetRetrySeconds = 0,
        overdriveSeconds = 0,
    }, SignalRelay)
end

function SignalRelay:node_count()
    return #NODE_IDS
end

function SignalRelay:node_id(index)
    return NODE_IDS[index]
end

function SignalRelay:has_pending_action()
    return self.pendingNode ~= nil or self.pendingUplink or self.resetPending
end

function SignalRelay:sync_effects(api)
    for index, id in ipairs(NODE_IDS) do
        local state = "locked"
        if self.captured[id] then
            state = "captured"
        elseif self.phase == "running" and self.nextNode == index then
            state = "active"
        end
        api.effects:set_state(id, state)
    end

    local uplink_state = "locked"
    if self.phase == "uplink" then
        uplink_state = "active"
    elseif self.phase == "overdrive" then
        uplink_state = "overdrive"
    end
    api.effects:set_state("uplink", uplink_state)
end

function SignalRelay:submit(api)
    if self.resetPending then
        api.network:compare_set_state(
            STATE_CHANNEL,
            self.sequence,
            empty_payload(self.round + 1, self.links)
        )
        self.resetRetrySeconds = 0.75
        return
    end

    local next_captured = copy_captured(self.captured)
    local next_node = self.nextNode
    local next_phase = self.phase
    local next_links = self.links
    local last_action = nil

    if self.pendingNode ~= nil and next_phase == "running" and self.pendingNode == next_node then
        local id = NODE_IDS[next_node]
        next_captured[id] = true
        last_action = { type = "capture", node = next_node }
        next_node = next_node + 1
        if next_node > #NODE_IDS then
            next_phase = "uplink"
        end
    elseif self.pendingUplink and next_phase == "uplink" then
        next_phase = "overdrive"
        next_links = next_links + 1
        last_action = { type = "uplink" }
    else
        return
    end

    api.network:compare_set_state(STATE_CHANNEL, self.sequence, {
        version = 1,
        round = self.round,
        phase = next_phase,
        nextNode = next_node,
        captured = next_captured,
        links = next_links,
        lastAction = last_action,
    })
end

function SignalRelay:initialize(api)
    api.network:compare_set_state(STATE_CHANNEL, 0, empty_payload(1, 0))
    self:sync_effects(api)
end

function SignalRelay:request_interaction(api, id)
    if id == "uplink" then
        if self.phase == "uplink" and not self.pendingUplink then
            self.pendingUplink = true
            self.message = "Firing the shared uplink..."
            self:submit(api)
        elseif self.phase == "running" then
            self.message = string.format("UPLINK LOCKED • FIND NODE %02d", self.nextNode)
        end
        return
    end

    local index = node_index(id)
    if index == nil or self.phase ~= "running" then
        return
    end
    if index ~= self.nextNode then
        if self.captured[id] then
            self.message = string.format("NODE %02d ALREADY LINKED", index)
        else
            self.message = string.format("NODE %02d LOCKED • FIND NODE %02d", index, self.nextNode)
        end
        return
    end
    if self.pendingNode ~= nil then
        return
    end

    self.pendingNode = index
    self.message = string.format("Linking node %02d...", index)
    self:submit(api)
end

function SignalRelay:apply_snapshot(api, event)
    local payload = event.payload
    local sequence = event.sequence
    if type(payload) ~= "table" or payload.version ~= 1 or type(sequence) ~= "number" then
        return
    end
    if self.hasSnapshot and sequence < self.sequence then
        return
    end
    if self.hasSnapshot and sequence == self.sequence then
        if self:has_pending_action() then
            self:submit(api)
        end
        return
    end
    if type(payload.round) ~= "number" or payload.round < 1 then
        return
    end
    if type(payload.nextNode) ~= "number" or payload.nextNode < 1 or payload.nextNode > #NODE_IDS + 1 then
        return
    end
    if payload.phase ~= "running" and payload.phase ~= "uplink" and payload.phase ~= "overdrive" then
        return
    end

    local previous_round = self.round
    local previous_phase = self.phase
    local previous_captured = self.captured
    local next_captured = copy_captured(payload.captured)
    local next_links = type(payload.links) == "number" and math.max(0, payload.links) or 0

    for index, id in ipairs(NODE_IDS) do
        local should_animate = self.hasSnapshot or self.pendingNode == index
        if should_animate and next_captured[id] and not previous_captured[id] then
            if index == 2 then
                api.audio:play("relay-chain")
            elseif index == 4 then
                api.audio:play("uplink-ready")
            else
                api.audio:play("relay-hit")
            end
            api.effects:play("relay-capture", { position = NODE_POSITIONS[index] })
        end
    end
    local entered_overdrive = payload.phase == "overdrive" and previous_phase ~= "overdrive"
    if (self.hasSnapshot or self.pendingUplink) and entered_overdrive then
        api.audio:play("relay-overdrive")
        api.effects:play("overdrive-burst", { position = UPLINK_POSITION })
    end

    self.round = payload.round
    self.phase = payload.phase
    self.nextNode = payload.nextNode
    self.captured = next_captured
    self.links = next_links
    self.sequence = sequence
    self.hasSnapshot = true

    if self.pendingNode ~= nil and (self.captured[NODE_IDS[self.pendingNode]] or self.phase ~= "running") then
        self.pendingNode = nil
    end
    if self.phase ~= "uplink" then
        self.pendingUplink = false
    end

    if self.round ~= previous_round then
        self.resetPending = false
        self.message = "New relay! Follow node 01."
    elseif self.phase == "overdrive" then
        self.message = "Signal locked! The whole relay is live."
    elseif self.phase == "uplink" and previous_phase ~= "uplink" then
        self.message = "All nodes linked! Sprint to the uplink."
    elseif type(payload.lastAction) == "table" and payload.lastAction.type == "capture" then
        self.message = string.format("Node %02d linked • next node %02d", payload.lastAction.node, self.nextNode)
    end

    if self.phase == "overdrive" then
        local age_seconds = type(event.ageMs) == "number" and math.max(0, event.ageMs / 1000) or 0
        self.overdriveSeconds = math.max(0, OVERDRIVE_SECONDS - age_seconds)
    else
        self.overdriveSeconds = 0
    end

    self:sync_effects(api)
    if self:has_pending_action() then
        self:submit(api)
    end
end

function SignalRelay:tick(api, delta_seconds)
    if self.phase ~= "overdrive" then
        return
    end
    self.overdriveSeconds = math.max(0, self.overdriveSeconds - delta_seconds)
    if self.overdriveSeconds > 0 then
        return
    end

    if not self.resetPending then
        self.resetPending = true
        self:submit(api)
        return
    end

    self.resetRetrySeconds = self.resetRetrySeconds - delta_seconds
    if self.resetRetrySeconds <= 0 then
        self:submit(api)
    end
end
