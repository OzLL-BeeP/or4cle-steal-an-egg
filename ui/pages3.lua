-- ui/pages3.lua — isi konten 5 tab
local C = {}
C.__index = C

function C.new(ctx, window)
    local self = setmetatable({}, C)
    self.ctx = ctx
    self.win = window
    self.cfg = ctx.config or {}
    self.modules = ctx.modules or {}

    local T = self.cfg.Theme or {}
    local cPurple = T.Purple or Color3.fromRGB(140, 90, 250)
    local cText = Color3.fromRGB(245, 245, 252)
    local cSub = Color3.fromRGB(145, 145, 170)

    local function makeSection(page, titleText, subtitleText)
        local sec = Instance.new("Frame", page)
        sec.Size = UDim2.new(1, 0, 0, 160)
        sec.BackgroundColor3 = Color3.fromRGB(30, 30, 44)
        sec.BorderSizePixel = 0
        sec.Visible = true
        sec.ZIndex = 7
        Instance.new("UICorner", sec).CornerRadius = UDim.new(0, 10)
        local stroke = Instance.new("UIStroke", sec)
        stroke.Color = cPurple
        stroke.Thickness = 1.5

        local title = Instance.new("TextLabel", sec)
        title.Size = UDim2.new(1, -24, 0, 24)
        title.Position = UDim2.new(0, 12, 0, 12)
        title.BackgroundTransparency = 1
        title.Text = titleText
        title.TextColor3 = cText
        title.Font = Enum.Font.GothamBold
        title.TextSize = 15
        title.TextXAlignment = Enum.TextXAlignment.Left
        title.Visible = true
        title.ZIndex = 8

        if subtitleText then
            local sub = Instance.new("TextLabel", sec)
            sub.Size = UDim2.new(1, -24, 0, 18)
            sub.Position = UDim2.new(0, 12, 0, 40)
            sub.BackgroundTransparency = 1
            sub.Text = subtitleText
            sub.TextColor3 = cSub
            sub.Font = Enum.Font.Gotham
            sub.TextSize = 12
            sub.TextXAlignment = Enum.TextXAlignment.Left
            sub.Visible = true
            sub.ZIndex = 8
        end

        return sec
    end

    local function makeToggle(parent, labelText, default, yPos, onChange)
        local row = Instance.new("Frame", parent)
        row.Size = UDim2.new(1, -24, 0, 30)
        row.Position = UDim2.new(0, 12, 0, yPos or 80)
        row.BackgroundTransparency = 1
        row.ZIndex = 8

        local lbl = Instance.new("TextLabel", row)
        lbl.Size = UDim2.new(1, -60, 1, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = labelText
        lbl.TextColor3 = cText
        lbl.Font = Enum.Font.Gotham
        lbl.TextSize = 13
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.ZIndex = 9

        local state = default or false

        local btn = Instance.new("TextButton", row)
        btn.Size = UDim2.new(0, 44, 0, 22)
        btn.Position = UDim2.new(1, -50, 0.5, -11)
        btn.BackgroundColor3 = state and cPurple or Color3.fromRGB(60, 60, 80)
        btn.Text = ""
        btn.AutoButtonColor = false
        btn.BorderSizePixel = 0
        btn.ZIndex = 9
        Instance.new("UICorner", btn).CornerRadius = UDim.new(1, 0)

        local dot = Instance.new("Frame", btn)
        dot.Size = UDim2.new(0, 16, 0, 16)
        dot.Position = state and UDim2.new(1, -20, 0.5, -8) or UDim2.new(0, 4, 0.5, -8)
        dot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        dot.BorderSizePixel = 0
        dot.ZIndex = 10
        Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)

        btn.MouseButton1Click:Connect(function()
            state = not state
            btn.BackgroundColor3 = state and cPurple or Color3.fromRGB(60, 60, 80)
            dot.Position = state and UDim2.new(1, -20, 0.5, -8) or UDim2.new(0, 4, 0.5, -8)
            if onChange then pcall(onChange, state) end
        end)

        return btn
    end

    -- VISUAL
    local v = self.win:getPage("Visual")
    if v then
        local s1 = makeSection(v, "ESP — Egg", "Nampilin nama egg + pet + rarity")
        makeToggle(s1, "Enable ESP", false, 80)

        local s2 = makeSection(v, "Invisible / Evasive", "Ghost + evasive dari Guardian")
        s2.Position = UDim2.new(0, 0, 0, 170)
        makeToggle(s2, "Ghost Mode", false, 80)
    end

    -- FARM
    local f = self.win:getPage("Farm")
    if f then
        local s1 = makeSection(f, "Auto Steal", "Otomatis nyolong egg")
        makeToggle(s1, "Enable", false, 80)

        local s2 = makeSection(f, "Auto Hatch", "Otomatis hatch di base")
        s2.Position = UDim2.new(0, 0, 0, 170)
        makeToggle(s2, "Enable", false, 80)
    end

    -- FRIENDS
    local fr = self.win:getPage("Friends")
    if fr then
        local s1 = makeSection(fr, "Drop for Friends", "Bawa egg, drop di jalur teman")
        makeToggle(s1, "Enable", false, 80)
    end

    -- INFO
    local info = self.win:getPage("Info")
    if info then
        local s1 = makeSection(info, "Live Info", "Jam + 10 slot egg terakhir")
        local clk = Instance.new("TextLabel", s1)
        clk.Size = UDim2.new(1, -24, 0, 18)
        clk.Position = UDim2.new(0, 12, 0, 80)
        clk.BackgroundTransparency = 1
        clk.Text = "Jam sekarang: --:--"
        clk.TextColor3 = cPurple
        clk.Font = Enum.Font.GothamBold
        clk.TextSize = 12
        clk.TextXAlignment = Enum.TextXAlignment.Left
        clk.ZIndex = 9
        task.spawn(function()
            while clk.Parent do
                if self.ctx.util and self.ctx.util.getClock then
                    clk.Text = "Jam sekarang: " .. self.ctx.util.getClock()
                end
                task.wait(1)
            end
        end)
    end

    -- SETTINGS
    local s = self.win:getPage("Settings")
    if s then
        local s1 = makeSection(s, "Performance", "Anti lag + FPS")
        makeToggle(s1, "Anti Lag", false, 80)

        local s2 = makeSection(s, "Server Guard", "Auto leave / hop / notify")
        s2.Position = UDim2.new(0, 0, 0, 170)
        makeToggle(s2, "Enable", false, 80)
    end

    return self
end

return C
