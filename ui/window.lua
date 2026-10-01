-- ui/window.lua
local Players = game:GetService("Players")
local C = {}
C.__index = C

function C.new(ctx)
    local self = setmetatable({}, C)
    self.ctx = ctx
    local cfg = ctx.config
    local T = cfg.Theme
    local UI = cfg.UI
    local pg = Players.LocalPlayer:WaitForChild("PlayerGui")

    local gui = Instance.new("ScreenGui")
    gui.Name = "OR4CLE_Window"
    gui.ResetOnSpawn = false
    gui.DisplayOrder = 997
    gui.Enabled = false
    gui.Parent = pg

    local main = Instance.new("Frame")
    main.Size = UDim2.new(0, UI.WindowSize.X, 0, UI.WindowSize.Y)
    main.Position = UDim2.new(0.5, -UI.WindowSize.X/2, 0.5, -UI.WindowSize.Y/2)
    main.BackgroundColor3 = T.Background
    main.BorderSizePixel = 0
    main.Parent = gui
    Instance.new("UICorner", main).CornerRadius = UDim.new(0, UI.CornerRadius)

    local stroke = Instance.new("UIStroke", main)
    stroke.Color = T.Border
    stroke.Thickness = 2

    -- topbar
    local top = Instance.new("Frame")
    top.Size = UDim2.new(1, 0, 0, 36)
    top.BackgroundColor3 = T.Surface
    top.BorderSizePixel = 0
    top.Parent = main
    Instance.new("UICorner", top).CornerRadius = UDim.new(0, UI.CornerRadius)

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -100, 1, 0)
    title.Position = UDim2.new(0, 14, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "OR4CLE — " .. (cfg.GAME or "")
    title.TextColor3 = T.Text
    title.Font = Enum.Font.GothamBold
    title.TextSize = 14
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = top

    local close = Instance.new("TextButton")
    close.Size = UDim2.new(0, 26, 0, 26)
    close.Position = UDim2.new(1, -34, 0, 5)
    close.BackgroundColor3 = T.Danger
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
    sidebar.BackgroundColor3 = T.Surface
    sidebar.BorderSizePixel = 0
    sidebar.Parent = main

    local sl = Instance.new("UIListLayout", sidebar)
    sl.Padding = UDim.new(0, 4)
    local sp = Instance.new("UIPadding", sidebar)
    sp.PaddingTop = UDim.new(0, 8)
    sp.PaddingLeft = UDim.new(0, 8)
    sp.PaddingRight = UDim.new(0, 8)

    -- content
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

    -- drag window
    local dragging, dragStart, startPos
    top.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true; dragStart = input.Position; startPos = main.Position
        end
    end)
    top.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local d = input.Position - dragStart
            main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X,
                                      startPos.Y.Scale, startPos.Y.Offset + d.Y)
        end
    end)
    game:GetService("UserInputService").InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)

    close.MouseButton1Click:Connect(function() self:hide() end)

    function self:show() gui.Enabled = true end
    function self:hide() gui.Enabled = false end
    function self:toggle() gui.Enabled = not gui.Enabled end
    function self:isOpen() return gui.Enabled end

    return self
end

return C
