-- ui/window.lua — explicit pixel size, no relative
local Players = game:GetService("Players")
local UIS     = game:GetService("UserInputService")

local C = {}
C.__index = C

function C.new(ctx)
    local self = setmetatable({}, C)
    self.ctx = ctx
    local cfg = ctx.config or {}
    local T = cfg.Theme or {}
    local UI = cfg.UI or {}

    local lp = Players.LocalPlayer
    if not lp then return self end
    local pg = lp:FindFirstChild("PlayerGui") or lp:WaitForChild("PlayerGui", 10)
    if not pg then return self end

    local vp = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(800, 600)
    local W = math.min((UI.WindowSize and UI.WindowSize.X) or 640, vp.X - 20)
    local H = math.min((UI.WindowSize and UI.WindowSize.Y) or 440, vp.Y - 40)

    local SIDEBAR_W = 130
    local TOPBAR_H = 44

    -- area konten: W - SIDEBAR_W (lebar), H - TOPBAR_H (tinggi)
    local CONTENT_W = W - SIDEBAR_W
    local CONTENT_H = H - TOPBAR_H

    local cBg = T.Background or Color3.fromRGB(11, 11, 17)
    local cSurface = T.Surface or Color3.fromRGB(20, 20, 28)
    local cSurface2 = T.SurfaceAlt or Color3.fromRGB(28, 28, 38)
    local cSurface3 = Color3.fromRGB(38, 38, 52)
    local cBorder = T.Border or Color3.fromRGB(50, 44, 80)
    local cPurple = T.Purple or Color3.fromRGB(140, 90, 250)
    local cText = Color3.fromRGB(245, 245, 252)
    local cSub = Color3.fromRGB(145, 145, 170)
    local cDanger = Color3.fromRGB(245, 75, 75)

    local gui = Instance.new("ScreenGui")
    gui.Name = "OR4CLE_Window"
    gui.ResetOnSpawn = false
    gui.DisplayOrder = 99998
    gui.IgnoreGuiInset = true
    gui.Enabled = false
    gui.Parent = pg

    if not gui.Parent then
        gui.Parent = pg
    end

    local main = Instance.new("Frame")
    main.Name = "Main"
    main.Size = UDim2.new(0, W, 0, H)
    main.Position = UDim2.new(0.5, -W/2, 0.5, -H/2)
    main.BackgroundColor3 = cBg
    main.BorderSizePixel = 0
    main.ClipsDescendants = true
    main.Parent = gui
    Instance.new("UICorner", main).CornerRadius = UDim.new(0, 14)
    local st = Instance.new("UIStroke", main)
    st.Color = cBorder
    st.Thickness = 1.5

    -- TOPBAR
    local top = Instance.new("Frame")
    top.Name = "Topbar"
    top.Size = UDim2.new(0, W, 0, TOPBAR_H)
    top.Position = UDim2.new(0, 0, 0, 0)
    top.BackgroundColor3 = cSurface
    top.BorderSizePixel = 0
    top.ZIndex = 4
    top.Parent = main
    Instance.new("UICorner", top).CornerRadius = UDim.new(0, 14)
    local topMask = Instance.new("Frame")
    topMask.Size = UDim2.new(0, W, 0, 14)
    topMask.Position = UDim2.new(0, 0, 0, TOPBAR_H - 14)
    topMask.BackgroundColor3 = cSurface
    topMask.BorderSizePixel = 0
    topMask.ZIndex = 0
    topMask.Parent = top

    local logo = Instance.new("ImageLabel")
    logo.Size = UDim2.new(0, 28, 0, 28)
    logo.Position = UDim2.new(0, 12, 0, (TOPBAR_H - 28) / 2)
    logo.BackgroundTransparency = 1
    logo.Image = (cfg.Assets and cfg.Assets.Logo) or ""
    logo.ScaleType = Enum.ScaleType.Crop
    logo.ZIndex = 5
    logo.Parent = top
    Instance.new("UICorner", logo).CornerRadius = UDim.new(1, 0)

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(0, 200, 0, 20)
    title.Position = UDim2.new(0, 50, 0, 6)
    title.BackgroundTransparency = 1
    title.Text = "OR4CLE"
    title.TextColor3 = cText
    title.Font = Enum.Font.GothamBold
    title.TextSize = 15
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.ZIndex = 5
    title.Parent = top

    local sub = Instance.new("TextLabel")
    sub.Size = UDim2.new(0, 200, 0, 14)
    sub.Position = UDim2.new(0, 50, 0, 26)
    sub.BackgroundTransparency = 1
    sub.Text = "Steal An Egg v"..(cfg.VERSION or "?")
    sub.TextColor3 = cSub
    sub.Font = Enum.Font.Gotham
    sub.TextSize = 10
    sub.TextXAlignment = Enum.TextXAlignment.Left
    sub.ZIndex = 5
    sub.Parent = top

    local close = Instance.new("TextButton")
    close.Size = UDim2.new(0, 26, 0, 26)
    close.Position = UDim2.new(0, W - 34, 0, (TOPBAR_H - 26) / 2)
    close.BackgroundColor3 = cDanger
    close.Text = "X"
    close.TextColor3 = Color3.fromRGB(255, 255, 255)
    close.Font = Enum.Font.GothamBold
    close.TextSize = 13
    close.BorderSizePixel = 0
    close.ZIndex = 5
    close.Parent = top
    Instance.new("UICorner", close).CornerRadius = UDim.new(0, 6)

    local mini = Instance.new("TextButton")
    mini.Size = UDim2.new(0, 26, 0, 26)
    mini.Position = UDim2.new(0, W - 64, 0, (TOPBAR_H - 26) / 2)
    mini.BackgroundColor3 = cSurface2
    mini.Text = "-"
    mini.TextColor3 = cText
    mini.Font = Enum.Font.GothamBold
    mini.TextSize = 14
    mini.BorderSizePixel = 0
    mini.ZIndex = 5
    mini.Parent = top
    Instance.new("UICorner", mini).CornerRadius = UDim.new(0, 6)

    -- SIDEBAR — explicit pixel
    local sidebar = Instance.new("Frame")
    sidebar.Name = "Sidebar"
    sidebar.Size = UDim2.new(0, SIDEBAR_W, 0, CONTENT_H)
    sidebar.Position = UDim2.new(0, 0, 0, TOPBAR_H)
    sidebar.BackgroundColor3 = cSurface
    sidebar.BorderSizePixel = 0
    sidebar.ZIndex = 2
    sidebar.Parent = main
    local sbList = Instance.new("UIListLayout")
    sbList.Padding = UDim.new(0, 4)
    sbList.SortOrder = Enum.SortOrder.LayoutOrder
    sbList.Parent = sidebar
    local sbPad = Instance.new("UIPadding")
    sbPad.PaddingTop = UDim.new(0, 8)
    sbPad.PaddingLeft = UDim.new(0, 8)
    sbPad.PaddingRight = UDim.new(0, 8)
    sbPad.Parent = sidebar

    -- CONTENT WRAP — explicit pixel
    local contentWrap = Instance.new("Frame")
    contentWrap.Name = "ContentWrap"
    contentWrap.Size = UDim2.new(0, CONTENT_W, 0, CONTENT_H)
    contentWrap.Position = UDim2.new(0, SIDEBAR_W, 0, TOPBAR_H)
    contentWrap.BackgroundColor3 = cBg
    contentWrap.BorderSizePixel = 0
    contentWrap.ZIndex = 2
    contentWrap.Parent = main

    -- CONTENT SCROLL — explicit pixel (kurangi padding 16)
    local contentScroll = Instance.new("ScrollingFrame")
    contentScroll.Name = "Content"
    contentScroll.Size = UDim2.new(0, CONTENT_W - 16, 0, CONTENT_H - 16)
    contentScroll.Position = UDim2.new(0, 8, 0, 8)
    contentScroll.BackgroundTransparency = 1
    contentScroll.BorderSizePixel = 0
    contentScroll.ScrollBarThickness = 3
    contentScroll.ScrollBarImageColor3 = cPurple
    contentScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    contentScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    contentScroll.ClipsDescendants = true
    contentScroll.ZIndex = 3
    contentScroll.Parent = contentWrap
    local csList = Instance.new("UIListLayout")
    csList.Padding = UDim.new(0, 10)
    csList.SortOrder = Enum.SortOrder.LayoutOrder
    csList.Parent = contentScroll

    self.gui = gui
    self.main = main
    self.top = top
    self.sidebar = sidebar
    self.content = contentScroll

    local tabs = (UI.TabList) or { "Visual", "Farm", "Friends", "Info", "Settings" }
    self.tabButtons = {}
    self.tabPages = {}

    local function selectTab(name)
        for n, btn in pairs(self.tabButtons) do
            local isActive = (n == name)
            local lbl = btn:FindFirstChild("Label")
            btn.BackgroundColor3 = isActive and cSurface3 or cSurface
            if lbl then lbl.TextColor3 = isActive and cText or cSub end
        end
        for n, p in pairs(self.tabPages) do
            p.Visible = (n == name)
        end
        self.activeTab = name
    end

    for i, name in ipairs(tabs) do
        local btn = Instance.new("TextButton")
        btn.Name = name.."Tab"
        btn.Size = UDim2.new(0, SIDEBAR_W - 16, 0, 36)
        btn.BackgroundColor3 = cSurface
        btn.Text = ""
        btn.AutoButtonColor = false
        btn.BorderSizePixel = 0
        btn.LayoutOrder = i
        btn.ZIndex = 3
        btn.Parent = sidebar
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)

        local lbl = Instance.new("TextLabel")
        lbl.Name = "Label"
        lbl.Size = UDim2.new(0, SIDEBAR_W - 30, 1, 0)
        lbl.Position = UDim2.new(0, 14, 0, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = string.format("%02d  %s", i, name)
        lbl.TextColor3 = cSub
        lbl.Font = Enum.Font.Gotham
        lbl.TextSize = 13
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.ZIndex = 4
        lbl.Parent = btn

        -- PAGE — explicit pixel width
        local page = Instance.new("Frame")
        page.Name = name.."Page"
        page.Size = UDim2.new(0, CONTENT_W - 16, 0, 200)
        page.BackgroundTransparency = 1
        page.Visible = false
        page.ZIndex = 3
        page.Parent = contentScroll
        local pl = Instance.new("UIListLayout")
        pl.Padding = UDim.new(0, 10)
        pl.SortOrder = Enum.SortOrder.LayoutOrder
        pl.Parent = page

        self.tabButtons[name] = btn
        self.tabPages[name] = page

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

    close.MouseButton1Click:Connect(function()
        local p = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
        for _, x in ipairs(p:GetChildren()) do
            if x:IsA("ScreenGui") and x.Name:find("OR4CLE") then x:Destroy() end
        end
    end)
    mini.MouseButton1Click:Connect(function() gui.Enabled = false end)

    function self:show()
        gui.Enabled = true
        main.Size = UDim2.new(0, W, 0, H)
        main.Position = UDim2.new(0.5, -W/2, 0.5, -H/2)
        task.defer(function()
            local mainSize = main.AbsoluteSize
            if mainSize.X > 0 and mainSize.Y > 0 then
                contentWrap.Size = UDim2.new(0, mainSize.X - SIDEBAR_W, 0, mainSize.Y - TOPBAR_H)
                contentScroll.Size = UDim2.new(0, mainSize.X - SIDEBAR_W - 16, 0, mainSize.Y - TOPBAR_H - 16)
                contentScroll.CanvasPosition = Vector2.new(0, 0)
            end
        end)
    end
    function self:hide() gui.Enabled = false end
    function self:toggle() gui.Enabled = not gui.Enabled end
    function self:isOpen() return gui.Enabled end
    function self:getPage(name) return self.tabPages[name] end
    function self:selectTab(n) selectTab(n) end

    self:show()
    gui.Enabled = false
    return self
end

return C
