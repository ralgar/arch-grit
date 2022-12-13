local beautiful = require('beautiful')
local gears = require("gears")
local lain  = require("lain")
local awful = require("awful")
local wibox = require("wibox")
local dpi   = require("beautiful.xresources").apply_dpi

local markup = lain.util.markup

-- Textclock
os.setlocale(os.getenv("LANG")) -- to localize the clock
local mytextclock = wibox.widget.textclock(markup(
    beautiful.clock,  -- color
    " %H:%M "
))
mytextclock.font = beautiful.font

-- Calendar
calendar = lain.widget.cal({
    attach_to = { mytextclock },
    notification_preset = {
        font = beautiful.font,
        fg   = beautiful.fg_normal,
        bg   = beautiful.bg_normal
    }
})

-- Weather
--[[ to be set before use
weather = lain.widget.weather({
    city_id = 2643743, -- placeholder (London)
    notification_preset = { font = beautiful.font, fg = beautiful.fg_normal },
    weather_na_markup = markup.fontfg(beautiful.font, beautiful.weather, "N/A "),
    settings = function()
        descr = weather_now["weather"][1]["description"]:lower()
        units = math.floor(weather_now["main"]["temp"])
        widget:set_markup(markup.fontfg(
            beautiful.font,
            beautiful.weather,  -- color
            " " .. descr .. " @ " .. units .. "°C "))
    end
})
--]]

-- / fs
--[[ commented because it needs Gio/Glib >= 2.54
fs = lain.widget.fs({
    notification_preset = { font = beautiful.font, fg = beautiful.fg_normal },
    settings  = function()
        widget:set_markup(markup.fontfg(
            beautiful.font,
            beautiful.fs,  -- color
            " " .. string.format("%.1f", fs_now["/"].used) .. "% "))
    end
})
--]]

-- Mail IMAP check
--[[ to be set before use
mail = lain.widget.imap({
    timeout  = 180,
    server   = "server",
    mail     = "mail",
    password = "keyring get mail",
    settings = function()
        if mailcount > 0 then
            widget:set_markup(markup.fontfg(
                beautiful.font,
                beautiful.mail,  -- color
                " " .. mailcount .. " "))
        else
            widget:set_text("No mail")
        end
    end
})
--]]

-- CPU
local cpu = lain.widget.cpu({
    settings = function()
        widget:set_markup(markup.fontfg(
            beautiful.font,
            beautiful.cpu_load,  -- color
            " " .. cpu_now.usage .. "% "))
    end
})

-- Coretemp
local temp = lain.widget.temp({
    settings = function()
        widget:set_markup(markup.fontfg(
            beautiful.font,
            beautiful.cpu_temp,  -- color
            " " .. coretemp_now .. "°C "))
    end
})

-- Battery
local bat = lain.widget.bat({
    settings = function()
        local perc = bat_now.perc ~= "N/A" and bat_now.perc .. "%" or bat_now.perc

        if bat_now.ac_status == 1 then
            perc = " " .. perc
        else
            perc = " " .. perc
        end

        widget:set_markup(markup.fontfg(
            beautiful.font,
            beautiful.battery,  -- color
            perc .. " ")
        )
    end
})

-- ALSA volume
volume = lain.widget.alsa({
    settings = function()
        if volume_now.status == "off" then
            volume_now.level = volume_now.level .. "M"
        end

        widget:set_markup(markup.fontfg(
            beautiful.font,
            beautiful.volume,  -- color
            "墳 " .. volume_now.level .. "% "))
    end
})

-- Net
local netdowninfo = wibox.widget.textbox()
local netupinfo = lain.widget.net({
    settings = function()
        --[[ uncomment if using the weather widget
        if iface ~= "network off" and
           string.match(weather.widget.text, "N/A")
        then
            weather.update()
        end
        --]]

        widget:set_markup(markup.fontfg(
            beautiful.font,
            beautiful.net_up,  -- color
            "祝 " .. net_now.sent .. " ")
        )
        netdowninfo:set_markup(markup.fontfg(
            beautiful.font,
            beautiful.net_down,  -- color
            " " .. net_now.received .. " ")
        )
    end
})

-- MEM
local memory = lain.widget.mem({
    settings = function()
        widget:set_markup(markup.fontfg(
            beautiful.font,
            beautiful.memory,  -- color
            "﬙ " .. mem_now.used .. "M "))
    end
})

-- MPD
mpd = lain.widget.mpd({
    settings = function()
        mpd_notification_preset = {
            text = string.format("%s [%s] - %s\n%s", mpd_now.artist,
                   mpd_now.album, mpd_now.date, mpd_now.title)
        }

        if mpd_now.state == "play" then
            artist = mpd_now.artist .. " > "
            title  = mpd_now.title .. " "
        elseif mpd_now.state == "pause" then
            artist = "mpd "
            title  = "paused "
        else
            artist = ""
            title  = ""
        end
        widget:set_markup(markup.fontfg(
            beautiful.font,
            beautiful.mpd_artist,  -- color
            " " .. artist) ..
        markup.fontfg(
            beautiful.font,
            beautiful.mpd_title,  -- color
            title))
    end
})

function at_screen_connect(s)
    -- Quake application
    s.quake = lain.util.quake({ app = awful.util.terminal })

    -- If wallpaper is a function, call it with the screen
    local wallpaper = beautiful.wallpaper
    if type(wallpaper) == "function" then
        wallpaper = wallpaper(s)
    end
    gears.wallpaper.maximized(wallpaper, s, true)

    -- Tags
    awful.tag(awful.util.tagnames, s, awful.layout.layouts)

    -- Create a taglist widget
    taglist = awful.widget.taglist(
        s,
        awful.widget.taglist.filter.all,
        awful.util.taglist_buttons
    )

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, awful.util.tasklist_buttons)

    -- Create the wibox
    s.mywibox = awful.wibar({ position = "top", screen = s, height = dpi(24), bg = beautiful.bg_normal, fg = beautiful.fg_normal })

    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        expand = 'none',
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            spacing = dpi(5),
            mpd.widget,
        },
        mytextclock,
        --nil,
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            spacing = dpi(5),
            wibox.widget.systray(),
            --mail.widget,
            netdowninfo,
            netupinfo.widget,
            volume.widget,
            memory.widget,
            cpu.widget,
            --fs.widget,
            --weather.widget,
            temp.widget,
            bat.widget,
        },
    }

    -- Create the bottom wibox
    s.mybottomwibox = awful.wibar({ position = "bottom", screen = s, border_width = 0, height = dpi(24), bg = beautiful.bg_normal, fg = beautiful.fg_normal })

    --local taglist   = require('widget.taglist')
    local layoutbox = require('widget.layoutbox')

    -- Add widgets to the bottom wibox
    s.mybottomwibox:setup {
        layout = wibox.layout.align.horizontal,
        expand = 'none',
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            taglist,
        },
        s.mytasklist, -- Middle widget
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            layoutbox,
        },
    }
end
