-- OR4CLE — Ride A Pet style (Steal An Egg)
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local lp = Players.LocalPlayer
local pg = lp:WaitForChild("PlayerGui")

for _, x in ipairs(pg:GetChildren()) do
    if x:IsA("ScreenGui") and x.Name:find("OR4CLE") then x:Destroy() end
end

local LOGO = "rbxassetid://114651091062453"
local VERSION = "0.5.0"

local cBg        = Color3.fromRGB(12, 13, 20)
local cBg2       = Color3.fromRGB(15, 16, 24)
local cRow       = Color3.fromRGB(20, 21, 32)
local cRowHover  = Color3.fromRGB(26, 27, 40)
local cAccent    = Color3.fromRGB(140, 92, 252)
local cAccent2   = Color3.fromRGB(105, 65, 220)
local cText      = Color3.fromRGB(232, 232, 240)
local cLabel     = Color3.fromRGB(200, 200, 215)
local cDim       = Color3.fromRGB(130, 130, 150)
local cMuted     = Color3.fromRGB(70, 72, 88)
local cLine      = Color3.fromRGB(28, 30, 44)

local vp = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(800,600)
local W = math.min(560, vp.X - 20)
local H = math.min(400, vp.Y - 30)
local SIDEBAR_W = 140
local TOPBAR_H = 48

local gui = Instance.new("ScreenGui")
gui.Name = "OR4CLE_Window"
gui.ResetOnSpawn = false
gui.DisplayOrder = 99998
gui.IgnoreGuiInset = true
gui.Enabled = false
gui.Parent = pg

local main = Instance.new("Frame")
main.Name = "Main"
main.Size = UDim2.new(0, W, 0, H)
main.Position = UDim2.new(0, 40, 0, 80)
main.BackgroundColor3 = cBg
main.BorderSizePixel = 0
main.ZIndex = 2
main.Parent = gui
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 10)

local ms = Instance.new("UIStroke", main)
ms.Color = Color3.fromRGB(40, 36, 60)
ms.Thickness = 1

local top = Instance.new("Frame")
top.Name = "Topbar"
top.Size = UDim2.new(0, W, 0, TOPBAR_H)
top.BackgroundColor3 = cBg2
top.BorderSizePixel = 0
top.ZIndex = 10
top.Parent = main
Instance.new("UICorner", top).CornerRadius = UDim.new(0, 10)

local tmask = Instance.new("Frame")
tmask.Size = UDim2.new(0, W, 0, 16)
tmask.Position = UDim2.new(0, 0, 0, TOPBAR_H - 16)
tmask.BackgroundColor3 = cBg2
tmask.BorderSizePixel = 0
tmask.ZIndex = 10
tmask.Parent = top

local sb = Instance.new("Frame")
sb.Size = UDim2.new(0, 220, 0, 30)
sb.Position = UDim2.new(0, SIDEBAR_W + 12, 0, 9)
sb.BackgroundColor3 = cRow
sb.BorderSizePixel = 0
sb.ZIndex = 11
sb.Parent = top
Instance.new("UICorner", sb).CornerRadius = UDim.new(0, 6)

local sbInput = Instance.new("TextBox")
sbInput.Size = UDim2.new(1, -20, 1, 0)
sbInput.Position = UDim2.new(0, 10, 0, 0)
sbInput.BackgroundTransparency = 1
sbInput.PlaceholderText = "cari..."
sbInput.PlaceholderColor3 = cDim
sbInput.Text = ""
sbInput.TextColor3 = cText
sbInput.Font = Enum.Font.Gotham
sbInput.TextSize = 12
sbInput.TextXAlignment = Enum.TextXAlignment.Left
sbInput.ClearTextOnFocus = false
sbInput.ZIndex = 12
sbInput.Parent = sb

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 28, 0, 28)
closeBtn.Position = UDim2.new(0, W - 38, 0, 10)
closeBtn.BackgroundColor3 = cRow
closeBtn.Text = "X"
closeBtn.TextColor3 = cLabel
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 13
closeBtn.BorderSizePixel = 0
closeBtn.AutoButtonColor = false
closeBtn.ZIndex = 11
closeBtn.Parent = top
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)

local sidebar = Instance.new("Frame")
sidebar.Name = "Sidebar"
sidebar.Size = UDim2.new(0, SIDEBAR_W, 0, H - TOPBAR_H)
sidebar.Position = UDim2.new(0, 0, 0, TOPBAR_H)
sidebar.BackgroundColor3 = cBg
sidebar.BorderSizePixel = 0
sidebar.ZIndex = 5
sidebar.Parent = main

local contentArea = Instance.new("Frame")
contentArea.Name = "ContentArea"
contentArea.Size = UDim2.new(0, W - SIDEBAR_W, 0, H - TOPBAR_H)
contentArea.Position = UDim2.new(0, SIDEBAR_W, 0, TOPBAR_H)
contentArea.BackgroundColor3 = cBg
contentArea.BorderSizePixel = 0
contentArea.ZIndex = 5
contentArea.Parent = main

local cs = Instance.new("ScrollingFrame")
cs.Name = "Content"
cs.Size = UDim2.new(0, W - SIDEBAR_W - 28, 0, H - TOPBAR_H - 24)
cs.Position = UDim2.new(0, 14, 0, 12)
cs.BackgroundTransparency = 1
cs.BorderSizePixel = 0
cs.ScrollBarThickness = 3
cs.ScrollBarImageColor3 = cAccent
cs.CanvasSize = UDim2.new(0, 0, 0, 0)
cs.AutomaticCanvasSize = Enum.AutomaticSize.Y
cs.ZIndex = 6
cs.Parent = contentArea

local csl = Instance.new("UIListLayout")
csl.Padding = UDim.new(0, 18)
csl.Parent = cs

local tabDefs = {
    {id="Visual",   name="VISUALS"},
    {id="Farm",     name="FARM"},
    {id="Friends",  name="FRIEND"},
    {id="Info",     name="UTILITY"},
    {id="Settings", name="SETTINGS"},
}
local tabButtons, tabPages, tabLines = {}, {}, {}

local function selectTab(id)
    for n, b in pairs(tabButtons) do
        local a = (n == id)
        local lbl = b:FindFirstChild("Lbl")
        if lbl then lbl.TextColor3 = a and cText or cDim end
        local ln = tabLines[n]
        if ln then ln.Visible = a end
    end
    for n, p in pairs(tabPages) do p.Visible = (n == id) end
end

for i, def in ipairs(tabDefs) do
    local btn = Instance.new("TextButton")
    btn.Name = def.id .. "Tab"
    btn.Size = UDim2.new(0, SIDEBAR_W, 0, 38)
    btn.Position = UDim2.new(0, 0, 0, 16 + (i-1) * 40)
    btn.BackgroundColor3 = cBg
    btn.Text = ""
    btn.AutoButtonColor = false
    btn.BorderSizePixel = 0
    btn.ZIndex = 6
    btn.Parent = sidebar

    local lbl = Instance.new("TextLabel")
    lbl.Name = "Lbl"
    lbl.Size = UDim2.new(1, -24, 1, 0)
    lbl.Position = UDim2.new(0, 20, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = def.name
    lbl.TextColor3 = cDim
    lbl.Font = Enum.Font.GothamMedium
    lbl.TextSize = 12
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.ZIndex = 7
    lbl.Parent = btn

    local line = Instance.new("Frame")
    line.Size = UDim2.new(0, SIDEBAR_W - 40, 0, 2)
    line.Position = UDim2.new(0, 20, 1, -6)
    line.BackgroundColor3 = cAccent
    line.BorderSizePixel = 0
    line.Visible = false
    line.ZIndex = 8
    line.Parent = btn
    Instance.new("UICorner", line).CornerRadius = UDim.new(1, 0)

    tabButtons[def.id] = btn
    tabLines[def.id] = line

    local page = Instance.new("Frame")
    page.Name = def.id .. "Page"
    page.Size = UDim2.new(1, 0, 0, 0)
    page.AutomaticSize = Enum.AutomaticSize.Y
    page.BackgroundTransparency = 1
    page.Visible = false
    page.ZIndex = 6
    page.Parent = cs
    local pl = Instance.new("UIListLayout")
    pl.Padding = UDim.new(0, 18)
    pl.Parent = page

    tabPages[def.id] = page

    btn.MouseButton1Click:Connect(function() selectTab(def.id) end)
    btn.MouseEnter:Connect(function()
        if lbl then lbl.TextColor3 = cLabel end
    end)
    btn.MouseLeave:Connect(function()
        local active = tabLines[def.id] and tabLines[def.id].Visible
        if lbl and not active then lbl.TextColor3 = cDim end
    end)
end

selectTab("Visual")

local function makeGroup(page, titleText)
    local wrap = Instance.new("Frame")
    wrap.Size = UDim2.new(1, 0, 0, 0)
    wrap.AutomaticSize = Enum.AutomaticSize.Y
    wrap.BackgroundTransparency = 1
    wrap.Parent = page

    local hdr = Instance.new("TextLabel")
    hdr.Size = UDim2.new(1, 0, 0, 16)
    hdr.BackgroundTransparency = 1
    hdr.Text = string.upper(titleText)
    hdr.TextColor3 = cDim
    hdr.Font = Enum.Font.GothamBold
    hdr.TextSize = 10
    hdr.TextXAlignment = Enum.TextXAlignment.Left
    hdr.Parent = wrap

    local body = Instance.new("Frame")
    body.Size = UDim2.new(1, 0, 0, 0)
    body.Position = UDim2.new(0, 0, 0, 24)
    body.AutomaticSize = Enum.AutomaticSize.Y
    body.BackgroundTransparency = 1
    body.Parent = wrap
    local ll = Instance.new("UIListLayout")
    ll.Padding = UDim.new(0, 6)
    ll.Parent = body
    return body
end

local function makeToggle(parent, labelText, default, onChange)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 44)
    row.BackgroundColor3 = cRow
    row.BorderSizePixel = 0
    row.Parent = parent
    Instance.new("UICorner", row).CornerRadius = UDim.new(0, 8)

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -140, 1, 0)
    lbl.Position = UDim2.new(0, 16, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = labelText
    lbl.TextColor3 = cLabel
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 13
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = row

    local stl = Instance.new("TextLabel")
    stl.Size = UDim2.new(0, 30, 1, 0)
    stl.Position = UDim2.new(1, -90, 0, 0)
    stl.BackgroundTransparency = 1
    stl.Text = default and "ON" or "OFF"
    stl.TextColor3 = cDim
    stl.Font = Enum.Font.GothamBold
    stl.TextSize = 10
    stl.TextXAlignment = Enum.TextXAlignment.Right
    stl.Parent = row

    local state = default or false
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 40, 0, 20)
    btn.Position = UDim2.new(1, -52, 0.5, -10)
    btn.BackgroundColor3 = state and cAccent or cMuted
    btn.Text = ""
    btn.AutoButtonColor = false
    btn.BorderSizePixel = 0
    btn.Parent = row
    Instance.new("UICorner", btn).CornerRadius = UDim.new(1, 0)

    local dot = Instance.new("Frame")
    dot.Size = UDim2.new(0, 16, 0, 16)
    dot.Position = state and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
    dot.BackgroundColor3 = Color3.fromRGB(255,255,255)
    dot.BorderSizePixel = 0
    dot.Parent = btn
    Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)

    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.BackgroundColor3 = state and cAccent or cMuted
        dot.Position = state and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
        stl.Text = state and "ON" or "OFF"
        if onChange then pcall(onChange, state) end
    end)
end

local function makePicker(parent, labelText, options, default, onSelect)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 44)
    row.BackgroundColor3 = cRow
    row.BorderSizePixel = 0
    row.Parent = parent
    Instance.new("UICorner", row).CornerRadius = UDim.new(0, 8)

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -180, 1, 0)
    lbl.Position = UDim2.new(0, 16, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = labelText
    lbl.TextColor3 = cLabel
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 13
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = row

    local value = default or (options and options[1]) or ""

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 160, 1, 0)
    btn.Position = UDim2.new(1, -168, 0, 0)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    btn.AutoButtonColor = false
    btn.Parent = row

    local txt = Instance.new("TextLabel")
    txt.Size = UDim2.new(1, -24, 1, 0)
    txt.BackgroundTransparency = 1
    txt.Text = tostring(value)
    txt.TextColor3 = cDim
    txt.Font = Enum.Font.Gotham
    txt.TextSize = 12
    txt.TextXAlignment = Enum.TextXAlignment.Right
    txt.Parent = btn

    local ch = Instance.new("TextLabel")
    ch.Size = UDim2.new(0, 16, 1, 0)
    ch.Position = UDim2.new(1, -16, 0, 0)
    ch.BackgroundTransparency = 1
    ch.Text = "v"
    ch.TextColor3 = cMuted
    ch.Font = Enum.Font.GothamBold
    ch.TextSize = 11
    ch.Parent = btn

    local popup = Instance.new("Frame")
    popup.Visible = false
    popup.Size = UDim2.new(0, 170, 0, 0)
    popup.AutomaticSize = Enum.AutomaticSize.Y
    popup.Position = UDim2.new(1, -178, 1, 6)
    popup.BackgroundColor3 = cRowHover
    popup.BorderSizePixel = 0
    popup.ZIndex = 50
    popup.Parent = row
    Instance.new("UICorner", popup).CornerRadius = UDim.new(0, 6)
    local pst = Instance.new("UIStroke", popup)
    pst.Color = cAccent2
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
        local o = Instance.new("TextButton")
        o.Size = UDim2.new(1, 0, 0, 26)
        o.BackgroundColor3 = cRowHover
        o.Text = tostring(opt)
        o.TextColor3 = cLabel
        o.Font = Enum.Font.Gotham
        o.TextSize = 11
        o.BorderSizePixel = 0
        o.AutoButtonColor = false
        o.Parent = popup
        o.MouseButton1Click:Connect(function()
            value = opt
            txt.Text = tostring(opt)
            popup.Visible = false
            if onSelect then pcall(onSelect, opt) end
        end)
    end
end

local function makeButton(parent, labelText, onClick)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 40)
    btn.BackgroundColor3 = cRow
    btn.Text = labelText
    btn.TextColor3 = cLabel
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 12
    btn.BorderSizePixel = 0
    btn.AutoButtonColor = false
    btn.Parent = parent
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    btn.MouseButton1Click:Connect(function()
        if onClick then pcall(onClick) end
    end)
end

local rarityList = {"Common","Uncommon","Rare","Epic","Legendary","Mythic","Cosmic","Secret","Eternal","Divine"}
local rarityOptions = {}
for i, r in ipairs(rarityList) do
    table.insert(rarityOptions, string.format("%02d %s", i, r))
end

local vp_ = tabPages.Visual
local v1 = makeGroup(vp_, "Egg ESP")
makeToggle(v1, "Enable Egg ESP", false)
local v2 = makeGroup(vp_, "ESP Rarity")
makePicker(v2, "ESP Min Tier", rarityOptions, "01 Common")
local v3 = makeGroup(vp_, "ESP Style")
makePicker(v3, "Style", {"Panel","Text","Minimal"}, "Panel")
local v4 = makeGroup(vp_, "ESP Settings")
makeToggle(v4, "Show Pet Name", true)
makeToggle(v4, "Show Rarity", true)
makeToggle(v4, "Show Distance", false)

local fp = tabPages.Farm
local f1 = makeGroup(fp, "Auto Steal")
makeToggle(f1, "Enable Auto Steal", false)
makePicker(f1, "Mode", {"Teleport","Idle"}, "Teleport")
makePicker(f1, "Priority", {"Rarest","Biggest","Nearest","Fastest"}, "Rarest")
local f2 = makeGroup(fp, "Auto Hatch")
makeToggle(f2, "Enable Auto Hatch", false)
makePicker(f2, "Speed", {"Safe","Normal","Turbo"}, "Normal")
local f3 = makeGroup(fp, "Auto Place")
makeToggle(f3, "Enable Auto Place", false)
local f4 = makeGroup(fp, "Speed Boost")
makeToggle(f4, "Enable Speed Boost", false)

local frp = tabPages.Friends
local fr1 = makeGroup(frp, "Drop for Friends")
makeToggle(fr1, "Enable", false)
makeToggle(fr1, "Auto Pickup Back", true)
makeButton(fr1, "Refresh Friend List", function() end)

local ip = tabPages.Info
local i1 = makeGroup(ip, "Live Info")
local clk = Instance.new("TextLabel")
clk.Size = UDim2.new(1, -32, 0, 20)
clk.Position = UDim2.new(0, 16, 0, 8)
clk.BackgroundTransparency = 1
clk.Text = "Time: --:--"
clk.TextColor3 = cAccent
clk.Font = Enum.Font.GothamBold
clk.TextSize = 12
clk.TextXAlignment = Enum.TextXAlignment.Left
clk.Parent = i1
task.spawn(function()
    while clk.Parent do
        local h = math.floor((tick() % 86400) / 3600)
        local m = math.floor(((tick() % 86400) % 3600) / 60)
        clk.Text = string.format("Time: %02d:%02d", h, m)
        task.wait(1)
    end
end)

local sp = tabPages.Settings
local s1 = makeGroup(sp, "Performance")
makeToggle(s1, "Anti Lag", false)
makePicker(s1, "FPS Cap", {"30","45","60","Unlimited"}, "60")
local s2 = makeGroup(sp, "Server Guard")
makeToggle(s2, "Enable", false)
makePicker(s2, "Action", {"Auto-Leave","Auto-Hop","Notify Only"}, "Notify Only")
local s3 = makeGroup(sp, "Debug")
makeButton(s3, "Unload All", function()
    for _, x in ipairs(pg:GetChildren()) do
        if x:IsA("ScreenGui") and x.Name:find("OR4CLE") then x:Destroy() end
    end
end)

local dragging, dragStart, startPos
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

closeBtn.MouseButton1Click:Connect(function()
    for _, x in ipairs(pg:GetChildren()) do
        if x:IsA("ScreenGui") and x.Name:find("OR4CLE") then x:Destroy() end
    end
end)

local bubble = Instance.new("ScreenGui")
bubble.Name = "OR4CLE_Bubble"
bubble.ResetOnSpawn = false
bubble.DisplayOrder = 99999
bubble.IgnoreGuiInset = true
bubble.Parent = pg

local bb = Instance.new("TextButton")
bb.Size = UDim2.new(0, 50, 0, 50)
bb.Position = UDim2.new(0, 20, 0, 200)
bb.BackgroundColor3 = cBg
bb.Text = ""
bb.AutoButtonColor = false
bb.BorderSizePixel = 0
bb.Parent = bubble
Instance.new("UICorner", bb).CornerRadius = UDim.new(1, 0)

local bst = Instance.new("UIStroke", bb)
bst.Color = cAccent
bst.Thickness = 2.5

local blogo = Instance.new("ImageLabel")
blogo.Size = UDim2.new(1, -6, 1, -6)
blogo.Position = UDim2.new(0, 3, 0, 3)
blogo.BackgroundTransparency = 1
blogo.Image = LOGO
blogo.ScaleType = Enum.ScaleType.Crop
blogo.Parent = bb
Instance.new("UICorner", blogo).CornerRadius = UDim.new(1, 0)

local bdrag, bstart, bpos
bb.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        bdrag = true; bstart = input.Position; bpos = bb.Position
    end
end)
bb.InputChanged:Connect(function(input)
    if bdrag and (input.UserInputType == Enum.UserInputType.MouseMovement
    or input.UserInputType == Enum.UserInputType.Touch) then
        local d = input.Position - bstart
        bb.Position = UDim2.new(bpos.X.Scale, bpos.X.Offset + d.X, bpos.Y.Scale, bpos.Y.Offset + d.Y)
    end
end)
UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        bdrag = false
    end
end)

bb.MouseButton1Click:Connect(function()
    gui.Enabled = not gui.Enabled
end)

UIS.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        gui.Enabled = not gui.Enabled
    end
end)

task.defer(function()
    local vp2 = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(800,600)
    local as = main.AbsoluteSize
    if as.X > 0 then
        local px = math.max(4, math.floor((vp2.X - as.X) / 2))
        local py = math.max(30, math.floor((vp2.Y - as.Y) / 2))
        main.Position = UDim2.new(0, px, 0, py)
    end
end)

_G.OR4CLE = _G.OR4CLE or {}
_G.OR4CLE.version = VERSION
_G.OR4CLE.loaded = true

warn("[OR4CLE] v" .. VERSION)
