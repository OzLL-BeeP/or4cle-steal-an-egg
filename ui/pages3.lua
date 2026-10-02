-- ui/pages3.lua — content 5 tabs
local C = {}
C.__index = C

function C.new(ctx, window)
    local self = setmetatable({}, C)
    self.ctx = ctx
    self.win = window
    self.cfg = ctx.config or {}
    self.modules = ctx.modules or {}

    local cPurple = Color3.fromRGB(140, 92, 252)
    local cText = Color3.fromRGB(240, 240, 248)
    local cSub = Color3.fromRGB(130, 130, 155)
    local cMuted = Color3.fromRGB(70, 70, 90)
    local cSurface2 = Color3.fromRGB(24, 24, 34)
    local cBorder = Color3.fromRGB(34, 32, 52)

    -- rarity options
    local rarityOptions = {}
    local rarityMap = {"Common","Uncommon","Rare","Epic","Legendary","Mythic","Cosmic","Secret","Eternal","Divine"}
    for i, r in ipairs(rarityMap) do
        table.insert(rarityOptions, string.format("%02d %s", i, r))
    end

    local function makeSection(page, titleText)
        local wrap = Instance.new("Frame", page)
        wrap.Size = UDim2.new(1, 0, 0, 0)
        wrap.AutomaticSize = Enum.AutomaticSize.Y
        wrap.BackgroundTransparency = 1

        local hdr = Instance.new("TextLabel", wrap)
        hdr.Size = UDim2.new(1, 0, 0, 16)
        hdr.BackgroundTransparency = 1
        hdr.Text = string.upper(titleText)
        hdr.TextColor3 = cSub
        hdr.Font = Enum.Font.GothamBold
        hdr.TextSize = 10
        hdr.TextXAlignment = Enum.TextXAlignment.Left

        local body = Instance.new("Frame", wrap)
        body.Size = UDim2.new(1, 0, 0, 0)
        body.Position = UDim2.new(0, 0, 0, 20)
        body.AutomaticSize = Enum.AutomaticSize.Y
        body.BackgroundTransparency = 1
        local ll = Instance.new("UIListLayout", body)
        ll.Padding = UDim.new(0, 2)
        return body
    end

    local function makeToggle(parent, labelText, default, onChange)
        local row = Instance.new("Frame", parent)
        row.Size = UDim2.new(1, 0, 0, 34)
        row.BackgroundColor3 = cSurface2
        row.BorderSizePixel = 0
        Instance.new("UICorner", row).CornerRadius = UDim.new(0, 6)

        local lbl = Instance.new("TextLabel", row)
        lbl.Size = UDim2.new(1, -100, 1, 0)
        lbl.Position = UDim2.new(0, 12, 0, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = labelText
        lbl.TextColor3 = cText
        lbl.Font = Enum.Font.Gotham
        lbl.TextSize = 12
        lbl.TextXAlignment = Enum.TextXAlignment.Left

        local stateLbl = Instance.new("TextLabel", row)
        stateLbl.Size = UDim2.new(0, 28, 1, 0)
        stateLbl.Position = UDim2.new(1, -78, 0, 0)
        stateLbl.BackgroundTransparency = 1
        stateLbl.Text = default and "ON" or "OFF"
        stateLbl.TextColor3 = cSub
        stateLbl.Font = Enum.Font.GothamBold
        stateLbl.TextSize = 10
        stateLbl.TextXAlignment = Enum.TextXAlignment.Right

        local state = default or false
        local btn = Instance.new("TextButton", row)
        btn.Size = UDim2.new(0, 30, 0, 16)
        btn.Position = UDim2.new(1, -42, 0.5, -8)
        btn.BackgroundColor3 = state and cPurple or Color3.fromRGB(50, 50, 65)
        btn.Text = ""
        btn.AutoButtonColor = false
        btn.BorderSizePixel = 0
        Instance.new("UICorner", btn).CornerRadius = UDim.new(1, 0)

        local dot = Instance.new("Frame", btn)
        dot.Size = UDim2.new(0, 12, 0, 12)
        dot.Position = state and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)
        dot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        dot.BorderSizePixel = 0
        Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)

        btn.MouseButton1Click:Connect(function()
            state = not state
            btn.BackgroundColor3 = state and cPurple or Color3.fromRGB(50, 50, 65)
            dot.Position = state and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)
            stateLbl.Text = state and "ON" or "OFF"
            if onChange then pcall(onChange, state) end
        end)
        return {get=function() return state end}
    end

    local function makePicker(parent, labelText, options, default, onSelect)
        local row = Instance.new("Frame", parent)
        row.Size = UDim2.new(1, 0, 0, 34)
        row.BackgroundColor3 = cSurface2
        row.BorderSizePixel = 0
        Instance.new("UICorner", row).CornerRadius = UDim.new(0, 6)

        local lbl = Instance.new("TextLabel", row)
        lbl.Size = UDim2.new(1, -170, 1, 0)
        lbl.Position = UDim2.new(0, 12, 0, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = labelText
        lbl.TextColor3 = cText
        lbl.Font = Enum.Font.Gotham
        lbl.TextSize = 12
        lbl.TextXAlignment = Enum.TextXAlignment.Left

        local value = default or (options and options[1]) or ""

        local btn = Instance.new("TextButton", row)
        btn.Size = UDim2.new(0, 150, 1, 0)
        btn.Position = UDim2.new(1, -158, 0, 0)
        btn.BackgroundTransparency = 1
        btn.Text = ""
        btn.AutoButtonColor = false

        local txt = Instance.new("TextLabel", btn)
        txt.Size = UDim2.new(1, -20, 1, 0)
        txt.BackgroundTransparency = 1
        txt.Text = tostring(value)
        txt.TextColor3 = cSub
        txt.Font = Enum.Font.Gotham
        txt.TextSize = 11
        txt.TextXAlignment = Enum.TextXAlignment.Right

        local chev = Instance.new("TextLabel", btn)
        chev.Size = UDim2.new(0, 16, 1, 0)
        chev.Position = UDim2.new(1, -16, 0, 0)
        chev.BackgroundTransparency = 1
        chev.Text = "v"
        chev.TextColor3 = cMuted
        chev.Font = Enum.Font.GothamBold
        chev.TextSize = 10

        local popup = Instance.new("Frame", row)
        popup.Visible = false
        popup.Size = UDim2.new(0, 150, 0, 0)
        popup.AutomaticSize = Enum.AutomaticSize.Y
        popup.Position = UDim2.new(1, -158, 1, 4)
        popup.BackgroundColor3 = cSurface2
        popup.BorderSizePixel = 0
        popup.ZIndex = 50
        Instance.new("UICorner", popup).CornerRadius = UDim.new(0, 6)
        local pst = Instance.new("UIStroke", popup)
        pst.Color = cBorder
        pst.Thickness = 1
        local pl = Instance.new("UIListLayout", popup)
        pl.Padding = UDim.new(0, 1)
        local pp = Instance.new("UIPadding", popup)
        pp.PaddingTop = UDim.new(0, 4)
        pp.PaddingBottom = UDim.new(0, 4)

        btn.MouseButton1Click:Connect(function()
            popup.Visible = not popup.Visible
        end)

        for _, opt in ipairs(options or {}) do
            local o = Instance.new("TextButton", popup)
            o.Size = UDim2.new(1, 0, 0, 22)
            o.BackgroundColor3 = cSurface2
            o.Text = tostring(opt)
            o.TextColor3 = cText
            o.Font = Enum.Font.Gotham
            o.TextSize = 11
            o.BorderSizePixel = 0
            o.AutoButtonColor = false
            o.MouseButton1Click:Connect(function()
                value = opt
                txt.Text = tostring(opt)
                popup.Visible = false
                if onSelect then pcall(onSelect, opt) end
            end)
        end
        return {get=function() return value end}
    end

    local function makeButton(parent, labelText, onClick)
        local btn = Instance.new("TextButton", parent)
        btn.Size = UDim2.new(1, 0, 0, 32)
        btn.BackgroundColor3 = cSurface2
        btn.Text = labelText
        btn.TextColor3 = cText
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 12
        btn.BorderSizePixel = 0
        btn.AutoButtonColor = false
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
        btn.MouseButton1Click:Connect(function()
            if onClick then pcall(onClick) end
        end)
    end

    -- VISUAL
    local v = self.win:getPage("Visual")
    if v then
        local g1 = makeSection(v, "Egg ESP")
        makeToggle(g1, "Enable Egg ESP", false, function(state)
            if self.modules.esp_egg then
                if state then pcall(self.modules.esp_egg.start, self.cfg.Defaults)
                else pcall(self.modules.esp_egg.stop) end
            end
        end)

        local g2 = makeSection(v, "ESP Rarity")
        makePicker(g2, "ESP Min Tier", rarityOptions, "03 Rare", function(opt)
            local num = tonumber(opt:match("^(%d+)"))
            if num then
                _G.OR4CLE.filters = _G.OR4CLE.filters or {}
                _G.OR4CLE.filters.esp_minRarityNum = num
                if self.modules.esp_egg and self.modules.esp_egg.setMinRarityNum then
                    self.modules.esp_egg.setMinRarityNum(num)
                end
            end
        end)

        local g3 = makeSection(v, "ESP Settings")
        makeToggle(g3, "Show Pet Name", true)
        makeToggle(g3, "Show Rarity", true)
        makeToggle(g3, "Show Distance", false)

        local g4 = makeSection(v, "Invisible / Evasive")
        makeToggle(g4, "Ghost Mode", false, function(state)
            if self.modules.invisible then
                if state then
                    self.modules.invisible.setConfig({
                        Invisible_Mode = "Notify Only",
                        Invisible_SafeDist = 30,
                        Invisible_Ghost = true,
                    })
                    pcall(self.modules.invisible.start)
                else
                    pcall(self.modules.invisible.stop)
                end
            end
        end)
    end

    -- FARM
    local f = self.win:getPage("Farm")
    if f then
        local g1 = makeSection(f, "Auto Steal")
        makeToggle(g1, "Enable", false, function(state)
            if self.modules.auto_steal then
                if state then pcall(self.modules.auto_steal.start, self.cfg.Defaults)
                else pcall(self.modules.auto_steal.stop) end
            end
        end)
        makePicker(g1, "Mode", {"Teleport","Idle"}, "Teleport")
        makePicker(g1, "Priority", {"Rarest","Biggest","Nearest","Fastest"}, "Rarest")

        local g2 = makeSection(f, "Auto Hatch")
        makeToggle(g2, "Enable", false)
        makePicker(g2, "Speed", {"Safe","Normal","Turbo"}, "Normal")

        local g3 = makeSection(f, "Auto Place")
        makeToggle(g3, "Enable", false)

        local g4 = makeSection(f, "Auto Treadmill")
        makeToggle(g4, "Enable", false)

        local g5 = makeSection(f, "Speed Boost")
        makeToggle(g5, "Enable", false, function(state)
            if self.modules.speed_boost then
                if state then pcall(self.modules.speed_boost.start, self.cfg.Defaults)
                else pcall(self.modules.speed_boost.stop) end
            end
        end)
    end

    -- FRIEND
    local fr = self.win:getPage("Friends")
    if fr then
        local g1 = makeSection(fr, "Drop for Friends")
        makeToggle(g1, "Enable", false)
        makeToggle(g1, "Auto Pickup Back", true)
        makeButton(g1, "Refresh Friend List", function() end)
    end

    -- UTILITY
    local info = self.win:getPage("Info")
    if info then
        local g1 = makeSection(info, "Live Info")
        local clk = Instance.new("TextLabel", g1)
        clk.Size = UDim2.new(1, -20, 0, 18)
        clk.Position = UDim2.new(0, 10, 0, 6)
        clk.BackgroundTransparency = 1
        clk.Text = "Time: --:--"
        clk.TextColor3 = cPurple
        clk.Font = Enum.Font.GothamBold
        clk.TextSize = 11
        clk.TextXAlignment = Enum.TextXAlignment.Left
        task.spawn(function()
            while clk.Parent do
                if self.ctx.util and self.ctx.util.getClock then
                    clk.Text = "Time: " .. self.ctx.util.getClock()
                end
                task.wait(1)
            end
        end)

        for i = 1, 8 do
            local slot = Instance.new("TextLabel", g1)
            slot.Size = UDim2.new(1, -20, 0, 16)
            slot.Position = UDim2.new(0, 10, 0, 30 + (i-1) * 18)
            slot.BackgroundTransparency = 1
            slot.Text = string.format("%02d. --", i)
            slot.TextColor3 = cSub
            slot.Font = Enum.Font.Code
            slot.TextSize = 10
            slot.TextXAlignment = Enum.TextXAlignment.Left
        end
    end

    -- SETTINGS
    local s = self.win:getPage("Settings")
    if s then
        local g1 = makeSection(s, "Performance")
        makeToggle(g1, "Anti Lag", false, function(state)
            if self.modules.anti_lag then
                if state then pcall(self.modules.anti_lag.start, self.cfg.Defaults)
                else pcall(self.modules.anti_lag.stop) end
            end
        end)
        makePicker(g1, "FPS Cap", {"30","45","60","Unlimited"}, "60")

        local g2 = makeSection(s, "Server Guard")
        makeToggle(g2, "Enable", false)
        makePicker(g2, "Action", {"Auto-Leave","Auto-Hop","Notify Only"}, "Notify Only")

        local g3 = makeSection(s, "Debug")
        makeButton(g3, "Reload Script", function()
            if _G.OR4CLE and _G.OR4CLE.loader then pcall(_G.OR4CLE.loader) end
        end)
        makeButton(g3, "Unload All", function()
            local p = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
            for _, x in ipairs(p:GetChildren()) do
                if x:IsA("ScreenGui") and x.Name:find("OR4CLE") then x:Destroy() end
            end
        end)
    end

    return self
end

return C
