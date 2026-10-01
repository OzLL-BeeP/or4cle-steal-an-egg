-- ui/window.lua — self-contained, render sidebar + tab content
local Players = game:GetService("Players")
local UIS     = game:GetService("UserInputService")

local C = {}
C.__index = C

function C.new(ctx)
    local self = setmetatable({}, C)
    self.ctx = ctx
    local cfg = ctx.config or {}
    local T   = cfg.Theme or {}
    local UI  = cfg.UI or {}
    local pg  = Players.LocalPlayer:WaitForChild("PlayerGui")

    local W = (UI.WindowSize and UI.WindowSize.X) or 640
    local H = (UI.WindowSize and UI.WindowSize.Y) or 440

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
    main.BackgroundColor3 = T.Background or Color3.fromRGB(12,12,18)
    main.BorderSizePixel = 0
    main.Parent = gui
    Instance.new("UICorner", main).CornerRadius = UDim.new(0, UI.CornerRadius or 10)

    local stroke = Instance.new("UIStroke", main)
    stroke.Color = T.Border or Color3.fromRGB(60,50,100)
    stroke.Thickness = 2

    -- topbar
    local top = Instance.new("Frame")
    top.Size = UDim2.new(1, 0, 0, 36)
    top.BackgroundColor3 = T.Surface or Color3.fromRGB(22,22,32)
    top.BorderSizePixel = 0
    top.Parent = main
    Instance.new("UICorner", top).CornerRadius = UDim.new(0, UI.CornerRadius or 10)

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -100, 1, 0)
    title.Position = UDim2.new(0, 14, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "OR4CLE — " .. (cfg.GAME or "")
    title.TextColor3 = T.Text or Color3.fromRGB(235,235,245)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 14
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = top

    local close = Instance.new("TextButton")
    close.Size = UDim2.new(0, 26, 0, 26)
    close.Position = UDim2.new(1, -34, 0, 5)
    close.BackgroundColor3 = T.Danger or Color3.fromRGB(239,68,68)
    close.Text = "X"
    close.TextColor3 = Color3.fromRGB(255,255,255)
    close.Font = Enum.Font.GothamBold
    close.TextSize = 14
    close.BorderSizePixel = 0
    close.Parent = top
    Instance.new("UICorner", close).CornerRadius = UDim.new(0, 6)

    -- sidebar
    local sidebar = Instance.new("Frame")
    sidebar.Size = UDim2.new(0, 140, 1, -36)
    sidebar.Position = UDim2.new(0, 0, 0, 36)
    sidebar.BackgroundColor3 = T.Surface or Color3.fromRGB(22,22,32)
    sidebar.BorderSizePixel = 0
    sidebar.Parent = main

    local sl = Instance.new("UIListLayout", sidebar)
    sl.Padding = UDim.new(0, 4)
    sl.SortOrder = Enum.SortOrder.LayoutOrder
    local sp = Instance.new("UIPadding", sidebar)
    sp.PaddingTop = UDim.new(0, 8)
    sp.PaddingLeft = UDim.new(0, 8)
    sp.PaddingRight = UDim.new(0, 8)

    -- content area
    local content = Instance.new("ScrollingFrame")
    content.Size = UDim2.new(1, -150, 1, -46)
    content.Position = UDim2.new(0, 146, 0, 42)
    content.BackgroundTransparency = 1
    content.BorderSizePixel = 0
    content.ScrollBarThickness = 4
    content.CanvasSize = UDim2.new(0, 0, 0, 0)
    content.AutomaticCanvasSize = Enum.AutomaticSize.Y
    content.Parent = main

    local cl = Instance.new("UIListLayout", content)
    cl.Padding = UDim.new(0, 10)
    cl.SortOrder = Enum.SortOrder.LayoutOrder

    self.gui = gui
    self.main = main
    self.top = top
    self.sidebar = sidebar
    self.content = content

    -- render sidebar tabs
    local tabs = (UI.TabList) or { "Visual", "Farm", "Friends", "Info", "Settings" }
    self.tabButtons = {}
    self.tabPages = {}

    local function selectTab(name)
        for n, b in pairs(self.tabButtons) do
            b.BackgroundColor3 = (n == name) and (T.Purple or Color3.fromRGB(138,92,246))
                or (T.Background or Color3.fromRGB(12,12,18))
            b.TextColor3 = (n == name) and (T.Text or Color3.fromRGB(235,235,245))
                or (T.SubText or Color3.fromRGB(150,150,175))
        end
        for n, p in pairs(self.tabPages) do
            p.Visible = (n == name)
        end
        self.activeTab = name
    end

    for i, name in ipairs(tabs) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 0, 32)
        btn.BackgroundColor3 = T.Background or Color3.fromRGB(12,12,18)
        btn.Text = name
        btn.TextColor3 = T.SubText or Color3.fromRGB(150,150,175)
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 13
        btn.BorderSizePixel = 0
        btn.LayoutOrder = i
        btn.Parent = sidebar
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

        local page = Instance.new("Frame")
        page.Name = name .. "Page"
        page.Size = UDim2.new(1, 0, 0, 0)
        page.AutomaticSize = Enum.AutomaticSize.Y
        page.BackgroundTransparency = 1
        page.Visible = false
        page.Parent = content
        local pl = Instance.new("UIListLayout", page)
        pl.Padding = UDim.new(0, 8)
        pl.SortOrder = Enum.SortOrder.LayoutOrder

        self.tabButtons[name] = btn
        self.tabPages[name] = page

        btn.MouseButton1Click:Connect(function() selectTab(name) end)
    end

    selectTab(tabs[1])

    -- drag window
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

    function self:show() gui.Enabled = true end
    function self:hide() gui.Enabled = false end
    function self:toggle() gui.Enabled = not gui.Enabled end
    function self:isOpen() return gui.Enabled end
    function self:getPage(name) return self.tabPages[name] end
    function self:selectTab(n) selectTab(n) end

    return self
end

return C
