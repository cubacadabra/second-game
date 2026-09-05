local GameUIStyles = {}

GameUIStyles.colors = {
    ink = "#0B102BF5",
    inkRaised = "#1A2152F7",
    keyline = "#B7F7E4A8",
    paper = "#F7F5E9FF",
    blue = "#57E5D0FF",
    coral = "#FF8A3DFF",
}

function GameUIStyles.control_style(background, accent, foreground, radius)
    return {
        background = background,
        borderColor = "#070B20B8",
        borderWidth = 3,
        cornerRadius = radius or 17,
        foreground = foreground or GameUIStyles.colors.paper,
        accent = accent or GameUIStyles.colors.blue,
        textAlign = "center",
        fontSize = 14,
    }
end

function GameUIStyles.popover_style()
    return {
        background = GameUIStyles.colors.inkRaised,
        borderColor = GameUIStyles.colors.keyline,
        borderWidth = 2,
        cornerRadius = 20,
        foreground = GameUIStyles.colors.paper,
    }
end
