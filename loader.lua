-- OR4CLE — loader.lua
local BASE = "https://raw.githubusercontent.com/OzLL-BeeP/or4cle-steal-an-egg/main/"

local function fetch(path)
    local ok, res = pcall(function() return game:HttpGet(BASE .. path) end)
    if not ok or not res or #res < 10 then
        warn("[OR4CLE] fetch gagal: " .. path .. " — " .. tostring(res))
        return nil
    end
    return res
end

local function compile(src, name)
    if not src then return nil end
    local fn, err
    if typeof(loadstring) == "function" then
        fn, err = loadstring(src, name or "or4cle")
    elseif typeof(load) == "function" then
        fn, err = load(src, name or "or4cle")
    end
    if not fn then
        warn("[OR4CLE] compile gagal: " .. tostring(name) .. " — " .. tostring(err))
        return nil
    end
    return fn
end

local function safeLoad(path)
    local src = fetch(path)
    local fn = compile(src, path)
    if not fn then return nil end
    local ok, res = pcall(fn)
    if not ok then
        warn("[OR4CLE] run gagal: " .. path .. " — " .. tostring(res))
        return nil
    end
    return res
end

local CONFIG = safeLoad("config.lua")
if not CONFIG then
    warn("[OR4CLE] config gagal load — abort")
    return
end

local UTIL = safeLoad("util.lua")
if not UTIL then
    warn("[OR4CLE] util gagal load — abort")
    return
end

local OR4CLE = {
    config   = CONFIG,
    util     = UTIL,
    modules  = {},
    registry = {},
    version  = CONFIG.VERSION,
    loaded   = false,
}
_G.OR4CLE = OR4CLE

-- UI chain
OR4CLE.ui = {
    bubble  = safeLoad("ui/bubble.lua"),
    window  = safeLoad("ui/window.lua"),
    sidebar = safeLoad("ui/sidebar.lua"),
    tabs    = safeLoad("ui/tabs.lua"),
    content = safeLoad("ui/content.lua"),
}
OR4CLE.components = {
    toggle        = safeLoad("ui/components/toggle.lua"),
    button        = safeLoad("ui/components/button.lua"),
    section       = safeLoad("ui/components/section.lua"),
    option_picker = safeLoad("ui/components/option_picker.lua"),
    search_box    = safeLoad("ui/components/search_box.lua"),
    checklist     = safeLoad("ui/components/checklist.lua"),
    text_input    = safeLoad("ui/components/text_input.lua"),
}

-- Modules
for _, n in ipairs({
    "esp_egg","auto_steal","auto_hatch","auto_place","auto_treadmill",
    "speed_boost","area_priority","mutation_filter","friends_drop",
    "anti_lag","server_guard","info_tracker","invisible",
}) do
    OR4CLE.modules[n] = safeLoad("modules/" .. n .. ".lua")
end

-- Init UI
if OR4CLE.ui.bubble and OR4CLE.ui.window then
    local okW, win = pcall(function() return OR4CLE.ui.window.new(OR4CLE) end)
    if okW and win then
        OR4CLE.windowInstance = win
        local okB, bub = pcall(function() return OR4CLE.ui.bubble.new(OR4CLE) end)
        if okB and bub then
            OR4CLE.bubbleInstance = bub
            bub.onClick = function() win:toggle() end
        else
            warn("[OR4CLE] bubble create gagal: " .. tostring(bub))
        end
    else
        warn("[OR4CLE] window create gagal: " .. tostring(win))
    end
end

OR4CLE.loaded = true
warn("[OR4CLE] loaded v" .. OR4CLE.version)
