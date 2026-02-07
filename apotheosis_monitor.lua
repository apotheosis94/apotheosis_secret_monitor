--[[ APOTHEOSIS SECRET MONITOR - OPTIMIZED CLEAN VERSION ]]

-- ===== ANTI DOUBLE EXECUTE =====
if _G.ApotheosisLoaded then
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Apotheosis",
        Text = "Script sudah berjalan!",
        Duration = 3
    })
    return
end
_G.ApotheosisLoaded = true

-- ===== WEBHOOK FROM EXECUTOR =====
local WEBHOOK_URL = getgenv().APOTHEOSIS_WEBHOOK
if not WEBHOOK_URL or WEBHOOK_URL == "" then
    warn("Webhook URL belum di-set!")
    return
end

-- ===== SECRET FISH LIST =====
local secret_list = {
    "Blob Shark","Ghost Shark","Skeleton Narwhal","Crystal Crab","Orca",
    "Ghost Worm Fish","Worm Fish","Megalodon","Lochness Monster","Monster Shark",
    "Eerie Shark","Great Whale","Frostborn Shark","Scare","Queen Crab",
    "King Crab","Cryoshade Glider","Panther Eel","Giant Squid","Depthseeker Ray",
    "Robot Kraken","Mosasaur Shark","King Jelly","Bone Whale","Elshark Gran Maja",
    "Ancient Whale","Gladiator Shark","Ancient Lochness Monster","Cursed Kraken",
    "Elpirate Gran Maja","Ancient Magma Whale","Pirate Megalodon","Thin Armor Shark",
    "Viridis Lurker"
}

-- ===== BUILD LOOKUP (OPTIMIZED) =====
local secret_lookup = {}
for _, fish in ipairs(secret_list) do
    secret_lookup[fish:lower()] = true
end

-- ===== SERVICES =====
local TextChatService = game:GetService("TextChatService")
local HttpService = game:GetService("HttpService")

local request =
    (syn and syn.request)
    or (http and http.request)
    or http_request
    or (fluxus and fluxus.request)

-- ===== UTIL =====
local function stripRichText(text)
    return text:gsub("<[^>]->", "")
end

local function getWIBTime()
    return os.date("%H:%M WIB")
end

local function sendWebhook(text)
    request({
        Url = WEBHOOK_URL,
        Method = "POST",
        Headers = {["Content-Type"] = "application/json"},
        Body = HttpService:JSONEncode({ content = text })
    })
end

-- ===== CHAT LISTENER =====
TextChatService.MessageReceived:Connect(function(msg)
    -- 1. Skip chat player (hemat CPU)
    if msg.TextSource ~= nil then return end

    -- 2. Strip rich text
    local clean = stripRichText(msg.Text)

    -- 3. Buang prefix [Server]:
    clean = clean:gsub("^%[Server%]:%s*", "")

    local lower = clean:lower()

    -- 4. Harus ada obtained
    if not lower:find("obtained") then return end

    -- 5. Cek ikan secret
    local matchedFish
    for fish in pairs(secret_lookup) do
        if lower:find(fish) then
            matchedFish = fish
            break
        end
    end
    if not matchedFish then return end

    -- 6. Parse data utama
    local player, fishName, weight =
        clean:match("(.+) obtained (.+) %((.+)kg%)")

    if not player or not fishName then return end

    local chance = clean:match("1 in ([%d%.KkMm]+) chance")

    -- 7. Kirim ke Discord (PLAIN TEXT)
    sendWebhook(
        "💎 SECRET DETECTED\n"
        .. player .. " obtained " .. fishName .. " (" .. (weight or "?") .. "kg)\n"
        .. (chance and ("Chance: 1 in " .. chance .. "\n") or "")
        .. "Time: " .. getWIBTime()
    )
end)

-- ===== UI INDICATOR (DELAYED) =====
task.delay(0.5, function()
    local gui = Instance.new("ScreenGui", game:GetService("CoreGui"))
    gui.Name = "ApotheosisIndicator"

    local label = Instance.new("TextLabel", gui)
    label.Size = UDim2.new(0, 200, 0, 36)
    label.Position = UDim2.new(0, 10, 0, 10)
    label.BackgroundColor3 = Color3.fromRGB(0, 200, 200)
    label.BackgroundTransparency = 0.2
    label.Text = "Apotheosis ON ✅"
    label.Font = Enum.Font.GothamBold
    label.TextColor3 = Color3.new(1,1,1)
    label.TextScaled = true
end)
