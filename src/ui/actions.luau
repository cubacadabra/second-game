local GameUIActions = {}

local shapes = {
    ["build.shape.cube"] = "cube",
    ["build.shape.beam"] = "beam",
    ["build.shape.slab"] = "slab",
}

local colors = {
    ["build.color.coral"] = "coral",
    ["build.color.butter"] = "butter",
    ["build.color.periwinkle"] = "periwinkle",
    ["build.color.ink"] = "ink",
    ["build.color.paper"] = "paper",
}

local shape_ids = { "cube", "beam", "slab" }
local color_ids = { "coral", "butter", "periwinkle", "ink", "paper" }
local beacon_count = 0

local function close_popovers(api)
    api.ui.open_popover = nil
    api.ui:set_visible("build-popover-catcher", false)
    api.ui:set_visible("build-shape-popover", false)
    api.ui:set_visible("build-color-popover", false)
end

local function open_popover(api, name)
    local should_open = api.ui.open_popover ~= name
    close_popovers(api)
    if should_open then
        api.ui.open_popover = name
        api.ui:set_visible("build-popover-catcher", true)
        api.ui:set_visible("build-" .. name .. "-popover", true)
    end
end

local function select_shape(api, shape)
    api.ui.selected_shape = shape
    for _, id in ipairs(shape_ids) do
        api.ui:set_checked("build-shape-" .. id, id == shape)
        api.ui:set_visible("build-shape-trigger-" .. id, id == shape)
    end
    close_popovers(api)
end

local function select_color(api, color)
    api.ui.selected_color = color
    for _, id in ipairs(color_ids) do
        api.ui:set_checked("build-color-" .. id, id == color)
        api.ui:set_visible("build-color-trigger-" .. id, id == color)
    end
    close_popovers(api)
end

function GameUIActions.handle(api, event)
    if event.phase ~= "activate" then
        return
    end
    if event.action == "build.shape.toggle" then
        open_popover(api, "shape")
    elseif event.action == "build.color.toggle" then
        open_popover(api, "color")
    elseif event.action == "build.popover.close" then
        close_popovers(api)
    elseif shapes[event.action] then
        select_shape(api, shapes[event.action])
    elseif colors[event.action] then
        select_color(api, colors[event.action])
    elseif event.action == "build.place" then
        beacon_count = beacon_count + 1
        local checkpoint = ((beacon_count - 1) % 4) + 1
        api.ui:set_text("second-game-status", "BEACON " .. checkpoint .. "/4")
    elseif event.action == "build.remove" then
        api.ui:set_text("second-game-status", "ROUTE EDITED")
    elseif event.action == "build.rotate" then
        api.ui:set_text("second-game-status", "TURN MARKER")
    end
end
