--[[
    ========================================================================================
    🩸 ZEROLIB v2.3 TESTBENCH - PRO TACTICAL EDITION
    ========================================================================================
--]]

local fn = loadfile("arcane_hub_custom_ui/ZeroLib.lua") or loadfile("ZeroLib.lua")
local ZeroLib
if fn then
    ZeroLib = fn()
else
    local content = (readfile and (readfile("arcane_hub_custom_ui/ZeroLib.lua") or readfile("ZeroLib.lua")))
    ZeroLib = loadstring(content)()
end

-- 1. Create Main Window
local Window = ZeroLib:CreateWindow({
    Title = "ARCANE LINEAGE",
    SubTitle = "CRIMSON v2.3",
    Size = UDim2.new(0, 560, 0, 400),
    ToggleKey = Enum.KeyCode.RightControl
})

-- 2. Real-Time Dynamic Watermark (Live FPS & Ping)
ZeroLib:SetWatermark("Arcane Lineage")
ZeroLib:Notify({
    Title = "🩸 ZeroLib Pro v2.3",
    Content = "Đã khởi chạy thành công với Live FPS/Ping, Standard Pro ColorPicker và Material Icons!",
    Type = "Success",
    Duration = 4
})

-- 3. Add Tabs with Clean Vector Icons (No crude emojis)
local FarmTab = Window:AddTab({ Name = "Auto Farm", Icon = ZeroLib.Icons.Farm })
local CombatTab = Window:AddTab({ Name = "Combat & QTE", Icon = ZeroLib.Icons.Combat })
local MiscTab = Window:AddTab({ Name = "Misc & World", Icon = ZeroLib.Icons.World })
local SettingsTab = Window:AddTab({ Name = "Settings", Icon = ZeroLib.Icons.Settings })

-- =============================================================================
-- TAB 1: AUTO FARM
-- =============================================================================
local BossGroup = FarmTab:AddLeftGroupbox("Auto Boss: Yar'thul")
local farmYarthul = BossGroup:AddToggle("AutoFarmYarthul", {
    Text = "Enable Auto Farm Yar'thul",
    Default = false,
    Callback = function(val)
        ZeroLib:Notify({
            Title = "Auto Boss",
            Content = val and "Đã kích hoạt Auto Farm Yar'thul!" or "Đã tắt Auto Farm.",
            Type = val and "Success" or "Warning"
        })
    end
})
farmYarthul:AddKeybind("YarthulKey", { Default = Enum.KeyCode.H, Mode = "Toggle" })

BossGroup:AddToggle("AutoRetryYarthul", {
    Text = "Auto Re-Challenge & Re-Enter",
    Default = true,
    Callback = function(val) end
})

BossGroup:AddSlider("AttackDelay", {
    Text = "Attack / Skill Delay",
    Min = 0.1,
    Max = 3.0,
    Default = 0.8,
    Rounding = 1,
    Suffix = "s",
    Callback = function(val) end
})

BossGroup:AddInput("DiscordWebhook", {
    Text = "Discord Webhook URL",
    Placeholder = "https://discord.com/api/webhooks/...",
    Default = "",
    Callback = function(val) end
})

BossGroup:AddButton({
    Text = "Test Discord Webhook Now",
    Func = function()
        ZeroLib:Notify({
            Title = "Discord Webhook",
            Content = "Đang gửi tín hiệu kiểm tra webhook lên Discord...",
            Type = "Info"
        })
    end
})

local ParamGroup = FarmTab:AddRightGroupbox("Farming Parameters")
ParamGroup:AddDropdown("FarmingStrategy", {
    Text = "Target Farming Routine",
    Values = {"Yar'thul Dragon (Mount Thul)", "Desert Crylight Herb", "Bandit Camps", "Deepwood Goblins"},
    Default = "Yar'thul Dragon (Mount Thul)",
    Callback = function(val)
        ZeroLib:Notify({ Title = "Strategy", Content = "Đã chọn: " .. val, Type = "Info" })
    end
})

ParamGroup:AddDropdown("MultiDropFilter", {
    Text = "Multi-Drop Loot Filter",
    Values = {"Legendary Gear", "Artifacts", "Runes", "Shards", "Ores", "Scrolls"},
    Default = {"Legendary Gear", "Artifacts"},
    Multi = true,
    Callback = function(selected) end
})

ParamGroup:AddSlider("FlySpeed", {
    Text = "Flight / Tween Speed",
    Min = 50,
    Max = 350,
    Default = 160,
    Rounding = 0,
    Suffix = " studs/s",
    Callback = function(val) end
})

ParamGroup:AddDivider()
ParamGroup:AddLabel("Pro ColorPicker hỗ trợ SV Box, Hue Bar, Hex và RGB trực tiếp.")

-- =============================================================================
-- TAB 2: COMBAT & QTE
-- =============================================================================
local QTEGroup = CombatTab:AddLeftGroupbox("Auto Perfect QTE")
local masterQTE = QTEGroup:AddToggle("MasterQTE", {
    Text = "Master Auto QTE (100% Perfect)",
    Default = true,
    Callback = function(val) end
})
masterQTE:AddKeybind("QTEKey", { Default = Enum.KeyCode.V, Mode = "Toggle" })

local autoDodge = QTEGroup:AddToggle("AutoDodge", {
    Text = "Auto Perfect Dodge & Guard",
    Default = true,
    Callback = function(val) end
})
autoDodge:AddColorPicker("DodgeColor", { Default = Color3.fromRGB(239, 68, 68) })

QTEGroup:AddSlider("QTEDelay", {
    Text = "QTE Reaction Timing",
    Min = 0,
    Max = 200,
    Default = 15,
    Rounding = 0,
    Suffix = "ms",
    Callback = function(val) end
})

local CombatAssist = CombatTab:AddRightGroupbox("Combat Assistance")
CombatAssist:AddToggle("AutoActionOrder", {
    Text = "Auto Optimal Skill Rotation",
    Default = true,
    Callback = function(val) end
})

CombatAssist:AddSlider("EnergyThreshold", {
    Text = "Min Energy to Cast Skill",
    Min = 10,
    Max = 100,
    Default = 30,
    Rounding = 0,
    Suffix = "%",
    Callback = function(val) end
})

CombatAssist:AddColorPicker("AuraColor", {
    Text = "Custom Combat Aura Color",
    Default = Color3.fromRGB(244, 63, 94),
    Callback = function(col) end
})

-- =============================================================================
-- TAB 3: MISC & WORLD
-- =============================================================================
local PlayerMods = MiscTab:AddLeftGroupbox("Player Modifications")
PlayerMods:AddSlider("WalkSpeed", {
    Text = "Walk Speed",
    Min = 16,
    Max = 150,
    Default = 16,
    Rounding = 0,
    Suffix = " studs/s",
    Callback = function(val)
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = val
        end
    end
})

local noclipToggle = PlayerMods:AddToggle("Noclip", {
    Text = "Noclip (Walk Through Walls)",
    Default = false,
    Callback = function(val) end
})
noclipToggle:AddKeybind("NoclipKey", { Default = Enum.KeyCode.N, Mode = "Toggle" })

PlayerMods:AddToggle("InfiniteStamina", {
    Text = "Infinite Sprint Stamina",
    Default = true,
    Callback = function(val) end
})

local VisualsGroup = MiscTab:AddRightGroupbox("Visuals & World ESP")
local espToggle = VisualsGroup:AddToggle("ItemESP", {
    Text = "Ore & Herb World ESP",
    Default = true,
    Callback = function(val) end
})
espToggle:AddColorPicker("ESPColor", { Default = Color3.fromRGB(244, 63, 94) })

VisualsGroup:AddToggle("Fullbright", {
    Text = "Fullbright (No Darkness)",
    Default = true,
    Callback = function(val) end
})

-- =============================================================================
-- TAB 4: SETTINGS & THEMES & CONFIGS
-- =============================================================================
local ThemeGroup = SettingsTab:AddLeftGroupbox("Appearance & Themes")
ThemeGroup:AddDropdown("ThemeSelect", {
    Text = "Select UI Color Theme",
    Values = {"Crimson Bloodline", "Cyber-Tactical Cyan", "Midnight Violet", "Emerald Glass"},
    Default = "Crimson Bloodline",
    Callback = function(themeName)
        if themeName == "Crimson Bloodline" then ZeroLib:SetTheme("Crimson")
        elseif themeName == "Cyber-Tactical Cyan" then ZeroLib:SetTheme("CyberCyan")
        elseif themeName == "Midnight Violet" then ZeroLib:SetTheme("MidnightViolet")
        elseif themeName == "Emerald Glass" then ZeroLib:SetTheme("EmeraldGlass")
        end
        ZeroLib:Notify({
            Title = "Theme Changed",
            Content = "Đã áp dụng giao diện: " .. themeName,
            Type = "Success"
        })
    end
})

local ConfigGroup = SettingsTab:AddRightGroupbox("Config Manager")
ConfigGroup:AddInput("ConfigName", {
    Text = "Config Profile Name",
    Placeholder = "my_profile",
    Default = "default",
    Callback = function(val) end
})

ConfigGroup:AddButton({
    Text = "Save Current Configuration",
    Func = function()
        local name = ZeroLib.Options.ConfigName and ZeroLib.Options.ConfigName.Value or "default"
        ZeroLib.ConfigManager:Save(name)
    end
})

ConfigGroup:AddButton({
    Text = "Load Saved Configuration",
    Func = function()
        local name = ZeroLib.Options.ConfigName and ZeroLib.Options.ConfigName.Value or "default"
        ZeroLib.ConfigManager:Load(name)
    end
})

ConfigGroup:AddDivider()
ConfigGroup:AddButton({
    Text = "Unload / Destroy Hub GUI",
    Func = function()
        ZeroLib:Unload()
    end
})

print("[ZeroLib v2.3] Pro Edition rendered successfully!")
return Window
