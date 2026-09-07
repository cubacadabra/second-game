local GameUIDocument = {}

function GameUIDocument.create()
    return {
        nodes = {
            {
                id = "signal-header",
                kind = "panel",
                visibleIn = { "relay-yard" },
                layout = {
                    anchor = "top",
                    width = "90%",
                    maxWidth = 430,
                    height = 112,
                    offset = { 0, 74 },
                    padding = 10,
                    direction = "column",
                    align = "stretch",
                    gap = 3,
                },
                style = GameUIStyles.panel_style(),
                children = {
                    {
                        id = "signal-kicker",
                        kind = "text",
                        text = "SIGNAL RUN • 0 LINKS",
                        layout = { width = "fill", height = 18 },
                        style = { fontSize = 12, foreground = GameUIStyles.colors.signal },
                    },
                    {
                        id = "signal-status",
                        kind = "text",
                        text = "NODE 01 / 04",
                        layout = { width = "fill", height = 24 },
                        style = { fontSize = 17, foreground = GameUIStyles.colors.paper },
                    },
                    {
                        id = "signal-route",
                        kind = "text",
                        text = ">01<  02  03  04  UPLINK",
                        layout = { width = "fill", height = 18 },
                        style = { fontSize = 11, foreground = GameUIStyles.colors.hot },
                    },
                    {
                        id = "signal-help",
                        kind = "text",
                        text = "Follow the pulsing gate. The relay is shared.",
                        layout = { width = "fill", height = 26 },
                        style = { fontSize = 11, foreground = GameUIStyles.colors.quiet },
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
                    borderColor = "#57E5D055",
                    borderWidth = 2,
                    cornerRadius = 60,
                    accent = GameUIStyles.colors.signal,
                },
            },
            {
                id = "player-jump",
                kind = "button",
                text = "JUMP",
                action = "player.jump",
                layout = { anchor = "bottomRight", width = 86, height = 44, offset = { -22, -84 } },
                style = GameUIStyles.control_style(),
            },
            {
                id = "player-run",
                kind = "button",
                text = "RUN",
                action = "player.run",
                layout = { anchor = "bottomRight", width = 86, height = 44, offset = { -22, -30 } },
                style = GameUIStyles.control_style(),
            },
        },
    }
end
