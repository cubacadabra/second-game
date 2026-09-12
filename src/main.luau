-- Portable entry point for Signal Run.
-- All relay rules and presentation stay inside this game package.

-- @include "@cubacadabra/shared-state-v1.luau"
-- @include "@cubacadabra/disclosure-v1.luau"
-- @include "relay.luau"
-- @include "ui/styles.luau"
-- @include "ui/document.luau"
-- @include "ui/actions.luau"

local SecondGame = {}
local relay = SignalRelay.create()
local signal_detail = CubaDisclosure.create({
    action = "signal.detail.toggle",
    triggerId = "signal-status",
    nodeIds = { "signal-detail" },
})

function SecondGame.on_start(api)
    api.lobby:set_status("Chain four signal gates, then fire the uplink!")
    api.ui:set_document(GameUIDocument.create())
    signal_detail:sync(api)
    SignalUI.bind(relay)
    relay:initialize(api)
end

function SecondGame.on_interaction(api, event)
    if event.phase ~= "enter" then
        return
    end
    relay:request_interaction(api, event.id)
end

function SecondGame.on_network_message(api, event)
    relay:receive(api, event)
end

function SecondGame.on_ui_event(api, event)
    signal_detail:handle(api, event)
end

function SecondGame.on_tick(api, delta_seconds)
    relay:tick(api, delta_seconds)
end

return SecondGame
