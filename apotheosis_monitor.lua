--[[ APOTHEOSIS SECRET MONITOR - FINAL STABLE ]]

-- ===== SAFETY CHECK =====
if _G.ApotheosisLoaded then
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Apotheosis",
        Text = "Script sudah berjalan!",
        Duration = 3
    })
    return
end
_G.ApotheosisLoaded = true

-- ===== GET WEBHOOK =====
local WEBHOOK_URL = getgenv().APOTHEOSIS_WEBHOOK
if not WEBHOOK_URL or WEBHOOK_URL == "" then
    warn("Webhook kosong!")
    return
end

-- ===== SERVICES =====
local TextChatService = game:GetService("TextChatService")
local HttpService = game:GetService("HttpService")
local StarterGui = game:GetService("StarterGui")
local request = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request)

-- ===== UI INDICATOR =====
local gui = Instance.new("ScreenGui")
gui.Name = "ApotheosisIndicator"
gui.Parent = game:GetService("CoreGui")

local label = Instance.new("TextLabel")
label.Parent = gui
label.Size = UDim2.new(0, 220, 0, 35)
label.Position = UDim2.new(0, 10, 0, 10)
label.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
label.BackgroundTransparency = 0.15
label.Text = "Apotheosis ACTIVE ✅"
label.Font = Enum.Font.GothamBold
label.TextColor3 = Color3.new(1,1,1)
label.TextScaled = true

-- ===== WEBHOOK FUNCTION =====
local function sendWebhook(text)
    request({
        Url = WEBHOOK_URL,
        Method = "POST",
        Headers = {["Content-Type"] = "application/json"},
        Body = HttpService:JSONEncode({
            content = text,
            username = "Apotheosis Monitor"
        })
    })
end

-- ===== TEST WEBHOOK (INI KUNCI) =====
sendWebhook("✅ **Apotheosis aktif & terhubung!**\nMonitoring Secret Fish dimulai.")

-- ===== LIST IKAN SECRET =====
local secret_list = {
    "Blob Shark","Ghost Shark","Skeleton Narwhal","Crystal Crab","Orca",
    "Ghost Worm Fish","Worm Fish","Megalodon","Lochness Monster","Monster Shark",
    "Eerie Shark","Great Whale","Frostborn Shark","Queen Crab","King Crab",
    "Giant Squid","Robot Kraken","Ancient Whale","Cursed Kraken"
}

-- ===== CHAT MONITOR =====
TextChatService.MessageReceived:Connect(function(msg)
    if msg.TextSource ~= nil then return end -- system only

    local text = msg.Text:lower()
    if not text:find("obtained") then return end

    for _, fish in pairs(secret_list) do
        if text:find(fish:lower()) then
            sendWebhook("💎 **SECRET DETECTED!**\n" .. msg.Text)
            break
        end
    end
end)

StarterGui:SetCore("SendNotification", {
    Title = "Apotheosis",
    Text = "Secret monitor AKTIF ✅",
    Duration = 4
})

