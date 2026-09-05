-- Portable entry point for the second-game package.
--
-- The build step expands these includes into one sandboxed Luau chunk for the
-- shared Rust runtime. Keeping the includes explicit makes load order visible
-- without requiring a runtime filesystem or module loader.

-- @include "ui/styles.luau"
-- @include "ui/document.luau"
-- @include "ui/actions.luau"

local SecondGame = {}

function SecondGame.on_start(api)
    api.lobby:set_status("SECOND GAME: step onto DROP SIGNAL to start the relay")
    api.ui.selected_shape = "beam"
    api.ui.selected_color = "periwinkle"
    api.ui.open_popover = nil
    api.ui:set_document(GameUIDocument.create())
    api.ui:set_text("second-game-status", "DROP BEACON 0/4")
end

function SecondGame.on_ui_event(api, event)
    GameUIActions.handle(api, event)
end

function SecondGame.on_tick(_api, _delta_seconds)
    -- The relay route and its collision geometry live in the manifest. The
    -- shared host still owns movement, launch timing, and multiplayer state.
end

return SecondGame
