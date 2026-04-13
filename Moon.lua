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
    Instance.
