--[[ APOTHEOSIS SECRET MONITOR - FINAL VERSION ]]

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

-- ===== AMBIL WEBHOOK DARI EXECUTOR =====
local WEBHOOK_URL = getgenv().APOTHEOSIS_WEBHOOK
if not WEBHOOK_URL then
    warn("❌ Apotheosis webhook belum diset!")
    return
end

-- ===== LIST IKAN SECRET =====
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

-- ===== SERVICES =====
local TextChatService = game:GetService("TextChatService")
local HttpService = game:GetService("HttpService")
local StarterGui = game:GetService("StarterGui")

local request =
    (syn and syn.request) or
    (http and http.request) or
    http_request or
    (fluxus and fluxus.request)

-- ===== UI INDICATOR =====
local gui = Instance.new("ScreenGui", game:GetService("CoreGui"))
gui.Name = "ApotheosisIndicator"

local label = Instance.new("TextLabel", gui)
label.Size = UDim2.new(0, 180, 0, 35)
label.Position = UDim2.new(0, 10, 0, 10)
label.BackgroundColor3 = Color3.fromRGB(0, 200, 200)
label.BackgroundTransparency = 0.2
label.Text = "Apotheosis ON ✅"
label.Font = Enum.Font.GothamBold
label.TextColor3 = Color3.new(1,1,1)
label.TextScaled = true

-- ===== WEBHOOK SEND =====
local function sendWebhook(text)
    request({
        Url = WEBHOOK_URL,
        Method = "POST",
        Headers = {["Content-Type"] = "application/json"},
        Body = HttpService:JSONEncode({
            content = text -- PURE COPAS TEKS
        })
    })
end

-- ===== TEST CONNECTION =====
sendWebhook("🧪 Apotheosis connected. Monitoring secret fishes.")
StarterGui:SetCore("SendNotification", {
    Title = "Apotheosis",
    Text = "Webhook connected ✅",
    Duration = 4
})

-- ===== CHAT LISTENER =====
TextChatService.MessageReceived:Connect(function(msg)
    -- Filter 1: HARUS SYSTEM MESSAGE
    if msg.TextSource ~= nil then return end

    local text = msg.Text
    local lower = text:lower()

    -- Filter 2: HARUS obtained
    if not lower:find("obtained") then return end

    -- Filter 3: HARUS ikan secret
    for _, fish in ipairs(secret_list) do
        if lower:find(fish:lower()) then
            sendWebhook(text)
            break
        end
    end
end)

StarterGui:SetCore("SendNotification", {
    Title = "Apotheosis",
    Text = "Monitoring Secret Fishes... ✅",
    Duration = 4
})

print("✅ Apotheosis Secret Monitor Loaded")
