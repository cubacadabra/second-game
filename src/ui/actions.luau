local SignalUI = {}

local function route_text(relay)
    local parts = {}
    for index = 1, relay:node_count() do
        local label = string.format("%02d", index)
        if relay.captured[relay:node_id(index)] then
            parts[index] = "X" .. label
        elseif relay.phase == "running" and relay.nextNode == index then
            parts[index] = ">" .. label .. "<"
        else
            parts[index] = label
        end
    end

    local uplink = "UPLINK"
    if relay.phase == "uplink" then
        uplink = ">UPLINK<"
    elseif relay.phase == "overdrive" then
        uplink = "XUPLINK"
    end
    return table.concat(parts, "  ") .. "  " .. uplink
end

function SignalUI.update(api, relay)
    local status
    local help = relay.message
    if relay.phase == "overdrive" then
        status = "OVERDRIVE"
        help = string.format("Relay linked! Reset in %.1fs.", relay.overdriveSeconds)
    elseif relay.phase == "uplink" then
        status = "UPLINK OPEN"
    else
        status = string.format("NODE %02d / %02d", relay.nextNode, relay:node_count())
    end

    api.ui:set_text("signal-kicker", string.format("SIGNAL RUN • %d LINKS", relay.links))
    api.ui:set_text("signal-status", status)
    api.ui:set_text("signal-route", route_text(relay))
    api.ui:set_text("signal-help", help)
end
