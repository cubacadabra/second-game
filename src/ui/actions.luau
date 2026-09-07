local SignalUI = {}

local function route_text(relay)
    local state = relay:state()
    local parts = {}
    for index = 1, relay:node_count() do
        local label = string.format("%02d", index)
        if index < state.nextNode then
            parts[index] = "X" .. label
        elseif state.phase == "running" and state.nextNode == index then
            parts[index] = ">" .. label .. "<"
        else
            parts[index] = label
        end
    end

    local uplink = "UPLINK"
    if state.phase == "uplink" then
        uplink = ">UPLINK<"
    elseif state.phase == "overdrive" then
        uplink = "XUPLINK"
    end
    return table.concat(parts, "  ") .. "  " .. uplink
end

function SignalUI.update(api, relay)
    local state = relay:state()
    local status
    local help = relay.message
    if state.phase == "overdrive" then
        status = "OVERDRIVE"
        help = string.format("Relay linked! Reset in %.1fs.", relay:remaining_seconds())
    elseif state.phase == "uplink" then
        status = "UPLINK OPEN"
    else
        status = string.format("NODE %02d / %02d", state.nextNode, relay:node_count())
    end

    api.ui:set_text("signal-kicker", string.format("SIGNAL RUN • %d LINKS", state.links))
    api.ui:set_text("signal-status", status)
    api.ui:set_text("signal-route", route_text(relay))
    api.ui:set_text("signal-help", help)
end
