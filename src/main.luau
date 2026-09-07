-- Portable entry point for Signal Run.
-- All relay rules and presentation stay inside this game package.

-- @include "@cubacadabra/shared-state-v1.luau"
-- @include "relay.luau"
-- @include "ui/styles.luau"
-- @include "ui/document.luau"
-- @include "ui/actions.luau"

local SecondGame = {}
local relay = SignalRelay.create()

function SecondGame.on_start(api)
    api.lobby:set_status("Chain four signal gates, then fire the uplink!")
    api.ui:set_document(GameUIDocument.create())
    relay:initialize(api)
    SignalUI.update(api, relay)
end

function SecondGame.on_interaction(api, event)
    if event.phase ~= "enter" then
        return
    end
    relay:request_interaction(api, event.id)
    SignalUI.update(api, relay)
end

function SecondGame.on_network_message(api, event)
    if relay:receive(api, event) then
        SignalUI.update(api, relay)
    end
end

function SecondGame.on_ui_event(_api, _event)
    -- Movement actions are handled by the shared host.
end

function SecondGame.on_tick(api, delta_seconds)
    relay:tick(api, delta_seconds)
    SignalUI.update(api, relay)
end

return SecondGame
