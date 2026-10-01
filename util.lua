-- OR4CLE — util.lua (fixed)
local Players  = game:GetService("Players")
local TweenSvc = game:GetService("TweenService")
local HttpSvc  = game:GetService("HttpService")

local UTIL = {}

-- PLAYER
function UTIL.getPlayer() return Players.LocalPlayer end
function UTIL.getChar()
    local lp = Players.LocalPlayer
    return lp and lp.Character
end
function UTIL.getHRP()
    local c = UTIL.getChar()
    return c and c:FindFirstChild("HumanoidRootPart")
end
function UTIL.getHumanoid()
    local c = UTIL.getChar()
    return c and c:FindFirstChildOfClass("Humanoid")
end
function UTIL.waitChar(timeout)
    local lp = Players.LocalPlayer
    timeout = timeout or 10
    if lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
        return lp.Character
    end
    local t = 0
    while t < timeout do
        task.wait(0.1); t = t + 0.1
        if lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
            return lp.Character
        end
    end
    return nil
end

-- NOTIFY
function UTIL.notify(text, dur)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "OR4CLE", Text = tostring(text), Duration = dur or 3,
        })
    end)
end

-- SAFE
function UTIL.safeCall(fn, ...)
    local ok, res = pcall(fn, ...)
    if not ok then return nil end
    return res
end

function UTIL.deepCopy(t)
    if type(t) ~= "table" then return t end
    local o = {}
    for k, v in pairs(t) do o[k] = UTIL.deepCopy(v) end
    return o
end

-- TWEEN (safe)
function UTIL.tween(obj, props, time, style, dir)
    if not obj or not props then return nil end
    local ok, tw = pcall(function()
        local i = TweenInfo.new(
            time or 0.2,
            style or Enum.EasingStyle.Quad,
            dir or Enum.EasingDirection.Out
        )
        return TweenSvc:Create(obj, i, props)
    end)
    if not ok or not tw then return nil end
    pcall(function() tw:Play() end)
    return tw
end

-- RARITY
function UTIL.getRank(r)
    local c = _G.OR4CLE and _G.OR4CLE.config
    if not c or not c.RarityRank then return 0 end
    return c.RarityRank[r] or 0
end
function UTIL.passesFilter(r, min)
    if not min or min == "All" then return true end
    return UTIL.getRank(r) >= UTIL.getRank(min)
end
function UTIL.getRarityColor(r)
    local c = _G.OR4CLE and _G.OR4CLE.config
    if not c or not c.RarityColor then return Color3.fromRGB(235,235,245) end
    return c.RarityColor[r] or Color3.fromRGB(235,235,245)
end

-- FRIENDS
function UTIL.getFriends()
    local lp = Players.LocalPlayer
    if not lp then return {} end
    local ok, pages = pcall(function() return Players:GetFriendsAsync(lp.UserId) end)
    if not ok or not pages then return {} end
    local list, guard = {}, 0
    while guard < 20 do
        guard = guard + 1
        local pok, items = pcall(function() return pages:GetCurrentPage() end)
        if not pok or not items then break end
        for _, it in ipairs(items) do
            table.insert(list, {
                UserId = it.Id, Username = it.Username,
                Display = it.DisplayName or it.Username,
                IsOnline = it.IsOnline or false,
            })
        end
        if pages.IsFinished then break end
        if not pcall(function() pages:AdvanceToNextPageAsync() end) then break end
    end
    return list
end

-- INFO QUEUE
function UTIL.ensureInfoQueue()
    if not _G.OR4CLE then return {} end
    _G.OR4CLE.registry = _G.OR4CLE.registry or {}
    _G.OR4CLE.registry.info = _G.OR4CLE.registry.info or {}
    return _G.OR4CLE.registry.info
end
function UTIL.pushInfo(e)
    local q = UTIL.ensureInfoQueue()
    local c = _G.OR4CLE and _G.OR4CLE.config
    local max = (c and c.Info and c.Info.MaxSlots) or 10
    e = e or {}
    e.timestamp = e.timestamp or (type(tick)=="function" and tick() or 0)
    e.expired = false
    table.insert(q, 1, e)
    while #q > max do table.remove(q, #q) end
    return q
end
function UTIL.clearInfo()
    local q = UTIL.ensureInfoQueue()
    for i = #q, 1, -1 do q[i] = nil end
end
function UTIL.getClock()
    local t = 0
    if type(tick) == "function" then pcall(function() t = tick() end) end
    local secs = math.floor(t) % 86400
    return string.format("%02d:%02d", math.floor(secs/3600), math.floor((secs%3600)/60))
end

-- PERSISTENCE
function UTIL.hasFileAPI()
    return type(writefile)=="function" and type(readfile)=="function"
end
function UTIL.saveTable(path, tbl)
    if not UTIL.hasFileAPI() then return false end
    return pcall(function() writefile(path, HttpSvc:JSONEncode(tbl)) end)
end
function UTIL.loadTable(path)
    if not UTIL.hasFileAPI() then return nil end
    local ok, data = pcall(function()
        if isfile and isfile(path) then return HttpSvc:JSONDecode(readfile(path)) end
    end)
    if ok then return data end
    return nil
end

-- REMOTE
function UTIL.getRemote(path)
    local cfg = _G.OR4CLE and _G.OR4CLE.config
    if not cfg or not cfg.Remotes then return nil end
    local full = cfg.Remotes.Base .. "." .. path:gsub("/", ".")
    local node = game
    for p in full:gmatch("[^%.]+") do
        node = node:FindFirstChild(p)
        if not node then return nil end
    end
    return node
end
function UTIL.fireRF(path, ...)
    local r = UTIL.getRemote(path)
    if not r then return nil end
    local ok, res = pcall(function() return r:InvokeServer(...) end)
    if ok then return res end
    return nil
end
function UTIL.fireRE(path, ...)
    local r = UTIL.getRemote(path)
    if not r then return false end
    return pcall(function() r:FireServer(...) end)
end

-- INSTANCE
function UTIL.magnitude(a, b)
    if not a or not b then return math.huge end
    return (a.Position - b.Position).Magnitude
end
function UTIL.forEachDescendant(root, class, cb)
    if not root then return end
    for _, v in ipairs(root:GetDescendants()) do
        if v:IsA(class) then UTIL.safeCall(cb, v) end
    end
end

return UTIL
