-- ui/window.lua — modern minimal (match referensi)
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
    local pg = lp:WaitForChild("PlayerGui", 10)
    if not pg then return self end

    local vp = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(800,600)
    local W = math.min(720, vp.X - 20)
    local H = math.min(480, vp.Y - 40)
    local SIDEBAR_W = 140
    local TOPBAR_H = 50

    local cBg = Color3.fromRGB(10, 10, 16)
    local cSurface = Color3.fromRGB(16, 16, 24)
    local cSurface2 = Color3.fromRGB(24, 24, 34)
    local cPurple = Color3.fromRGB(138, 90, 250)
    local cPurpleDim = Color3.fromRGB(88, 60, 160)
    local cText = Color3.fromRGB(240, 240, 248)
    local cSub = Color3.fromRGB(130, 130, 155)
    local cMuted = Color3.fromRGB(70, 70, 90)
    local cBorder = Color3.fromRGB(35, 32, 55)
    local cDanger = Color3.fromRGB(240, 60, 60)

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
    Instance.new("UICorner", main).CornerRadius = UDim.new(0, 8)
    local st = Instance.new("UIStroke", main)
    st.Color = cBorder
    st.Thickness = 1

    -- TOPBAR
    local top = Instance.new("Frame", main)
    top.Name = "Topbar"
    top.Size = UDim2.new(0, W, 0, TOPBAR_H)
    top.BackgroundColor3 = cBg
    top.BorderSizePixel = 0
    top.ZIndex = 10

    -- search box
    local searchBox = Instance.new("Frame", top)
    searchBox.Size = UDim2.new(0, 240, 0, 30)
    searchBox.Position = UDim2.new(0, SIDEBAR_W + 16, 0, 10)
    searchBox.BackgroundColor3 = cSurface2
    searchBox.BorderSizePixel = 0
    searchBox.ZIndex = 11
    Instance.new("UICorner", searchBox).CornerRadius = UDim.new(0, 6)

    local searchIcon = Instance.new("TextLabel", searchBox)
    searchIcon.Size = UDim2.new(0, 24, 1, 0)
    searchIcon.Position = UDim2.new(0, 6, 0, 0)
    searchIcon.BackgroundTransparency = 1
    searchIcon.Text = "?"
    searchIcon.TextColor3 = cMuted
    searchIcon.Font = Enum.Font.GothamBold
    searchIcon.TextSize = 12
    searchIcon.ZIndex = 12

    local searchInput = Instance.new("TextBox", searchBox)
    searchInput.Size = UDim2.new(1, -34, 1, 0)
    searchInput.Position = UDim2.new(0, 28, 0, 0)
    searchInput.BackgroundTransparency = 1
    searchInput.Text = ""
    searchInput.PlaceholderText = "Search..."
    searchInput.PlaceholderColor3 = cMuted
    searchInput.TextColor3 = cText
    searchInput.Font = Enum.Font.Gotham
    searchInput.TextSize = 12
    searchInput.TextXAlignment = Enum.TextXAlignment.Left
    searchInput.ClearTextOnFocus = false
    searchInput.ZIndex = 12

    -- close button
    local close = Instance.new("TextButton", top)
    close.Size = UDim2.new(0, 30, 0, 30)
    close.Position = UDim2.new(0, W - 42, 0, 10)
    close.BackgroundColor3 = cSurface2
    close.Text = "X"
    close.TextColor3 = cSub
    close.Font = Enum.Font.GothamBold
    close.TextSize = 13
    close.BorderSizePixel = 0
    close.ZIndex = 11
    Instance.new("UICorner", close).CornerRadius = UDim.new(0, 6)

    -- SIDEBAR
    local sidebar = Instance.new("Frame", main)
    sidebar.Name = "Sidebar"
    sidebar.Size = UDim2.new(0, SIDEBAR_W, 0, H - TOPBAR_H)
    sidebar.Position = UDim2.new(0, 0, 0, TOPBAR_H)
    sidebar.BackgroundColor3 = cBg
    sidebar.BorderSizePixel = 0
    sidebar.ZIndex = 5

    -- sidebar divider kanan
    local sbLine = Instance.new("Frame", sidebar)
    sbLine.Size = UDim2.new(0, 1, 1, 0)
    sbLine.Position = UDim2.new(1, -1, 0, 0)
    sbLine.BackgroundColor3 = cBorder
    sbLine.BorderSizePixel = 0

    local sbPad = Instance.new("UIPadding", sidebar)
    sbPad.PaddingTop = UDim.new(0, 16)
    sbPad.PaddingLeft = UDim.new(0, 20)
    sbPad.PaddingRight = UDim.new(0, 14)

    local sbList = Instance.new("UIListLayout", sidebar)
    sbList.Padding = UDim.new(0, 6)

    -- CONTENT AREA
    local contentArea = Instance.new("Frame", main)
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
    contentScroll.ScrollBarImageColor3 = cPurpleDim
    contentScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    contentScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    contentScroll.ZIndex = 6
    local csList = Instance.new("UIListLayout", contentScroll)
    csList.Padding = UDim.new(0, 16)

    self.gui = gui
    self.main = main
    self.top = top
    self.sidebar = sidebar
    self.content = contentScroll
    self.searchInput = searchInput

    local tabs = (UI.TabList) or { "Visual", "Farm", "Friends", "Info", "Settings" }
    self.tabButtons = {}
    self.tabPages = {}
    self.tabUnderlines = {}

    local function selectTab(name)
        for n, b in pairs(self.tabButtons) do
            local isActive = (n == name)
            local lbl = b:FindFirstChild("Label")
            if lbl then lbl.TextColor3 = isActive and cText or cSub end
            local ul = self.tabUnderlines[n]
            if ul then ul.Visible = isActive end
        end
        for n, p in pairs(self.tabPages) do
            p.Visible = (n == name)
        end
        self.activeTab = name
    end

    for i, name in ipairs(tabs) do
        local btn = Instance.new("TextButton", sidebar)
        btn.Name = name.."Tab"
        btn.Size = UDim2.new(1, 0, 0, 30)
        btn.BackgroundColor3 = cBg
        btn.Text = ""
        btn.AutoButtonColor = false
        btn.BorderSizePixel = 0
        btn.ZIndex = 6

        local lbl = Instance.new("TextLabel", btn)
        lbl.Name = "Label"
        lbl.Size = UDim2.new(1, 0, 1, 0)
        lbl.Position = UDim2.new(0, 0, 0, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = string.upper(name)
        lbl.TextColor3 = cSub
        lbl.Font = Enum.Font.GothamMedium
        lbl.TextSize = 12
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.ZIndex = 7

        local ul = Instance.new("Frame", btn)
        ul.Name = "Underline"
        ul.Size = UDim2.new(0, 100, 0, 2)
        ul.Position = UDim2.new(0, 0, 1, -2)
        ul.BackgroundColor3 = cPurple
        ul.BorderSizePixel = 0
        ul.Visible = false
        ul.ZIndex = 8

        self.tabButtons[name] = btn
        self.tabUnderlines[name] = ul

        local page = Instance.new("Frame", contentScroll)
        page.Name = name.."Page"
        page.Size = UDim2.new(0, W - SIDEBAR_W - 24, 0, 400)
        page.BackgroundTransparency = 1
        page.Visible = false
        page.ZIndex = 6
        local pl = Instance.new("UIListLayout", page)
        pl.Padding = UDim.new(0, 18)

        self.tabPages[name] = page

        btn.MouseButton1Click:Connect(function() selectTab(name) end)
    end

    selectTab(tabs[1])

    -- drag
    local dragging, dragStart, startPos
    top.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; dragStart = input.Position; startPos = main.Position
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

    function self:show() gui.Enabled = true end
    function self:hide() gui.Enabled = false end
    function self:toggle() gui.Enabled = not gui.Enabled end
    function self:isOpen() return gui.Enabled end
    function self:getPage(name) return self.tabPages[name] end
    function self:selectTab(n) selectTab(n) end

    return self
end

return C
