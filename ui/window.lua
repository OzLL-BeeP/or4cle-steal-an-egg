-- ui/window.lua — modern pro edition v2
local Players = game:GetService("Players")
local UIS     = game:GetService("UserInputService")
local Tween   = game:GetService("TweenService")

local C = {}
C.__index = C

local function tw(o, t, props, style)
    local info = TweenInfo.new(t or 0.18, style or Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    local t2 = Tween:Create(o, info, props)
    t2:Play()
    return t2
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
    local H = math.min((UI.WindowSize and UI.WindowSize.Y) or 460, vp.Y - (isMobile and 40 or 100))
    local SIDEBAR_W = isMobile and 108 or 156

    local cBg       = Color3.fromRGB(10, 10, 16)
    local cSurface  = Color3.fromRGB(18, 18, 26)
    local cSurface2 = Color3.fromRGB(26, 26, 38)
    local cSurface3 = Color3.fromRGB(34, 34, 48)
    local cBorder   = Color3.fromRGB(48, 42, 78)
    local cPurple   = T.Purple or Color3.fromRGB(140, 90, 250)
    local cViolet   = Color3.fromRGB(180, 120, 255)
    local cBlue     = T.Blue or Color3.fromRGB(60, 130, 250)
    local cCyan     = Color3.fromRGB(90, 200, 255)
    local cText     = Color3.fromRGB(240, 240, 248)
    local cSub      = Color3.fromRGB(140, 140, 165)
    local cMuted    = Color3.fromRGB(90, 90, 115)
    local cDanger   = Color3.fromRGB(240, 70, 70)

    local gui = Instance.new("ScreenGui")
    gui.Name = "OR4CLE_Window"
    gui.ResetOnSpawn = false
    gui.DisplayOrder = 99998
    gui.IgnoreGuiInset = true
    gui.Enabled = false
    gui.Parent = pg

    local shadow = Instance.new("Frame")
    shadow.Name = "Shadow"
    shadow.Size = UDim2.new(0, W + 20, 0, H + 20)
    shadow.Position = UDim2.new(0, 20, 0, 100)
    shadow.BackgroundColor3 = cPurple
    shadow.BackgroundTransparency = 0.85
    shadow.BorderSizePixel = 0
    shadow.ZIndex = 0
    shadow.Parent = gui
    Instance.new("UICorner", shadow).CornerRadius = UDim.new(0, 22)

    local main = Instance.new("Frame")
    main.Name = "Main"
    main.Size = UDim2.new(0, W, 0, H)
    main.Position = UDim2.new(0, 30, 0, 110)
    main.BackgroundColor3 = cBg
    main.BorderSizePixel = 0
    main.ClipsDescendants = true
    main.ZIndex = 1
    main.Parent = gui
    Instance.new("UICorner", main).CornerRadius = UDim.new(0, 16)

    local mainStroke = Instance.new("UIStroke", main)
    mainStroke.Color = cBorder
    mainStroke.Thickness = 1.5
    mainStroke.Transparency = 0.2

    local strip = Instance.new("Frame")
    strip.Size = UDim2.new(1, 0, 0, 3)
    strip.Position = UDim2.new(0, 0, 0, 0)
    strip.BackgroundColor3 = Color3.fromRGB(255,255,255)
    strip.BorderSizePixel = 0
    strip.ZIndex = 3
    strip.Parent = main
    local stripGrad = Instance.new("UIGradient", strip)
    stripGrad.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, cPurple),
        ColorSequenceKeypoint.new(0.5, cViolet),
        ColorSequenceKeypoint.new(1, cCyan),
    }

    local top = Instance.new("Frame")
    top.Name = "Topbar"
    top.Size = UDim2.new(1, 0, 0, 48)
    top.BackgroundColor3 = cSurface
    top.BorderSizePixel = 0
    top.ZIndex = 4
    top.Parent = main

    local topMask = Instance.new("Frame", top)
    topMask.Size = UDim2.new(1, 0, 0, 20)
    topMask.Position = UDim2.new(0, 0, 1, -20)
    topMask.BackgroundColor3 = cSurface
    topMask.BorderSizePixel = 0
    topMask.ZIndex = 0

    local logoWrap = Instance.new("Frame", top)
    logoWrap.Size = UDim2.new(0, 30, 0, 30)
    logoWrap.Position = UDim2.new(0, 14, 0.5, -15)
    logoWrap.BackgroundColor3 = cSurface2
    logoWrap.BorderSizePixel = 0
    logoWrap.ZIndex = 5
    Instance.new("UICorner", logoWrap).CornerRadius = UDim.new(1, 0)
    local lwStroke = Instance.new("UIStroke", logoWrap)
    lwStroke.Color = cPurple
    lwStroke.Thickness = 1.5

    local topLogo = Instance.new("ImageLabel")
    topLogo.Size = UDim2.new(1, -4, 1, -4)
    topLogo.Position = UDim2.new(0, 2, 0, 2)
    topLogo.BackgroundTransparency = 1
    topLogo.Image = (cfg.Assets and cfg.Assets.Logo) or ""
    topLogo.ScaleType = Enum.ScaleType.Crop
    topLogo.ZIndex = 6
    topLogo.Parent = logoWrap
    Instance.new("UICorner", topLogo).CornerRadius = UDim.new(1, 0)

    local titleBox = Instance.new("Frame", top)
    titleBox.Size = UDim2.new(0, 200, 1, 0)
    titleBox.Position = UDim2.new(0, 54, 0, 0)
    titleBox.BackgroundTransparency = 1
    titleBox.ZIndex = 5

    local title = Instance.new("TextLabel", titleBox)
    title.Size = UDim2.new(1, 0, 0, 18)
    title.Position = UDim2.new(0, 0, 0, 8)
    title.BackgroundTransparency = 1
    title.Text = "OR4CLE"
    title.TextColor3 = cText
    title.Font = Enum.Font.GothamBold
    title.TextSize = 14
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.ZIndex = 5

    local subtitle = Instance.new("TextLabel", titleBox)
    subtitle.Size = UDim2.new(1, 0, 0, 14)
    subtitle.Position = UDim2.new(0, 0, 0, 26)
    subtitle.BackgroundTransparency = 1
    subtitle.Text = "Steal An Egg · v" .. (cfg.VERSION or "?")
    subtitle.TextColor3 = cSub
    subtitle.Font = Enum.Font.Gotham
    subtitle.TextSize = 10
    subtitle.TextXAlignment = Enum.TextXAlignment.Left
    subtitle.ZIndex = 5

    local function mkBtn(name, sym, color, xOff, onClick)
        local b = Instance.new("TextButton", top)
        b.Name = name
        b.Size = UDim2.new(0, 26, 0, 26)
        b.Position = UDim2.new(1, xOff, 0.5, -13)
        b.BackgroundColor3 = cSurface2
        b.Text = sym
        b.TextColor3 = cSub
        b.Font = Enum.Font.GothamBold
        b.TextSize = 13
        b.BorderSizePixel = 0
        b.AutoButtonColor = false
        b.ZIndex = 5
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 7)

        local st = Instance.new("UIStroke", b)
        st.Color = cBorder
        st.Thickness = 1
        st.Transparency = 0.5

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

    local closeBtn = mkBtn("Close", "X", cDanger, -36, function()
        -- hapus semua GUI OR4CLE (window + bubble) + debug panels
        local pgAll = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
        for _, x in ipairs(pgAll:GetChildren()) do
            if x:IsA("ScreenGui") then
                if x.Name:find("OR4CLE") or x.Name == "BubbleCheck" or x.Name == "DeepDebug" or x.Name == "PagesDebug" or x.Name == "LineDebug" or x.Name == "IsolateTest" or x.Name == "UtilTest" or x.Name == "BubbleTest" then
                    x:Destroy()
                end
            end
        end
    end)
    local minBtn   = mkBtn("Min",   "-", cPurple, -68, function()
        -- cuma hide window, bubble tetep
        gui.Enabled = false
    end)

    local sidebar = Instance.new("Frame", main)
    sidebar.Name = "Sidebar"
    sidebar.Size = UDim2.new(0, SIDEBAR_W, 1, -48)
    sidebar.Position = UDim2.new(0, 0, 0, 48)
    sidebar.BackgroundColor3 = cSurface
    sidebar.BorderSizePixel = 0
    sidebar.ZIndex = 2

    local sbPad = Instance.new("UIPadding", sidebar)
    sbPad.PaddingTop = UDim.new(0, 12)
    sbPad.PaddingBottom = UDim.new(0, 12)
    sbPad.PaddingLeft = UDim.new(0, 10)
    sbPad.PaddingRight = UDim.new(0, 10)

    local sbList = Instance.new("UIListLayout", sidebar)
    sbList.Padding = UDim.new(0, 4)
    sbList.SortOrder = Enum.SortOrder.LayoutOrder

    local contentWrap = Instance.new("Frame", main)
    contentWrap.Name = "ContentWrap"
    contentWrap.Size = UDim2.new(1, -SIDEBAR_W, 1, -48)
    contentWrap.Position = UDim2.new(0, SIDEBAR_W, 0, 48)
    contentWrap.BackgroundColor3 = cBg
    contentWrap.BorderSizePixel = 0
    contentWrap.ZIndex = 2

    local sep = Instance.new("Frame", contentWrap)
    sep.Size = UDim2.new(0, 1, 1, -20)
    sep.Position = UDim2.new(0, 0, 0, 10)
    sep.BackgroundColor3 = cBorder
    sep.BackgroundTransparency = 0.6
    sep.BorderSizePixel = 0
    sep.ZIndex = 3

    local contentScroll = Instance.new("ScrollingFrame", contentWrap)
    contentScroll.Name = "Content"
    contentScroll.Size = UDim2.new(1, -24, 1, -20)
    contentScroll.Position = UDim2.new(0, 14, 0, 10)
    contentScroll.BackgroundTransparency = 1
    contentScroll.BorderSizePixel = 0
    contentScroll.ScrollBarThickness = 3
    contentScroll.ScrollBarImageColor3 = cPurple
    contentScroll.ScrollBarImageTransparency = 0.3
    contentScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    contentScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    contentScroll.ZIndex = 3
    contentScroll.Parent = contentWrap

    local csList = Instance.new("UIListLayout", contentScroll)
    csList.Padding = UDim.new(0, 12)
    csList.SortOrder = Enum.SortOrder.LayoutOrder

    self.gui = gui
    self.main = main
    self.top = top
    self.sidebar = sidebar
    self.content = contentScroll

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
            tw(btn, 0.2, {BackgroundColor3 = isActive and cSurface3 or cSurface})
            if lbl then tw(lbl, 0.2, {TextColor3 = isActive and cText or cSub}) end
            if ico then tw(ico, 0.2, {TextColor3 = isActive and cPurple or cMuted}) end
            if acc then tw(acc, 0.2, {BackgroundTransparency = isActive and 0 or 1}) end
        end
        for n, p in pairs(self.tabPages) do
            p.Visible = (n == name)
        end
        self.activeTab = name
    end

    local TAB_ICON = { "01", "02", "03", "04", "05" }

    for i, name in ipairs(tabs) do
        local btn = Instance.new("TextButton", sidebar)
        btn.Name = name .. "Tab"
        btn.Size = UDim2.new(1, 0, 0, 38)
        btn.BackgroundColor3 = cSurface
        btn.Text = ""
        btn.AutoButtonColor = false
        btn.BorderSizePixel = 0
        btn.LayoutOrder = i
        btn.ZIndex = 3
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)

        local acc = Instance.new("Frame", btn)
        acc.Name = "Accent"
        acc.Size = UDim2.new(0, 3, 0, 20)
        acc.Position = UDim2.new(0, 0, 0.5, -10)
        acc.BackgroundColor3 = cPurple
        acc.BorderSizePixel = 0
        acc.BackgroundTransparency = 1
        acc.ZIndex = 4
        Instance.new("UICorner", acc).CornerRadius = UDim.new(1, 0)

        local ico = Instance.new("TextLabel", btn)
        ico.Name = "Icon"
        ico.Size = UDim2.new(0, 30, 1, 0)
        ico.Position = UDim2.new(0, 8, 0, 0)
        ico.BackgroundTransparency = 1
        ico.Text = TAB_ICON[i] or "."
        ico.TextColor3 = cMuted
        ico.Font = Enum.Font.GothamBold
        ico.TextSize = 11
        ico.TextXAlignment = Enum.TextXAlignment.Center
        ico.ZIndex = 4

        local lbl = Instance.new("TextLabel", btn)
        lbl.Name = "Label"
        lbl.Size = UDim2.new(1, -42, 1, 0)
        lbl.Position = UDim2.new(0, 42, 0, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = name
        lbl.TextColor3 = cSub
        lbl.Font = Enum.Font.GothamMedium
        lbl.TextSize = 13
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.ZIndex = 4

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
        page.ZIndex = 3
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
            local nx = startPos.X.Offset + d.X
            local ny = startPos.Y.Offset + d.Y
            main.Position = UDim2.new(startPos.X.Scale, nx, startPos.Y.Scale, ny)
            shadow.Position = UDim2.new(startPos.X.Scale, nx - 10, startPos.Y.Scale, ny - 10)
        end
    end)
    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    function self:show()
        gui.Enabled = true
        -- center pakai viewport aktual
        local vpNow = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(900, 600)
        local curW = math.min((UI.WindowSize and UI.WindowSize.X) or 680, vpNow.X - 16)
        local curH = math.min((UI.WindowSize and UI.WindowSize.Y) or 460, vpNow.Y - 40)
        local px = math.floor((vpNow.X - curW) / 2)
        local py = math.floor((vpNow.Y - curH) / 2)
        if px < 0 then px = 0 end
        if py < 0 then py = 0 end
        main.Size = UDim2.new(0, curW, 0, curH)
        main.Position = UDim2.new(0, px, 0, py)
        shadow.Size = UDim2.new(0, curW + 20, 0, curH + 20)
        shadow.Position = UDim2.new(0, px - 10, 0, py - 10)
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
