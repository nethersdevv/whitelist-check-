-- [[ MOONHUB WHITELIST SYSTEM ]] --

local whitelist = {
    ["LaFrenchCrousty_9310"] = true,
    -- ["La French Crousty"] = true,
}

local player = game:GetService("Players").LocalPlayer

-- Vérification de l'utilisateur
if not whitelist[player.Name] then
    player:Kick("MoonHub You Are Not Whitelisted")
    return -- Sécurité pour stopper l'exécution du code suivant
end

-- [[ TON SCRIPT COMMENCE ICI ]] --
print("Bienvenue sur MoonHub, " .. player.Name .. "!")

-- Exemple de notification pour confirmer le chargement
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "MoonHub",
    Text = "Successfully Whitelisted!",
    Duration = 5
})
