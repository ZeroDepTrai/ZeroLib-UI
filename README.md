# ZeroLib - Ultra-Compact & Tactical Roblox UI Library (v2.8)

An ultra-compact, high-density, high-legibility Roblox UI library designed with esports cheat aesthetic (Linoria / Neverlose tier), full reactive theme engine, 100% native rainbow color pickers, fluid animations, and a 1:1 Linoria-style SaveManager.

---

## Features

- **Ultra-Compact & High-Density**: Optimized 560x400 window with 130px sidebar, 30x15 toggle switches, 6px slider bars, 22px inputs/dropdowns, and 24px buttons.
- **Ultra-Legible Typography**: Powered by `BuilderSans` & `Gotham` neo-grotesque font stack with upgraded, crisp font sizes.
- **100% Native UIGradient ColorPicker**: Full-spectrum 7-color rainbow hue bar and 2D saturation/brightness field with real-time RGB/Hex editing (zero external asset dependency).
- **Reactive Theme Engine**: Change themes in real-time with instant 0ms morphing across all toggles, sliders, dropdowns, inputs, buttons, borders, and notifications.
  - *Cyber-Tactical Cyan* (Deep Navy + Cyber Cyan) [Default]
  - *Crimson Bloodline* (OLED Black + Ruby Crimson)
  - *Midnight Violet* (Abyssal Dark + Neon Purple)
  - *Emerald Glass* (Obsidian + Mint Emerald)
- **Live Dynamic Watermark**: Real-time FPS and Server Ping (ms) monitor running on `RenderStepped`.
- **Full Clean Unload System**: Topbar 'X' executes full cleanup of connections, threads, and UI instances from memory.
- **100% Linoria-style SaveManager**: Built-in config manager with `BuildConfigSection`, `Create config`, `Load config`, `Overwrite config`, `Delete config`, `Refresh list`, `Set as autoload`, `Reset autoload`, `Current autoload config: [name]` label, and `LoadAutoloadConfig()` on boot!

---

## Quickstart

```lua
local ZeroLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/ZeroDepTrai/ZeroLib-UI/main/ZeroLib.lua"))()

-- 1. Create Main Window
local Window = ZeroLib:CreateWindow({
    Title = "ARCANE LINEAGE",
    SubTitle = "CYBER v2.8",
    Size = UDim2.new(0, 560, 0, 400),
    ToggleKey = Enum.KeyCode.RightControl
})

-- 2. Set Watermark
ZeroLib:SetWatermark("Arcane Lineage")

-- 3. Add Tab
local MainTab = Window:AddTab({ Name = "Main", Icon = ZeroLib.Icons.Combat })
local Group = MainTab:AddLeftGroupbox("Combat Options")

-- 4. Add Toggle with Keybind and ColorPicker
local myToggle = Group:AddToggle("AutoAttack", {
    Text = "Enable Auto Attack",
    Default = true,
    Callback = function(val)
        print("AutoAttack:", val)
    end
})
myToggle:AddKeybind("AttackKey", { Default = Enum.KeyCode.V, Mode = "Toggle" })
myToggle:AddColorPicker("AttackColor", { Default = Color3.fromRGB(6, 182, 212) })

-- 5. Add Slider
Group:AddSlider("SpeedSlider", {
    Text = "Walk Speed",
    Min = 16,
    Max = 150,
    Default = 16,
    Rounding = 0,
    Suffix = " studs/s",
    Callback = function(val)
        print("Speed:", val)
    end
})

-- 6. Add Dropdown (Single or Multi)
Group:AddDropdown("TargetFilter", {
    Text = "Target Types",
    Values = {"Players", "NPCs", "Bosses", "Items"},
    Default = {"Bosses", "Players"},
    Multi = true,
    Callback = function(selected)
        print("Selected:", table.concat(selected, ", "))
    end
})

-- 7. Add Settings Tab & 100% Linoria SaveManager
local SettingsTab = Window:AddTab({ Name = "Settings", Icon = ZeroLib.Icons.Settings })
local ConfigGroup = SettingsTab:AddLeftGroupbox("Configuration")

-- Build full Linoria config section with 1 line!
ZeroLib.SaveManager:BuildConfigSection(ConfigGroup)

-- Load autoload config on script boot
ZeroLib.SaveManager:LoadAutoloadConfig()
```

---

## License
MIT License.
