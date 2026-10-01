-- ui/bubble.lua — floating bubble + logo bulat + outline ungu + glow
local Players = game:GetService("Players")
local UIS     = game:GetService("UserInputService")

local C = {}
C.__index = C

function C.new(ctx)
    local self = setmetatable({}, C)
    self.ctx = ctx
    self.cfg = ctx.config
    local T = self.cfg.Theme
    local UI = self.cfg.UI
    local pg = Players.LocalPlayer:WaitForChild("PlayerGui")

    local gui = Instance.new("ScreenGui")
    gui.Name = "OR4CLE_Bubble"
    gui.ResetOnSpawn = false
    gui.DisplayOrder = 998
    gui.Parent = pg

    -- glow (belakang)
    local glow = Instance.new("ImageLabel")
    glow.Size = UDim2.new(0, UI.BubbleSize + 16, 0, UI.BubbleSize + 16)
    glow.Position = UDim2.new(0, 20 - 8, 0, 200 - 8)
    glow.BackgroundTransparency = 1
    glow.Image = self.cfg.Assets.Logo
    glow.ImageColor3 = UI.BubbleGlowColor
    glow.ImageTransparency = 0.55
    glow.ScaleType = Enum.ScaleType.Crop
    glow.ZIndex = 1
    glow.Parent = gui
    Instance.new("UICorner", glow).CornerRadius = UDim.new(1, 0)

    -- frame outline
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, UI.BubbleSize, 0, UI.BubbleSize)
    frame.Position = UDim2.new(0, 20, 0, 200)
    frame.BackgroundColor3 = T.Background
    frame.BorderSizePixel = 0
    frame.ZIndex = 2
    frame.Parent = gui
    Instance.new("UICorner", frame).CornerRadius = UDim.new(1, 0)

    local stroke = Instance.new("UIStroke", frame)
    stroke.Color = UI.BubbleOutlineColor
    stroke.Thickness = UI.BubbleOutline

    -- logo
    local logo = Instance.new("ImageLabel")
    logo.Size = UDim2.new(1, -UI.BubbleOutline * 2, 1, -UI.BubbleOutline * 2)
    logo.Position = UDim2.new(0, UI.BubbleOutline, 0, UI.BubbleOutline)
    logo.BackgroundTransparency = 1
    logo.Image = self.cfg.Assets.Logo
    logo.ScaleType = Enum.ScaleType.Crop
    logo.ZIndex = 3
    logo.Parent = frame
    Instance.new("UICorner", logo).CornerRadius = UDim.new(1, 0)

    self.gui = gui
    self.frame = frame
    self.glow = glow

    -- drag
    local dragging, dragStart, startPos
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
        end
    end)
    frame.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch) then
            local d = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X,
                                       startPos.Y.Scale, startPos.Y.Offset + d.Y)
            glow.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X - 8,
                                      startPos.Y.Scale, startPos.Y.Offset + d.Y - 8)
        end
    end)
    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    -- klik → toggle window
    local moved = false
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then moved = false end
    end)
    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then moved = true end
    end)
    frame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 and not moved then
            if self.onClick then self.onClick() end
        end
    end)

    -- hotkey
    UIS.InputBegan:Connect(function(input, gpe)
        if gpe then return end
        if input.KeyCode == UI.ToggleKey then
            if self.onClick then self.onClick() end
        end
    end)

    return self
end

return C
