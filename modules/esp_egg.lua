-- modules/esp_egg.lua — ESP nama egg + rarity + hasil catch
local Players = game:GetService("Players")
local RunSvc  = game:GetService("RunService")
local lp = Players.LocalPlayer

local M = {}
M.state = false
M.conn = nil
M.labels = {}
M.eggMap = nil
M.cfg = nil

local function loadMap()
    local ok, res = pcall(function()
        return loadstring(game:HttpGet(
            "https://raw.githubusercontent.com/OzLL-BeeP/or4cle-steal-an-egg/main/config_eggmap.lua"
        ))()
    end)
    if ok and type(res) == "table" then
        M.eggMap = res
    end
end

-- cari egg yang lo bawa / yang ada di field
local function findEggs()
    local list = {}
    for _, v in ipairs(workspace:GetDescendants()) do
        if v:IsA("Model") and v.Name:lower():find("egg") then
            local hrp = v:FindFirstChild("HumanoidRootPart") or v.PrimaryPart
            if hrp then
                local data = M.eggMap and M.eggMap[v.Name]
                table.insert(list, {
                    model = v,
                    part = hrp,
                    name = v.Name,
                    pet = data and data.pet or "?",
                    rarity = data and data.rarity or "?",
                    income = data and data.income or 0,
                })
            end
        end
    end
    return list
end

local function getOrCreateLabel(model)
    if M.labels[model] and M.labels[model].Parent then
        return M.labels[model]
    end
    local part = model:FindFirstChild("HumanoidRootPart") or model.PrimaryPart
    if not part then return nil end

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "OR4CLE_EggESP"
    billboard.Size = UDim2.new(0, 200, 0, 44)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = part

    local frame = Instance.new("Frame", billboard)
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundColor3 = Color3.fromRGB(10,10,16)
    frame.BackgroundTransparency = 0.2
    frame.BorderSizePixel = 0
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)

    local stroke = Instance.new("UIStroke", frame)
    stroke.Color = Color3.fromRGB(140, 90, 250)
    stroke.Thickness = 1.5

    local nameLbl = Instance.new("TextLabel", frame)
    nameLbl.Size = UDim2.new(1, -6, 0, 16)
    nameLbl.Position = UDim2.new(0, 3, 0, 2)
    nameLbl.BackgroundTransparency = 1
    nameLbl.Text = "?"
    nameLbl.TextColor3 = Color3.fromRGB(245, 245, 252)
    nameLbl.Font = Enum.Font.GothamBold
    nameLbl.TextSize = 12
    nameLbl.TextXAlignment = Enum.TextXAlignment.Left

    local infoLbl = Instance.new("TextLabel", frame)
    infoLbl.Size = UDim2.new(1, -6, 0, 12)
    infoLbl.Position = UDim2.new(0, 3, 0, 20)
    infoLbl.BackgroundTransparency = 1
    infoLbl.Text = "?"
    infoLbl.TextColor3 = Color3.fromRGB(150, 150, 175)
    infoLbl.Font = Enum.Font.Gotham
    infoLbl.TextSize = 10
    infoLbl.TextXAlignment = Enum.TextXAlignment.Left

    local lbl = {billboard=billboard, nameLbl=nameLbl, infoLbl=infoLbl}
    M.labels[model] = lbl
    return lbl
end

local function updateLabels()
    local eggs = findEggs()
    local seen = {}
    for _, e in ipairs(eggs) do
        local lbl = getOrCreateLabel(e.model)
        if lbl then
            seen[e.model] = true
            lbl.nameLbl.Text = e.name
            lbl.infoLbl.Text = string.format("%s  |  %s", e.pet, e.rarity)
        end
    end
    -- cleanup label yang gak ada egg
    for model, lbl in pairs(M.labels) do
        if not seen[model] or not model.Parent then
            pcall(function() lbl.billboard:Destroy() end)
            M.labels[model] = nil
        end
    end
end

function M.start(cfg)
    if M.state then return end
    M.state = true
    M.cfg = cfg
    if not M.eggMap then loadMap() end
    M.conn = RunSvc.Heartbeat:Connect(function()
        pcall(updateLabels)
    end)
end

function M.stop()
    if not M.state then return end
    M.state = false
    if M.conn then M.conn:Disconnect(); M.conn = nil end
    for model, lbl in pairs(M.labels) do
        pcall(function() lbl.billboard:Destroy() end)
    end
    M.labels = {}
end

function M.setConfig(cfg) M.cfg = cfg end
return M
