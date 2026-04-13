local TeleportService = game:GetService("TeleportService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

--- SYSTEME DE WHITELIST ---
local WhitelistedUsers = {
    "sadowyoni_ytb", -- Ton pseudo unique
}

local function isWhitelisted(player)
    for _, name in pairs(WhitelistedUsers) do
        if player.Name == name then return true end
    end
    return false
end

-- Sécurité : Kick si le joueur n'est pas autorisé
if not isWhitelisted(LocalPlayer) then
    LocalPlayer:Kick("\n\nMoonHub\nyou are not whitelisted")
    return 
end

--- CONFIGURATION (SAUVEGARDE LOCALE) ---
local filename = "MoonLoader_Config.json"
local config = { bind = "V" }

local function saveConfig()
    pcall(function() writefile(filename, HttpService:JSONEncode(config)) end)
end

local function loadConfig()
    if isfile(filename) then
        local success, data = pcall(function() return HttpService:JSONDecode(readfile(filename)) end)
        if success and data and data.bind then config.bind = data.bind end
    end
end
loadConfig()

--- LOGIQUE DU SERVER HOP ---
local function doServerHop()
    local success, result = pcall(function()
        return HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"))
    end)
    
    if success and result and result.data then
        for _, v in pairs(result.data) do
            if v.playing < v.maxPlayers and v.id ~= game.JobId then
                TeleportService:TeleportToPlaceInstance(game.PlaceId, v.id, LocalPlayer)
                return
            end
        end
    end
end

--- INTERFACE GRAPHIQUE ---
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MoonLoader_V10"
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.Enabled = false -- Menu caché par défaut (appuie sur K)

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 260, 0, 170)
Main.Position = UDim2.new(0.5, -130, 0.5, -85)
Main.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
Main.BorderSizePixel = 0
Main.Parent = ScreenGui

Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)
local Stroke = Instance.new("UIStroke", Main)
Stroke.Thickness = 2
Stroke.Color = Color3.fromRGB(0, 120, 255)

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 45)
Title.BackgroundTransparency = 1
Title.Text = "MOON LOADER"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 17

local Info = Instance.new("TextLabel", Main)
Info.Size = UDim2.new(1, 0, 0, 20)
Info.Position = UDim2.new(0, 0, 0.85, 0)
Info.BackgroundTransparency = 1
Info.Text = "TOUCHE [K] POUR LE MENU"
Info.TextColor3 = Color3.fromRGB(80, 80, 80)
Info.Font = Enum.Font.Gotham
Info.TextSize = 9

local Container = Instance.new("Frame", Main)
Container.Size = UDim2.new(0.9, 0, 0.5, 0)
Container.Position = UDim2.new(0.05, 0, 0.32, 0)
Container.BackgroundTransparency = 1
local Layout = Instance.new("UIListLayout", Container)
Layout.Padding = UDim.new(0, 10)
Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local function createBtn(text, color)
    local btn = Instance.new("TextButton", Container)
    btn.Size = UDim2.new(1, 0, 0, 35)
    btn.BackgroundColor3 = color
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 12
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    return btn
end

local HopBtn = createBtn("CHANGE SERVER", Color3.fromRGB(25, 25, 35))
local BindBtn = createBtn("KEYBIND : " .. config.bind, Color3.fromRGB(0, 100, 200))

--- GESTION DES INPUTS ---
local listening = false

HopBtn.MouseButton1Click:Connect(doServerHop)

BindBtn.MouseButton1Click:Connect(function()
    listening = true
    BindBtn.Text = "..."
    BindBtn.BackgroundColor3 = Color3.fromRGB(200, 100, 0)
end)

UserInputService.InputBegan:Connect(function(input, gpe)
    -- Touche K pour ouvrir/fermer l'UI
    if input.KeyCode == Enum.KeyCode.K and not gpe then
        ScreenGui.Enabled = not ScreenGui.Enabled
    end

    -- Changement de la touche personnalisée
    if listening then
        if input.UserInputType == Enum.UserInputType.Keyboard then
            config.bind = input.KeyCode.Name
            saveConfig()
            BindBtn.Text = "KEYBIND : " .. config.bind
            BindBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
            listening = false
        end
    elseif not gpe then
        -- Action de Server Hop avec la touche choisie
        if input.KeyCode == Enum.KeyCode[config.bind] then
            doServerHop()
        end
    end
end)

-- Système de Drag (Déplacement de la fenêtre)
local dragging, dragStart, startPos
Main.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true dragStart = i.Position startPos = Main.Position end end)
UserInputService.InputChanged:Connect(function(i) if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then local delta = i.Position - dragStart Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y) end end)
UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
