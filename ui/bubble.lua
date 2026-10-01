-- ui/bubble.lua — minimal reliable
local Players = game:GetService("Players")

local C = {}
C.__index = C

function C.new(ctx)
    local self = setmetatable({}, C)
    self.ctx = ctx
    self.cfg = ctx.config or {}
    self.open = false

    local T  = self.cfg.Theme or {}
    local UI = self.cfg.UI or {}
    local pg = Players.LocalPlayer:WaitForChild("PlayerGui")

    local size = UI.BubbleSize or 56

    local gui = Instance.new("ScreenGui")
    gui.Name = "OR4CLE_Bubble"
    gui.ResetOnSpawn = false
    gui.DisplayOrder = 100000
    gui.IgnoreGuiInset = true
    gui.Parent = pg

    -- tombol utama
    local btn = Instance.new("TextButton")
    btn.Name = "MainBtn"
    btn.Size = UDim2.new(0, size, 0, size)
    btn.Position = UDim2.new(0, 20, 0, 200)
    btn.BackgroundColor3 = Color3.fromRGB(12,12,18)
    btn.BorderSizePixel = 0
    btn.Text = ""
    btn.AutoButtonColor = false
    btn.Active = true
    btn.ZIndex = 999
    btn.Parent = gui
    Instance.new("UICorner", btn).CornerRadius = UDim.new(1, 0)

    local stroke = Instance.new("UIStroke", btn)
    stroke.Color = Color3.fromRGB(138,92,246)
    stroke.Thickness = 3

    -- logo
    local logo = Instance.new("ImageLabel")
    logo.Name = "Logo"
    logo.Size = UDim2.new(1, -6, 1, -6)
    logo.Position = UDim2.new(0, 3, 0, 3)
    logo.BackgroundTransparency = 1
    logo.Image = (self.cfg.Assets and self.cfg.Assets.Logo) or ""
    logo.ScaleType = Enum.ScaleType.Crop
    logo.ZIndex = 1000
    logo.Parent = btn
    Instance.new("UICorner", logo).CornerRadius = UDim.new(1, 0)

    self.gui = gui
    self.btn = btn

    -- KLIK — simple, no drag detect
    btn.MouseButton1Click:Connect(function()
        if self.onClick then
            local ok, err = pcall(self.onClick)
            if not ok then warn("[OR4CLE] onClick err: "..tostring(err)) end
        end
    end)

    return self
end

return C
