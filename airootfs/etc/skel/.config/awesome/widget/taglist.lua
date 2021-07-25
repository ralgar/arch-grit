local awful = require('awful')
local modkey = require('config.keys.mod').mod_key

-- Tags
local tags = awful.tag(awful.util.tagnames, s, awful.layout.layouts)

-- Create a taglist widget
local taglist = function(s)
    awful.widget.taglist(
    s,
    tags.filter.all,
    awful.util.table.join(
        awful.button({ }, 1, function(t) t:view_only() end),
        awful.button({ modkey }, 1, function(t)
            if client.focus then client.focus:move_to_tag(t) end
        end),
        awful.button({ }, 3, awful.tag.viewtoggle),
        awful.button({ modkey }, 3, function(t)
            if client.focus then client.focus:toggle_tag(t) end
        end),
        awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
        awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
    ))
    return awful.widget.taglist
end

return taglist
