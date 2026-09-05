local GameUIDocument = {}

local function shape_trigger(id, icon, visible)
    return {
        id = id,
        kind = "button",
        icon = icon,
        action = "build.shape.toggle",
        visible = visible,
        visibleIn = { "real-game" },
        layout = { region = "header", width = 56, height = 56 },
        style = GameUIStyles.control_style("#1A2152F7", "#57E5D0FF"),
    }
end

local function color_trigger(id, label, background, foreground, visible)
    return {
        id = id,
        kind = "button",
        icon = "colorswap",
        action = "build.color.toggle",
        visible = visible,
        visibleIn = { "real-game" },
        layout = { region = "header", width = 56, height = 56 },
        style = GameUIStyles.control_style(background, "#57E5D0FF", foreground),
    }
end

local function shape_choice(id, icon, label, checked)
    return {
        id = "build-shape-" .. id,
        kind = "button",
        icon = icon,
        text = label,
        action = "build.shape." .. id,
        checked = checked,
        layout = { width = 96, height = 88 },
        style = GameUIStyles.control_style("#20295DFF", "#57E5D0FF", "#F7F5E9FF", 16),
    }
end

local function color_choice(id, background, foreground, checked)
    return {
        id = "build-color-" .. id,
        kind = "button",
        action = "build.color." .. id,
        checked = checked,
        layout = { width = 56, height = 56 },
        style = GameUIStyles.control_style(background, "#57E5D0FF", foreground, 18),
    }
end

function GameUIDocument.create()
    return {
        nodes = {
            shape_trigger("build-shape-trigger-cube", "cube", false),
            shape_trigger("build-shape-trigger-beam", "beam", true),
            shape_trigger("build-shape-trigger-slab", "slab", false),

            color_trigger("build-color-trigger-coral", "orange", "#FF8A3DFF", "#0B102BFF", false),
            color_trigger("build-color-trigger-butter", "acid", "#F1E95BFF", "#0B102BFF", false),
            color_trigger("build-color-trigger-periwinkle", "violet", "#9F7BFFFF", "#F7F5E9FF", true),
            color_trigger("build-color-trigger-ink", "midnight", "#171B43FF", "#F7F5E9FF", false),
            color_trigger("build-color-trigger-paper", "warm white", "#F7F5E9FF", "#0B102BFF", false),

            -- This transparent outside-tap target closes either selector
            -- without visually obscuring the world.
            {
                id = "build-popover-catcher",
                kind = "modal",
                action = "build.popover.close",
                blocksInput = true,
                visible = false,
                visibleIn = { "real-game" },
                layout = { width = "fill", height = "fill", ignoreSafeArea = true },
            },
            {
                id = "build-shape-popover",
                kind = "menu",
                blocksInput = true,
                visible = false,
                visibleIn = { "real-game" },
                layout = {
                    anchor = "topLeft",
                    width = 336,
                    height = 136,
                    offset = { 316, 88 },
                    padding = 12,
                    direction = "column",
                    align = "stretch",
                    gap = 8,
                },
                style = GameUIStyles.popover_style(),
                children = {
                    {
                        id = "build-shape-title",
                        kind = "text",
                        text = "CHOOSE A SHAPE",
                        layout = { width = "fill", height = 20 },
                        style = { fontSize = 15, foreground = "#F7F5E9FF" },
                    },
                    {
                        id = "build-shape-options",
                        kind = "stack",
                        layout = { width = "fill", height = 88, direction = "row", align = "center", gap = 10 },
                        children = {
                            shape_choice("cube", "cube", "CUBE", false),
                            shape_choice("beam", "beam", "BEAM", true),
                            shape_choice("slab", "slab", "SLAB", false),
                        },
                    },
                },
            },
            {
                id = "build-color-popover",
                kind = "menu",
                blocksInput = true,
                visible = false,
                visibleIn = { "real-game" },
                layout = {
                    anchor = "topLeft",
                    width = 336,
                    height = 108,
                    offset = { 380, 88 },
                    padding = 12,
                    direction = "column",
                    align = "stretch",
                    gap = 8,
                },
                style = GameUIStyles.popover_style(),
                children = {
                    {
                        id = "build-color-title",
                        kind = "text",
                        text = "CHOOSE A COLOR",
                        layout = { width = "fill", height = 20 },
                        style = { fontSize = 15, foreground = "#F7F8EEFF" },
                    },
                    {
                        id = "build-color-options",
                        kind = "stack",
                        layout = { width = "fill", height = 56, direction = "row", align = "center", gap = 7 },
                        children = {
                            color_choice("coral", "#FF8A3DFF", "#0B102BFF", false),
                            color_choice("butter", "#F1E95BFF", "#0B102BFF", false),
                            color_choice("periwinkle", "#9F7BFFFF", "#F7F5E9FF", true),
                            color_choice("ink", "#171B43FF", "#F7F5E9FF", false),
                            color_choice("paper", "#F7F5E9FF", "#0B102BFF", false),
                        },
                    },
                },
            },

            {
                id = "build-context",
                kind = "panel",
                visibleIn = { "real-game" },
                layout = {
                    region = "bottomCenter",
                    width = "auto",
                    height = 68,
                    padding = 5,
                    direction = "row",
                    align = "center",
                    gap = 8,
                },
                style = {
                    background = "#0B102BE8",
                    borderColor = "#B7F7E466",
                    borderWidth = 2,
                    cornerRadius = 18,
                },
                children = {
                    {
                        id = "second-game-label",
                        kind = "stack",
                        layout = { width = 116, height = 58, direction = "column", align = "start", gap = 2 },
                        children = {
                            {
                                id = "second-game-name",
                                kind = "text",
                                text = "SIGNAL RUN",
                                layout = { width = "fill", height = 22 },
                                style = { fontSize = 14, foreground = "#57E5D0FF" },
                            },
                            {
                                id = "second-game-status",
                                kind = "text",
                                text = "DROP BEACON 0/4",
                                layout = { width = "fill", height = 30 },
                                style = { fontSize = 11, foreground = "#F7F5E9FF" },
                            },
                        },
                    },
                    {
                        id = "build-place",
                        kind = "button",
                        icon = "place",
                        action = "build.place",
                        layout = { width = 58, height = 58 },
                        style = GameUIStyles.control_style("#57E5D0FF", "#57E5D0FF", "#0B102BFF", 18),
                    },
                    {
                        id = "build-rotate",
                        kind = "button",
                        icon = "rotate",
                        action = "build.rotate",
                        layout = { width = 58, height = 58 },
                        style = GameUIStyles.control_style("#20295DFF", "#57E5D0FF", "#F7F5E9FF", 18),
                    },
                    {
                        id = "build-remove",
                        kind = "button",
                        icon = "trash",
                        action = "build.remove",
                        layout = { width = 58, height = 58 },
                        style = GameUIStyles.control_style("#B64C6FFF", "#FF8A3DFF", "#F7F5E9FF", 18),
                    },
                },
            },
            {
                id = "player-joystick",
                kind = "joystick",
                action = "player.move",
                layout = { anchor = "bottomLeft", width = 120, height = 120, offset = { 20, -24 } },
                style = {
                    background = "#0B102BC9",
                    borderColor = "#B7F7E455",
                    borderWidth = 2,
                    cornerRadius = 60,
                    accent = "#57E5D0FF",
                },
            },
            {
                id = "player-jump",
                kind = "button",
                text = "JUMP",
                action = "player.jump",
                layout = { anchor = "bottomRight", width = 86, height = 44, offset = { -22, -84 } },
                style = GameUIStyles.control_style("#1A2152E8", "#57E5D0FF", "#F7F5E9FF", 14),
            },
            {
                id = "player-run",
                kind = "button",
                text = "RUN",
                action = "player.run",
                layout = { anchor = "bottomRight", width = 86, height = 44, offset = { -22, -30 } },
                style = GameUIStyles.control_style("#1A2152E8", "#57E5D0FF", "#F7F5E9FF", 14),
            },
        },
    }
end
