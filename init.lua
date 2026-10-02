-- OR4CLE — Ultra Premium UI
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local Tween = game:GetService("TweenService")
local Run = game:GetService("RunService")
local lp = Players.LocalPlayer
local pg = lp:WaitForChild("PlayerGui")

for _, x in ipairs(pg:GetChildren()) do
    if x:IsA("ScreenGui") and x.Name:find("OR4CLE") then x:Destroy() end
end

local LOGO = "rbxassetid://114651091062453"
local VERSION = "1.0.0"

local function tw(o, t, p, s)
    local tn = Tween:Create(o, TweenInfo.new(t or 0.2, s or Enum.EasingStyle.Quart, Enum.EasingDirection.Out), p)
    tn:Play()
    return tn
end

-- palette
local cBg        = Color3.fromRGB(10, 11, 17)
local cBg2       = Color3.fromRGB(13, 14, 22)
local cPanel     = Color3.fromRGB(17, 18, 28)
local cRow       = Color3.fromRGB(22, 23, 35)
local cRowHi     = Color3.fromRGB(28, 30, 44)
local cAccent    = Color3.fromRGB(140, 92, 252)
local cAccent2   = Color3.fromRGB(180, 130, 255)
local cCyan      = Color3.fromRGB(95, 210, 255)
local cText      = Color3.fromRGB(240, 240, 250)
local cLabel     = Color3.fromRGB(205, 205, 220)
local cDim       = Color3.fromRGB(125, 128, 148)
local cMuted     = Color3.fromRGB(62, 65, 82)
local cLine      = Color3.fromRGB(32, 34, 50)

local vp = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(800,600)
local SIDEBAR_W = 148
local TOPBAR_H = 52
-- clamp: max 580x420, tapi kalo viewport kecil sesuaikan
local W = math.min(580, vp.X - 40)
local H = math.min(420, vp.Y - 120)  -- reservasi 120px buat topbar + offset
if H < 260 then H = vp.Y - 40 end     -- darurat
if W < 400 then W = vp.X - 20 end

-- ═══════════════════════════════════════
-- WINDOW
-- ═══════════════════════════════════════
local gui = Instance.new("ScreenGui")
gui.Name = "OR4CLE_Window"
gui.ResetOnSpawn = false
gui.DisplayOrder = 99998
gui.IgnoreGuiInset = true
gui.Enabled = false
gui.Parent = pg

-- outer ambient glow
local glow = Instance.new("Frame")
glow.Name = "Glow"
glow.Size = UDim2.new(0, W + 32, 0, H + 32)
glow.Position = UDim2.new(0, 40 - 16, 0, 80 - 16)
glow.BackgroundColor3 = cAccent
glow.BackgroundTransparency = 0.93
glow.BorderSizePixel = 0
glow.ZIndex = 0
glow.Parent = gui
Instance.new("UICorner", glow).CornerRadius = UDim.new(0, 20)

-- drop shadow
local shadow = Instance.new("Frame")
shadow.Name = "Shadow"
shadow.Size = UDim2.new(0, W + 8, 0, H + 8)
shadow.Position = UDim2.new(0, 40 - 4, 0, 80 + 6)
shadow.BackgroundColor3 = Color3.fromRGB(0,0,0)
shadow.BackgroundTransparency = 0.45
shadow.BorderSizePixel = 0
shadow.ZIndex = 1
shadow.Parent = gui
Instance.new("UICorner", shadow).CornerRadius = UDim.new(0, 14)

-- main
local main = Instance.new("Frame")
main.Name = "Main"
main.Size = UDim2.new(0, W, 0, H)
main.Position = UDim2.new(0, 40, 0, 80)
main.BackgroundColor3 = cBg
main.BorderSizePixel = 0
main.ZIndex = 2
main.Parent = gui
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 12)

-- gradient border
local mSt = Instance.new("UIStroke", main)
mSt.Color = Color3.fromRGB(255,255,255)
mSt.Thickness = 1
mSt.Transparency = 0.7
local mGrad = Instance.new("UIGradient", mSt)
mGrad.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, cAccent),
    ColorSequenceKeypoint.new(0.33, cCyan),
    ColorSequenceKeypoint.new(0.66, cAccent2),
    ColorSequenceKeypoint.new(1, cAccent),
}
mGrad.Rotation = 45

-- animate gradient border rotation
task.spawn(function()
    local rot = 45
    while mGrad.Parent do
        rot = (rot + 1) % 360
        mGrad.Rotation = rot
        task.wait(0.05)
    end
end)

-- SHIMMER effect — cahaya bergerak dari kiri atas ke kanan bawah
local shimmer = Instance.new("Frame")
shimmer.Name = "Shimmer"
shimmer.Size = UDim2.new(0, 80, 1, 0)
shimmer.Position = UDim2.new(0, -100, 0, 0)
shimmer.BackgroundColor3 = Color3.fromRGB(255,255,255)
shimmer.BackgroundTransparency = 0.92
shimmer.BorderSizePixel = 0
shimmer.ZIndex = 4
shimmer.Parent = main
local shGrad = Instance.new("UIGradient", shimmer)
shGrad.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255,255,255)),
    ColorSequenceKeypoint.new(0.5, cCyan),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255,255,255)),
}
shGrad.Transparency = NumberSequence.new{
    NumberSequenceKeypoint.new(0, 1),
    NumberSequenceKeypoint.new(0.5, 0),
    NumberSequenceKeypoint.new(1, 1),
}
shGrad.Rotation = 30

task.spawn(function()
    while shimmer.Parent do
        shimmer.Position = UDim2.new(0, -100, 0, 0)
        local t = Tween:Create(shimmer, TweenInfo.new(3.5, Enum.EasingStyle.Linear), {
            Position = UDim2.new(1, 100, 0, 0),
        })
        t:Play()
        t.Completed:Wait()
        task.wait(2.5)
    end
end)

-- top subtle gradient overlay
local topGrad = Instance.new("Frame")
topGrad.Size = UDim2.new(1, 0, 0, 100)
topGrad.BackgroundColor3 = Color3.fromRGB(255,255,255)
topGrad.BackgroundTransparency = 0.98
topGrad.BorderSizePixel = 0
topGrad.ZIndex = 3
topGrad.Parent = main
Instance.new("UICorner", topGrad).CornerRadius = UDim.new(0, 12)
local tgGrad = Instance.new("UIGradient", topGrad)
tgGrad.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, cAccent),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0,0,0)),
}
tgGrad.Rotation = 90

-- ═══════════════════════════════════════
-- TOPBAR
-- ═══════════════════════════════════════
local top = Instance.new("Frame")
top.Name = "Topbar"
top.Size = UDim2.new(0, W, 0, TOPBAR_H)
top.BackgroundColor3 = cBg2
top.BorderSizePixel = 0
top.ZIndex = 10
top.Parent = main
Instance.new("UICorner", top).CornerRadius = UDim.new(0, 12)

local tmask = Instance.new("Frame")
tmask.Size = UDim2.new(0, W, 0, 16)
tmask.Position = UDim2.new(0, 0, 0, TOPBAR_H - 16)
tmask.BackgroundColor3 = cBg2
tmask.BorderSizePixel = 0
tmask.ZIndex = 10
tmask.Parent = top

-- topbar logo kecil dengan glow
local tLogoWrap = Instance.new("Frame")
tLogoWrap.Size = UDim2.new(0, 28, 0, 28)
tLogoWrap.Position = UDim2.new(0, 14, 0.5, -14)
tLogoWrap.BackgroundColor3 = cRow
tLogoWrap.BorderSizePixel = 0
tLogoWrap.ZIndex = 12
tLogoWrap.Parent = top
Instance.new("UICorner", tLogoWrap).CornerRadius = UDim.new(1, 0)

local tlSt = Instance.new("UIStroke", tLogoWrap)
tlSt.Color = Color3.fromRGB(255,255,255)
tlSt.Thickness = 1.5
local tlGrad = Instance.new("UIGradient", tlSt)
tlGrad.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, cAccent),
    ColorSequenceKeypoint.new(1, cCyan),
}
tlGrad.Rotation = 45

local tLogo = Instance.new("ImageLabel")
tLogo.Size = UDim2.new(1, -4, 1, -4)
tLogo.Position = UDim2.new(0, 2, 0, 2)
tLogo.BackgroundTransparency = 1
tLogo.Image = LOGO
tLogo.ScaleType = Enum.ScaleType.Crop
tLogo.ZIndex = 13
tLogo.Parent = tLogoWrap
Instance.new("UICorner", tLogo).CornerRadius = UDim.new(1, 0)

-- title kecil di top
local tTitle = Instance.new("TextLabel")
tTitle.Size = UDim2.new(0, 150, 1, 0)
tTitle.Position = UDim2.new(0, 50, 0, 0)
tTitle.BackgroundTransparency = 1
tTitle.Text = "OR4CLE"
tTitle.TextColor3 = cText
tTitle.Font = Enum.Font.GothamBold
tTitle.TextSize = 14
tTitle.TextXAlignment = Enum.TextXAlignment.Left
tTitle.ZIndex = 12
tTitle.Parent = top

-- search dihapus — ganti subtitle kecil
local tSub = Instance.new("TextLabel")
tSub.Size = UDim2.new(0, 200, 0, 12)
tSub.Position = UDim2.new(0, 50, 0, 30)
tSub.BackgroundTransparency = 1
tSub.Text = "Steal An Egg  ·  v" .. VERSION
tSub.TextColor3 = cDim
tSub.Font = Enum.Font.Gotham
tSub.TextSize = 9
tSub.TextXAlignment = Enum.TextXAlignment.Left
tSub.ZIndex = 12
tSub.Parent = top

-- window controls
local function mkCtrl(text, xOff, hover, onClick)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0, 28, 0, 28)
    b.Position = UDim2.new(0, W - xOff, 0.5, -14)
    b.BackgroundColor3 = cRow
    b.Text = text
    b.TextColor3 = cDim
    b.Font = Enum.Font.GothamBold
    b.TextSize = 13
    b.BorderSizePixel = 0
    b.AutoButtonColor = false
    b.ZIndex = 11
    b.Parent = top
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)

    b.MouseEnter:Connect(function() tw(b, 0.15, {BackgroundColor3 = hover, TextColor3 = Color3.fromRGB(255,255,255)}) end)
    b.MouseLeave:Connect(function() tw(b, 0.15, {BackgroundColor3 = cRow, TextColor3 = cDim}) end)
    b.MouseButton1Click:Connect(function() if onClick then pcall(onClick) end end)
    return b
end

local closeBtn = mkCtrl("X", 42, Color3.fromRGB(240,70,90), function()
    for _, x in ipairs(pg:GetChildren()) do
        if x:IsA("ScreenGui") and x.Name:find("OR4CLE") then x:Destroy() end
    end
end)
local minBtn = mkCtrl("-", 78, cAccent, function() gui.Enabled = false end)

-- ═══════════════════════════════════════
-- SIDEBAR
-- ═══════════════════════════════════════
local sidebar = Instance.new("Frame")
sidebar.Name = "Sidebar"
sidebar.Size = UDim2.new(0, SIDEBAR_W, 0, H - TOPBAR_H)
sidebar.Position = UDim2.new(0, 0, 0, TOPBAR_H)
sidebar.BackgroundColor3 = cBg
sidebar.BorderSizePixel = 0
sidebar.ZIndex = 5
sidebar.Parent = main

-- content
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
csl.Padding = UDim.new(0, 20)
csl.Parent = cs

-- ═══════════════════════════════════════
-- TABS
-- ═══════════════════════════════════════
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
        if lbl then tw(lbl, 0.2, {TextColor3 = a and cText or cDim}) end
        local ln = tabLines[n]
        if ln then
            if a then
                ln.Visible = true
                ln.Size = UDim2.new(0, 0, 0, 2)
                tw(ln, 0.25, {Size = UDim2.new(0, SIDEBAR_W - 48, 0, 2)})
            else
                ln.Visible = false
            end
        end
    end
    for n, p in pairs(tabPages) do p.Visible = (n == id) end
end

for i, def in ipairs(tabDefs) do
    local btn = Instance.new("TextButton")
    btn.Name = def.id .. "Tab"
    btn.Size = UDim2.new(0, SIDEBAR_W, 0, 40)
    btn.Position = UDim2.new(0, 0, 0, 18 + (i-1) * 42)
    btn.BackgroundColor3 = cBg
    btn.Text = ""
    btn.AutoButtonColor = false
    btn.BorderSizePixel = 0
    btn.ZIndex = 6
    btn.Parent = sidebar

    local lbl = Instance.new("TextLabel")
    lbl.Name = "Lbl"
    lbl.Size = UDim2.new(1, -28, 1, 0)
    lbl.Position = UDim2.new(0, 24, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = def.name
    lbl.TextColor3 = cDim
    lbl.Font = Enum.Font.GothamMedium
    lbl.TextSize = 12
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.ZIndex = 7
    lbl.Parent = btn

    local line = Instance.new("Frame")
    line.Size = UDim2.new(0, SIDEBAR_W - 48, 0, 2)
    line.Position = UDim2.new(0, 24, 1, -6)
    line.BackgroundColor3 = cAccent
    line.BorderSizePixel = 0
    line.Visible = false
    line.ZIndex = 8
    line.Parent = btn
    Instance.new("UICorner", line).CornerRadius = UDim.new(1, 0)
    local lGrad = Instance.new("UIGradient", line)
    lGrad.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, cAccent),
        ColorSequenceKeypoint.new(1, cCyan),
    }

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
    pl.Padding = UDim.new(0, 20)
    pl.Parent = page

    tabPages[def.id] = page

    btn.MouseButton1Click:Connect(function() selectTab(def.id) end)
    btn.MouseEnter:Connect(function()
        if lbl then tw(lbl, 0.15, {TextColor3 = cLabel}) end
    end)
    btn.MouseLeave:Connect(function()
        local active = tabLines[def.id] and tabLines[def.id].Visible
        if lbl and not active then tw(lbl, 0.15, {TextColor3 = cDim}) end
    end)
end

selectTab("Visual")

-- ═══════════════════════════════════════
-- COMPONENTS
-- ═══════════════════════════════════════
local function makeGroup(page, titleText)
    local wrap = Instance.new("Frame")
    wrap.Size = UDim2.new(1, 0, 0, 0)
    wrap.AutomaticSize = Enum.AutomaticSize.Y
    wrap.BackgroundTransparency = 1
    wrap.Parent = page

    -- header row: bar + label
    local hdrRow = Instance.new("Frame")
    hdrRow.Size = UDim2.new(1, 0, 0, 18)
    hdrRow.BackgroundTransparency = 1
    hdrRow.Parent = wrap

    local bar = Instance.new("Frame")
    bar.Size = UDim2.new(0, 3, 0, 12)
    bar.Position = UDim2.new(0, 0, 0.5, -6)
    bar.BackgroundColor3 = cAccent
    bar.BorderSizePixel = 0
    bar.Parent = hdrRow
    Instance.new("UICorner", bar).CornerRadius = UDim.new(1, 0)

    local hdr = Instance.new("TextLabel")
    hdr.Size = UDim2.new(1, -10, 1, 0)
    hdr.Position = UDim2.new(0, 10, 0, 0)
    hdr.BackgroundTransparency = 1
    hdr.Text = string.upper(titleText)
    hdr.TextColor3 = cDim
    hdr.Font = Enum.Font.GothamBold
    hdr.TextSize = 10
    hdr.TextXAlignment = Enum.TextXAlignment.Left
    hdr.Parent = hdrRow

    local body = Instance.new("Frame")
    body.Size = UDim2.new(1, 0, 0, 0)
    body.Position = UDim2.new(0, 0, 0, 26)
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
    row.Size = UDim2.new(1, 0, 0, 46)
    row.BackgroundColor3 = cRow
    row.BorderSizePixel = 0
    row.Parent = parent
    Instance.new("UICorner", row).CornerRadius = UDim.new(0, 8)

    local rSt = Instance.new("UIStroke", row)
    rSt.Color = cLine
    rSt.Thickness = 1
    rSt.Transparency = 0.6

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
    stl.Size = UDim2.new(0, 32, 1, 0)
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
        tw(btn, 0.2, {BackgroundColor3 = state and cAccent or cMuted})
        tw(dot, 0.2, {Position = state and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)})
        stl.Text = state and "ON" or "OFF"
        if onChange then pcall(onChange, state) end
    end)
end

local function makePicker(parent, labelText, options, default, onSelect)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 46)
    row.BackgroundColor3 = cRow
    row.BorderSizePixel = 0
    row.Parent = parent
    Instance.new("UICorner", row).CornerRadius = UDim.new(0, 8)

    local rSt = Instance.new("UIStroke", row)
    rSt.Color = cLine
    rSt.Thickness = 1
    rSt.Transparency = 0.6

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
    popup.Size = UDim2.new(0, 180, 0, 0)
    popup.AutomaticSize = Enum.AutomaticSize.Y
    popup.Position = UDim2.new(1, -188, 1, 6)
    popup.BackgroundColor3 = cPanel
    popup.BorderSizePixel = 0
    popup.ZIndex = 50
    popup.Parent = row
    Instance.new("UICorner", popup).CornerRadius = UDim.new(0, 8)
    local pst = Instance.new("UIStroke", popup)
    pst.Color = cAccent
    pst.Thickness = 1
    pst.Transparency = 0.5

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
        o.BackgroundColor3 = cPanel
        o.Text = tostring(opt)
        o.TextColor3 = cLabel
        o.Font = Enum.Font.Gotham
        o.TextSize = 11
        o.BorderSizePixel = 0
        o.AutoButtonColor = false
        o.Parent = popup
        o.MouseEnter:Connect(function() o.BackgroundColor3 = cRowHi end)
        o.MouseLeave:Connect(function() o.BackgroundColor3 = cPanel end)
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
    btn.Size = UDim2.new(1, 0, 0, 42)
    btn.BackgroundColor3 = cRow
    btn.Text = labelText
    btn.TextColor3 = cLabel
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 12
    btn.BorderSizePixel = 0
    btn.AutoButtonColor = false
    btn.Parent = parent
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)

    local bSt = Instance.new("UIStroke", btn)
    bSt.Color = cLine
    bSt.Thickness = 1
    bSt.Transparency = 0.6

    btn.MouseEnter:Connect(function() tw(btn, 0.15, {BackgroundColor3 = cRowHi}) end)
    btn.MouseLeave:Connect(function() tw(btn, 0.15, {BackgroundColor3 = cRow}) end)
    btn.MouseButton1Click:Connect(function()
        if onClick then pcall(onClick) end
    end)
end

-- FILL VISUAL
local rarityList = {"Common","Uncommon","Rare","Epic","Legendary","Mythic","Cosmic","Secret","Eternal","Divine"}
local rarityOptions = {}
for i, r in ipairs(rarityList) do
    table.insert(rarityOptions, string.format("%02d %s", i, r))
end

local vp_ = tabPages.Visual
local v1 = makeGroup(vp_, "Egg ESP")
makeToggle(v1, "Enable Egg ESP", false, function(state)
    local esp = _G.OR4CLE and _G.OR4CLE.modules and _G.OR4CLE.modules.esp_egg
    if esp then
        if state then pcall(esp.start, {}) else pcall(esp.stop) end
    end
end)
local v2 = makeGroup(vp_, "ESP Rarity")
makePicker(v2, "ESP Min Tier", rarityOptions, "01 Common")
local v3 = makeGroup(vp_, "ESP Style")
makePicker(v3, "Style", {"Panel","Text","Minimal"}, "Panel")
local v4 = makeGroup(vp_, "ESP Settings")
makeToggle(v4, "Show Pet Name", true)
makeToggle(v4, "Show Rarity", true)
makeToggle(v4, "Show Distance", false)
makeToggle(v4, "Show Tracer", false)

-- FARM
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
local f4 = makeGroup(fp, "Auto Treadmill")
makeToggle(f4, "Enable Auto Treadmill", false)
local f5 = makeGroup(fp, "Speed Boost")
makeToggle(f5, "Enable Speed Boost", false)

-- FRIEND
local frp = tabPages.Friends
local fr1 = makeGroup(frp, "Drop for Friends")
makeToggle(fr1, "Enable", false)
makeToggle(fr1, "Auto Pickup Back", true)
makeButton(fr1, "Refresh Friend List", function() end)

-- UTILITY
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

-- SETTINGS
local sp = tabPages.Settings
local s1 = makeGroup(sp, "Performance")
makeToggle(s1, "Anti Lag", false)
makePicker(s1, "FPS Cap", {"30","45","60","Unlimited"}, "60")
local s2 = makeGroup(sp, "Server Guard")
makeToggle(s2, "Enable", false)
makePicker(s2, "Action", {"Auto-Leave","Auto-Hop","Notify Only"}, "Notify Only")
local s3 = makeGroup(sp, "Debug")
makeButton(s3, "Reload Script", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/OzLL-BeeP/or4cle-steal-an-egg/main/init.lua"))()
end)
makeButton(s3, "Unload All", function()
    for _, x in ipairs(pg:GetChildren()) do
        if x:IsA("ScreenGui") and x.Name:find("OR4CLE") then x:Destroy() end
    end
end)

-- ═══════════════════════════════════════
-- DRAG
-- ═══════════════════════════════════════
local dragging, dragStart, startPos
local function repositionGlow(pos)
    glow.Position = UDim2.new(pos.X.Scale, pos.X.Offset - 16, pos.Y.Scale, pos.Y.Offset - 16)
    shadow.Position = UDim2.new(pos.X.Scale, pos.X.Offset - 4, pos.Y.Scale, pos.Y.Offset + 6)
end

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
        local np = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X,
                             startPos.Y.Scale, startPos.Y.Offset + d.Y)
        main.Position = np
        repositionGlow(np)
    end
end)
UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

-- ═══════════════════════════════════════
-- BUBBLE (upgraded logo overlay)
-- ═══════════════════════════════════════
local bubble = Instance.new("ScreenGui")
bubble.Name = "OR4CLE_Bubble"
bubble.ResetOnSpawn = false
bubble.DisplayOrder = 99999
bubble.IgnoreGuiInset = true
bubble.Parent = pg

-- outer glow layer
local bGlow = Instance.new("ImageLabel")
bGlow.Size = UDim2.new(0, 70, 0, 70)
bGlow.Position = UDim2.new(0, 20 - 10, 0, 200 - 10)
bGlow.BackgroundTransparency = 1
bGlow.Image = LOGO
bGlow.ImageColor3 = cAccent
bGlow.ImageTransparency = 0.75
bGlow.ScaleType = Enum.ScaleType.Crop
bGlow.ZIndex = 0
bGlow.Parent = bubble
Instance.new("UICorner", bGlow).CornerRadius = UDim.new(1, 0)

-- pulse ring
local bPulse = Instance.new("Frame")
bPulse.Size = UDim2.new(0, 50, 0, 50)
bPulse.Position = UDim2.new(0, 20, 0, 200)
bPulse.BackgroundTransparency = 1
bPulse.ZIndex = 1
bPulse.Parent = bubble
Instance.new("UICorner", bPulse).CornerRadius = UDim.new(1, 0)
local bPSt = Instance.new("UIStroke", bPulse)
bPSt.Color = cAccent
bPSt.Thickness = 2
bPSt.Transparency = 0.7

-- ring layer
local bRing = Instance.new("Frame")
bRing.Size = UDim2.new(0, 56, 0, 56)
bRing.Position = UDim2.new(0, 20 - 3, 0, 200 - 3)
bRing.BackgroundTransparency = 1
bRing.ZIndex = 2
bRing.Parent = bubble
Instance.new("UICorner", bRing).CornerRadius = UDim.new(1, 0)
local bRSt = Instance.new("UIStroke", bRing)
bRSt.Color = cAccent2
bRSt.Thickness = 1
bRSt.Transparency = 0.4

-- main button
local bb = Instance.new("TextButton")
bb.Size = UDim2.new(0, 50, 0, 50)
bb.Position = UDim2.new(0, 20, 0, 200)
bb.BackgroundColor3 = cBg
bb.Text = ""
bb.AutoButtonColor = false
bb.BorderSizePixel = 0
bb.ZIndex = 3
bb.Parent = bubble
Instance.new("UICorner", bb).CornerRadius = UDim.new(1, 0)

local bSt = Instance.new("UIStroke", bb)
bSt.Color = cAccent
bSt.Thickness = 2.5

local blogo = Instance.new("ImageLabel")
blogo.Size = UDim2.new(1, -6, 1, -6)
blogo.Position = UDim2.new(0, 3, 0, 3)
blogo.BackgroundTransparency = 1
blogo.Image = LOGO
blogo.ScaleType = Enum.ScaleType.Crop
blogo.ZIndex = 4
blogo.Parent = bb
Instance.new("UICorner", blogo).CornerRadius = UDim.new(1, 0)

-- bubble shimmer (cahaya bergerak di atas logo)
local bShimmer = Instance.new("Frame")
bShimmer.Size = UDim2.new(0, 18, 1, 0)
bShimmer.Position = UDim2.new(0, -20, 0, 0)
bShimmer.BackgroundColor3 = Color3.fromRGB(255,255,255)
bShimmer.BackgroundTransparency = 0.7
bShimmer.BorderSizePixel = 0
bShimmer.ZIndex = 5
bShimmer.Parent = bb
Instance.new("UICorner", bShimmer).CornerRadius = UDim.new(1, 0)
local bShGrad = Instance.new("UIGradient", bShimmer)
bShGrad.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255,255,255)),
    ColorSequenceKeypoint.new(0.5, cCyan),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255,255,255)),
}
bShGrad.Transparency = NumberSequence.new{
    NumberSequenceKeypoint.new(0, 1),
    NumberSequenceKeypoint.new(0.5, 0.2),
    NumberSequenceKeypoint.new(1, 1),
}
bShGrad.Rotation = 30

task.spawn(function()
    while bShimmer.Parent do
        bShimmer.Position = UDim2.new(0, -20, 0, 0)
        local t = Tween:Create(bShimmer, TweenInfo.new(2.5, Enum.EasingStyle.Linear), {
            Position = UDim2.new(1, 20, 0, 0),
        })
        t:Play()
        t.Completed:Wait()
        task.wait(2)
    end
end)

-- pulse animation
task.spawn(function()
    while bPulse.Parent do
        bPSt.Transparency = 0.7
        bPulse.Size = UDim2.new(0, 50, 0, 50)
        local t1 = Tween:Create(bPulse, TweenInfo.new(1.8, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 80, 0, 80),
        })
        local t2 = Tween:Create(bPSt, TweenInfo.new(1.8, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Transparency = 1,
        })
        t1:Play(); t2:Play()
        task.wait(1.8)
    end
end)

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
        local np = UDim2.new(bpos.X.Scale, bpos.X.Offset + d.X, bpos.Y.Scale, bpos.Y.Offset + d.Y)
        bb.Position = np
        bGlow.Position = UDim2.new(np.X.Scale, np.X.Offset - 10, np.Y.Scale, np.Y.Offset - 10)
        bRing.Position = UDim2.new(np.X.Scale, np.X.Offset - 3, np.Y.Scale, np.Y.Offset - 3)
        bPulse.Position = np
    end
end)
UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        bdrag = false
    end
end)

bb.MouseEnter:Connect(function() tw(bSt, 0.15, {Thickness = 3.5}) end)
bb.MouseLeave:Connect(function() tw(bSt, 0.15, {Thickness = 2.5}) end)

bb.MouseButton1Click:Connect(function()
    gui.Enabled = not gui.Enabled
end)

UIS.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        gui.Enabled = not gui.Enabled
    end
end)

-- recenter
task.defer(function()
    local vp2 = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(800,600)
    -- clamp window size ke viewport
    local fitW = math.min(W, vp2.X - 20)
    local fitH = math.min(H, vp2.Y - 40)
    if fitH < 200 then fitH = vp2.Y - 20 end
    main.Size = UDim2.new(0, fitW, 0, fitH)
    task.wait(0.1)
    local px = math.max(10, math.floor((vp2.X - fitW) / 2))
    local py = math.max(40, math.floor((vp2.Y - fitH) / 2) + 10)
    main.Position = UDim2.new(0, px, 0, py)
    glow.Position = UDim2.new(0, px - 16, 0, py - 16)
    shadow.Position = UDim2.new(0, px - 4, 0, py + 6)
end)

_G.OR4CLE = _G.OR4CLE or {}
_G.OR4CLE.version = VERSION
_G.OR4CLE.loaded = true

warn("[OR4CLE] v" .. VERSION)
