-- ui/window.lua — responsive, no emoji
local Players = game:GetService("Players")
local UIS     = game:GetService("UserInputService")
local Tween   = game:GetService("TweenService")

local C = {}
C.__index = C

function C.new(ctx)
    local self = setmetatable({}, C)
    self.ctx = ctx
    local cfg = ctx.config or {}
    local T   = cfg.Theme or {}
    local UI  = cfg.UI or {}
    local pg  = Players.LocalPlayer:WaitForChild("PlayerGui")

    local vp = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(800, 600)
    local maxW = vp.X - 40
    local maxH = vp.Y - 80
    local W = math.min((UI.WindowSize and UI.WindowSize.X) or 640, maxW)
    local H = math.min((UI.WindowSize and UI.WindowSize.Y) or 440, maxH)
    if vp.X < 600 then
        W = vp.X - 20
        H = vp.Y - 60
    end

    local SIDEBAR_W = 130
    if vp.X < 500 then SIDEBAR_W = 110 end

    local cBg      = T.Background or Color3.fromRGB(12,12,18)
    local cSurface = T.Surface or Color3.fromRGB(22,22,32)
    local cSurface2= T.SurfaceAlt or Color3.fromRGB(30,30,44)
    local cBorder  = T.Border or Color3.fromRGB(60,50,100)
    local cPurple  = T.Purple or Color3.fromRGB(138,92,246)
    local cBlue    = T.Blue or Color3.fromRGB(59,130,246)
    local cText    = T.Text or Color3.fromRGB(235,235,245)
    local cSub     = T.SubText or Color3.fromRGB(150,150,175)
    local cDanger  = T.Danger or Color3.fromRGB(239,68,68)

    local gui = Instance.new("ScreenGui")
    gui.Name = "OR4CLE_Window"
    gui.ResetOnSpawn = false
    gui.DisplayOrder = 99998
    gui.IgnoreGuiInset = true
    gui.Enabled = false
    gui.Parent = pg

    local main = Instance.new("Frame")
    main.Size = UDim2.new(0, W, 0, H)
    main.Position = UDim2.new(0.5, -W/2, 0.5, -H/2)
    main.BackgroundColor3 = cBg
    main.BorderSizePixel = 0
    main.ClipsDescendants = true
    main.Parent = gui
    Instance.new("UICorner", main).CornerRadius = UDim.new(0, 12)

    local stroke = Instance.new("UIStroke", main)
    stroke.Color = cBorder
    stroke.Thickness = 2

    local accentBar = Instance.new("Frame", main)
    accentBar.Size = UDim2.new(1, 0, 0, 2)
    accentBar.Position = UDim2.new(0, 0, 0, 0)
    accentBar.BackgroundColor3 = cPurple
    accentBar.BorderSizePixel = 0
    accentBar.ZIndex = 2
    local accGrad = Instance.new("UIGradient", accentBar)
    accGrad.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, cPurple),
        ColorSequenceKeypoint.new(1, cBlue),
    }

    local top = Instance.new("Frame")
    top.Size = UDim2.new(1, 0, 0, 40)
    top.BackgroundColor3 = cSurface
    top.BorderSizePixel = 0
    top.Parent = main
    Instance.new("UICorner", top).CornerRadius = UDim.new(0, 12)

    local topMask = Instance.new("Frame", top)
    topMask.Size = UDim2.new(1, 0, 0, 12)
    topMask.Position = UDim2.new(0, 0, 1, -12)
    topMask.BackgroundColor3 = cSurface
    topMask.BorderSizePixel = 0
    topMask.ZIndex = 0

    local topLogo = Instance.new("ImageLabel")
    topLogo.Size = UDim2.new(0, 24, 0, 24)
    topLogo.Position = UDim2.new(0, 14, 0.5, -12)
    topLogo.BackgroundTransparency = 1
    topLogo.Image = (cfg.Assets and cfg.Assets.Logo) or ""
    topLogo.ScaleType = Enum.ScaleType.Crop
    topLogo.ZIndex = 3
    topLogo.Parent = top
    Instance.new("UICorner", topLogo).CornerRadius = UDim.new(1, 0)

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -140, 1, 0)
    title.Position = UDim2.new(0, 46, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "OR4CLE"
    title.TextColor3 = cText
    title.Font = Enum.Font.GothamBold
    title.TextSize = 15
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.ZIndex = 3
    title.Parent = top

    local version = Instance.new("TextLabel")
    version.Size = UDim2.new(0, 60, 1, 0)
    version.Position = UDim2.new(0, 110, 0, 0)
    version.BackgroundTransparency = 1
    version.Text = "v" .. (cfg.VERSION or "?")
    version.TextColor3 = cSub
    version.Font = Enum.Font.Gotham
    version.TextSize = 11
    version.TextXAlignment = Enum.TextXAlignment.Left
    version.ZIndex = 3
    version.Parent = top

    local close = Instance.new("TextButton")
    close.Size = UDim2.new(0, 28, 0, 28)
    close.Position = UDim2.new(1, -38, 0.5, -14)
    close.BackgroundColor3 = cDanger
    close.Text = "X"
    close.TextColor3 = Color3.fromRGB(255,255,255)
    close.Font = Enum.Font.GothamBold
    close.TextSize = 14
    close.BorderSizePixel = 0
    close.AutoButtonColor = false
    close.ZIndex = 3
    close.Parent = top
    Instance.new("UICorner", close).CornerRadius = UDim.new(0, 8)

    close.MouseEnter:Connect(function()
        Tween:Create(close, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(255,100,100)}):Play()
    end)
    close.MouseLeave:Connect(function()
        Tween:Create(close, TweenInfo.new(0.15), {BackgroundColor3 = cDanger}):Play()
    end)

    local mini = Instance.new("TextButton")
    mini.Size = UDim2.new(0, 28, 0, 28)
    mini.Position = UDim2.new(1, -72, 0.5, -14)
    mini.BackgroundColor3 = cSurface2
    mini.Text = "-"
    mini.TextColor3 = cText
    mini.Font = Enum.Font.GothamBold
    mini.TextSize = 16
    mini.BorderSizePixel = 0
    mini.AutoButtonColor = false
    mini.ZIndex = 3
    mini.Parent = top
    Instance.new("UICorner", mini).CornerRadius = UDim.new(0, 8)

    mini.MouseEnter:Connect(function()
        Tween:Create(mini, TweenInfo.new(0.15), {BackgroundColor3 = cPurple}):Play()
    end)
    mini.MouseLeave:Connect(function()
        Tween:Create(mini, TweenInfo.new(0.15), {BackgroundColor3 = cSurface2}):Play()
    end)

    local sidebar = Instance.new("Frame")
    sidebar.Size = UDim2.new(0, SIDEBAR_W, 1, -40)
    sidebar.Position = UDim2.new(0, 0, 0, 40)
    sidebar.BackgroundColor3 = cSurface
    sidebar.BorderSizePixel = 0
    sidebar.Parent = main

    local sl = Instance.new("UIListLayout", sidebar)
    sl.Padding = UDim.new(0, 4)
    sl.SortOrder = Enum.SortOrder.LayoutOrder
    local sp = Instance.new("UIPadding", sidebar)
    sp.PaddingTop = UDim.new(0, 10)
    sp.PaddingLeft = UDim.new(0, 8)
    sp.PaddingRight = UDim.new(0, 8)

    local content = Instance.new("Frame")
    content.Size = UDim2.new(1, -SIDEBAR_W, 1, -40)
    content.Position = UDim2.new(0, SIDEBAR_W, 0, 40)
    content.BackgroundTransparency = 1
    content.Parent = main

    local contentScroll = Instance.new("ScrollingFrame")
    contentScroll.Size = UDim2.new(1, -16, 1, -16)
    contentScroll.Position = UDim2.new(0, 8, 0, 8)
    contentScroll.BackgroundTransparency = 1
    contentScroll.BorderSizePixel = 0
    contentScroll.ScrollBarThickness = 4
    contentScroll.ScrollBarImageColor3 = cPurple
    contentScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    contentScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    contentScroll.Parent = content

    local cl = Instance.new("UIListLayout", contentScroll)
    cl.Padding = UDim.new(0, 10)
    cl.SortOrder = Enum.SortOrder.LayoutOrder

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
        for n, b in pairs(self.tabButtons) do
            local isActive = (n == name)
            Tween:Create(b, TweenInfo.new(0.18), {
                BackgroundColor3 = isActive and cSurface2 or cSurface
            }):Play()
            b.TextColor3 = isActive and cText or cSub
            local acc = self.tabAccents[n]
            if acc then
                Tween:Create(acc, TweenInfo.new(0.18), {
                    BackgroundTransparency = isActive and 0 or 1
                }):Play()
            end
        end
        for n, p in pairs(self.tabPages) do
            p.Visible = (n == name)
        end
        self.activeTab = name
    end

    for i, name in ipairs(tabs) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 0, 34)
        btn.BackgroundColor3 = cSurface
        btn.Text = ""
        btn.AutoButtonColor = false
        btn.BorderSizePixel = 0
        btn.LayoutOrder = i
        btn.Parent = sidebar
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)

        local acc = Instance.new("Frame", btn)
        acc.Size = UDim2.new(0, 3, 0, 18)
        acc.Position = UDim2.new(0, 0, 0.5, -9)
        acc.BackgroundColor3 = cPurple
        acc.BorderSizePixel = 0
        acc.BackgroundTransparency = 1
        Instance.new("UICorner", acc).CornerRadius = UDim.new(0, 2)

        local num = Instance.new("TextLabel", btn)
        num.Size = UDim2.new(0, 24, 1, 0)
        num.Position = UDim2.new(0, 8, 0, 0)
        num.BackgroundTransparency = 1
        num.Text = string.format("%02d", i)
        num.TextColor3 = cPurple
        num.Font = Enum.Font.GothamBold
        num.TextSize = 12
        num.TextXAlignment = Enum.TextXAlignment.Center

        local lbl = Instance.new("TextLabel", btn)
        lbl.Size = UDim2.new(1, -36, 1, 0)
        lbl.Position = UDim2.new(0, 36, 0, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = name
        lbl.TextColor3 = cSub
        lbl.Font = Enum.Font.Gotham
        lbl.TextSize = 13
        lbl.TextXAlignment = Enum.TextXAlignment.Left

        btn.MouseEnter:Connect(function()
            if self.activeTab ~= name then
                Tween:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = cSurface2}):Play()
            end
        end)
        btn.MouseLeave:Connect(function()
            if self.activeTab ~= name then
                Tween:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = cSurface}):Play()
            end
        end)

        local page = Instance.new("Frame")
        page.Name = name .. "Page"
        page.Size = UDim2.new(1, 0, 0, 0)
        page.AutomaticSize = Enum.AutomaticSize.Y
        page.BackgroundTransparency = 1
        page.Visible = false
        page.Parent = contentScroll
        local pl = Instance.new("UIListLayout", page)
        pl.Padding = UDim.new(0, 8)
        pl.SortOrder = Enum.SortOrder.LayoutOrder

        self.tabButtons[name] = btn
        self.tabPages[name] = page
        self.tabAccents[name] = acc

        btn.MouseButton1Click:Connect(function() selectTab(name) end)
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

    close.MouseButton1Click:Connect(function() gui.Enabled = false end)
    mini.MouseButton1Click:Connect(function() gui.Enabled = false end)

    function self:show()
        gui.Enabled = true
        main.Size = UDim2.new(0, W, 0, H)
        main.Position = UDim2.new(0.5, -W/2, 0.5, -H/2)
    end
    function self:hide() gui.Enabled = false end
    function self:toggle() gui.Enabled = not gui.Enabled end
    function self:isOpen() return gui.Enabled end
    function self:getPage(name) return self.tabPages[name] end
    function self:selectTab(n) selectTab(n) end

    return self
end

return C
