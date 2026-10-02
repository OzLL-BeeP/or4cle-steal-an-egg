-- ui/window.lua — final compact
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

    -- sizing
    local vp = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(800,600)
    local W = 540
    local H = 380
    if W > vp.X - 20 then W = vp.X - 20 end
    if H > vp.Y - 60 then H = vp.Y - 60 end

    local SIDEBAR_W = 120
    local TOPBAR_H = 44

    -- palette
    local cBg = Color3.fromRGB(11, 11, 16)
    local cSurface = Color3.fromRGB(17, 17, 24)
    local cSurface2 = Color3.fromRGB(24, 24, 34)
    local cAccent = Color3.fromRGB(140, 92, 252)
    local cText = Color3.fromRGB(240, 240, 248)
    local cSub = Color3.fromRGB(130, 130, 155)
    local cMuted = Color3.fromRGB(70, 70, 90)
    local cBorder = Color3.fromRGB(34, 32, 52)
    local cDanger = Color3.fromRGB(240, 70, 90)

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
    mainStroke.Color = cAccent
    mainStroke.Thickness = 1
    mainStroke.Transparency = 0.4

    -- ═══ TOPBAR ═══
    local top = Instance.new("Frame", main)
    top.Name = "Topbar"
    top.Size = UDim2.new(0, W, 0, TOPBAR_H)
    top.Position = UDim2.new(0, 0, 0, 0)
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
    topLogo.Image = (cfg.Assets and cfg.Assets.Logo) or ""
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
    sub.Text = "Steal An Egg · v"..(cfg.VERSION or "?")
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
    mini.Text = "–"
    mini.TextColor3 = cSub
    mini.Font = Enum.Font.GothamBold
    mini.TextSize = 14
    mini.BorderSizePixel = 0
    mini.AutoButtonColor = false
    mini.ZIndex = 11
    Instance.new("UICorner", mini).CornerRadius = UDim.new(0, 6)

    -- ═══ SIDEBAR ═══
    local sidebar = Instance.new("Frame", main)
    sidebar.Name = "Sidebar"
    sidebar.Size = UDim2.new(0, SIDEBAR_W, 0, H - TOPBAR_H)
    sidebar.Position = UDim2.new(0, 0, 0, TOPBAR_H)
    sidebar.BackgroundColor3 = cBg
    sidebar.BorderSizePixel = 0
    sidebar.ZIndex = 5

    -- ═══ CONTENT ═══
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
    contentScroll.ScrollBarImageColor3 = cAccent
    contentScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    contentScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    contentScroll.ZIndex = 6
    local csList = Instance.new("UIListLayout", contentScroll)
    csList.Padding = UDim.new(0, 14)

    self.gui = gui
    self.main = main
    self.top = top
    self.sidebar = sidebar
    self.content = contentScroll
    self.W = W
    self.H = H
    self.SIDEBAR_W = SIDEBAR_W
    self.TOPBAR_H = TOPBAR_H

    -- tabs
    local tabDefs = {
        {id="Visual",   num="01", name="Visual"},
        {id="Farm",     num="02", name="Farm"},
        {id="Friends",  num="03", name="Friend"},
        {id="Info",     num="04", name="Utility"},
        {id="Settings", num="05", name="Settings"},
    }
    self.tabButtons = {}
    self.tabPages = {}
    self.tabIndicators = {}
    self.tabNums = {}
    self.tabLabels = {}

    local function selectTab(id)
        for n, b in pairs(self.tabButtons) do
            local isActive = (n == id)
            b.BackgroundColor3 = isActive and cSurface2 or cBg
            local lbl = self.tabLabels[n]
            local num = self.tabNums[n]
            if lbl then lbl.TextColor3 = isActive and cText or cSub end
            if num then num.TextColor3 = isActive and cAccent or cMuted end
            local ind = self.tabIndicators[n]
            if ind then ind.Visible = isActive end
        end
        for n, p in pairs(self.tabPages) do
            p.Visible = (n == id)
        end
        self.activeTab = id
    end

    for i, def in ipairs(tabDefs) do
        local btn = Instance.new("TextButton", sidebar)
        btn.Name = def.id.."Tab"
        btn.Size = UDim2.new(0, SIDEBAR_W - 16, 0, 34)
        btn.Position = UDim2.new(0, 8, 0, 10 + (i-1) * 38)
        btn.BackgroundColor3 = cBg
        btn.Text = ""
        btn.AutoButtonColor = false
        btn.BorderSizePixel = 0
        btn.ZIndex = 6
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 7)

        local ind = Instance.new("Frame", btn)
        ind.Name = "Indicator"
        ind.Size = UDim2.new(0, 3, 0, 20)
        ind.Position = UDim2.new(0, 0, 0.5, -10)
        ind.BackgroundColor3 = cAccent
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

        self.tabButtons[def.id] = btn
        self.tabIndicators[def.id] = ind
        self.tabNums[def.id] = num
        self.tabLabels[def.id] = lbl

        local page = Instance.new("Frame", contentScroll)
        page.Name = def.id.."Page"
        page.Size = UDim2.new(0, W - SIDEBAR_W - 24, 0, 400)
        page.BackgroundTransparency = 1
        page.Visible = false
        page.ZIndex = 6
        local pl = Instance.new("UIListLayout", page)
        pl.Padding = UDim.new(0, 12)

        self.tabPages[def.id] = page

        btn.MouseButton1Click:Connect(function() selectTab(def.id) end)
    end

    selectTab("Visual")

    -- DRAG (fix — pakai input.UserInputType termasuk Touch)
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
        if dragging then
            if input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch then
                local d = input.Position - dragStart
                main.Position = UDim2.new(
                    startPos.X.Scale, startPos.X.Offset + d.X,
                    startPos.Y.Scale, startPos.Y.Offset + d.Y
                )
            end
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

    function self:show() gui.Enabled = true end
    function self:hide() gui.Enabled = false end
    function self:toggle() gui.Enabled = not gui.Enabled end
    function self:isOpen() return gui.Enabled end
    function self:getPage(name) return self.tabPages[name] end
    function self:selectTab(n) selectTab(n) end

    return self
end

return C
