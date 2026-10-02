-- ui/pages3.lua — content 5 tabs (EN, compact)
local C = {}
C.__index = C

function C.new(ctx, window)
    local self = setmetatable({}, C)
    self.ctx = ctx
    self.win = window
    self.cfg = ctx.config or {}
    self.modules = ctx.modules or {}
    self.toggles = {}

    local T = self.cfg.Theme or {}
    local cPurple = T.Purple or Color3.fromRGB(140, 90, 250)
    local cViolet = Color3.fromRGB(180, 130, 255)
    local cText = Color3.fromRGB(245, 245, 252)
    local cSub = Color3.fromRGB(145, 145, 170)
    local cSurface2 = Color3.fromRGB(28, 28, 38)
    local cBorder = Color3.fromRGB(50, 44, 80)

    -- ═══════════════════════════════════════
    -- COMPONENTS
    -- ═══════════════════════════════════════
    local function makeSection(page, titleText, subtitleText)
        local wrap = Instance.new("Frame", page)
        wrap.Size = UDim2.new(1, 0, 0, 0)
        wrap.AutomaticSize = Enum.AutomaticSize.Y
        wrap.BackgroundTransparency = 1
        wrap.ZIndex = 7

        local hdr = Instance.new("Frame", wrap)
        hdr.Size = UDim2.new(1, 0, 0, 26)
        hdr.BackgroundTransparency = 1
        hdr.ZIndex = 8

        local bar = Instance.new("Frame", hdr)
        bar.Size = UDim2.new(0, 3, 0, 14)
        bar.Position = UDim2.new(0, 0, 0.5, -7)
        bar.BackgroundColor3 = cPurple
        bar.BorderSizePixel = 0
        bar.ZIndex = 9
        Instance.new("UICorner", bar).CornerRadius = UDim.new(1, 0)

        local title = Instance.new("TextLabel", hdr)
        title.Size = UDim2.new(1, -14, 0, 18)
        title.Position = UDim2.new(0, 12, 0, 0)
        title.BackgroundTransparency = 1
        title.Text = titleText
        title.TextColor3 = cText
        title.Font = Enum.Font.GothamBold
        title.TextSize = 13
        title.TextXAlignment = Enum.TextXAlignment.Left
        title.ZIndex = 9

        if subtitleText then
            local sub = Instance.new("TextLabel", hdr)
            sub.Size = UDim2.new(1, -14, 0, 10)
            sub.Position = UDim2.new(0, 12, 0, 16)
            sub.BackgroundTransparency = 1
            sub.Text = subtitleText
            sub.TextColor3 = cSub
            sub.Font = Enum.Font.Gotham
            sub.TextSize = 10
            sub.TextXAlignment = Enum.TextXAlignment.Left
            sub.ZIndex = 9
        end

        local body = Instance.new("Frame", wrap)
        body.Size = UDim2.new(1, 0, 0, 0)
        body.Position = UDim2.new(0, 0, 0, 28)
        body.AutomaticSize = Enum.AutomaticSize.Y
        body.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
        body.BorderSizePixel = 0
        body.ZIndex = 7
        Instance.new("UICorner", body).CornerRadius = UDim.new(0, 8)

        local bodyStroke = Instance.new("UIStroke", body)
        bodyStroke.Color = cBorder
        bodyStroke.Thickness = 1
        bodyStroke.Transparency = 0.5

        local pad = Instance.new("UIPadding", body)
        pad.PaddingTop = UDim.new(0, 8)
        pad.PaddingBottom = UDim.new(0, 8)
        pad.PaddingLeft = UDim.new(0, 10)
        pad.PaddingRight = UDim.new(0, 10)

        local ll = Instance.new("UIListLayout", body)
        ll.Padding = UDim.new(0, 6)
        ll.SortOrder = Enum.SortOrder.LayoutOrder

        return body
    end

    local function makeToggle(parent, labelText, default, onChange)
        local row = Instance.new("Frame", parent)
        row.Size = UDim2.new(1, 0, 0, 26)
        row.BackgroundTransparency = 1

        local lbl = Instance.new("TextLabel", row)
        lbl.Size = UDim2.new(1, -60, 1, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = labelText
        lbl.TextColor3 = cText
        lbl.Font = Enum.Font.Gotham
        lbl.TextSize = 12
        lbl.TextXAlignment = Enum.TextXAlignment.Left

        local state = default or false

        local btn = Instance.new("TextButton", row)
        btn.Size = UDim2.new(0, 36, 0, 18)
        btn.Position = UDim2.new(1, -40, 0.5, -9)
        btn.BackgroundColor3 = state and cPurple or Color3.fromRGB(55, 55, 72)
        btn.Text = ""
        btn.AutoButtonColor = false
        btn.BorderSizePixel = 0
        Instance.new("UICorner", btn).CornerRadius = UDim.new(1, 0)

        local dot = Instance.new("Frame", btn)
        dot.Size = UDim2.new(0, 12, 0, 12)
        dot.Position = state and UDim2.new(1, -15, 0.5, -6) or UDim2.new(0, 3, 0.5, -6)
        dot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        dot.BorderSizePixel = 0
        Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)

        btn.MouseButton1Click:Connect(function()
            state = not state
            btn.BackgroundColor3 = state and cPurple or Color3.fromRGB(55, 55, 72)
            dot.Position = state and UDim2.new(1, -15, 0.5, -6) or UDim2.new(0, 3, 0.5, -6)
            if onChange then pcall(onChange, state) end
        end)

        return {get=function() return state end, set=function(v) btn:MouseButton1Click() end}
    end

    local function makePicker(parent, labelText, options, default, onSelect)
        local row = Instance.new("Frame", parent)
        row.Size = UDim2.new(1, 0, 0, 26)
        row.BackgroundTransparency = 1

        local lbl = Instance.new("TextLabel", row)
        lbl.Size = UDim2.new(0.5, -4, 1, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = labelText
        lbl.TextColor3 = cText
        lbl.Font = Enum.Font.Gotham
        lbl.TextSize = 12
        lbl.TextXAlignment = Enum.TextXAlignment.Left

        local value = default or (options and options[1]) or ""

        local btn = Instance.new("TextButton", row)
        btn.Size = UDim2.new(0.5, -4, 1, 0)
        btn.Position = UDim2.new(0.5, 4, 0, 0)
        btn.BackgroundColor3 = cSurface2
        btn.Text = tostring(value)
        btn.TextColor3 = cText
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 11
        btn.BorderSizePixel = 0
        btn.AutoButtonColor = false
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

        local popup = Instance.new("Frame", row)
        popup.Visible = false
        popup.Size = UDim2.new(0, 140, 0, 0)
        popup.AutomaticSize = Enum.AutomaticSize.Y
        popup.Position = UDim2.new(0.5, 4, 1, 4)
        popup.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
        popup.BorderSizePixel = 0
        popup.ZIndex = 50
        Instance.new("UICorner", popup).CornerRadius = UDim.new(0, 6)
        local pst = Instance.new("UIStroke", popup)
        pst.Color = cPurple
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
                btn.Text = tostring(opt)
                popup.Visible = false
                if onSelect then pcall(onSelect, opt) end
            end)
        end

        return {get=function() return value end}
    end

    local function makeButton(parent, title, onClick)
        local btn = Instance.new("TextButton", parent)
        btn.Size = UDim2.new(1, 0, 0, 26)
        btn.BackgroundColor3 = cSurface2
        btn.Text = title
        btn.TextColor3 = cText
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 12
        btn.BorderSizePixel = 0
        btn.AutoButtonColor = false
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
        btn.MouseButton1Click:Connect(function()
            if onClick then pcall(onClick) end
        end)
        return btn
    end

    -- ═══════════════════════════════════════
    -- TAB 1: VISUAL
    -- ═══════════════════════════════════════
    local v = self.win:getPage("Visual")
    if v then
        local sec1 = makeSection(v, "ESP — Egg", "Show egg name + pet + rarity")
        makeToggle(sec1, "Enable ESP", false, function(state)
            if self.modules.esp_egg then
                if state then
                    pcall(self.modules.esp_egg.start, self.cfg.Defaults)
                else
                    pcall(self.modules.esp_egg.stop)
                end
            end
        end)
        makePicker(sec1, "Min Rarity", self.cfg.RarityOrder or {}, "Rare", function(opt)
            self.ctx.filters = self.ctx.filters or {}
            self.ctx.filters.esp_minRarity = opt
        end)
        makeToggle(sec1, "Show Pet Name", true)
        makeToggle(sec1, "Show Rarity", true)
        makeToggle(sec1, "Show Distance", false)
        makeToggle(sec1, "Show Tracer", false)

        local sec2 = makeSection(v, "Invisible / Evasive", "Ghost mode + Guardian evasive")
        makeToggle(sec2, "Ghost Mode", false, function(state)
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
        makePicker(sec2, "Evasive Mode",
            {"Off","Auto-Hide","Auto-Teleport","Notify Only"}, "Notify Only")
        makeToggle(sec2, "Guardian Radar", true)
    end

    -- ═══════════════════════════════════════
    -- TAB 2: FARM
    -- ═══════════════════════════════════════
    local f = self.win:getPage("Farm")
    if f then
        local s1 = makeSection(f, "Auto Steal", "Auto steal egg from biome")
        makeToggle(s1, "Enable", false, function(state)
            if self.modules.auto_steal then
                if state then pcall(self.modules.auto_steal.start, self.cfg.Defaults)
                else pcall(self.modules.auto_steal.stop) end
            end
        end)
        makePicker(s1, "Mode", {"Teleport","Idle"}, "Teleport")
        makePicker(s1, "Priority", {"Rarest","Biggest","Nearest","Fastest"}, "Rarest")
        makeToggle(s1, "Ignore Guardian", false)

        local s2 = makeSection(f, "Auto Hatch", "Auto hatch egg at base")
        makeToggle(s2, "Enable", false, function(state)
            if self.modules.auto_hatch then
                if state then pcall(self.modules.auto_hatch.start, self.cfg.Defaults)
                else pcall(self.modules.auto_hatch.stop) end
            end
        end)
        makePicker(s2, "Speed", {"Safe","Normal","Turbo"}, "Normal")

        local s3 = makeSection(f, "Auto Place", "Auto place pet")
        makeToggle(s3, "Enable", false, function(state)
            if self.modules.auto_place then
                if state then pcall(self.modules.auto_place.start, self.cfg.Defaults)
                else pcall(self.modules.auto_place.stop) end
            end
        end)

        local s4 = makeSection(f, "Auto Treadmill", "Auto upgrade speed")
        makeToggle(s4, "Enable", false, function(state)
            if self.modules.auto_treadmill then
                if state then pcall(self.modules.auto_treadmill.start, self.cfg.Defaults)
                else pcall(self.modules.auto_treadmill.stop) end
            end
        end)

        local s5 = makeSection(f, "Speed Boost", "Faster walk speed")
        makeToggle(s5, "Enable", false, function(state)
            if self.modules.speed_boost then
                if state then pcall(self.modules.speed_boost.start, self.cfg.Defaults)
                else pcall(self.modules.speed_boost.stop) end
            end
        end)
    end

    -- ═══════════════════════════════════════
    -- TAB 3: FRIENDS
    -- ═══════════════════════════════════════
    local fr = self.win:getPage("Friends")
    if fr then
        local s1 = makeSection(fr, "Drop for Friends", "Drop egg on friend's path")
        makeToggle(s1, "Enable", false, function(state)
            if self.modules.friends_drop then
                if state then pcall(self.modules.friends_drop.start, self.cfg.Defaults)
                else pcall(self.modules.friends_drop.stop) end
            end
        end)
        makeToggle(s1, "Auto Pickup Back", true)
        makeButton(s1, "Refresh Friend List", function() end)
    end

    -- ═══════════════════════════════════════
    -- TAB 4: INFO
    -- ═══════════════════════════════════════
    local info = self.win:getPage("Info")
    if info then
        local s1 = makeSection(info, "Live Info", "10 recent egg info")
        local clk = Instance.new("TextLabel", s1)
        clk.Size = UDim2.new(1, 0, 0, 16)
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

        local listFrame = Instance.new("Frame", s1)
        listFrame.Size = UDim2.new(1, 0, 0, 220)
        listFrame.BackgroundColor3 = Color3.fromRGB(11, 11, 17)
        listFrame.BorderSizePixel = 0
        Instance.new("UICorner", listFrame).CornerRadius = UDim.new(0, 6)

        for i = 1, 10 do
            local slot = Instance.new("TextLabel", listFrame)
            slot.Size = UDim2.new(1, -16, 0, 18)
            slot.Position = UDim2.new(0, 10, 0, (i-1) * 21 + 8)
            slot.BackgroundTransparency = 1
            slot.Text = string.format("%02d. --", i)
            slot.TextColor3 = cSub
            slot.Font = Enum.Font.Code
            slot.TextSize = 11
            slot.TextXAlignment = Enum.TextXAlignment.Left
        end
    end

    -- ═══════════════════════════════════════
    -- TAB 5: SETTINGS
    -- ═══════════════════════════════════════
    local s = self.win:getPage("Settings")
    if s then
        local s1 = makeSection(s, "Performance", "Anti lag + FPS")
        makeToggle(s1, "Anti Lag", false, function(state)
            if self.modules.anti_lag then
                if state then pcall(self.modules.anti_lag.start, self.cfg.Defaults)
                else pcall(self.modules.anti_lag.stop) end
            end
        end)
        makePicker(s1, "FPS Cap", {"30","45","60","Unlimited"}, "60")
        makeToggle(s1, "Disable Particles", true)
        makeToggle(s1, "Disable Shadows", true)

        local s2 = makeSection(s, "Server Guard", "Auto leave / hop / notify")
        makeToggle(s2, "Enable", false, function(state)
            if self.modules.server_guard then
                if state then pcall(self.modules.server_guard.start, self.cfg.Defaults)
                else pcall(self.modules.server_guard.stop) end
            end
        end)
        makePicker(s2, "Action", {"Auto-Leave","Auto-Hop","Notify Only"}, "Notify Only")
        makePicker(s2, "Hop After", {"5 min","15 min","30 min","60 min"}, "15 min")

        local s3 = makeSection(s, "Debug", "Reload + unload")
        makeToggle(s3, "Safe Mode", true)
        makeButton(s3, "Reload Script", function()
            if _G.OR4CLE and _G.OR4CLE.loader then pcall(_G.OR4CLE.loader) end
        end)
        makeButton(s3, "Unload All", function()
            local p = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
            for _, x in ipairs(p:GetChildren()) do
                if x:IsA("ScreenGui") and x.Name:find("OR4CLE") then x:Destroy() end
            end
        end)
    end

    return self
end

return C
