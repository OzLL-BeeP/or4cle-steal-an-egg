-- OR4CLE — loader.lua FULL INLINE (bekerja terbukti)
local Players = game:GetService("Players")
local UIS     = game:GetService("UserInputService")

local lp = Players.LocalPlayer
if not lp then return end
local pg = lp:WaitForChild("PlayerGui", 10)
if not pg then return end

-- clear existing
for _, x in ipairs(pg:GetChildren()) do
    if x:IsA("ScreenGui") and x.Name:find("OR4CLE") then x:Destroy() end
end

-- ════════════════════════════════════════════
-- CONFIG
-- ════════════════════════════════════════════
local LOGO_ID = "rbxassetid://114651091062453"
local VERSION = "0.3.0"

local cBg = Color3.fromRGB(11, 11, 16)
local cSurface = Color3.fromRGB(17, 17, 24)
local cSurface2 = Color3.fromRGB(24, 24, 34)
local cPurple = Color3.fromRGB(140, 92, 252)
local cText = Color3.fromRGB(240, 240, 248)
local cSub = Color3.fromRGB(130, 130, 155)
local cMuted = Color3.fromRGB(70, 70, 90)
local cBorder = Color3.fromRGB(34, 32, 52)
local cDanger = Color3.fromRGB(240, 70, 90)

-- ════════════════════════════════════════════
-- WINDOW
-- ════════════════════════════════════════════
local vp = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(800,600)
local W = math.min(540, vp.X - 20)
local H = math.min(380, vp.Y - 60)
local SIDEBAR_W = 120
local TOPBAR_H = 44

local gui = Instance.new("ScreenGui")
gui.Name = "OR4CLE_Window"
gui.ResetOnSpawn = false
gui.DisplayOrder = 99998
gui.IgnoreGuiInset = true
gui.Enabled = false
gui.Parent = pg

local main = Instance.new("Frame", gui)
main.Name = "Main"
main.Size = UDim2.new(0, W, 0, H)
main.Position = UDim2.new(0.5, -W/2, 0.5, -H/2)
main.BackgroundColor3 = cBg
main.BorderSizePixel = 0
main.ZIndex = 2
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 12)

local mainStroke = Instance.new("UIStroke", main)
mainStroke.Color = cPurple
mainStroke.Thickness = 1
mainStroke.Transparency = 0.4

-- TOPBAR
local top = Instance.new("Frame", main)
top.Name = "Topbar"
top.Size = UDim2.new(0, W, 0, TOPBAR_H)
top.BackgroundColor3 = cSurface
top.BorderSizePixel = 0
top.ZIndex = 10
Instance.new("UICorner", top).CornerRadius = UDim.new(0, 12)

local tmask = Instance.new("Frame", top)
tmask.Size = UDim2.new(0, W, 0, 14)
tmask.Position = UDim2.new(0, 0, 0, TOPBAR_H - 14)
tmask.BackgroundColor3 = cSurface
tmask.BorderSizePixel = 0
tmask.ZIndex = 10

local topLogo = Instance.new("ImageLabel", top)
topLogo.Size = UDim2.new(0, 24, 0, 24)
topLogo.Position = UDim2.new(0, 14, 0, 10)
topLogo.BackgroundTransparency = 1
topLogo.Image = LOGO_ID
topLogo.ScaleType = Enum.ScaleType.Crop
topLogo.ZIndex = 11
Instance.new("UICorner", topLogo).CornerRadius = UDim.new(1, 0)

local title = Instance.new("TextLabel", top)
title.Size = UDim2.new(0, 200, 0, 16)
title.Position = UDim2.new(0, 46, 0, 8)
title.BackgroundTransparency = 1
title.Text = "OR4CLE"
title.TextColor3 = cText
title.Font = Enum.Font.GothamBold
title.TextSize = 13
title.TextXAlignment = Enum.TextXAlignment.Left
title.ZIndex = 11

local sub = Instance.new("TextLabel", top)
sub.Size = UDim2.new(0, 200, 0, 12)
sub.Position = UDim2.new(0, 46, 0, 24)
sub.BackgroundTransparency = 1
sub.Text = "Steal An Egg · v" .. VERSION
sub.TextColor3 = cSub
sub.Font = Enum.Font.Gotham
sub.TextSize = 9
sub.TextXAlignment = Enum.TextXAlignment.Left
sub.ZIndex = 11

local close = Instance.new("TextButton", top)
close.Size = UDim2.new(0, 26, 0, 26)
close.Position = UDim2.new(0, W - 34, 0, 9)
close.BackgroundColor3 = cSurface2
close.Text = "X"
close.TextColor3 = cSub
close.Font = Enum.Font.GothamBold
close.TextSize = 12
close.BorderSizePixel = 0
close.AutoButtonColor = false
close.ZIndex = 11
Instance.new("UICorner", close).CornerRadius = UDim.new(0, 6)

local mini = Instance.new("TextButton", top)
mini.Size = UDim2.new(0, 26, 0, 26)
mini.Position = UDim2.new(0, W - 64, 0, 9)
mini.BackgroundColor3 = cSurface2
mini.Text = "-"
mini.TextColor3 = cSub
mini.Font = Enum.Font.GothamBold
mini.TextSize = 14
mini.BorderSizePixel = 0
mini.AutoButtonColor = false
mini.ZIndex = 11
Instance.new("UICorner", mini).CornerRadius = UDim.new(0, 6)

-- SIDEBAR
local sidebar = Instance.new("Frame", main)
sidebar.Name = "Sidebar"
sidebar.Size = UDim2.new(0, SIDEBAR_W, 0, H - TOPBAR_H)
sidebar.Position = UDim2.new(0, 0, 0, TOPBAR_H)
sidebar.BackgroundColor3 = cBg
sidebar.BorderSizePixel = 0
sidebar.ZIndex = 5

-- CONTENT
local contentArea = Instance.new("Frame", main)
contentArea.Name = "ContentArea"
contentArea.Size = UDim2.new(0, W - SIDEBAR_W, 0, H - TOPBAR_H)
contentArea.Position = UDim2.new(0, SIDEBAR_W, 0, TOPBAR_H)
contentArea.BackgroundColor3 = cBg
contentArea.BorderSizePixel = 0
contentArea.ZIndex = 5

local contentScroll = Instance.new("ScrollingFrame", contentArea)
contentScroll.Name = "Content"
contentScroll.Size = UDim2.new(0, W - SIDEBAR_W - 24, 0, H - TOPBAR_H - 20)
contentScroll.Position = UDim2.new(0, 12, 0, 10)
contentScroll.BackgroundTransparency = 1
contentScroll.BorderSizePixel = 0
contentScroll.ScrollBarThickness = 3
contentScroll.ScrollBarImageColor3 = cPurple
contentScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
contentScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
contentScroll.ZIndex = 6
local csList = Instance.new("UIListLayout", contentScroll)
csList.Padding = UDim.new(0, 14)

-- ════════════════════════════════════════════
-- TABS
-- ════════════════════════════════════════════
local tabs = {
    {id="Visual",   num="01", name="Visual"},
    {id="Farm",     num="02", name="Farm"},
    {id="Friends",  num="03", name="Friend"},
    {id="Info",     num="04", name="Utility"},
    {id="Settings", num="05", name="Settings"},
}
local tabButtons = {}
local tabPages = {}
local tabIndicators = {}
local tabNums = {}
local tabLabels = {}

local function selectTab(id)
    for n, b in pairs(tabButtons) do
        local act = (n == id)
        b.BackgroundColor3 = act and cSurface2 or cBg
        if tabLabels[n] then tabLabels[n].TextColor3 = act and cText or cSub end
        if tabNums[n] then tabNums[n].TextColor3 = act and cPurple or cMuted end
        if tabIndicators[n] then tabIndicators[n].Visible = act end
    end
    for n, p in pairs(tabPages) do
        p.Visible = (n == id)
    end
end

for i, def in ipairs(tabs) do
    local btn = Instance.new("TextButton", sidebar)
    btn.Name = def.id .. "Tab"
    btn.Size = UDim2.new(0, SIDEBAR_W - 16, 0, 34)
    btn.Position = UDim2.new(0, 8, 0, 10 + (i-1) * 38)
    btn.BackgroundColor3 = cBg
    btn.Text = ""
    btn.AutoButtonColor = false
    btn.BorderSizePixel = 0
    btn.ZIndex = 6
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 7)

    local ind = Instance.new("Frame", btn)
    ind.Size = UDim2.new(0, 3, 0, 20)
    ind.Position = UDim2.new(0, 0, 0.5, -10)
    ind.BackgroundColor3 = cPurple
    ind.BorderSizePixel = 0
    ind.Visible = false
    ind.ZIndex = 8
    Instance.new("UICorner", ind).CornerRadius = UDim.new(1, 0)

    local num = Instance.new("TextLabel", btn)
    num.Size = UDim2.new(0, 26, 1, 0)
    num.Position = UDim2.new(0, 10, 0, 0)
    num.BackgroundTransparency = 1
    num.Text = def.num
    num.TextColor3 = cMuted
    num.Font = Enum.Font.GothamBold
    num.TextSize = 11
    num.TextXAlignment = Enum.TextXAlignment.Left
    num.ZIndex = 7

    local lbl = Instance.new("TextLabel", btn)
    lbl.Size = UDim2.new(1, -42, 1, 0)
    lbl.Position = UDim2.new(0, 36, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = def.name
    lbl.TextColor3 = cSub
    lbl.Font = Enum.Font.GothamMedium
    lbl.TextSize = 12
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.ZIndex = 7

    tabButtons[def.id] = btn
    tabIndicators[def.id] = ind
    tabNums[def.id] = num
    tabLabels[def.id] = lbl

    local page = Instance.new("Frame", contentScroll)
    page.Name = def.id .. "Page"
    page.Size = UDim2.new(0, W - SIDEBAR_W - 24, 0, 400)
    page.BackgroundTransparency = 1
    page.Visible = false
    page.ZIndex = 6
    local pl = Instance.new("UIListLayout", page)
    pl.Padding = UDim.new(0, 12)

    tabPages[def.id] = page

    btn.MouseButton1Click:Connect(function() selectTab(def.id) end)
end

selectTab("Visual")

-- ════════════════════════════════════════════
-- COMPONENTS
-- ════════════════════════════════════════════
local function makeSection(page, titleText)
    local wrap = Instance.new("Frame", page)
    wrap.Size = UDim2.new(1, 0, 0, 0)
    wrap.AutomaticSize = Enum.AutomaticSize.Y
    wrap.BackgroundTransparency = 1

    local hdr = Instance.new("TextLabel", wrap)
    hdr.Size = UDim2.new(1, 0, 0, 16)
    hdr.BackgroundTransparency = 1
    hdr.Text = string.upper(titleText)
    hdr.TextColor3 = cSub
    hdr.Font = Enum.Font.GothamBold
    hdr.TextSize = 10
    hdr.TextXAlignment = Enum.TextXAlignment.Left

    local body = Instance.new("Frame", wrap)
    body.Size = UDim2.new(1, 0, 0, 0)
    body.Position = UDim2.new(0, 0, 0, 20)
    body.AutomaticSize = Enum.AutomaticSize.Y
    body.BackgroundTransparency = 1
    local ll = Instance.new("UIListLayout", body)
    ll.Padding = UDim.new(0, 2)
    return body
end

local function makeToggle(parent, labelText, default, onChange)
    local row = Instance.new("Frame", parent)
    row.Size = UDim2.new(1, 0, 0, 34)
    row.BackgroundColor3 = cSurface2
    row.BorderSizePixel = 0
    Instance.new("UICorner", row).CornerRadius = UDim.new(0, 6)

    local lbl = Instance.new("TextLabel", row)
    lbl.Size = UDim2.new(1, -100, 1, 0)
    lbl.Position = UDim2.new(0, 12, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = labelText
    lbl.TextColor3 = cText
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 12
    lbl.TextXAlignment = Enum.TextXAlignment.Left

    local stateLbl = Instance.new("TextLabel", row)
    stateLbl.Size = UDim2.new(0, 28, 1, 0)
    stateLbl.Position = UDim2.new(1, -78, 0, 0)
    stateLbl.BackgroundTransparency = 1
    stateLbl.Text = default and "ON" or "OFF"
    stateLbl.TextColor3 = cSub
    stateLbl.Font = Enum.Font.GothamBold
    stateLbl.TextSize = 10
    stateLbl.TextXAlignment = Enum.TextXAlignment.Right

    local state = default or false
    local btn = Instance.new("TextButton", row)
    btn.Size = UDim2.new(0, 30, 0, 16)
    btn.Position = UDim2.new(1, -42, 0.5, -8)
    btn.BackgroundColor3 = state and cPurple or Color3.fromRGB(50, 50, 65)
    btn.Text = ""
    btn.AutoButtonColor = false
    btn.BorderSizePixel = 0
    Instance.new("UICorner", btn).CornerRadius = UDim.new(1, 0)

    local dot = Instance.new("Frame", btn)
    dot.Size = UDim2.new(0, 12, 0, 12)
    dot.Position = state and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)
    dot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    dot.BorderSizePixel = 0
    Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)

    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.BackgroundColor3 = state and cPurple or Color3.fromRGB(50, 50, 65)
        dot.Position = state and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)
        stateLbl.Text = state and "ON" or "OFF"
        if onChange then pcall(onChange, state) end
    end)
    return {get=function() return state end}
end

local function makePicker(parent, labelText, options, default, onSelect)
    local row = Instance.new("Frame", parent)
    row.Size = UDim2.new(1, 0, 0, 34)
    row.BackgroundColor3 = cSurface2
    row.BorderSizePixel = 0
    Instance.new("UICorner", row).CornerRadius = UDim.new(0, 6)

    local lbl = Instance.new("TextLabel", row)
    lbl.Size = UDim2.new(1, -170, 1, 0)
    lbl.Position = UDim2.new(0, 12, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = labelText
    lbl.TextColor3 = cText
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 12
    lbl.TextXAlignment = Enum.TextXAlignment.Left

    local value = default or (options and options[1]) or ""

    local btn = Instance.new("TextButton", row)
    btn.Size = UDim2.new(0, 150, 1, 0)
    btn.Position = UDim2.new(1, -158, 0, 0)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    btn.AutoButtonColor = false

    local txt = Instance.new("TextLabel", btn)
    txt.Size = UDim2.new(1, -20, 1, 0)
    txt.BackgroundTransparency = 1
    txt.Text = tostring(value)
    txt.TextColor3 = cSub
    txt.Font = Enum.Font.Gotham
    txt.TextSize = 11
    txt.TextXAlignment = Enum.TextXAlignment.Right

    local chev = Instance.new("TextLabel", btn)
    chev.Size = UDim2.new(0, 16, 1, 0)
    chev.Position = UDim2.new(1, -16, 0, 0)
    chev.BackgroundTransparency = 1
    chev.Text = "v"
    chev.TextColor3 = cMuted
    chev.Font = Enum.Font.GothamBold
    chev.TextSize = 10

    local popup = Instance.new("Frame", row)
    popup.Visible = false
    popup.Size = UDim2.new(0, 150, 0, 0)
    popup.AutomaticSize = Enum.AutomaticSize.Y
    popup.Position = UDim2.new(1, -158, 1, 4)
    popup.BackgroundColor3 = cSurface2
    popup.BorderSizePixel = 0
    popup.ZIndex = 50
    Instance.new("UICorner", popup).CornerRadius = UDim.new(0, 6)
    local pst = Instance.new("UIStroke", popup)
    pst.Color = cBorder
    pst.Thickness = 1
    local pl = Instance.new("UIListLayout", popup)
    pl.Padding = UDim.new(0, 1)
    local pp = Instance.new("UIPadding", popup)
    pp.PaddingTop = UDim.new(0, 4)
    pp.PaddingBottom = UDim.new(0, 4)

    btn.MouseButton1Click:Connect(function()
        popup.Visible = not popup.Visible
    end)

    for _, opt in ipairs(options or {}) do
        local o = Instance.new("TextButton", popup)
        o.Size = UDim2.new(1, 0, 0, 22)
        o.BackgroundColor3 = cSurface2
        o.Text = tostring(opt)
        o.TextColor3 = cText
        o.Font = Enum.Font.Gotham
        o.TextSize = 11
        o.BorderSizePixel = 0
        o.AutoButtonColor = false
        o.MouseButton1Click:Connect(function()
            value = opt
            txt.Text = tostring(opt)
            popup.Visible = false
            if onSelect then pcall(onSelect, opt) end
        end)
    end
    return {get=function() return value end}
end

local function makeButton(parent, labelText, onClick)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(1, 0, 0, 32)
    btn.BackgroundColor3 = cSurface2
    btn.Text = labelText
    btn.TextColor3 = cText
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 12
    btn.BorderSizePixel = 0
    btn.AutoButtonColor = false
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    btn.MouseButton1Click:Connect(function()
        if onClick then pcall(onClick) end
    end)
end

-- ════════════════════════════════════════════
-- FILL VISUAL
-- ════════════════════════════════════════════
local rarityList = {"Common","Uncommon","Rare","Epic","Legendary","Mythic","Cosmic","Secret","Eternal","Divine"}
local rarityOptions = {}
for i, r in ipairs(rarityList) do
    table.insert(rarityOptions, string.format("%02d %s", i, r))
end

local vPage = tabPages.Visual
local vSec1 = makeSection(vPage, "Egg ESP")
makeToggle(vSec1, "Enable Egg ESP", false, function(state)
    local esp = _G.OR4CLE and _G.OR4CLE.modules and _G.OR4CLE.modules.esp_egg
    if esp then
        if state then pcall(esp.start, {})
        else pcall(esp.stop) end
    end
end)

local vSec2 = makeSection(vPage, "ESP Rarity")
makePicker(vSec2, "Min Tier", rarityOptions, "03 Rare", function(opt)
    local num = tonumber(opt:match("^(%d+)"))
    if num then
        _G.OR4CLE = _G.OR4CLE or {}
        _G.OR4CLE.filters = _G.OR4CLE.filters or {}
        _G.OR4CLE.filters.esp_minRarityNum = num
        local esp = _G.OR4CLE.modules and _G.OR4CLE.modules.esp_egg
        if esp and esp.setMinRarityNum then pcall(esp.setMinRarityNum, num) end
    end
end)

local vSec3 = makeSection(vPage, "ESP Settings")
makeToggle(vSec3, "Show Pet Name", true)
makeToggle(vSec3, "Show Rarity", true)
makeToggle(vSec3, "Show Distance", false)

local vSec4 = makeSection(vPage, "Invisible / Evasive")
makeToggle(vSec4, "Ghost Mode", false)

-- FILL FARM
local fPage = tabPages.Farm
local fSec1 = makeSection(fPage, "Auto Steal")
makeToggle(fSec1, "Enable Auto Steal", false)
makePicker(fSec1, "Mode", {"Teleport","Idle"}, "Teleport")
makePicker(fSec1, "Priority", {"Rarest","Biggest","Nearest","Fastest"}, "Rarest")

local fSec2 = makeSection(fPage, "Auto Hatch")
makeToggle(fSec2, "Enable Auto Hatch", false)
makePicker(fSec2, "Speed", {"Safe","Normal","Turbo"}, "Normal")

local fSec3 = makeSection(fPage, "Auto Place")
makeToggle(fSec3, "Enable Auto Place", false)

local fSec4 = makeSection(fPage, "Auto Treadmill")
makeToggle(fSec4, "Enable Auto Treadmill", false)

local fSec5 = makeSection(fPage, "Speed Boost")
makeToggle(fSec5, "Enable Speed Boost", false)

-- FILL FRIEND
local frPage = tabPages.Friends
local frSec1 = makeSection(frPage, "Drop for Friends")
makeToggle(frSec1, "Enable", false)
makeToggle(frSec1, "Auto Pickup Back", true)
makeButton(frSec1, "Refresh Friend List", function() end)

-- FILL UTILITY
local iPage = tabPages.Info
local iSec1 = makeSection(iPage, "Live Info")
local clk = Instance.new("TextLabel", iSec1)
clk.Size = UDim2.new(1, -20, 0, 18)
clk.Position = UDim2.new(0, 10, 0, 6)
clk.BackgroundTransparency = 1
clk.Text = "Time: --:--"
clk.TextColor3 = cPurple
clk.Font = Enum.Font.GothamBold
clk.TextSize = 11
clk.TextXAlignment = Enum.TextXAlignment.Left

task.spawn(function()
    while clk.Parent do
        local h = math.floor((tick() % 86400) / 3600)
        local m = math.floor(((tick() % 86400) % 3600) / 60)
        clk.Text = string.format("Time: %02d:%02d", h, m)
        task.wait(1)
    end
end)

for i = 1, 8 do
    local slot = Instance.new("TextLabel", iSec1)
    slot.Size = UDim2.new(1, -20, 0, 16)
    slot.Position = UDim2.new(0, 10, 0, 30 + (i-1) * 18)
    slot.BackgroundTransparency = 1
    slot.Text = string.format("%02d. --", i)
    slot.TextColor3 = cSub
    slot.Font = Enum.Font.Code
    slot.TextSize = 10
    slot.TextXAlignment = Enum.TextXAlignment.Left
end

-- FILL SETTINGS
local sPage = tabPages.Settings
local sSec1 = makeSection(sPage, "Performance")
makeToggle(sSec1, "Anti Lag", false)
makePicker(sSec1, "FPS Cap", {"30","45","60","Unlimited"}, "60")

local sSec2 = makeSection(sPage, "Server Guard")
makeToggle(sSec2, "Enable", false)
makePicker(sSec2, "Action", {"Auto-Leave","Auto-Hop","Notify Only"}, "Notify Only")

local sSec3 = makeSection(sPage, "Debug")
makeButton(sSec3, "Reload Script", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/OzLL-BeeP/or4cle-steal-an-egg/main/loader.lua"))()
end)
makeButton(sSec3, "Unload All", function()
    for _, x in ipairs(pg:GetChildren()) do
        if x:IsA("ScreenGui") and x.Name:find("OR4CLE") then x:Destroy() end
    end
end)

-- ════════════════════════════════════════════
-- DRAG
-- ════════════════════════════════════════════
local dragging = false
local dragStart, startPos
top.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = main.Position
    end
end)
top.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
    or input.UserInputType == Enum.UserInputType.Touch) then
        local d = input.Position - dragStart
        main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X,
                                   startPos.Y.Scale, startPos.Y.Offset + d.Y)
    end
end)
UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

close.MouseButton1Click:Connect(function()
    for _, x in ipairs(pg:GetChildren()) do
        if x:IsA("ScreenGui") and x.Name:find("OR4CLE") then x:Destroy() end
    end
end)
mini.MouseButton1Click:Connect(function() gui.Enabled = false end)

-- ════════════════════════════════════════════
-- BUBBLE
-- ════════════════════════════════════════════
local bubble = Instance.new("ScreenGui")
bubble.Name = "OR4CLE_Bubble"
bubble.ResetOnSpawn = false
bubble.DisplayOrder = 99999
bubble.IgnoreGuiInset = true
bubble.Parent = pg

local bbtn = Instance.new("TextButton", bubble)
bbtn.Size = UDim2.new(0, 50, 0, 50)
bbtn.Position = UDim2.new(0, 20, 0, 200)
bbtn.BackgroundColor3 = cBg
bbtn.Text = ""
bbtn.AutoButtonColor = false
bbtn.BorderSizePixel = 0
Instance.new("UICorner", bbtn).CornerRadius = UDim.new(1, 0)

local bstroke = Instance.new("UIStroke", bbtn)
bstroke.Color = cPurple
bstroke.Thickness = 2.5

local blogo = Instance.new("ImageLabel", bbtn)
blogo.Size = UDim2.new(1, -6, 1, -6)
blogo.Position = UDim2.new(0, 3, 0, 3)
blogo.BackgroundTransparency = 1
blogo.Image = LOGO_ID
blogo.ScaleType = Enum.ScaleType.Crop
Instance.new("UICorner", blogo).CornerRadius = UDim.new(1, 0)

bbtn.MouseButton1Click:Connect(function()
    gui.Enabled = not gui.Enabled
end)

UIS.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        gui.Enabled = not gui.Enabled
    end
end)

-- REGISTER _G.OR4CLE (stub, buat module lain)
_G.OR4CLE = _G.OR4CLE or {}
_G.OR4CLE.version = VERSION
_G.OR4CLE.loaded = true
_G.OR4CLE.filters = _G.OR4CLE.filters or {}

warn("[OR4CLE] v" .. VERSION .. " loaded inline")
