local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local dpi   = require("beautiful.xresources").apply_dpi

local theme                    = {}
theme.confdir                  = os.getenv("HOME") .. "/.config/awesome/themes/onedark"
theme.wallpaper                = theme.confdir .. "/wallpaper.jpg"
theme.font                     = "MesloLGS NF 10"
theme.bg_normal                = "#121417"
theme.bg_focus                 = "#1e2127"
theme.bg_urgent                = "#121417"
theme.fg_normal                = "#5c6370"
theme.fg_focus                 = "#abb2bf"
theme.fg_urgent                = "#e06c75"
theme.fg_minimize              = "#3e4452"
theme.border_width             = dpi(2)
theme.border_normal            = "#3e4452"
theme.border_focus             = "#5c6370"
theme.border_marked            = "#61afaf"
theme.tasklist_plain_task_name = true
theme.tasklist_disable_icon    = false
theme.useless_gap              = 5
theme.corner_radius            = 9

theme.mpd_artist = "#e06c75"
theme.mpd_title  = "#3e4452"
theme.clock      = "#56b6c2"
theme.net_down   = "#98c379"
theme.net_up     = "#e06c75"
theme.volume     = "#61afef"
theme.memory     = "#e5c07b"
theme.cpu_load   = "#e06c75"
theme.cpu_temp   = "#d19a66"
theme.battery    = "#abb2bf"
theme.weather    = "#abb2bf"
theme.fs         = "#abb2bf"
theme.mail       = "#abb2bf"

theme.taglist_squares_sel      = theme.confdir .. "/icons/square_a.png"
theme.taglist_squares_unsel    = theme.confdir .. "/icons/square_b.png"
theme.layout_tile              = theme.confdir .. "/icons/tile.png"
theme.layout_tilegaps          = theme.confdir .. "/icons/tilegaps.png"
theme.layout_tileleft          = theme.confdir .. "/icons/tileleft.png"
theme.layout_tilebottom        = theme.confdir .. "/icons/tilebottom.png"
theme.layout_tiletop           = theme.confdir .. "/icons/tiletop.png"
theme.layout_fairv             = theme.confdir .. "/icons/fairv.png"
theme.layout_fairh             = theme.confdir .. "/icons/fairh.png"
theme.layout_spiral            = theme.confdir .. "/icons/spiral.png"
theme.layout_dwindle           = theme.confdir .. "/icons/dwindle.png"
theme.layout_max               = theme.confdir .. "/icons/max.png"
theme.layout_fullscreen        = theme.confdir .. "/icons/fullscreen.png"
theme.layout_magnifier         = theme.confdir .. "/icons/magnifier.png"
theme.layout_floating          = theme.confdir .. "/icons/floating.png"

return theme
