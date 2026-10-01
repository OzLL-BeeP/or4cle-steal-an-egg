-- ui/pages.lua — populate 5 tab dengan komponen
local C = {}
C.__index = C

function C.new(ctx, window)
    local self = setmetatable({}, C)
    self.ctx = ctx
    self.win = window
    self.cfg = ctx.config or {}
    self.components = ctx.components or {}
    self.modules = ctx.modules or {}

    local T = self.cfg.Theme or {}

    -- helper: bikin section di page
    local function makeSection(page, title)
        local wrap = Instance.new("Frame")
        wrap.Size = UDim2.new(1, 0, 0, 0)
        wrap.AutomaticSize = Enum.AutomaticSize.Y
        wrap.BackgroundTransparency = 1
        wrap.Parent = page

        local hdr = Instance.new("Frame", wrap)
        hdr.Size = UDim2.new(1, 0, 0, 26)
        hdr.BackgroundTransparency = 1
        hdr.Parent = wrap

        local bar = Instance.new("Frame", hdr)
        bar.Size = UDim2.new(0, 3, 0, 14)
        bar.Position = UDim2.new(0, 0, 0.5, -7)
        bar.BackgroundColor3 = T.Purple or Color3.fromRGB(138,92,246)
        bar.BorderSizePixel = 0
        Instance.new("UICorner", bar).CornerRadius = UDim.new(1, 0)

        local lbl = Instance.new("TextLabel", hdr)
        lbl.Size = UDim2.new(1, -10, 1, 0)
        lbl.Position = UDim2.new(0, 10, 0, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = title
        lbl.TextColor3 = T.Text or Color3.fromRGB(235,235,245)
        lbl.Font = Enum.Font.GothamBold
        lbl.TextSize = 13
        lbl.TextXAlignment = Enum.TextXAlignment.Left

        local body = Instance.new("Frame", wrap)
        body.Size = UDim2.new(1, 0, 0, 0)
        body.Position = UDim2.new(0, 0, 0, 28)
        body.AutomaticSize = Enum.AutomaticSize.Y
        body.BackgroundColor3 = T.Surface or Color3.fromRGB(22,22,32)
        body.BorderSizePixel = 0
        body.Parent = wrap
        Instance.new("UICorner", body).CornerRadius = UDim.new(0, 8)

        local pad = Instance.new("UIPadding", body)
        pad.PaddingTop = UDim.new(0, 8)
        pad.PaddingBottom = UDim.new(0, 8)
        pad.PaddingLeft = UDim.new(0, 10)
        pad.PaddingRight = UDim.new(0, 10)

        local layout = Instance.new("UIListLayout", body)
        layout.Padding = UDim.new(0, 6)
        layout.SortOrder = Enum.SortOrder.LayoutOrder

        return body
    end

    -- helper: toggle
    local function addToggle(parent, title, default, onChange)
        local row = Instance.new("Frame")
        row.Size = UDim2.new(1, 0, 0, 28)
        row.BackgroundTransparency = 1
        row.Parent = parent

        local lbl = Instance.new("TextLabel", row)
        lbl.Size = UDim2.new(1, -60, 1, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = title
        lbl.TextColor3 = T.Text or Color3.fromRGB(235,235,245)
        lbl.Font = Enum.Font.Gotham
        lbl.TextSize = 12
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Parent = row

        local state = default or false

        local btn = Instance.new("TextButton", row)
        btn.Size = UDim2.new(0, 40, 0, 20)
        btn.Position = UDim2.new(1, -44, 0.5, -10)
        btn.BackgroundColor3 = state and (T.Purple or Color3.fromRGB(138,92,246)) or Color3.fromRGB(60,60,80)
        btn.Text = ""
        btn.AutoButtonColor = false
        btn.BorderSizePixel = 0
        Instance.new("UICorner", btn).CornerRadius = UDim.new(1, 0)

        local dot = Instance.new("Frame", btn)
        dot.Size = UDim2.new(0, 14, 0, 14)
        dot.Position = state and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)
        dot.BackgroundColor3 = Color3.fromRGB(255,255,255)
        dot.BorderSizePixel = 0
        Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)

        btn.MouseButton1Click:Connect(function()
            state = not state
            btn.BackgroundColor3 = state and (T.Purple or Color3.fromRGB(138,92,246)) or Color3.fromRGB(60,60,80)
            dot.Position = state and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)
            if onChange then pcall(onChange, state) end
        end)
        return { get = function() return state end, btn = btn, dot = dot }
    end

    -- helper: option picker (list)
    local function addPicker(parent, title, options, default, onSelect)
        local row = Instance.new("Frame")
        row.Size = UDim2.new(1, 0, 0, 28)
        row.BackgroundTransparency = 1
        row.Parent = parent

        local lbl = Instance.new("TextLabel", row)
        lbl.Size = UDim2.new(0.5, -4, 1, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = title
        lbl.TextColor3 = T.Text or Color3.fromRGB(235,235,245)
        lbl.Font = Enum.Font.Gotham
        lbl.TextSize = 12
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Parent = row

        local value = default or (options and options[1]) or ""

        local btn = Instance.new("TextButton", row)
        btn.Size = UDim2.new(0.5, -4, 1, 0)
        btn.Position = UDim2.new(0.5, 4, 0, 0)
        btn.BackgroundColor3 = T.SurfaceAlt or Color3.fromRGB(30,30,44)
        btn.Text = tostring(value)
        btn.TextColor3 = T.Text or Color3.fromRGB(235,235,245)
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 11
        btn.BorderSizePixel = 0
        btn.AutoButtonColor = false
        btn.Parent = row
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

        local popup = Instance.new("Frame", row)
        popup.Visible = false
        popup.Size = UDim2.new(0, 150, 0, 0)
        popup.AutomaticSize = Enum.AutomaticSize.Y
        popup.Position = UDim2.new(0.5, 4, 1, 4)
        popup.BackgroundColor3 = T.Surface or Color3.fromRGB(22,22,32)
        popup.BorderSizePixel = 0
        popup.ZIndex = 50
        Instance.new("UICorner", popup).CornerRadius = UDim.new(0, 6)
        local st = Instance.new("UIStroke", popup)
        st.Color = T.Purple or Color3.fromRGB(138,92,246)
        st.Thickness = 1
        local pl = Instance.new("UIListLayout", popup)
        pl.Padding = UDim.new(0, 2)
        local pp = Instance.new("UIPadding", popup)
        pp.PaddingTop = UDim.new(0, 4)
        pp.PaddingBottom = UDim.new(0, 4)

        btn.MouseButton1Click:Connect(function()
            popup.Visible = not popup.Visible
        end)

        local function setValue(v)
            value = v
            btn.Text = tostring(v)
            popup.Visible = false
            if onSelect then pcall(onSelect, v) end
        end

        for _, opt in ipairs(options or {}) do
            local o = Instance.new("TextButton", popup)
            o.Size = UDim2.new(1, 0, 0, 24)
            o.BackgroundColor3 = T.SurfaceAlt or Color3.fromRGB(30,30,44)
            o.Text = tostring(opt)
            o.TextColor3 = T.Text or Color3.fromRGB(235,235,245)
            o.Font = Enum.Font.Gotham
            o.TextSize = 11
            o.BorderSizePixel = 0
            o.AutoButtonColor = false
            o.MouseButton1Click:Connect(function() setValue(opt) end)
        end

        return { get = function() return value end, set = setValue }
    end

    -- helper: button
    local function addButton(parent, title, onClick)
        local btn = Instance.new("TextButton", parent)
        btn.Size = UDim2.new(1, 0, 0, 28)
        btn.BackgroundColor3 = T.SurfaceAlt or Color3.fromRGB(30,30,44)
        btn.Text = title
        btn.TextColor3 = T.Text or Color3.fromRGB(235,235,245)
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 12
        btn.BorderSizePixel = 0
        btn.AutoButtonColor = false
        btn.Parent = parent
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
        btn.MouseButton1Click:Connect(function()
            if onClick then pcall(onClick) end
        end)
        return btn
    end

    -- ═══════════════════════════════════
    -- TAB 1: VISUAL
    -- ═══════════════════════════════════
    local pVisual = self.win:getPage("Visual")
    if pVisual then
        local secESP = makeSection(pVisual, "ESP — Egg")
        addToggle(secESP, "Enable ESP", false, function(v)
            if self.modules.esp_egg then
                if v then
                    pcall(self.modules.esp_egg.start, self.cfg.Defaults)
                else
                    pcall(self.modules.esp_egg.stop)
                end
            end
        end)
        addPicker(secESP, "Min Rarity", self.cfg.RarityOrder or {}, "Rare")
        addPicker(secESP, "Biome", {"All", unpack(self.cfg.Biomes or {})}, "All")
        addToggle(secESP, "Show Tier", true)
        addToggle(secESP, "Show Distance", true)
        addToggle(secESP, "Show Tracer", false)

        local secInv = makeSection(pVisual, "Invisible / Evasive")
        addToggle(secInv, "Ghost Mode", false, function(v)
            if self.modules.invisible then
                if v then
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
        addPicker(secInv, "Evasive Mode",
            self.cfg.Invisible and self.cfg.Invisible.Modes or {"Off","Auto-Hide","Auto-Teleport","Notify Only"},
            "Notify Only")
        addToggle(secInv, "Guardian Radar", true)
    end

    -- ═══════════════════════════════════
    -- TAB 2: FARM
    -- ═══════════════════════════════════
    local pFarm = self.win:getPage("Farm")
    if pFarm then
        local secSteal = makeSection(pFarm, "Auto Steal")
        addToggle(secSteal, "Enable", false, function(v)
            if self.modules.auto_steal then
                if v then pcall(self.modules.auto_steal.start, self.cfg.Defaults)
                else pcall(self.modules.auto_steal.stop) end
            end
        end)
        addPicker(secSteal, "Mode", self.cfg.Farm and self.cfg.Farm.StealModes or {"Teleport","Idle"}, "Teleport")
        addPicker(secSteal, "Priority", self.cfg.Farm and self.cfg.Farm.SelectRarity or {"Rarest","Biggest","Nearest","Fastest"}, "Rarest")

        local secHatch = makeSection(pFarm, "Auto Hatch")
        addToggle(secHatch, "Enable", false, function(v)
            if self.modules.auto_hatch then
                if v then pcall(self.modules.auto_hatch.start, self.cfg.Defaults)
                else pcall(self.modules.auto_hatch.stop) end
            end
        end)
        addPicker(secHatch, "Speed", self.cfg.Farm and self.cfg.Farm.HatchSpeeds or {"Safe","Normal","Turbo"}, "Normal")

        local secPlace = makeSection(pFarm, "Auto Place")
        addToggle(secPlace, "Enable", false, function(v)
            if self.modules.auto_place then
                if v then pcall(self.modules.auto_place.start, self.cfg.Defaults)
                else pcall(self.modules.auto_place.stop) end
            end
        end)

        local secTread = makeSection(pFarm, "Auto Treadmill")
        addToggle(secTread, "Enable", false, function(v)
            if self.modules.auto_treadmill then
                if v then pcall(self.modules.auto_treadmill.start, self.cfg.Defaults)
                else pcall(self.modules.auto_treadmill.stop) end
            end
        end)

        local secSpeed = makeSection(pFarm, "Speed Boost")
        addToggle(secSpeed, "Enable", false, function(v)
            if self.modules.speed_boost then
                if v then pcall(self.modules.speed_boost.start, self.cfg.Defaults)
                else pcall(self.modules.speed_boost.stop) end
            end
        end)
    end

    -- ═══════════════════════════════════
    -- TAB 3: FRIENDS
    -- ═══════════════════════════════════
    local pFriends = self.win:getPage("Friends")
    if pFriends then
        local sec = makeSection(pFriends, "Drop for Friends")
        addToggle(sec, "Enable", false, function(v)
            if self.modules.friends_drop then
                if v then pcall(self.modules.friends_drop.start, self.cfg.Defaults)
                else pcall(self.modules.friends_drop.stop) end
            end
        end)
        addToggle(sec, "Auto Pickup Back", true)
        addButton(sec, "Refresh Friend List", function()
            if self.ctx.util and self.ctx.util.notify then
                self.ctx.util.notify("Refresh friend list (stub)", 2)
            end
        end)
    end

    -- ═══════════════════════════════════
    -- TAB 4: INFO
    -- ═══════════════════════════════════
    local pInfo = self.win:getPage("Info")
    if pInfo then
        local sec = makeSection(pInfo, "Live Info")
        local clock = Instance.new("TextLabel", sec)
        clock.Size = UDim2.new(1, 0, 0, 20)
        clock.BackgroundTransparency = 1
        clock.Text = "Jam sekarang: --:--"
        clock.TextColor3 = T.PurpleGlow or Color3.fromRGB(168,85,247)
        clock.Font = Enum.Font.GothamBold
        clock.TextSize = 12
        clock.TextXAlignment = Enum.TextXAlignment.Left
        clock.Parent = sec

        task.spawn(function()
            while clock.Parent do
                if self.ctx.util and self.ctx.util.getClock then
                    clock.Text = "Jam sekarang: " .. self.ctx.util.getClock()
                end
                task.wait(1)
            end
        end)

        local listFrame = Instance.new("Frame", sec)
        listFrame.Size = UDim2.new(1, 0, 0, 200)
        listFrame.BackgroundColor3 = T.Background or Color3.fromRGB(12,12,18)
        listFrame.BorderSizePixel = 0
        Instance.new("UICorner", listFrame).CornerRadius = UDim.new(0, 6)

        local ls = Instance.new("UIListLayout", listFrame)
        ls.Padding = UDim.new(0, 2)
        local lp = Instance.new("UIPadding", listFrame)
        lp.PaddingTop = UDim.new(0, 6)
        lp.PaddingLeft = UDim.new(0, 8)

        for i = 1, 10 do
            local slot = Instance.new("TextLabel", listFrame)
            slot.Size = UDim2.new(1, -10, 0, 14)
            slot.BackgroundTransparency = 1
            slot.Text = string.format("%02d. --", i)
            slot.TextColor3 = T.SubText or Color3.fromRGB(150,150,175)
            slot.Font = Enum.Font.Code
            slot.TextSize = 11
            slot.TextXAlignment = Enum.TextXAlignment.Left
            slot.Name = "Slot"..i
        end
    end

    -- ═══════════════════════════════════
    -- TAB 5: SETTINGS
    -- ═══════════════════════════════════
    local pSettings = self.win:getPage("Settings")
    if pSettings then
        local secPerf = makeSection(pSettings, "Performance")
        addToggle(secPerf, "Anti Lag", false, function(v)
            if self.modules.anti_lag then
                if v then pcall(self.modules.anti_lag.start, self.cfg.Defaults)
                else pcall(self.modules.anti_lag.stop) end
            end
        end)
        addPicker(secPerf, "FPS Cap", {"30","45","60","Unlimited"}, "60")
        addToggle(secPerf, "Disable Particles", true)
        addToggle(secPerf, "Disable Shadows", true)

        local secGuard = makeSection(pSettings, "Server Guard")
        addToggle(secGuard, "Enable", false, function(v)
            if self.modules.server_guard then
                if v then pcall(self.modules.server_guard.start, self.cfg.Defaults)
                else pcall(self.modules.server_guard.stop) end
            end
        end)
        addPicker(secGuard, "Action", self.cfg.ServerGuard and self.cfg.ServerGuard.ActionList or {"Auto-Leave","Auto-Hop","Notify Only"}, "Notify Only")
        addButton(secGuard, "Refresh Whitelist", function() end)

        local secDebug = makeSection(pSettings, "Debug")
        addToggle(secDebug, "Safe Mode", true)
        addButton(secDebug, "Reload Script", function()
            if self.ctx.loader then
                pcall(self.ctx.loader)
            end
        end)
        addButton(secDebug, "Unload", function()
            if self.win and self.win.gui then
                self.win.gui:Destroy()
            end
        end)
    end

    return self
end

return C
