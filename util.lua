-- OR4CLE — util.lua
local Players = game:GetService("Players")
local RunSvc  = game:GetService("RunService")
local TweenSvc = game:GetService("TweenService")
local Http    = game:GetService("HttpService")

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
    dur = dur or 3
    local ok = pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "OR4CLE", Text = tostring(text), Duration = dur,
        })
    end)
    if not ok then warn("[OR4CLE] " .. tostring(text)) end
end

-- SAFE
function UTIL.safeCall(fn, ...)
    local ok, res = pcall(fn, ...)
    if not ok then
        local cfg = _G.OR4CLE and _G.OR4CLE.config
        if cfg and cfg.Debug then warn("[OR4CLE] " .. tostring(res)) end
        return nil
    end
    return res
end

function UTIL.deepCopy(t)
    if type(t) ~= "table" then return t end
    local o = {}
    for k, v in pairs(t) do o[k] = UTIL.deepCopy(v) end
    return o
end

-- TWEEN
function UTIL.tween(obj, props, time, style, dir)
    if not obj then return end
    local i = TweenInfo.new(time or 0.2, style or Enum.EasingStyle.Quad, dir or Enum.EasingDirection.Out)
    local t = TweenSvc:Create(obj, i, props)
    t:Play()
    return t
end

-- RARITY
function UTIL.getRank(r)
    local c = _G.OR4CLE and _G.OR4CLE.config
    return (c and c.RarityRank and c.RarityRank[r]) or 0
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
    e.timestamp = e.timestamp or os.time()
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
    local t = os.date("*t")
    return string.format("%02d:%02d", t.hour, t.min)
end

-- PERSISTENCE
function UTIL.hasFileAPI()
    return typeof(writefile) == "function" and typeof(readfile) == "function"
end
function UTIL.saveTable(path, tbl)
    if not UTIL.hasFileAPI() then return false end
    return pcall(function() writefile(path, Http:JSONEncode(tbl)) end)
end
function UTIL.loadTable(path)
    if not UTIL.hasFileAPI() then return nil end
    local ok, data = pcall(function()
        if isfile and isfile(path) then return Http:JSONDecode(readfile(path)) end
    end)
    return ok and data or nil
end

-- REMOTE HELPERS
function UTIL.getRemote(path)
    local cfg = _G.OR4CLE and _G.OR4CLE.config
    if not cfg or not cfg.Remotes then return nil end
    local base = cfg.Remotes.Base
    local full = base .. "." .. path:gsub("/", ".")
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
    return ok and res or nil
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
