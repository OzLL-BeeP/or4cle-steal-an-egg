-- ui/window.lua — ultra modern pro
local Players = game:GetService("Players")
local UIS     = game:GetService("UserInputService")
local Tween   = game:GetService("TweenService")

local C = {}
C.__index = C

local function tw(o, t, props, style, dir)
    local info = TweenInfo.new(t or 0.2, style or Enum.EasingStyle.Quart, dir or Enum.EasingDirection.Out)
    local t2 = Tween:Create(o, info, props)
    t2:Play()
    return t2
end

local function addShadow(parent, radius)
    local sh = Instance.new("Frame", parent)
    sh.Name = "Shadow"
    sh.Size = UDim2.new(1, 12, 1, 12)
    sh.Position = UDim2.new(0, -6, 0, 4)
    sh.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    sh.BackgroundTransparency = 0.55
    sh.BorderSizePixel = 0
    sh.ZIndex = parent.ZIndex - 1
    Instance.new("UICorner", sh).CornerRadius = UDim.new(0, radius or 14)
    return sh
end

function C.new(ctx)
    local self = setmetatable({}, C)
    self.ctx = ctx
    local cfg = ctx.config or {}
    local T   = cfg.Theme or {}
    local UI  = cfg.UI or {}
    local pg  = Players.LocalPlayer:WaitForChild("PlayerGui")

    local vp = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(900, 600)
    local isMobile = vp.X < 700
    local W = math.min((UI.WindowSize and UI.WindowSize.X) or 680, vp.X - (isMobile and 16 or 60))
    local H = math.min((UI.WindowSize and UI.WindowSize.Y) or 480, vp.Y - (isMobile and 40 or 100))
    local SIDEBAR_W = isMobile and 100 or 168

    local cBg       = Color3.fromRGB(11, 11, 17)
    local cBg2      = Color3.fromRGB(15, 15, 22)
    local cSurface  = Color3.fromRGB(20, 20, 28)
    local cSurface2 = Color3.fromRGB(28, 28, 38)
    local cSurface3 = Color3.fromRGB(38, 38, 52)
    local cBorder   = Color3.fromRGB(50, 44, 80)
    local cPurple   = T.Purple or Color3.fromRGB(140, 90, 250)
    local cViolet   = Color3.fromRGB(180, 130, 255)
    local cBlue     = T.Blue or Color3.fromRGB(60, 130, 250)
    local cCyan     = Color3.fromRGB(90, 200, 255)
    local cText     = Color3.fromRGB(245, 245, 252)
    local cSub      = Color3.fromRGB(145, 145, 170)
    local cMuted    = Color3.fromRGB(85, 85, 105)
    local cDanger   = Color3.fromRGB(245, 75, 75)
    local cGreen    = Color3.fromRGB(70, 220, 140)

    local gui = Instance.new("ScreenGui")
    gui.Name = "OR4CLE_Window"
    gui.ResetOnSpawn = false
    gui.DisplayOrder = 99998
    gui.IgnoreGuiInset = true
    gui.Enabled = false
    gui.Parent = pg

    -- wrapper
    local wrap = Instance.new("Frame")
    wrap.Name = "Wrap"
    wrap.Size = UDim2.new(0, W, 0, H)
    wrap.Position = UDim2.new(0, 30, 0, 100)
    wrap.BackgroundTransparency = 1
    wrap.Parent = gui

    -- outer glow
    local outerGlow = Instance.new("Frame", wrap)
    outerGlow.Name = "OuterGlow"
    outerGlow.Size = UDim2.new(1, 24, 1, 24)
    outerGlow.Position = UDim2.new(0, -12, 0, -12)
    outerGlow.BackgroundColor3 = cPurple
    outerGlow.BackgroundTransparency = 0.92
    outerGlow.BorderSizePixel = 0
    outerGlow.ZIndex = 0
    Instance.new("UICorner", outerGlow).CornerRadius = UDim.new(0, 24)

    -- drop shadow
    local dropShadow = Instance.new("Frame", wrap)
    dropShadow.Name = "DropShadow"
    dropShadow.Size = UDim2.new(1, 10, 1, 10)
    dropShadow.Position = UDim2.new(0, -5, 0, 5)
    dropShadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    dropShadow.BackgroundTransparency = 0.6
    dropShadow.BorderSizePixel = 0
    dropShadow.ZIndex = 1
    Instance.new("UICorner", dropShadow).CornerRadius = UDim.new(0, 18)

    -- main container
    local main = Instance.new("Frame")
    main.Name = "Main"
    main.Size = UDim2.new(1, 0, 1, 0)
    main.BackgroundColor3 = cBg
    main.BorderSizePixel = 0
    main.ClipsDescendants = true
    main.ZIndex = 2
    main.Parent = wrap
    Instance.new("UICorner", main).CornerRadius = UDim.new(0, 18)

    -- gradient border (UIStroke + gradient)
    local borderStroke = Instance.new("UIStroke", main)
    borderStroke.Color = Color3.fromRGB(255,255,255)
    borderStroke.Thickness = 1.5
    borderStroke.Transparency = 0.2
    local borderGrad = Instance.new("UIGradient", borderStroke)
    borderGrad.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, cPurple),
        ColorSequenceKeypoint.new(0.5, cViolet),
        ColorSequenceKeypoint.new(1, cCyan),
    }
    borderGrad.Rotation = 45

    -- backdrop subtle gradient
    local bgGrad = Instance.new("Frame", main)
    bgGrad.Size = UDim2.new(1, 0, 1, 0)
    bgGrad.BackgroundColor3 = Color3.fromRGB(255,255,255)
    bgGrad.BackgroundTransparency = 0.97
    bgGrad.BorderSizePixel = 0
    bgGrad.ZIndex = 2
    Instance.new("UICorner", bgGrad).CornerRadius = UDim.new(0, 18)
    local bgGrad2 = Instance.new("UIGradient", bgGrad)
    bgGrad2.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, cPurple),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0,0,0)),
    }
    bgGrad2.Rotation = 135

    -- ═══ TOPBAR FLOATING ═══
    local top = Instance.new("Frame")
    top.Name = "Topbar"
    top.Size = UDim2.new(1, -24, 0, 56)
    top.Position = UDim2.new(0, 12, 0, 12)
    top.BackgroundColor3 = cSurface
    top.BorderSizePixel = 0
    top.ZIndex = 4
    top.Parent = main
    Instance.new("UICorner", top).CornerRadius = UDim.new(0, 14)

    local topStroke = Instance.new("UIStroke", top)
    topStroke.Color = cBorder
    topStroke.Thickness = 1
    topStroke.Transparency = 0.6

    -- logo dengan gradient ring
    local logoRing = Instance.new("Frame", top)
    logoRing.Size = UDim2.new(0, 36, 0, 36)
    logoRing.Position = UDim2.new(0, 12, 0.5, -18)
    logoRing.BackgroundColor3 = cSurface2
    logoRing.BorderSizePixel = 0
    logoRing.ZIndex = 5
    Instance.new("UICorner", logoRing).CornerRadius = UDim.new(1, 0)

    local ringStroke = Instance.new("UIStroke", logoRing)
    ringStroke.Color = Color3.fromRGB(255,255,255)
    ringStroke.Thickness = 2
    local ringGrad = Instance.new("UIGradient", ringStroke)
    ringGrad.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, cPurple),
        ColorSequenceKeypoint.new(1, cCyan),
    }
    ringGrad.Rotation = 45

    local topLogo = Instance.new("ImageLabel")
    topLogo.Size = UDim2.new(1, -6, 1, -6)
    topLogo.Position = UDim2.new(0, 3, 0, 3)
    topLogo.BackgroundTransparency = 1
    topLogo.Image = (cfg.Assets and cfg.Assets.Logo) or ""
    topLogo.ScaleType = Enum.ScaleType.Crop
    topLogo.ZIndex = 6
    topLogo.Parent = logoRing
    Instance.new("UICorner", topLogo).CornerRadius = UDim.new(1, 0)

    -- title
    local title = Instance.new("TextLabel", top)
    title.Size = UDim2.new(0, 200, 0, 20)
    title.Position = UDim2.new(0, 60, 0, 10)
    title.BackgroundTransparency = 1
    title.Text = "OR4CLE"
    title.TextColor3 = cText
    title.Font = Enum.Font.GothamBold
    title.TextSize = 16
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.ZIndex = 5

    local subtitle = Instance.new("TextLabel", top)
    subtitle.Size = UDim2.new(0, 200, 0, 14)
    subtitle.Position = UDim2.new(0, 60, 0, 30)
    subtitle.BackgroundTransparency = 1
    subtitle.Text = "Steal An Egg  ·  v" .. (cfg.VERSION or "?")
    subtitle.TextColor3 = cSub
    subtitle.Font = Enum.Font.Gotham
    subtitle.TextSize = 10
    subtitle.TextXAlignment = Enum.TextXAlignment.Left
    subtitle.ZIndex = 5

    -- window controls — pill group
    local ctrlWrap = Instance.new("Frame", top)
    ctrlWrap.Size = UDim2.new(0, 76, 0, 30)
    ctrlWrap.Position = UDim2.new(1, -88, 0.5, -15)
    ctrlWrap.BackgroundColor3 = cSurface2
    ctrlWrap.BorderSizePixel = 0
    ctrlWrap.ZIndex = 5
    Instance.new("UICorner", ctrlWrap).CornerRadius = UDim.new(0, 10)

    local ctrlStroke = Instance.new("UIStroke", ctrlWrap)
    ctrlStroke.Color = cBorder
    ctrlStroke.Thickness = 1
    ctrlStroke.Transparency = 0.5

    local function mkPillBtn(name, sym, color, xOff, onClick)
        local b = Instance.new("TextButton", ctrlWrap)
        b.Name = name
        b.Size = UDim2.new(0, 30, 0, 22)
        b.Position = UDim2.new(0, xOff, 0.5, -11)
        b.BackgroundColor3 = cSurface2
        b.Text = sym
        b.TextColor3 = cSub
        b.Font = Enum.Font.GothamBold
        b.TextSize = 13
        b.BorderSizePixel = 0
        b.AutoButtonColor = false
        b.ZIndex = 6
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)

        b.MouseEnter:Connect(function()
            tw(b, 0.15, {BackgroundColor3 = color, TextColor3 = Color3.fromRGB(255,255,255)})
        end)
        b.MouseLeave:Connect(function()
            tw(b, 0.15, {BackgroundColor3 = cSurface2, TextColor3 = cSub})
        end)
        b.MouseButton1Click:Connect(function()
            if onClick then pcall(onClick) end
        end)
        return b
    end

    local closeBtn = mkPillBtn("Close", "X", cDanger, 42, function()
        local pgAll = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
        for _, x in ipairs(pgAll:GetChildren()) do
            if x:IsA("ScreenGui") then
                if x.Name:find("OR4CLE") or x.Name == "BubbleCheck" or x.Name == "DeepDebug" or x.Name == "PagesDebug" or x.Name == "LineDebug" or x.Name == "IsolateTest" or x.Name == "UtilTest" or x.Name == "BubbleTest" then
                    x:Destroy()
                end
            end
        end
    end)
    local minBtn = mkPillBtn("Min", "–", cPurple, 6, function()
        gui.Enabled = false
    end)

    -- ═══ SIDEBAR ═══
    local sidebar = Instance.new("Frame", main)
    sidebar.Name = "Sidebar"
    sidebar.Size = UDim2.new(0, SIDEBAR_W, 1, -80)
    sidebar.Position = UDim2.new(0, 12, 0, 76)
    sidebar.BackgroundColor3 = cSurface
    sidebar.BorderSizePixel = 0
    sidebar.ZIndex = 3
    Instance.new("UICorner", sidebar).CornerRadius = UDim.new(0, 14)

    local sbStroke = Instance.new("UIStroke", sidebar)
    sbStroke.Color = cBorder
    sbStroke.Thickness = 1
    sbStroke.Transparency = 0.6

    local sbPad = Instance.new("UIPadding", sidebar)
    sbPad.PaddingTop = UDim.new(0, 10)
    sbPad.PaddingBottom = UDim.new(0, 10)
    sbPad.PaddingLeft = UDim.new(0, 8)
    sbPad.PaddingRight = UDim.new(0, 8)

    local sbList = Instance.new("UIListLayout", sidebar)
    sbList.Padding = UDim.new(0, 4)
    sbList.SortOrder = Enum.SortOrder.LayoutOrder

    -- ═══ CONTENT ═══
    local contentWrap = Instance.new("Frame", main)
    contentWrap.Name = "ContentWrap"
    contentWrap.Size = UDim2.new(1, -SIDEBAR_W - 24, 1, -88)
    contentWrap.Position = UDim2.new(0, SIDEBAR_W + 20, 0, 76)
    contentWrap.BackgroundColor3 = cSurface
    contentWrap.BorderSizePixel = 0
    contentWrap.ZIndex = 3
    Instance.new("UICorner", contentWrap).CornerRadius = UDim.new(0, 14)

    local cwStroke = Instance.new("UIStroke", contentWrap)
    cwStroke.Color = cBorder
    cwStroke.Thickness = 1
    cwStroke.Transparency = 0.6

    local contentScroll = Instance.new("ScrollingFrame", contentWrap)
    contentScroll.Name = "Content"
    contentScroll.Size = UDim2.new(1, -16, 1, -16)
    contentScroll.Position = UDim2.new(0, 8, 0, 8)
    contentScroll.BackgroundTransparency = 1
    contentScroll.BorderSizePixel = 0
    contentScroll.ScrollBarThickness = 3
    contentScroll.ScrollBarImageColor3 = cPurple
    contentScroll.ScrollBarImageTransparency = 0.3
    contentScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    contentScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    contentScroll.ZIndex = 4
    contentScroll.Parent = contentWrap

    local csList = Instance.new("UIListLayout", contentScroll)
    csList.Padding = UDim.new(0, 12)
    csList.SortOrder = Enum.SortOrder.LayoutOrder

    self.gui = gui
    self.main = main
    self.wrap = wrap
    self.top = top
    self.sidebar = sidebar
    self.content = contentScroll

    -- ═══ TABS ═══
    local tabs = (UI.TabList) or { "Visual", "Farm", "Friends", "Info", "Settings" }
    self.tabButtons = {}
    self.tabPages = {}
    self.tabAccents = {}

    local function selectTab(name)
        for n, btn in pairs(self.tabButtons) do
            local isActive = (n == name)
            local lbl = btn:FindFirstChild("Label")
            local ico = btn:FindFirstChild("Icon")
            local acc = self.tabAccents[n]
            tw(btn, 0.22, {BackgroundColor3 = isActive and cSurface3 or cSurface})
            if lbl then tw(lbl, 0.22, {TextColor3 = isActive and cText or cSub}) end
            if ico then tw(ico, 0.22, {TextColor3 = isActive and cViolet or cMuted}) end
            if acc then
                tw(acc, 0.22, {
                    BackgroundTransparency = isActive and 0 or 1,
                    Size = isActive and UDim2.new(0, 3, 0, 22) or UDim2.new(0, 3, 0, 12)
                })
            end
        end
        for n, p in pairs(self.tabPages) do
            p.Visible = (n == name)
        end
        self.activeTab = name
    end

    for i, name in ipairs(tabs) do
        local btn = Instance.new("TextButton", sidebar)
        btn.Name = name .. "Tab"
        btn.Size = UDim2.new(1, 0, 0, 40)
        btn.BackgroundColor3 = cSurface
        btn.Text = ""
        btn.AutoButtonColor = false
        btn.BorderSizePixel = 0
        btn.LayoutOrder = i
        btn.ZIndex = 4
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)

        -- accent bar left
        local acc = Instance.new("Frame", btn)
        acc.Name = "Accent"
        acc.Size = UDim2.new(0, 3, 0, 12)
        acc.Position = UDim2.new(0, 0, 0.5, -6)
        acc.BackgroundColor3 = cViolet
        acc.BorderSizePixel = 0
        acc.BackgroundTransparency = 1
        acc.ZIndex = 5
        Instance.new("UICorner", acc).CornerRadius = UDim.new(1, 0)

        -- number badge
        local badge = Instance.new("Frame", btn)
        badge.Size = UDim2.new(0, 26, 0, 26)
        badge.Position = UDim2.new(0, 10, 0.5, -13)
        badge.BackgroundColor3 = cSurface2
        badge.BorderSizePixel = 0
        badge.ZIndex = 5
        Instance.new("UICorner", badge).CornerRadius = UDim.new(0, 8)

        local ico = Instance.new("TextLabel", badge)
        ico.Name = "Icon"
        ico.Size = UDim2.new(1, 0, 1, 0)
        ico.BackgroundTransparency = 1
        ico.Text = string.format("%02d", i)
        ico.TextColor3 = cMuted
        ico.Font = Enum.Font.GothamBold
        ico.TextSize = 11
        ico.ZIndex = 6

        local lbl = Instance.new("TextLabel", btn)
        lbl.Name = "Label"
        lbl.Size = UDim2.new(1, -46, 1, 0)
        lbl.Position = UDim2.new(0, 44, 0, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = name
        lbl.TextColor3 = cSub
        lbl.Font = Enum.Font.GothamMedium
        lbl.TextSize = 13
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.ZIndex = 5

        btn.MouseEnter:Connect(function()
            if self.activeTab ~= name then
                tw(btn, 0.15, {BackgroundColor3 = cSurface2})
            end
        end)
        btn.MouseLeave:Connect(function()
            if self.activeTab ~= name then
                tw(btn, 0.15, {BackgroundColor3 = cSurface})
            end
        end)

        local page = Instance.new("Frame", contentScroll)
        page.Name = name .. "Page"
        page.Size = UDim2.new(1, 0, 0, 0)
        page.AutomaticSize = Enum.AutomaticSize.Y
        page.BackgroundTransparency = 1
        page.Visible = false
        page.ZIndex = 4
        local pl = Instance.new("UIListLayout", page)
        pl.Padding = UDim.new(0, 14)
        pl.SortOrder = Enum.SortOrder.LayoutOrder

        self.tabButtons[name] = btn
        self.tabPages[name] = page
        self.tabAccents[name] = acc

        btn.MouseButton1Click:Connect(function()
            selectTab(name)
        end)
    end

    selectTab(tabs[1])

    -- ═══ DRAG ═══
    local dragging, dragStart, startPos
    top.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = wrap.Position
        end
    end)
    top.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch) then
            local d = input.Position - dragStart
            local nx = startPos.X.Offset + d.X
            local ny = startPos.Y.Offset + d.Y
            wrap.Position = UDim2.new(startPos.X.Scale, nx, startPos.Y.Scale, ny)
        end
    end)
    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    -- ═══ API ═══
    function self:show()
        gui.Enabled = true
        local vpNow = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(900, 600)
        local curW = math.min((UI.WindowSize and UI.WindowSize.X) or 680, vpNow.X - 16)
        local curH = math.min((UI.WindowSize and UI.WindowSize.Y) or 480, vpNow.Y - 40)
        local px = math.floor((vpNow.X - curW) / 2)
        local py = math.floor((vpNow.Y - curH) / 2)
        if px < 0 then px = 0 end
        if py < 0 then py = 0 end
        wrap.Size = UDim2.new(0, curW, 0, curH)
        wrap.Position = UDim2.new(0, px, 0, py)
    end
    function self:hide() gui.Enabled = false end
    function self:toggle() if gui.Enabled then self:hide() else self:show() end end
    function self:isOpen() return gui.Enabled end
    function self:getPage(name) return self.tabPages[name] end
    function self:selectTab(n) selectTab(n) end

    self:show()
    gui.Enabled = false

    return self
end

return C
