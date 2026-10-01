-- OR4CLE — loader.lua
local CONFIG = loadstring(game:HttpGet("https://raw.githubusercontent.com/OzLL-BeeP/or4cle-steal-an-egg/main/config.lua"))()
local UTIL   = loadstring(game:HttpGet(CONFIG.BASE_URL .. "util.lua"))()

local OR4CLE = {
    config   = CONFIG,
    util     = UTIL,
    modules  = {},
    registry = {},
    version  = CONFIG.VERSION,
    loaded   = false,
}
_G.OR4CLE = OR4CLE

local function safeLoad(path)
    local ok, res = pcall(function()
        return loadstring(game:HttpGet(CONFIG.BASE_URL .. path))()
    end)
    if not ok then
        warn("[OR4CLE] gagal load " .. path .. ": " .. tostring(res))
        return nil
    end
    return res
end

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

-- init UI
if OR4CLE.ui.bubble and OR4CLE.ui.window then
    local win = OR4CLE.ui.window.new(OR4CLE)
    OR4CLE.windowInstance = win
    local bub = OR4CLE.ui.bubble.new(OR4CLE)
    bub.onClick = function() win:toggle() end
    OR4CLE.bubbleInstance = bub
end

OR4CLE.loaded = true
print("[OR4CLE] loaded v" .. OR4CLE.version)
