-- ui/pages.lua — populate 5 tab
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
    local cText   = T.Text or Color3.fromRGB(245, 245, 252)
    local cSub    = T.SubText or Color3.fromRGB(145, 145, 170)

    -- ═════════════════════════════════════════
    -- HELPERS
    -- ═════════════════════════════════════════
    local function makeSection(page, title, subtitle)
        local wrap = Instance.new("Frame")
        wrap.Size = UDim2.new(1, 0, 0, 0)
        wrap.AutomaticSize = Enum.AutomaticSize.Y
        wrap.BackgroundTransparency = 1
        wrap.Parent = page

        local hdrRow = Instance.new("Frame", wrap)
        hdrRow.Size = UDim2.new(1, 0, 0, 30)
        hdrRow.BackgroundTransparency = 1
        hdrRow.Parent = wrap

        local bar = Instance.new("Frame", hdrRow)
        bar.Size = UDim2.new(0, 3, 0, 18)
        bar.Position = UDim2.new(0, 0, 0, 6)
        bar.BackgroundColor3 = cPurple
        bar.BorderSizePixel = 0
        Instance.new("UICorner", bar).CornerRadius = UDim.new(1, 0)

        local lbl = Instance.new("TextLabel", hdrRow)
        lbl.Size = UDim2.new(1, -10, 0, 18)
        lbl.Position = UDim2.new(0, 12, 0, 4)
        lbl.BackgroundTransparency = 1
        lbl.Text = title
        lbl.TextColor3 = cText
        lbl.Font = Enum.Font.GothamBold
        lbl.TextSize = 14
        lbl.TextXAlignment = Enum.TextXAlignment.Left

        if subtitle then
            local sub = Instance.new("TextLabel", hdrRow)
            sub.Size = UDim2.new(1, -10, 0, 12)
            sub.Position = UDim2.new(0, 12, 0, 20)
            sub.BackgroundTransparency = 1
            sub.Text = subtitle
            sub.TextColor3 = cSub
            sub.Font = Enum.Font.Gotham
            sub.TextSize = 10
            sub.TextXAlignment = Enum.TextXAlignment.Left
        end

        local body = Instance.new("Frame", wrap)
        body.Size = UDim2.new(1, 0, 0, 0)
        body.Position = UDim2.new(0, 0, 0, 32)
        body.AutomaticSize = Enum.AutomaticSize.Y
        body.BackgroundColor3 = T.Surface or Color3.fromRGB(20, 20, 28)
        body.BorderSizePixel = 0
        body.Parent = wrap
        Instance.new("UICorner", body).CornerRadius = UDim.new(0, 10)

        local bodyStroke = Instance.new("UIStroke", body)
        bodyStroke.Color = T.Border or Color3.fromRGB(50, 44, 80)
        bodyStroke.Thickness = 1
        bodyStroke.Transparency = 0.6

        local pad = Instance.new("UIPadding", body)
        pad.PaddingTop = UDim.new(0, 10)
        pad.PaddingBottom = UDim.new(0, 10)
        pad.PaddingLeft = UDim.new(0, 12)
        pad.PaddingRight = UDim.new(0, 12)

        local layout = Instance.new("UIListLayout", body)
        layout.Padding = UDim.new(0, 8)
        layout.SortOrder = Enum.SortOrder.LayoutOrder

        return body
    end

    local function addToggle(parent, title, default, onChange)
        local row = Instance.new("Frame", parent)
        row.Size = UDim2.new(1, 0, 0, 28)
        row.BackgroundTransparency = 1

        local lbl = Instance.new("TextLabel", row)
        lbl.Size = UDim2.new(1, -60, 1, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = title
        lbl.TextColor3 = cText
        lbl.Font = Enum.Font.Gotham
        lbl.TextSize = 13
        lbl.TextXAlignment = Enum.TextXAlignment.Left

        local state = default or false

        local btn = Instance.new("TextButton", row)
        btn.Size = UDim2.new(0, 40, 0, 20)
        btn.Position = UDim2.new(1, -44, 0.5, -10)
        btn.BackgroundColor3 = state and cPurple or Color3.fromRGB(60, 60, 80)
        btn.Text = ""
        btn.AutoButtonColor = false
        btn.BorderSizePixel = 0
        Instance.new("UICorner", btn).CornerRadius = UDim.new(1, 0)

        local dot = Instance.new("Frame", btn)
        dot.Size = UDim2.new(0, 14, 0, 14)
        dot.Position = state and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)
        dot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        dot.BorderSizePixel = 0
        Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)

        btn.MouseButton1Click:Connect(function()
            state = not state
            btn.BackgroundColor3 = state and cPurple or Color3.fromRGB(60, 60, 80)
            dot.Position = state and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)
            if onChange then pcall(onChange, state) end
        end)

        return {get = function() return state end}
    end

    local function addPicker(parent, title, options, default, onSelect)
        local row = Instance.new("Frame", parent)
        row.Size = UDim2.new(1, 0, 0, 28)
        row.BackgroundTransparency = 1

        local lbl = Instance.new("TextLabel", row)
        lbl.Size = UDim2.new(0.5, -4, 1, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = title
        lbl.TextColor3 = cText
        lbl.Font = Enum.Font.Gotham
        lbl.TextSize = 13
        lbl.TextXAlignment = Enum.TextXAlignment.Left

        local value = default or (options and options[1]) or ""

        local btn = Instance.new("TextButton", row)
        btn.Size = UDim2.new(0.5, -4, 1, 0)
        btn.Position = UDim2.new(0.5, 4, 0, 0)
        btn.BackgroundColor3 = T.SurfaceAlt or Color3.fromRGB(28, 28, 38)
        btn.Text = tostring(value)
        btn.TextColor3 = cText
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 12
        btn.BorderSizePixel = 0
        btn.AutoButtonColor = false
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)

        local popup = Instance.new("Frame", row)
        popup.Visible = false
        popup.Size = UDim2.new(0, 160, 0, 0)
        popup.AutomaticSize = Enum.AutomaticSize.Y
        popup.Position = UDim2.new(0.5, 4, 1, 4)
        popup.BackgroundColor3 = T.Surface or Color3.fromRGB(20, 20, 28)
        popup.BorderSizePixel = 0
        popup.ZIndex = 50
        Instance.new("UICorner", popup).CornerRadius = UDim.new(0, 8)

        local st = Instance.new("UIStroke", popup)
        st.Color = cPurple
        st.Thickness = 1

        local pl = Instance.new("UIListLayout", popup)
        pl.Padding = UDim.new(0, 2)
        local pp = Instance.new("UIPadding", popup)
        pp.PaddingTop = UDim.new(0, 4)
        pp.PaddingBottom = UDim.new(0, 4)

        btn.MouseButton1Click:Connect(function()
            popup.Visible = not popup.Visible
        end)

        for _, opt in ipairs(options or {}) do
            local o = Instance.new("TextButton", popup)
            o.Size = UDim2.new(1, 0, 0, 24)
            o.BackgroundColor3 = T.SurfaceAlt or Color3.fromRGB(28, 28, 38)
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

        return {get = function() return value end}
    end

    local function addButton(parent, title, onClick)
        local btn = Instance.new("TextButton", parent)
        btn.Size = UDim2.new(1, 0, 0, 28)
        btn.BackgroundColor3 = T.SurfaceAlt or Color3.fromRGB(28, 28, 38)
        btn.Text = title
        btn.TextColor3 = cText
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 12
        btn.BorderSizePixel = 0
        btn.AutoButtonColor = false
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
        btn.MouseButton1Click:Connect(function()
            if onClick then pcall(onClick) end
        end)
        return btn
    end

    local function addLabel(parent, text, color)
        local lbl = Instance.new("TextLabel", parent)
        lbl.Size = UDim2.new(1, 0, 0, 18)
        lbl.BackgroundTransparency = 1
        lbl.Text = text
        lbl.TextColor3 = color or cSub
        lbl.Font = Enum.Font.Code
        lbl.TextSize = 11
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        return lbl
    end

    -- ═════════════════════════════════════════
    -- TAB 1: VISUAL
    -- ═════════════════════════════════════════
    local pVisual = self.win:getPage("Visual")
    if pVisual then
        local secESP = makeSection(pVisual, "ESP — Egg", "Nampilin nama egg + pet + rarity di dunia")
        addToggle(secESP, "Enable ESP", false, function(v)
            if self.modules.esp_egg then
                if v then pcall(self.modules.esp_egg.start, self.cfg.Defaults)
                else pcall(self.modules.esp_egg.stop) end
            end
        end)
        addPicker(secESP, "Min Rarity", self.cfg.RarityOrder or {}, "Rare")
        addPicker(secESP, "Biome", {"All", unpack(self.cfg.Biomes or {})}, "All")
        addToggle(secESP, "Show Pet Name", true)
        addToggle(secESP, "Show Rarity", true)
        addToggle(secESP, "Show Tracer", false)

        local secInv = makeSection(pVisual, "Invisible / Evasive", "Ghost mode + evasive dari Guardian")
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
            {"Off", "Auto-Hide", "Auto-Teleport", "Notify Only"},
            "Notify Only")
        addToggle(secInv, "Guardian Radar", true)
    end

    -- ═════════════════════════════════════════
    -- TAB 2: FARM
    -- ═════════════════════════════════════════
    local pFarm = self.win:getPage("Farm")
    if pFarm then
        local secSteal = makeSection(pFarm, "Auto Steal", "Otomatis nyolong egg")
        addToggle(secSteal, "Enable", false, function(v)
            if self.modules.auto_steal then
                if v then pcall(self.modules.auto_steal.start, self.cfg.Defaults)
                else pcall(self.modules.auto_steal.stop) end
            end
        end)
        addPicker(secSteal, "Mode", {"Teleport", "Idle"}, "Teleport")
        addPicker(secSteal, "Priority", {"Rarest", "Biggest", "Nearest", "Fastest"}, "Rarest")
        addToggle(secSteal, "Ignore Guardian", false)

        local secHatch = makeSection(pFarm, "Auto Hatch", "Otomatis hatch egg di base")
        addToggle(secHatch, "Enable", false, function(v)
            if self.modules.auto_hatch then
                if v then pcall(self.modules.auto_hatch.start, self.cfg.Defaults)
                else pcall(self.modules.auto_hatch.stop) end
            end
        end)
        addPicker(secHatch, "Speed", {"Safe", "Normal", "Turbo"}, "Normal")

        local secPlace = makeSection(pFarm, "Auto Place", "Otomatis taruh pet di base")
        addToggle(secPlace, "Enable", false, function(v)
            if self.modules.auto_place then
                if v then pcall(self.modules.auto_place.start, self.cfg.Defaults)
                else pcall(self.modules.auto_place.stop) end
            end
        end)
        addPicker(secPlace, "Place Mode", {"Best First", "FIFO", "Rarity Only"}, "Best First")

        local secTread = makeSection(pFarm, "Auto Treadmill", "Otomatis upgrade speed")
        addToggle(secTread, "Enable", false, function(v)
            if self.modules.auto_treadmill then
                if v then pcall(self.modules.auto_treadmill.start, self.cfg.Defaults)
                else pcall(self.modules.auto_treadmill.stop) end
            end
        end)

        local secSpeed = makeSection(pFarm, "Speed Boost", "Gerak lebih cepat")
        addToggle(secSpeed, "Enable", false, function(v)
            if self.modules.speed_boost then
                if v then pcall(self.modules.speed_boost.start, self.cfg.Defaults)
                else pcall(self.modules.speed_boost.stop) end
            end
        end)
    end

    -- ═════════════════════════════════════════
    -- TAB 3: FRIENDS
    -- ═════════════════════════════════════════
    local pFriends = self.win:getPage("Friends")
    if pFriends then
        local sec = makeSection(pFriends, "Drop for Friends", "Bawa egg, drop di jalur teman sebelum base")
        addToggle(sec, "Enable", false, function(v)
            if self.modules.friends_drop then
                if v then pcall(self.modules.friends_drop.start, self.cfg.Defaults)
                else pcall(self.modules.friends_drop.stop) end
            end
        end)
        addToggle(sec, "Auto Pickup Back", true)
        addButton(sec, "Refresh Friend List", function()
            if self.ctx.util and self.ctx.util.notify then
                self.ctx.util.notify("Refreshing friend list...", 2)
            end
        end)

        local secWl = makeSection(pFriends, "Whitelist", "Pilih teman yang boleh masuk server")
        addButton(secWl, "Buka Whitelist Manager", function()
            if self.ctx.util and self.ctx.util.notify then
                self.ctx.util.notify("Whitelist manager (coming soon)", 2)
            end
        end)
    end

    -- ═════════════════════════════════════════
    -- TAB 4: INFO
    -- ═════════════════════════════════════════
    local pInfo = self.win:getPage("Info")
    if pInfo then
        local sec = makeSection(pInfo, "Live Info", "10 info egg terakhir + waktu muncul")
        local clock = addLabel(sec, "Jam sekarang: --:--", cPurple)
        task.spawn(function()
            while clock.Parent do
                if self.ctx.util and self.ctx.util.getClock then
                    clock.Text = "Jam sekarang: " .. self.ctx.util.getClock()
                end
                task.wait(1)
            end
        end)

        local listFrame = Instance.new("Frame", sec)
        listFrame.Size = UDim2.new(1, 0, 0, 240)
        listFrame.BackgroundColor3 = T.Background or Color3.fromRGB(11, 11, 17)
        listFrame.BorderSizePixel = 0
        Instance.new("UICorner", listFrame).CornerRadius = UDim.new(0, 8)

        local ls = Instance.new("UIListLayout", listFrame)
        ls.Padding = UDim.new(0, 3)
        local lp = Instance.new("UIPadding", listFrame)
        lp.PaddingTop = UDim.new(0, 8)
        lp.PaddingLeft = UDim.new(0, 10)

        for i = 1, 10 do
            local slot = Instance.new("TextLabel", listFrame)
            slot.Size = UDim2.new(1, -10, 0, 16)
            slot.BackgroundTransparency = 1
            slot.Text = string.format("%02d. --", i)
            slot.TextColor3 = cSub
            slot.Font = Enum.Font.Code
            slot.TextSize = 11
            slot.TextXAlignment = Enum.TextXAlignment.Left
            slot.Name = "Slot" .. i
        end

        local secActions = makeSection(pInfo, "Actions")
        addButton(secActions, "Clear Queue", function()
            if self.ctx.util and self.ctx.util.clearInfo then
                self.ctx.util.clearInfo()
            end
        end)
        addButton(secActions, "Refresh Info", function() end)
    end

    -- ═════════════════════════════════════════
    -- TAB 5: SETTINGS
    -- ═════════════════════════════════════════
    local pSettings = self.win:getPage("Settings")
    if pSettings then
        local secPerf = makeSection(pSettings, "Performance", "Anti lag + FPS")
        addToggle(secPerf, "Anti Lag", false, function(v)
            if self.modules.anti_lag then
                if v then pcall(self.modules.anti_lag.start, self.cfg.Defaults)
                else pcall(self.modules.anti_lag.stop) end
            end
        end)
        addPicker(secPerf, "FPS Cap", {"30", "45", "60", "Unlimited"}, "60")
        addToggle(secPerf, "Disable Particles", true)
        addToggle(secPerf, "Disable Shadows", true)
        addToggle(secPerf, "Disable Textures", false)

        local secGuard = makeSection(pSettings, "Server Guard", "Auto leave / hop / notify")
        addToggle(secGuard, "Enable", false, function(v)
            if self.modules.server_guard then
                if v then pcall(self.modules.server_guard.start, self.cfg.Defaults)
                else pcall(self.modules.server_guard.stop) end
            end
        end)
        addPicker(secGuard, "Action", {"Auto-Leave", "Auto-Hop", "Notify Only"}, "Notify Only")
        addPicker(secGuard, "Hop After", {"5 min", "15 min", "30 min", "60 min"}, "15 min")
        addButton(secGuard, "Whitelist Manager", function() end)

        local secDebug = makeSection(pSettings, "Debug", "Reload + unload")
        addToggle(secDebug, "Safe Mode", true)
        addToggle(secDebug, "Show Console Log", false)
        addButton(secDebug, "Reload Script", function()
            if _G.OR4CLE and _G.OR4CLE.loader then pcall(_G.OR4CLE.loader) end
        end)
        addButton(secDebug, "Unload All", function()
            local pgAll = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
            for _, x in ipairs(pgAll:GetChildren()) do
                if x:IsA("ScreenGui") and x.Name:find("OR4CLE") then
                    x:Destroy()
                end
            end
        end)
    end

    -- paksa semua page visible ke default
    task.defer(function()
        for name, page in pairs(self.win.tabPages or {}) do
            page.Visible = false
        end
        -- aktifkan tab pertama
        local firstTab = (self.cfg.UI and self.cfg.UI.TabList and self.cfg.UI.TabList[1]) or "Visual"
        if self.win.selectTab then
            self.win:selectTab(firstTab)
        end
        local firstPage = self.win.tabPages and self.win.tabPages[firstTab]
        if firstPage then
            firstPage.Visible = true
        end
    end)

    return self
end

return C
