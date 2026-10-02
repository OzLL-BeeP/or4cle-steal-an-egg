-- ui/pages3.lua — content 5 tabs (EN, referensi style)
local C = {}
C.__index = C

function C.new(ctx, window)
    local self = setmetatable({}, C)
    self.ctx = ctx
    self.win = window
    self.cfg = ctx.config or {}
    self.modules = ctx.modules or {}

    local T = self.cfg.Theme or {}
    local cPurple = T.Purple or Color3.fromRGB(138, 90, 250)
    local cText = Color3.fromRGB(240, 240, 248)
    local cSub = Color3.fromRGB(130, 130, 155)
    local cMuted = Color3.fromRGB(70, 70, 90)
    local cSurface2 = Color3.fromRGB(24, 24, 34)
    local cBorder = Color3.fromRGB(35, 32, 55)

    -- ═══ SECTION HEADER (uppercase kecil) ═══
    local function makeGroup(page, headerText)
        local wrap = Instance.new("Frame", page)
        wrap.Size = UDim2.new(1, 0, 0, 0)
        wrap.AutomaticSize = Enum.AutomaticSize.Y
        wrap.BackgroundTransparency = 1
        wrap.ZIndex = 7

        local hdr = Instance.new("TextLabel", wrap)
        hdr.Size = UDim2.new(1, 0, 0, 16)
        hdr.BackgroundTransparency = 1
        hdr.Text = string.upper(headerText)
        hdr.TextColor3 = cSub
        hdr.Font = Enum.Font.GothamMedium
        hdr.TextSize = 11
        hdr.TextXAlignment = Enum.TextXAlignment.Left
        hdr.ZIndex = 8

        local body = Instance.new("Frame", wrap)
        body.Size = UDim2.new(1, 0, 0, 0)
        body.Position = UDim2.new(0, 0, 0, 22)
        body.AutomaticSize = Enum.AutomaticSize.Y
        body.BackgroundColor3 = Color3.fromRGB(14, 14, 22)
        body.BorderSizePixel = 0
        body.ZIndex = 7
        Instance.new("UICorner", body).CornerRadius = UDim.new(0, 8)

        local ll = Instance.new("UIListLayout", body)
        ll.Padding = UDim.new(0, 0)
        ll.SortOrder = Enum.SortOrder.LayoutOrder

        return body
    end

    -- ═══ TOGGLE ROW (label OFF/ON di kanan) ═══
    local function makeToggle(parent, labelText, default, onChange)
        local row = Instance.new("Frame", parent)
        row.Size = UDim2.new(1, 0, 0, 44)
        row.BackgroundTransparency = 1

        local lbl = Instance.new("TextLabel", row)
        lbl.Size = UDim2.new(1, -100, 1, 0)
        lbl.Position = UDim2.new(0, 14, 0, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = labelText
        lbl.TextColor3 = cText
        lbl.Font = Enum.Font.Gotham
        lbl.TextSize = 13
        lbl.TextXAlignment = Enum.TextXAlignment.Left

        local stateLbl = Instance.new("TextLabel", row)
        stateLbl.Size = UDim2.new(0, 30, 1, 0)
        stateLbl.Position = UDim2.new(1, -86, 0, 0)
        stateLbl.BackgroundTransparency = 1
        stateLbl.Text = default and "ON" or "OFF"
        stateLbl.TextColor3 = cSub
        stateLbl.Font = Enum.Font.GothamBold
        stateLbl.TextSize = 11
        stateLbl.TextXAlignment = Enum.TextXAlignment.Right

        local state = default or false

        local btn = Instance.new("TextButton", row)
        btn.Size = UDim2.new(0, 34, 0, 18)
        btn.Position = UDim2.new(1, -40, 0.5, -9)
        btn.BackgroundColor3 = state and cPurple or Color3.fromRGB(40, 40, 55)
        btn.Text = ""
        btn.AutoButtonColor = false
        btn.BorderSizePixel = 0
        Instance.new("UICorner", btn).CornerRadius = UDim.new(1, 0)

        local dot = Instance.new("Frame", btn)
        dot.Size = UDim2.new(0, 14, 0, 14)
        dot.Position = state and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
        dot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        dot.BorderSizePixel = 0
        Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)

        btn.MouseButton1Click:Connect(function()
            state = not state
            btn.BackgroundColor3 = state and cPurple or Color3.fromRGB(40, 40, 55)
            dot.Position = state and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
            stateLbl.Text = state and "ON" or "OFF"
            if onChange then pcall(onChange, state) end
        end)

        return {get=function() return state end}
    end

    -- ═══ PICKER (label + chevron v) ═══
    local function makePicker(parent, labelText, options, default, onSelect)
        local row = Instance.new("Frame", parent)
        row.Size = UDim2.new(1, 0, 0, 44)
        row.BackgroundTransparency = 1

        local lbl = Instance.new("TextLabel", row)
        lbl.Size = UDim2.new(1, -180, 1, 0)
        lbl.Position = UDim2.new(0, 14, 0, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = labelText
        lbl.TextColor3 = cText
        lbl.Font = Enum.Font.Gotham
        lbl.TextSize = 13
        lbl.TextXAlignment = Enum.TextXAlignment.Left

        local value = default or (options and options[1]) or ""

        local btn = Instance.new("TextButton", row)
        btn.Size = UDim2.new(0, 150, 0, 30)
        btn.Position = UDim2.new(1, -164, 0.5, -15)
        btn.BackgroundTransparency = 1
        btn.Text = ""
        btn.AutoButtonColor = false

        local txt = Instance.new("TextLabel", btn)
        txt.Size = UDim2.new(1, -20, 1, 0)
        txt.BackgroundTransparency = 1
        txt.Text = tostring(value)
        txt.TextColor3 = cSub
        txt.Font = Enum.Font.Gotham
        txt.TextSize = 12
        txt.TextXAlignment = Enum.TextXAlignment.Right

        local chev = Instance.new("TextLabel", btn)
        chev.Size = UDim2.new(0, 16, 1, 0)
        chev.Position = UDim2.new(1, -16, 0, 0)
        chev.BackgroundTransparency = 1
        chev.Text = "v"
        chev.TextColor3 = cMuted
        chev.Font = Enum.Font.GothamBold
        chev.TextSize = 11

        local popup = Instance.new("Frame", row)
        popup.Visible = false
        popup.Size = UDim2.new(0, 150, 0, 0)
        popup.AutomaticSize = Enum.AutomaticSize.Y
        popup.Position = UDim2.new(1, -164, 1, 4)
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
            o.Size = UDim2.new(1, 0, 0, 24)
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

    -- ═══ BUTTON ROW ═══
    local function makeButton(parent, labelText, onClick)
        local row = Instance.new("Frame", parent)
        row.Size = UDim2.new(1, 0, 0, 40)
        row.BackgroundTransparency = 1

        local btn = Instance.new("TextButton", row)
        btn.Size = UDim2.new(1, -24, 1, -8)
        btn.Position = UDim2.new(0, 12, 0, 4)
        btn.BackgroundColor3 = cSurface2
        btn.Text = labelText
        btn.TextColor3 = cText
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 12
        btn.BorderSizePixel = 0
        btn.AutoButtonColor = false
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
        local bst = Instance.new("UIStroke", btn)
        bst.Color = cBorder
        bst.Thickness = 1
        btn.MouseButton1Click:Connect(function()
            if onClick then pcall(onClick) end
        end)
    end

    -- ═══════════════════════════════════════
    -- VISUAL
    -- ═══════════════════════════════════════
    local v = self.win:getPage("Visual")
    if v then
        local g1 = makeGroup(v, "Egg ESP")
        makeToggle(g1, "Enable Egg ESP", false, function(state)
            if self.modules.esp_egg then
                if state then pcall(self.modules.esp_egg.start, self.cfg.Defaults)
                else pcall(self.modules.esp_egg.stop) end
            end
        end)

        local g2 = makeGroup(v, "ESP Rarity")
        makePicker(g2, "ESP Min Tier: Rare", self.cfg.RarityOrder or {}, "Rare", function(opt)
            _G.OR4CLE.filters = _G.OR4CLE.filters or {}
            _G.OR4CLE.filters.esp_minRarity = opt
            if self.modules.esp_egg and self.modules.esp_egg.setMinRarity then
                self.modules.esp_egg.setMinRarity(opt)
            end
        end)

        local g3 = makeGroup(v, "ESP Style")
        makePicker(g3, "Style: Panel", {"Panel","Text","Minimal"}, "Panel")

        local g4 = makeGroup(v, "ESP Settings")
        makeToggle(g4, "Show Pet Name", true)
        makeToggle(g4, "Show Rarity", true)
        makeToggle(g4, "Show Distance", false)
        makeToggle(g4, "Show Tracer", false)

        local g5 = makeGroup(v, "Invisible / Evasive")
        makeToggle(g5, "Ghost Mode", false, function(state)
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
        makePicker(g5, "Evasive Mode", {"Off","Auto-Hide","Auto-Teleport","Notify Only"}, "Notify Only")
        makeToggle(g5, "Guardian Radar", true)
    end

    -- ═══════════════════════════════════════
    -- FARM
    -- ═══════════════════════════════════════
    local f = self.win:getPage("Farm")
    if f then
        local g1 = makeGroup(f, "Auto Steal")
        makeToggle(g1, "Enable Auto Steal", false, function(state)
            if self.modules.auto_steal then
                if state then pcall(self.modules.auto_steal.start, self.cfg.Defaults)
                else pcall(self.modules.auto_steal.stop) end
            end
        end)
        makePicker(g1, "Mode: Teleport", {"Teleport","Idle"}, "Teleport")
        makePicker(g1, "Priority: Rarest", {"Rarest","Biggest","Nearest","Fastest"}, "Rarest")
        makeToggle(g1, "Ignore Guardian", false)

        local g2 = makeGroup(f, "Auto Hatch")
        makeToggle(g2, "Enable Auto Hatch", false, function(state)
            if self.modules.auto_hatch then
                if state then pcall(self.modules.auto_hatch.start, self.cfg.Defaults)
                else pcall(self.modules.auto_hatch.stop) end
            end
        end)
        makePicker(g2, "Speed: Normal", {"Safe","Normal","Turbo"}, "Normal")

        local g3 = makeGroup(f, "Auto Place")
        makeToggle(g3, "Enable Auto Place", false, function(state)
            if self.modules.auto_place then
                if state then pcall(self.modules.auto_place.start, self.cfg.Defaults)
                else pcall(self.modules.auto_place.stop) end
            end
        end)

        local g4 = makeGroup(f, "Auto Treadmill")
        makeToggle(g4, "Enable Auto Treadmill", false, function(state)
            if self.modules.auto_treadmill then
                if state then pcall(self.modules.auto_treadmill.start, self.cfg.Defaults)
                else pcall(self.modules.auto_treadmill.stop) end
            end
        end)

        local g5 = makeGroup(f, "Speed Boost")
        makeToggle(g5, "Enable Speed Boost", false, function(state)
            if self.modules.speed_boost then
                if state then pcall(self.modules.speed_boost.start, self.cfg.Defaults)
                else pcall(self.modules.speed_boost.stop) end
            end
        end)
    end

    -- ═══════════════════════════════════════
    -- FRIENDS
    -- ═══════════════════════════════════════
    local fr = self.win:getPage("Friends")
    if fr then
        local g1 = makeGroup(fr, "Drop for Friends")
        makeToggle(g1, "Enable", false, function(state)
            if self.modules.friends_drop then
                if state then pcall(self.modules.friends_drop.start, self.cfg.Defaults)
                else pcall(self.modules.friends_drop.stop) end
            end
        end)
        makeToggle(g1, "Auto Pickup Back", true)
        makeButton(g1, "Refresh Friend List", function() end)
    end

    -- ═══════════════════════════════════════
    -- INFO
    -- ═══════════════════════════════════════
    local info = self.win:getPage("Info")
    if info then
        local g1 = makeGroup(info, "Live Info")
        local clk = Instance.new("TextLabel", g1)
        clk.Size = UDim2.new(1, -28, 0, 20)
        clk.Position = UDim2.new(0, 14, 0, 8)
        clk.BackgroundTransparency = 1
        clk.Text = "Time: --:--"
        clk.TextColor3 = cPurple
        clk.Font = Enum.Font.GothamBold
        clk.TextSize = 12
        clk.TextXAlignment = Enum.TextXAlignment.Left
        task.spawn(function()
            while clk.Parent do
                if self.ctx.util and self.ctx.util.getClock then
                    clk.Text = "Time: " .. self.ctx.util.getClock()
                end
                task.wait(1)
            end
        end)

        for i = 1, 10 do
            local slot = Instance.new("TextLabel", g1)
            slot.Size = UDim2.new(1, -28, 0, 18)
            slot.Position = UDim2.new(0, 14, 0, 32 + (i-1) * 20)
            slot.BackgroundTransparency = 1
            slot.Text = string.format("%02d. --", i)
            slot.TextColor3 = cSub
            slot.Font = Enum.Font.Code
            slot.TextSize = 11
            slot.TextXAlignment = Enum.TextXAlignment.Left
        end
    end

    -- ═══════════════════════════════════════
    -- SETTINGS
    -- ═══════════════════════════════════════
    local s = self.win:getPage("Settings")
    if s then
        local g1 = makeGroup(s, "Performance")
        makeToggle(g1, "Anti Lag", false, function(state)
            if self.modules.anti_lag then
                if state then pcall(self.modules.anti_lag.start, self.cfg.Defaults)
                else pcall(self.modules.anti_lag.stop) end
            end
        end)
        makePicker(g1, "FPS Cap: 60", {"30","45","60","Unlimited"}, "60")
        makeToggle(g1, "Disable Particles", true)
        makeToggle(g1, "Disable Shadows", true)

        local g2 = makeGroup(s, "Server Guard")
        makeToggle(g2, "Enable", false, function(state)
            if self.modules.server_guard then
                if state then pcall(self.modules.server_guard.start, self.cfg.Defaults)
                else pcall(self.modules.server_guard.stop) end
            end
        end)
        makePicker(g2, "Action: Notify Only", {"Auto-Leave","Auto-Hop","Notify Only"}, "Notify Only")
        makePicker(g2, "Hop After: 15 min", {"5 min","15 min","30 min","60 min"}, "15 min")

        local g3 = makeGroup(s, "Debug")
        makeToggle(g3, "Safe Mode", true)
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
