---@module 'hl'

-- 1. Default Fallbacks (Catppuccin Mocha)
local color1 = "rgba(cba6f7ff)"
local color2 = "rgba(89b4faff)"

-- 2. Ingest Dynamic Colors from Wallust Cache
local home = os.getenv("HOME") or "/home/subhro"
local cache_file = io.open(home .. "/.cache/wallust/colors-hyprland.conf", "r")

if cache_file then
    for line in cache_file:lines() do
        local key, val = line:match("^%s*%$([%w_]+)%s*=%s*(.-)%s*$")
        if val then
            -- Normalize 'rgb(HEX)' -> 'rgba(HEXff)' for the CColor parser
            local hex = val:match("rgb%((%x+)%)") or val:match("rgba%((%x+)%)")
            if hex then
                val = string.format("rgba(%sff)", hex:gsub("ff$", ""))
            end

            if key == "color1" then
                color1 = val
            elseif key == "color2" then
                color2 = val
            end
        end
    end
    cache_file:close()
end

-- 3. Core Theme Configuration with Animated Gradient
hl.config({
    general = {
        gaps_in = 6,
        gaps_out = 14,
        border_size = 2,
        ["col.active_border"] = {
            colors = { color1, color2 },
            angle = 45,
        },
        ["col.inactive_border"] = "rgba(31324444)",
        layout = "dwindle",
    },
    decoration = {
        rounding = 14,
        blur = {
            enabled = true,
            size = 6,
            passes = 3,
        },
        shadow = {
            enabled = true,
            range = 30,
            color = "rgba(00000099)",
        },
    },
})

-- 4. Infinite Rotating Gradient Border Animation
hl.animation({
    leaf = "borderangle",
    enabled = true,
    speed = 30,
    bezier = "liner",
    style = "loop",
})