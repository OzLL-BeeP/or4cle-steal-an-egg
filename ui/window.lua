-- ui/window.lua — pattern standalone (jalan terbukti)
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
    local W = math.min((UI.WindowSize and UI.WindowSize.X) or 640, vp.X - 20)
    local H = math.min((UI.WindowSize and UI.WindowSize.Y) or 440, vp.Y - 40)
    local SIDEBAR_W = 130
    local TOPBAR_H = 44

    local cBg = T.Background or Color3.fromRGB(11, 11, 17)
    local cSurface = T.Surface or Color3.fromRGB(20, 20, 28)
    local cSurface2 = T.SurfaceAlt or Color3.fromRGB(28, 28, 38)
    local cSurface3 = Color3.fromRGB(38, 38, 52)
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

    local main = Instance.new("Frame", gui)
    main.Name = "Main"
    main.Size = UDim2.new(0, W, 0, H)
    main.Position = UDim2.new(0.5, -W/2, 0.5, -H/2)
    main.BackgroundColor3 = cBg
    main.BorderSizePixel = 0
    Instance.new("UICorner", main).CornerRadius = UDim.new(0, 14)
    local st = Instance.new("UIStroke", main)
    st.Color = cPurple
    st.Thickness = 1.5

    local top = Instance.new("Frame", main)
    top.Name = "Topbar"
    top.Size = UDim2.new(0, W, 0, TOPBAR_H)
    top.BackgroundColor3 = cSurface
    top.BorderSizePixel = 0
    top.ZIndex = 10
    Instance.new("UICorner", top).CornerRadius = UDim.new(0, 14)

    local tmask = Instance.new("Frame", top)
    tmask.Size = UDim2.new(0, W, 0, 14)
    tmask.Position = UDim2.new(0, 0, 0, 30)
    tmask.BackgroundColor3 = cSurface
    tmask.BorderSizePixel = 0
    tmask.ZIndex = 10

    local title = Instance.new("TextLabel", top)
    title.Size = UDim2.new(0, 200, 1, 0)
    title.Position = UDim2.new(0, 20, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "OR4CLE — " .. (cfg.GAME or "Steal An Egg")
    title.TextColor3 = cText
    title.Font = Enum.Font.GothamBold
    title.TextSize = 15
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.ZIndex = 11

    local close = Instance.new("TextButton", top)
    close.Size = UDim2.new(0, 26, 0, 26)
    close.Position = UDim2.new(0, W - 34, 0, 9)
    close.BackgroundColor3 = cDanger
    close.Text = "X"
    close.TextColor3 = Color3.fromRGB(255,255,255)
    close.Font = Enum.Font.GothamBold
    close.TextSize = 13
    close.BorderSizePixel = 0
    close.ZIndex = 11
    Instance.new("UICorner", close).CornerRadius = UDim.new(0, 6)

    local sidebar = Instance.new("Frame", main)
    sidebar.Name = "Sidebar"
    sidebar.Size = UDim2.new(0, SIDEBAR_W, 0, H - TOPBAR_H)
    sidebar.Position = UDim2.new(0, 0, 0, TOPBAR_H)
    sidebar.BackgroundColor3 = cSurface
    sidebar.BorderSizePixel = 0
    sidebar.ZIndex = 5
    local sbList = Instance.new("UIListLayout", sidebar)
    sbList.Padding = UDim.new(0, 4)
    local sbPad = Instance.new("UIPadding", sidebar)
    sbPad.PaddingTop = UDim.new(0, 8)
    sbPad.PaddingLeft = UDim.new(0, 8)
    sbPad.PaddingRight = UDim.new(0, 8)

    local contentArea = Instance.new("Frame", main)
    contentArea.Name = "ContentArea"
    contentArea.Size = UDim2.new(0, W - SIDEBAR_W, 0, H - TOPBAR_H)
    contentArea.Position = UDim2.new(0, SIDEBAR_W, 0, TOPBAR_H)
    contentArea.BackgroundColor3 = cBg
    contentArea.BorderSizePixel = 0
    contentArea.ZIndex = 5

    local contentScroll = Instance.new("ScrollingFrame", contentArea)
    contentScroll.Name = "Content"
    contentScroll.Size = UDim2.new(0, W - SIDEBAR_W - 16, 0, H - TOPBAR_H - 16)
    contentScroll.Position = UDim2.new(0, 8, 0, 8)
    contentScroll.BackgroundTransparency = 1
    contentScroll.BorderSizePixel = 0
    contentScroll.ScrollBarThickness = 3
    contentScroll.ScrollBarImageColor3 = cPurple
    contentScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    contentScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    contentScroll.ZIndex = 6
    local csList = Instance.new("UIListLayout", contentScroll)
    csList.Padding = UDim.new(0, 10)

    self.gui = gui
    self.main = main
    self.top = top
    self.sidebar = sidebar
    self.content = contentScroll
    self.W = W
    self.H = H
    self.SIDEBAR_W = SIDEBAR_W

    local tabs = (UI.TabList) or { "Visual", "Farm", "Friends", "Info", "Settings" }
    self.tabButtons = {}
    self.tabPages = {}

    local function selectTab(name)
        for n, b in pairs(self.tabButtons) do
            b.BackgroundColor3 = (n == name) and cSurface3 or cSurface
            local lbl = b:FindFirstChild("Label")
            if lbl then lbl.TextColor3 = (n == name) and cText or cSub end
        end
        for n, p in pairs(self.tabPages) do
            p.Visible = (n == name)
        end
        self.activeTab = name
    end

    for i, name in ipairs(tabs) do
        local btn = Instance.new("TextButton", sidebar)
        btn.Name = name.."Tab"
        btn.Size = UDim2.new(0, SIDEBAR_W - 16, 0, 36)
        btn.BackgroundColor3 = cSurface
        btn.Text = ""
        btn.AutoButtonColor = false
        btn.BorderSizePixel = 0
        btn.LayoutOrder = i
        btn.ZIndex = 6
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)

        local lbl = Instance.new("TextLabel", btn)
        lbl.Name = "Label"
        lbl.Size = UDim2.new(1, -16, 1, 0)
        lbl.Position = UDim2.new(0, 14, 0, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = string.format("%02d  %s", i, name)
        lbl.TextColor3 = cSub
        lbl.Font = Enum.Font.Gotham
        lbl.TextSize = 13
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.ZIndex = 7

        local page = Instance.new("Frame", contentScroll)
        page.Name = name.."Page"
        page.Size = UDim2.new(0, W - SIDEBAR_W - 16, 0, 400)
        page.BackgroundTransparency = 1
        page.Visible = false
        page.ZIndex = 6
        local pl = Instance.new("UIListLayout", page)
        pl.Padding = UDim.new(0, 10)

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

    function self:show() gui.Enabled = true end
    function self:hide() gui.Enabled = false end
    function self:toggle() gui.Enabled = not gui.Enabled end
    function self:isOpen() return gui.Enabled end
    function self:getPage(name) return self.tabPages[name] end
    function self:selectTab(n) selectTab(n) end

    return self
end

return C
