--[[
    ========================================================================================
    🩸 ZEROLIB v2.7 - COMPREHENSIVE PRODUCTION ENGINE
    ========================================================================================
    • Full Linoria Multi-Select Dictionary Support: Options[id].Value[item] == true
    • 1-Based Number Index Default Resolution: Default = 1 resolves to Values[1]
    • Multi-Callback Dispatcher: Supports both initial Callback and multiple OnChanged listeners
    • Anti-AFK Conflict Fix: Default Menu Key is Enum.KeyCode.End (no more random minimize)
    • Live Config Manager with Dynamic Dropdown & Refresh
    • 100% Native Gradient ColorPicker (Hue + Sat/Val + RGB + Hex)
    • Dynamic Real-Time Watermark (FPS + Ping ms)
    • Full Unload & Resource Cleanup
    ========================================================================================
--]]

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local TextService = game:GetService("TextService")
local HttpService = game:GetService("HttpService")
local StatsService = game:GetService("Stats")

local LocalPlayer = Players.LocalPlayer or Players.PlayerAdded:Wait()

-- =============================================================================
-- TYPOGRAPHY ENGINE (BUILDERSANS & GOTHAM HYBRID)
-- =============================================================================
local DevFont = {
    Title = Enum.Font.BuilderSansBold or Enum.Font.GothamBold,
    Bold = Enum.Font.BuilderSansBold or Enum.Font.GothamBold,
    Medium = Enum.Font.BuilderSansMedium or Enum.Font.GothamMedium,
    Regular = Enum.Font.BuilderSans or Enum.Font.Gotham,
}

local function applyFont(label, weight)
    if weight == "Bold" or weight == true then
        label.Font = DevFont.Bold
    elseif weight == "Medium" then
        label.Font = DevFont.Medium
    else
        label.Font = DevFont.Regular
    end
end

local ZeroLib = {
    Themes = {
        Crimson = {
            Name = "Crimson Bloodline",
            MainBg = Color3.fromRGB(8, 8, 10),
            SidebarBg = Color3.fromRGB(11, 11, 14),
            CardBg = Color3.fromRGB(14, 14, 18),
            CardInner = Color3.fromRGB(20, 20, 26),
            CardStroke = Color3.fromRGB(32, 32, 40),
            Accent = Color3.fromRGB(239, 68, 68),
            AccentGlow = Color3.fromRGB(185, 28, 28),
            AccentSecondary = Color3.fromRGB(244, 63, 94),
            TextMain = Color3.fromRGB(250, 250, 250),
            TextMuted = Color3.fromRGB(155, 155, 165),
            TextDark = Color3.fromRGB(90, 90, 100),
            Success = Color3.fromRGB(34, 197, 94),
            Warning = Color3.fromRGB(245, 158, 11),
            Danger = Color3.fromRGB(239, 68, 68),
        },
        CyberCyan = {
            Name = "Cyber-Tactical Cyan",
            MainBg = Color3.fromRGB(10, 12, 16),
            SidebarBg = Color3.fromRGB(13, 16, 22),
            CardBg = Color3.fromRGB(16, 20, 26),
            CardInner = Color3.fromRGB(22, 28, 38),
            CardStroke = Color3.fromRGB(32, 42, 56),
            Accent = Color3.fromRGB(6, 182, 212),
            AccentGlow = Color3.fromRGB(8, 145, 178),
            AccentSecondary = Color3.fromRGB(14, 165, 233),
            TextMain = Color3.fromRGB(248, 250, 252),
            TextMuted = Color3.fromRGB(145, 160, 180),
            TextDark = Color3.fromRGB(85, 100, 120),
            Success = Color3.fromRGB(34, 197, 94),
            Warning = Color3.fromRGB(245, 158, 11),
            Danger = Color3.fromRGB(239, 68, 68),
        },
        MidnightViolet = {
            Name = "Midnight Violet",
            MainBg = Color3.fromRGB(9, 8, 13),
            SidebarBg = Color3.fromRGB(12, 10, 18),
            CardBg = Color3.fromRGB(16, 14, 24),
            CardInner = Color3.fromRGB(24, 20, 34),
            CardStroke = Color3.fromRGB(38, 32, 54),
            Accent = Color3.fromRGB(168, 85, 247),
            AccentGlow = Color3.fromRGB(126, 34, 206),
            AccentSecondary = Color3.fromRGB(192, 132, 252),
            TextMain = Color3.fromRGB(250, 245, 255),
            TextMuted = Color3.fromRGB(160, 155, 175),
            TextDark = Color3.fromRGB(100, 95, 115),
            Success = Color3.fromRGB(34, 197, 94),
            Warning = Color3.fromRGB(245, 158, 11),
            Danger = Color3.fromRGB(239, 68, 68),
        },
        EmeraldGlass = {
            Name = "Emerald Glass",
            MainBg = Color3.fromRGB(8, 11, 9),
            SidebarBg = Color3.fromRGB(10, 15, 12),
            CardBg = Color3.fromRGB(14, 20, 16),
            CardInner = Color3.fromRGB(18, 28, 22),
            CardStroke = Color3.fromRGB(28, 42, 34),
            Accent = Color3.fromRGB(16, 185, 129),
            AccentGlow = Color3.fromRGB(5, 150, 105),
            AccentSecondary = Color3.fromRGB(52, 211, 153),
            TextMain = Color3.fromRGB(245, 255, 250),
            TextMuted = Color3.fromRGB(140, 160, 150),
            TextDark = Color3.fromRGB(85, 105, 95),
            Success = Color3.fromRGB(34, 197, 94),
            Warning = Color3.fromRGB(245, 158, 11),
            Danger = Color3.fromRGB(239, 68, 68),
        }
    },
    ActiveTheme = "CyberCyan",
    Toggles = {},
    Options = {},
    Flags = {},
    Windows = {},
    ActiveNotifications = {},
    Notifications = nil,
    Watermark = nil,
    PopoverLayer = nil,
    ActivePopover = nil,
    IsVisible = true,
    ToggleKey = Enum.KeyCode.End,
    ThemeObjects = {},
    Connections = {},
    Font = DevFont
}

local globalEnv = (getgenv and getgenv()) or _G
globalEnv.Toggles = ZeroLib.Toggles
globalEnv.Options = ZeroLib.Options
globalEnv.ZeroLib = ZeroLib
pcall(function() shared.ZeroLib = ZeroLib end)
pcall(function() shared.Toggles = ZeroLib.Toggles end)
pcall(function() shared.Options = ZeroLib.Options end)
pcall(function() _G.ZeroLib = ZeroLib end)
pcall(function() _G.Toggles = ZeroLib.Toggles end)
pcall(function() _G.Options = ZeroLib.Options end)

local Icons = {
    Combat = "rbxassetid://10734975692",   -- Material Symbols: Swords
    Farm = "rbxassetid://10709769841",     -- Material Symbols: Sprout / Leaf
    World = "rbxassetid://10723415903",    -- Material Symbols: Globe
    Teleport = "rbxassetid://10723415903", -- Material Symbols: Globe / Portal
    Settings = "rbxassetid://10734950309", -- Material Symbols: Sliders
    Player = "rbxassetid://10747373176",   -- Material Symbols: Zap / Speed
    Movement = "rbxassetid://10747373176", -- Material Symbols: Zap / Speed
    Visuals = "rbxassetid://10723415205",  -- Material Symbols: Eye
    Terminal = "rbxassetid://10734950020", -- Material Symbols: Terminal
    Dot = "rbxassetid://10709773823"
}
ZeroLib.Icons = Icons

local function tween(object, info, properties)
    local tw = TweenService:Create(object, info, properties)
    tw:Play()
    return tw
end

local function fastTween(object, properties, duration)
    return tween(object, TweenInfo.new(duration or 0.14, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), properties)
end

local function round(val, decimalPlaces)
    local shift = 10 ^ (decimalPlaces or 0)
    return math.floor(val * shift + 0.5) / shift
end

local function makeDraggable(topbar, mainFrame)
    local dragging = false
    local dragInput, dragStart, startPos

    local c1 = topbar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    local c2 = topbar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    local c3 = UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)

    table.insert(ZeroLib.Connections, c1)
    table.insert(ZeroLib.Connections, c2)
    table.insert(ZeroLib.Connections, c3)
end

function ZeroLib:SetToggleKey(key)
    if typeof(key) == "EnumItem" then
        self.ToggleKey = key
    elseif type(key) == "string" then
        self.ToggleKey = Enum.KeyCode[key] or self.ToggleKey
    end
end

-- =============================================================================
-- UNLOAD SYSTEM
-- =============================================================================
function ZeroLib:Unload()
    print("[ZeroLib] 🧹 Đang dọn dẹp và Unload toàn bộ GUI...")

    for _, conn in ipairs(self.Connections) do
        if typeof(conn) == "RBXScriptConnection" and conn.Connected then
            conn:Disconnect()
        elseif type(conn) == "table" and conn.Disconnect then
            pcall(conn.Disconnect)
        end
    end
    table.clear(self.Connections)

    for _, win in ipairs(self.Windows) do
        if win.Gui and win.Gui.Parent then
            win.Gui:Destroy()
        end
    end
    table.clear(self.Windows)

    if self.Watermark and self.Watermark.Gui and self.Watermark.Gui.Parent then
        self.Watermark.Gui:Destroy()
    end
    self.Watermark = nil

    if self.Notifications and self.Notifications.Gui and self.Notifications.Gui.Parent then
        self.Notifications.Gui:Destroy()
    end
    self.Notifications = nil

    getgenv().ZeroLib = nil
    print("[ZeroLib] ✨ Đã Unload hoàn tất!")
end

-- =============================================================================
-- THEME ENGINE
-- =============================================================================
function ZeroLib:RegisterThemeObject(inst, prop, themeKey)
    table.insert(self.ThemeObjects, { Instance = inst, Property = prop, Key = themeKey })
    local theme = self.Themes[self.ActiveTheme]
    if theme and theme[themeKey] and inst and inst.Parent then
        inst[prop] = theme[themeKey]
    end
end

function ZeroLib:SetTheme(themeName)
    if not self.Themes[themeName] then return end
    self.ActiveTheme = themeName
    local theme = self.Themes[themeName]

    for _, item in ipairs(self.ThemeObjects) do
        if item.Instance and item.Instance.Parent and theme[item.Key] then
            pcall(function()
                item.Instance[item.Property] = theme[item.Key]
            end)
        end
    end

    for _, tog in pairs(self.Toggles) do
        if tog.UpdateVisuals then tog:UpdateVisuals() end
    end

    for _, opt in pairs(self.Options) do
        if opt.UpdateVisuals then opt:UpdateVisuals() end
    end

    for _, win in ipairs(self.Windows) do
        for _, tab in ipairs(win.Tabs) do
            if tab == win.ActiveTab then
                tab.Button.BackgroundColor3 = theme.CardBg
                tab.Label.TextColor3 = theme.TextMain
                tab.Icon.ImageColor3 = theme.Accent
                tab.Button.Indicator.BackgroundColor3 = theme.Accent
                tab.Button.Indicator.BackgroundTransparency = 0
            else
                tab.Button.BackgroundTransparency = 1
                tab.Label.TextColor3 = theme.TextMuted
                tab.Icon.ImageColor3 = theme.TextMuted
                tab.Button.Indicator.BackgroundTransparency = 1
            end
        end
    end

    for _, notif in ipairs(self.ActiveNotifications) do
        if notif.Card and notif.Card.Parent then
            notif.Card.BackgroundColor3 = theme.CardBg
            if notif.AccentBar then notif.AccentBar.BackgroundColor3 = theme.Accent end
            if notif.ProgressBar then notif.ProgressBar.BackgroundColor3 = theme.Accent end
            if notif.TitleLabel then notif.TitleLabel.TextColor3 = theme.TextMain end
            if notif.ContentLabel then notif.ContentLabel.TextColor3 = theme.TextMuted end
            if notif.Stroke then notif.Stroke.Color = theme.CardStroke end
        end
    end

    if self.Watermark and self.Watermark.Frame and self.Watermark.Frame.Parent then
        self.Watermark.Frame.BackgroundColor3 = theme.MainBg
        if self.Watermark.Line then self.Watermark.Line.BackgroundColor3 = theme.Accent end
        if self.Watermark.Label then self.Watermark.Label.TextColor3 = theme.TextMain end
    end
end

-- =============================================================================
-- NOTIFICATIONS
-- =============================================================================
function ZeroLib:InitNotifications()
    if self.Notifications then return self.Notifications end

    local parentGui = (function()
        local pgui = LocalPlayer and (LocalPlayer:FindFirstChild("PlayerGui") or LocalPlayer:WaitForChild("PlayerGui", 3))
        if pgui then return pgui end
        local hui = gethui and gethui()
        if hui and not hui:IsA("ScreenGui") and not hui:IsA("GuiObject") then return hui end
        return CoreGui or pgui
    end)()

    local notifGui = Instance.new("ScreenGui")
    notifGui.Name = "ZeroLib_Notifications"
    notifGui.ResetOnSpawn = false
    notifGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    notifGui.Parent = parentGui

    local notifContainer = Instance.new("Frame")
    notifContainer.Name = "Container"
    notifContainer.Size = UDim2.new(0, 270, 1, -30)
    notifContainer.Position = UDim2.new(1, -285, 0, 15)
    notifContainer.BackgroundTransparency = 1
    notifContainer.Parent = notifGui

    local layout = Instance.new("UIListLayout")
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    layout.VerticalAlignment = Enum.VerticalAlignment.Bottom
    layout.Padding = UDim.new(0, 6)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = notifContainer

    self.Notifications = { Gui = notifGui, Container = notifContainer }
    return self.Notifications
end

function ZeroLib:Notify(data)
    local notifs = self:InitNotifications()
    local theme = self.Themes[self.ActiveTheme]

    local title = type(data) == "table" and data.Title or "Notification"
    local content = type(data) == "table" and (data.Content or data.Text or "") or tostring(data)
    local duration = type(data) == "table" and data.Duration or 3.5
    local notifType = type(data) == "table" and data.Type or "Info"

    local typeColor = theme.Accent
    if type(data) == "table" and data.Color then
        typeColor = data.Color
    elseif notifType == "Warning" then
        typeColor = theme.Warning
    elseif notifType == "Error" or notifType == "Danger" then
        typeColor = theme.Danger
    else
        typeColor = theme.Accent
    end

    local card = Instance.new("Frame")
    card.Name = "NotifCard"
    card.Size = UDim2.new(1, 0, 0, 0)
    card.BackgroundColor3 = theme.CardBg
    card.BorderSizePixel = 0
    card.ClipsDescendants = true
    card.Parent = notifs.Container

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 5)
    corner.Parent = card

    local stroke = Instance.new("UIStroke")
    stroke.Color = theme.CardStroke
    stroke.Thickness = 1
    stroke.Parent = card

    local accentBar = Instance.new("Frame")
    accentBar.Size = UDim2.new(0, 3, 1, 0)
    accentBar.BackgroundColor3 = typeColor
    accentBar.BorderSizePixel = 0
    accentBar.Parent = card

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -20, 0, 18)
    titleLabel.Position = UDim2.new(0, 10, 0, 6)
    titleLabel.BackgroundTransparency = 1
    applyFont(titleLabel, "Bold")
    titleLabel.Text = title
    titleLabel.TextColor3 = theme.TextMain
    titleLabel.TextSize = 11
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = card

    local contentLabel = Instance.new("TextLabel")
    contentLabel.Size = UDim2.new(1, -20, 0, 0)
    contentLabel.Position = UDim2.new(0, 10, 0, 24)
    contentLabel.BackgroundTransparency = 1
    applyFont(contentLabel, "Regular")
    contentLabel.Text = content
    contentLabel.TextColor3 = theme.TextMuted
    contentLabel.TextSize = 10
    contentLabel.TextWrapped = true
    contentLabel.TextXAlignment = Enum.TextXAlignment.Left
    contentLabel.TextYAlignment = Enum.TextYAlignment.Top
    contentLabel.Parent = card

    local progressTrack = Instance.new("Frame")
    progressTrack.Size = UDim2.new(1, 0, 0, 2)
    progressTrack.Position = UDim2.new(0, 0, 1, -2)
    progressTrack.BackgroundColor3 = theme.CardInner
    progressTrack.BorderSizePixel = 0
    progressTrack.Parent = card

    local progressBar = Instance.new("Frame")
    progressBar.Size = UDim2.new(1, 0, 1, 0)
    progressBar.BackgroundColor3 = typeColor
    progressBar.BorderSizePixel = 0
    progressBar.Parent = progressTrack

    local notifObj = {
        Card = card,
        AccentBar = accentBar,
        ProgressBar = progressBar,
        TitleLabel = titleLabel,
        ContentLabel = contentLabel,
        Stroke = stroke
    }
    table.insert(self.ActiveNotifications, notifObj)

    local textHeight = TextService:GetTextSize(content, 10, DevFont.Regular, Vector2.new(250, 1000)).Y
    local finalHeight = math.max(50, 32 + textHeight)

    fastTween(card, { Size = UDim2.new(1, 0, 0, finalHeight) }, 0.2)
    tween(progressBar, TweenInfo.new(duration, Enum.EasingStyle.Linear), { Size = UDim2.new(0, 0, 1, 0) })

    task.delay(duration, function()
        if card and card.Parent then
            local tw = fastTween(card, { Size = UDim2.new(1, 0, 0, 0), BackgroundTransparency = 1 }, 0.16)
            tw.Completed:Connect(function()
                card:Destroy()
                local idx = table.find(ZeroLib.ActiveNotifications, notifObj)
                if idx then table.remove(ZeroLib.ActiveNotifications, idx) end
            end)
        end
    end)
end

-- =============================================================================
-- REAL-TIME WATERMARK
-- =============================================================================
function ZeroLib:SetWatermark(gameTitle)
    local theme = self.Themes[self.ActiveTheme]
    local parentGui = (function()
        local pgui = LocalPlayer and (LocalPlayer:FindFirstChild("PlayerGui") or LocalPlayer:WaitForChild("PlayerGui", 3))
        if pgui then return pgui end
        local hui = gethui and gethui()
        if hui and not hui:IsA("ScreenGui") and not hui:IsA("GuiObject") then return hui end
        return CoreGui or pgui
    end)()

    gameTitle = gameTitle or "Arcane Lineage"

    if not self.Watermark then
        local wmGui = Instance.new("ScreenGui")
        wmGui.Name = "ZeroLib_Watermark"
        wmGui.ResetOnSpawn = false
        wmGui.Parent = parentGui

        local wmFrame = Instance.new("Frame")
        wmFrame.Name = "WatermarkFrame"
        wmFrame.Size = UDim2.new(0, 0, 0, 24)
        wmFrame.Position = UDim2.new(0, 16, 0, 16)
        wmFrame.BackgroundColor3 = theme.MainBg
        wmFrame.BorderSizePixel = 0
        wmFrame.Parent = wmGui

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 4)
        corner.Parent = wmFrame

        local stroke = Instance.new("UIStroke")
        stroke.Color = theme.CardStroke
        stroke.Thickness = 1
        stroke.Parent = wmFrame

        local accentLine = Instance.new("Frame")
        accentLine.Size = UDim2.new(0, 2, 1, -8)
        accentLine.Position = UDim2.new(0, 4, 0, 4)
        accentLine.BackgroundColor3 = theme.Accent
        accentLine.BorderSizePixel = 0
        accentLine.Parent = wmFrame

        local label = Instance.new("TextLabel")
        label.Name = "TextLabel"
        label.Size = UDim2.new(1, -16, 1, 0)
        label.Position = UDim2.new(0, 10, 0, 0)
        label.BackgroundTransparency = 1
        applyFont(label, "Bold")
        label.TextColor3 = theme.TextMain
        label.TextSize = 10
        label.Parent = wmFrame

        self.Watermark = { Gui = wmGui, Frame = wmFrame, Label = label, Line = accentLine, Title = gameTitle }
        self:RegisterThemeObject(wmFrame, "BackgroundColor3", "MainBg")
        self:RegisterThemeObject(stroke, "Color", "CardStroke")
        self:RegisterThemeObject(accentLine, "BackgroundColor3", "Accent")

        local frameCount = 0
        local lastUpdate = os.clock()
        local currentFps = 60

        local renderConn = RunService.RenderStepped:Connect(function()
            frameCount = frameCount + 1
            local now = os.clock()
            if now - lastUpdate >= 0.4 then
                currentFps = math.floor(frameCount / (now - lastUpdate))
                frameCount = 0
                lastUpdate = now

                local ping = 0
                pcall(function()
                    if StatsService and StatsService.Network and StatsService.Network.ServerStatsItem and StatsService.Network.ServerStatsItem["Data Ping"] then
                        ping = math.floor(StatsService.Network.ServerStatsItem["Data Ping"]:GetValue())
                    end
                end)

                if self.Watermark and self.Watermark.Label and self.Watermark.Label.Parent then
                    local display = string.format("%s  |  %d FPS  |  %d ms", self.Watermark.Title, currentFps, ping)
                    self.Watermark.Label.Text = display
                    local txtWidth = TextService:GetTextSize(display, 10, DevFont.Bold, Vector2.new(1000, 24)).X
                    self.Watermark.Frame.Size = UDim2.new(0, txtWidth + 22, 0, 24)
                end
            end
        end)
        table.insert(self.Connections, renderConn)
    else
        self.Watermark.Title = gameTitle
    end
end

-- =============================================================================
-- WINDOW BUILDER (COMPACT & SLEEK 560x400)
-- =============================================================================
function ZeroLib:CreateWindow(config)
    local theme = self.Themes[self.ActiveTheme]
    local parentGui = (function()
        local pgui = LocalPlayer and (LocalPlayer:FindFirstChild("PlayerGui") or LocalPlayer:WaitForChild("PlayerGui", 3))
        if pgui then return pgui end
        local hui = gethui and gethui()
        if hui and not hui:IsA("ScreenGui") and not hui:IsA("GuiObject") then return hui end
        return CoreGui or pgui
    end)()

    local titleText = config.Title or "ARCANE LINEAGE"
    local subTitleText = config.SubTitle or "CRIMSON v2.7"
    local windowSize = config.Size or UDim2.new(0, 560, 0, 400)
    local toggleKey = config.ToggleKey or Enum.KeyCode.End
    ZeroLib.ToggleKey = toggleKey

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "ZeroLib_UI"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.Parent = parentGui

    -- Popover Layer
    local popoverLayer = Instance.new("Frame")
    popoverLayer.Name = "PopoverLayer"
    popoverLayer.Size = UDim2.new(1, 0, 1, 0)
    popoverLayer.BackgroundTransparency = 1
    popoverLayer.ZIndex = 500
    popoverLayer.Parent = screenGui
    ZeroLib.PopoverLayer = popoverLayer

    -- Popover Click-Outside Listener
    local clickConn = UserInputService.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            if ZeroLib.ActivePopover and ZeroLib.ActivePopover.Close then
                local pos = input.Position
                local popInst = ZeroLib.ActivePopover.Instance
                if popInst and popInst.Parent then
                    local absPos = popInst.AbsolutePosition
                    local absSize = popInst.AbsoluteSize
                    local inBounds = (pos.X >= absPos.X and pos.X <= absPos.X + absSize.X and pos.Y >= absPos.Y and pos.Y <= absPos.Y + absSize.Y)
                    if not inBounds and not ZeroLib.ActivePopover.IgnoreClick then
                        ZeroLib.ActivePopover.Close()
                    end
                end
            end
        end
    end)
    table.insert(ZeroLib.Connections, clickConn)

    -- Main Shell Frame
    local mainShell = Instance.new("Frame")
    mainShell.Name = "MainShell"
    mainShell.Size = windowSize
    mainShell.Position = UDim2.new(0.5, -windowSize.X.Offset / 2, 0.5, -windowSize.Y.Offset / 2)
    mainShell.BackgroundColor3 = theme.MainBg
    mainShell.BorderSizePixel = 0
    mainShell.ClipsDescendants = false
    mainShell.Parent = screenGui

    local shellCorner = Instance.new("UICorner")
    shellCorner.CornerRadius = UDim.new(0, 6)
    shellCorner.Parent = mainShell

    local shellStroke = Instance.new("UIStroke")
    shellStroke.Color = theme.CardStroke
    shellStroke.Thickness = 1
    shellStroke.Parent = mainShell

    ZeroLib:RegisterThemeObject(mainShell, "BackgroundColor3", "MainBg")
    ZeroLib:RegisterThemeObject(shellStroke, "Color", "CardStroke")

    -- Topbar (Height: 36px)
    local topbar = Instance.new("Frame")
    topbar.Name = "Topbar"
    topbar.Size = UDim2.new(1, 0, 0, 36)
    topbar.BackgroundColor3 = theme.SidebarBg
    topbar.BorderSizePixel = 0
    topbar.Parent = mainShell

    local topbarCorner = Instance.new("UICorner")
    topbarCorner.CornerRadius = UDim.new(0, 6)
    topbarCorner.Parent = topbar

    local topbarBottomLine = Instance.new("Frame")
    topbarBottomLine.Size = UDim2.new(1, 0, 0, 1)
    topbarBottomLine.Position = UDim2.new(0, 0, 1, -1)
    topbarBottomLine.BackgroundColor3 = theme.CardStroke
    topbarBottomLine.BorderSizePixel = 0
    topbarBottomLine.Parent = topbar

    ZeroLib:RegisterThemeObject(topbar, "BackgroundColor3", "SidebarBg")
    ZeroLib:RegisterThemeObject(topbarBottomLine, "BackgroundColor3", "CardStroke")

    makeDraggable(topbar, mainShell)

    -- Brand Icon & Clean Title
    local titleIcon = Instance.new("ImageLabel")
    titleIcon.Size = UDim2.new(0, 16, 0, 16)
    titleIcon.Position = UDim2.new(0, 10, 0.5, -8)
    titleIcon.BackgroundTransparency = 1
    titleIcon.Image = Icons.Terminal
    titleIcon.ImageColor3 = theme.Accent
    titleIcon.Parent = topbar

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(0, 150, 1, 0)
    titleLabel.Position = UDim2.new(0, 32, 0, 0)
    titleLabel.BackgroundTransparency = 1
    applyFont(titleLabel, "Bold")
    titleLabel.Text = titleText
    titleLabel.TextColor3 = theme.TextMain
    titleLabel.TextSize = 11.5
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = topbar

    ZeroLib:RegisterThemeObject(titleIcon, "ImageColor3", "Accent")
    ZeroLib:RegisterThemeObject(titleLabel, "TextColor3", "TextMain")

    -- Topbar Buttons (Minimize & Full UNLOAD Button)
    local controlsFrame = Instance.new("Frame")
    controlsFrame.Size = UDim2.new(0, 56, 1, 0)
    controlsFrame.Position = UDim2.new(1, -60, 0, 0)
    controlsFrame.BackgroundTransparency = 1
    controlsFrame.Parent = topbar

    local minBtn = Instance.new("TextButton")
    minBtn.Size = UDim2.new(0, 22, 0, 22)
    minBtn.Position = UDim2.new(0, 2, 0.5, -11)
    minBtn.BackgroundColor3 = theme.CardBg
    minBtn.BorderSizePixel = 0
    applyFont(minBtn, "Bold")
    minBtn.Text = "-"
    minBtn.TextColor3 = theme.TextMuted
    minBtn.TextSize = 12
    minBtn.Parent = controlsFrame

    local minCorner = Instance.new("UICorner")
    minCorner.CornerRadius = UDim.new(0, 4)
    minCorner.Parent = minBtn

    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 22, 0, 22)
    closeBtn.Position = UDim2.new(0, 28, 0.5, -11)
    closeBtn.BackgroundColor3 = theme.Danger
    closeBtn.BorderSizePixel = 0
    applyFont(closeBtn, "Bold")
    closeBtn.Text = "X"
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.TextSize = 10.5
    closeBtn.Parent = controlsFrame

    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 4)
    closeCorner.Parent = closeBtn

    closeBtn.MouseButton1Click:Connect(function()
        ZeroLib:Unload()
    end)

    minBtn.MouseButton1Click:Connect(function()
        ZeroLib.IsVisible = not ZeroLib.IsVisible
        mainShell.Visible = ZeroLib.IsVisible
    end)

    -- Toggle GUI Key Listener (Strict check to prevent false AFK pulses)
    local keyConn = UserInputService.InputBegan:Connect(function(input, gpe)
        if not gpe and input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == ZeroLib.ToggleKey then
            ZeroLib.IsVisible = not ZeroLib.IsVisible
            mainShell.Visible = ZeroLib.IsVisible
        end
    end)
    table.insert(ZeroLib.Connections, keyConn)

    -- Sidebar (Slim 130px)
    local sidebar = Instance.new("Frame")
    sidebar.Name = "Sidebar"
    sidebar.Size = UDim2.new(0, 130, 1, -36)
    sidebar.Position = UDim2.new(0, 0, 0, 36)
    sidebar.BackgroundColor3 = theme.SidebarBg
    sidebar.BorderSizePixel = 0
    sidebar.Parent = mainShell

    local sidebarRightLine = Instance.new("Frame")
    sidebarRightLine.Size = UDim2.new(0, 1, 1, 0)
    sidebarRightLine.Position = UDim2.new(1, -1, 0, 0)
    sidebarRightLine.BackgroundColor3 = theme.CardStroke
    sidebarRightLine.BorderSizePixel = 0
    sidebarRightLine.Parent = sidebar

    ZeroLib:RegisterThemeObject(sidebar, "BackgroundColor3", "SidebarBg")
    ZeroLib:RegisterThemeObject(sidebarRightLine, "BackgroundColor3", "CardStroke")

    local tabList = Instance.new("ScrollingFrame")
    tabList.Name = "TabList"
    tabList.Size = UDim2.new(1, -10, 1, -12)
    tabList.Position = UDim2.new(0, 5, 0, 6)
    tabList.BackgroundTransparency = 1
    tabList.BorderSizePixel = 0
    tabList.ScrollBarThickness = 2
    tabList.Parent = sidebar

    local tabLayout = Instance.new("UIListLayout")
    tabLayout.Padding = UDim.new(0, 4)
    tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabLayout.Parent = tabList

    -- Page Container
    local pageContainer = Instance.new("Frame")
    pageContainer.Name = "PageContainer"
    pageContainer.Size = UDim2.new(1, -130, 1, -36)
    pageContainer.Position = UDim2.new(0, 130, 0, 36)
    pageContainer.BackgroundTransparency = 1
    pageContainer.Parent = mainShell

    local Window = {
        Gui = screenGui,
        Main = mainShell,
        Tabs = {},
        ActiveTab = nil,
    }
    table.insert(ZeroLib.Windows, Window)

    -- ADD TAB
    function Window:AddTab(tabConfig)
        local tabName = type(tabConfig) == "table" and tabConfig.Name or tostring(tabConfig)
        local tabIconAsset = type(tabConfig) == "table" and tabConfig.Icon or Icons.Combat

        local tabBtn = Instance.new("TextButton")
        tabBtn.Name = "Tab_" .. tabName
        tabBtn.Size = UDim2.new(1, 0, 0, 28)
        tabBtn.BackgroundColor3 = theme.CardBg
        tabBtn.BackgroundTransparency = 1
        tabBtn.BorderSizePixel = 0
        tabBtn.Text = ""
        tabBtn.Parent = tabList

        local tabBtnCorner = Instance.new("UICorner")
        tabBtnCorner.CornerRadius = UDim.new(0, 4)
        tabBtnCorner.Parent = tabBtn

        local tabIcon = Instance.new("ImageLabel")
        tabIcon.Size = UDim2.new(0, 14, 0, 14)
        tabIcon.Position = UDim2.new(0, 8, 0.5, -7)
        tabIcon.BackgroundTransparency = 1
        tabIcon.Image = tabIconAsset
        tabIcon.ImageColor3 = theme.TextMuted
        tabIcon.Parent = tabBtn

        local tabLabel = Instance.new("TextLabel")
        tabLabel.Size = UDim2.new(1, -28, 1, 0)
        tabLabel.Position = UDim2.new(0, 26, 0, 0)
        tabLabel.BackgroundTransparency = 1
        applyFont(tabLabel, "Medium")
        tabLabel.Text = tabName
        tabLabel.TextColor3 = theme.TextMuted
        tabLabel.TextSize = 10.5
        tabLabel.TextXAlignment = Enum.TextXAlignment.Left
        tabLabel.Parent = tabBtn

        local activeIndicator = Instance.new("Frame")
        activeIndicator.Name = "Indicator"
        activeIndicator.Size = UDim2.new(0, 2, 0, 14)
        activeIndicator.Position = UDim2.new(0, 2, 0.5, -7)
        activeIndicator.BackgroundColor3 = theme.Accent
        activeIndicator.BackgroundTransparency = 1
        activeIndicator.BorderSizePixel = 0
        activeIndicator.Parent = tabBtn

        local indCorner = Instance.new("UICorner")
        indCorner.CornerRadius = UDim.new(1, 0)
        indCorner.Parent = activeIndicator

        -- Content Page
        local tabPage = Instance.new("ScrollingFrame")
        tabPage.Name = "Page_" .. tabName
        tabPage.Size = UDim2.new(1, -12, 1, -12)
        tabPage.Position = UDim2.new(0, 6, 0, 6)
        tabPage.BackgroundTransparency = 1
        tabPage.BorderSizePixel = 0
        tabPage.ScrollBarThickness = 3
        tabPage.Visible = false
        tabPage.CanvasSize = UDim2.new(0, 0, 0, 0)
        tabPage.Parent = pageContainer

        local leftColumn = Instance.new("Frame")
        leftColumn.Name = "LeftColumn"
        leftColumn.Size = UDim2.new(0.5, -4, 1, 0)
        leftColumn.Position = UDim2.new(0, 0, 0, 0)
        leftColumn.BackgroundTransparency = 1
        leftColumn.Parent = tabPage

        local leftLayout = Instance.new("UIListLayout")
        leftLayout.Padding = UDim.new(0, 6)
        leftLayout.SortOrder = Enum.SortOrder.LayoutOrder
        leftLayout.Parent = leftColumn

        local rightColumn = Instance.new("Frame")
        rightColumn.Name = "RightColumn"
        rightColumn.Size = UDim2.new(0.5, -4, 1, 0)
        rightColumn.Position = UDim2.new(0.5, 4, 0, 0)
        rightColumn.BackgroundTransparency = 1
        rightColumn.Parent = tabPage

        local rightLayout = Instance.new("UIListLayout")
        rightLayout.Padding = UDim.new(0, 6)
        rightLayout.SortOrder = Enum.SortOrder.LayoutOrder
        rightLayout.Parent = rightColumn

        local function updateCanvasSize()
            local lHeight = leftLayout.AbsoluteContentSize.Y
            local rHeight = rightLayout.AbsoluteContentSize.Y
            local maxH = math.max(lHeight, rHeight)
            tabPage.CanvasSize = UDim2.new(0, 0, 0, maxH + 14)
        end

        leftLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateCanvasSize)
        rightLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateCanvasSize)

        local Tab = {
            Name = tabName,
            Button = tabBtn,
            Icon = tabIcon,
            Label = tabLabel,
            Page = tabPage,
            LeftColumn = leftColumn,
            RightColumn = rightColumn,
        }

        function Tab:Select()
            local curTheme = ZeroLib.Themes[ZeroLib.ActiveTheme]
            for _, t in pairs(Window.Tabs) do
                t.Page.Visible = false
                t.Button.BackgroundTransparency = 1
                t.Label.TextColor3 = curTheme.TextMuted
                t.Icon.ImageColor3 = curTheme.TextMuted
                t.Button.Indicator.BackgroundTransparency = 1
            end
            tabPage.Visible = true
            tabBtn.BackgroundTransparency = 0
            tabBtn.BackgroundColor3 = curTheme.CardBg
            tabLabel.TextColor3 = curTheme.TextMain
            tabIcon.ImageColor3 = curTheme.Accent
            activeIndicator.BackgroundColor3 = curTheme.Accent
            activeIndicator.BackgroundTransparency = 0
            Window.ActiveTab = Tab
        end

        tabBtn.MouseButton1Click:Connect(function()
            Tab:Select()
        end)

        -- GROUPBOX BUILDER
        local function createGroupbox(parentCol, title)
            local card = Instance.new("Frame")
            card.Name = "Group_" .. title
            card.Size = UDim2.new(1, 0, 0, 32)
            card.BackgroundColor3 = theme.CardBg
            card.BorderSizePixel = 0
            card.Parent = parentCol

            local cardCorner = Instance.new("UICorner")
            cardCorner.CornerRadius = UDim.new(0, 5)
            cardCorner.Parent = card

            local cardStroke = Instance.new("UIStroke")
            cardStroke.Color = theme.CardStroke
            cardStroke.Thickness = 1
            cardStroke.Parent = card

            ZeroLib:RegisterThemeObject(card, "BackgroundColor3", "CardBg")
            ZeroLib:RegisterThemeObject(cardStroke, "Color", "CardStroke")

            local headerFrame = Instance.new("Frame")
            headerFrame.Size = UDim2.new(1, 0, 0, 22)
            headerFrame.BackgroundTransparency = 1
            headerFrame.Parent = card

            local accentPip = Instance.new("Frame")
            accentPip.Size = UDim2.new(0, 2, 0, 10)
            accentPip.Position = UDim2.new(0, 8, 0.5, -5)
            accentPip.BackgroundColor3 = theme.Accent
            accentPip.BorderSizePixel = 0
            accentPip.Parent = headerFrame

            local pipCorner = Instance.new("UICorner")
            pipCorner.CornerRadius = UDim.new(1, 0)
            pipCorner.Parent = accentPip

            local cardHeader = Instance.new("TextLabel")
            cardHeader.Size = UDim2.new(1, -24, 1, 0)
            cardHeader.Position = UDim2.new(0, 16, 0, 0)
            cardHeader.BackgroundTransparency = 1
            applyFont(cardHeader, "Bold")
            cardHeader.Text = title
            cardHeader.TextColor3 = theme.TextMain
            cardHeader.TextSize = 10.5
            cardHeader.TextXAlignment = Enum.TextXAlignment.Left
            cardHeader.Parent = headerFrame

            local headerDiv = Instance.new("Frame")
            headerDiv.Size = UDim2.new(1, -16, 0, 1)
            headerDiv.Position = UDim2.new(0, 8, 1, -1)
            headerDiv.BackgroundColor3 = theme.CardStroke
            headerDiv.BorderSizePixel = 0
            headerDiv.Parent = headerFrame

            ZeroLib:RegisterThemeObject(accentPip, "BackgroundColor3", "Accent")
            ZeroLib:RegisterThemeObject(cardHeader, "TextColor3", "TextMain")
            ZeroLib:RegisterThemeObject(headerDiv, "BackgroundColor3", "CardStroke")

            local container = Instance.new("Frame")
            container.Name = "Container"
            container.Size = UDim2.new(1, -16, 0, 0)
            container.Position = UDim2.new(0, 8, 0, 26)
            container.BackgroundTransparency = 1
            container.Parent = card

            local cLayout = Instance.new("UIListLayout")
            cLayout.Padding = UDim.new(0, 5)
            cLayout.SortOrder = Enum.SortOrder.LayoutOrder
            cLayout.Parent = container

            cLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                card.Size = UDim2.new(1, 0, 0, cLayout.AbsoluteContentSize.Y + 34)
            end)

            local Group = { Card = card, Container = container }

            function Group:Resize()
                pcall(function()
                    card.Size = UDim2.new(1, 0, 0, cLayout.AbsoluteContentSize.Y + 34)
                end)
            end

            -- 100% NATIVE PRO COLORPICKER
            local function createProColorPicker(cpId, defaultColor, callback, anchorButton)
                local curColor = defaultColor or Color3.fromRGB(239, 68, 68)
                local h, s, v = curColor:ToHSV()

                local pickerFrame = Instance.new("Frame")
                pickerFrame.Name = "ProColorPicker_" .. cpId
                pickerFrame.Size = UDim2.new(0, 184, 0, 186)
                pickerFrame.BackgroundColor3 = theme.CardBg
                pickerFrame.BorderSizePixel = 0
                pickerFrame.ClipsDescendants = true
                pickerFrame.Visible = false
                pickerFrame.ZIndex = 700
                pickerFrame.Parent = ZeroLib.PopoverLayer

                local pCorner = Instance.new("UICorner")
                pCorner.CornerRadius = UDim.new(0, 5)
                pCorner.Parent = pickerFrame

                local pStroke = Instance.new("UIStroke")
                pStroke.Color = theme.CardStroke
                pStroke.Thickness = 1
                pStroke.Parent = pickerFrame

                ZeroLib:RegisterThemeObject(pickerFrame, "BackgroundColor3", "CardBg")
                ZeroLib:RegisterThemeObject(pStroke, "Color", "CardStroke")

                -- 1. Saturation / Value 2D Box
                local svBox = Instance.new("Frame")
                svBox.Name = "SVBox"
                svBox.Size = UDim2.new(1, -16, 0, 95)
                svBox.Position = UDim2.new(0, 8, 0, 8)
                svBox.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
                svBox.BorderSizePixel = 0
                svBox.ClipsDescendants = true
                svBox.ZIndex = 701
                svBox.Parent = pickerFrame

                local svCorner = Instance.new("UICorner")
                svCorner.CornerRadius = UDim.new(0, 4)
                svCorner.Parent = svBox

                local satOverlay = Instance.new("Frame")
                satOverlay.Name = "SatOverlay"
                satOverlay.Size = UDim2.new(1, 0, 1, 0)
                satOverlay.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                satOverlay.BorderSizePixel = 0
                satOverlay.ZIndex = 702
                satOverlay.Parent = svBox

                local satGrad = Instance.new("UIGradient")
                satGrad.Transparency = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 0),
                    NumberSequenceKeypoint.new(1, 1)
                })
                satGrad.Parent = satOverlay

                local valOverlay = Instance.new("Frame")
                valOverlay.Name = "ValOverlay"
                valOverlay.Size = UDim2.new(1, 0, 1, 0)
                valOverlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                valOverlay.BorderSizePixel = 0
                valOverlay.ZIndex = 703
                valOverlay.Parent = svBox

                local valGrad = Instance.new("UIGradient")
                valGrad.Rotation = 90
                valGrad.Transparency = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 1),
                    NumberSequenceKeypoint.new(1, 0)
                })
                valGrad.Parent = valOverlay

                local svCursor = Instance.new("Frame")
                svCursor.Name = "SVCursor"
                svCursor.Size = UDim2.new(0, 10, 0, 10)
                svCursor.AnchorPoint = Vector2.new(0.5, 0.5)
                svCursor.Position = UDim2.new(s, 0, 1 - v, 0)
                svCursor.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                svCursor.BorderSizePixel = 0
                svCursor.ZIndex = 705
                svCursor.Parent = svBox

                local curCorner = Instance.new("UICorner")
                curCorner.CornerRadius = UDim.new(1, 0)
                curCorner.Parent = svCursor

                local curStroke = Instance.new("UIStroke")
                curStroke.Color = Color3.fromRGB(0, 0, 0)
                curStroke.Thickness = 1.5
                curStroke.Parent = svCursor

                -- 2. Rainbow Hue Bar
                local hueBar = Instance.new("Frame")
                hueBar.Name = "HueBar"
                hueBar.Size = UDim2.new(1, -16, 0, 12)
                hueBar.Position = UDim2.new(0, 8, 0, 110)
                hueBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                hueBar.BorderSizePixel = 0
                hueBar.ZIndex = 701
                hueBar.Parent = pickerFrame

                local hueCorner = Instance.new("UICorner")
                hueCorner.CornerRadius = UDim.new(0, 3)
                hueCorner.Parent = hueBar

                local rainbowGrad = Instance.new("UIGradient")
                rainbowGrad.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 0, 0)),
                    ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 255, 0)),
                    ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0, 255, 0)),
                    ColorSequenceKeypoint.new(0.50, Color3.fromRGB(0, 255, 255)),
                    ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0, 0, 255)),
                    ColorSequenceKeypoint.new(0.83, Color3.fromRGB(255, 0, 255)),
                    ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 0, 0))
                })
                rainbowGrad.Parent = hueBar

                local hueCursor = Instance.new("Frame")
                hueCursor.Name = "HueCursor"
                hueCursor.Size = UDim2.new(0, 5, 1, 4)
                hueCursor.AnchorPoint = Vector2.new(0.5, 0.5)
                hueCursor.Position = UDim2.new(h, 0, 0.5, 0)
                hueCursor.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                hueCursor.BorderSizePixel = 0
                hueCursor.ZIndex = 705
                hueCursor.Parent = hueBar

                local hCurCorner = Instance.new("UICorner")
                hCurCorner.CornerRadius = UDim.new(0, 2)
                hCurCorner.Parent = hueCursor

                local hCurStroke = Instance.new("UIStroke")
                hCurStroke.Color = Color3.fromRGB(0, 0, 0)
                hCurStroke.Thickness = 1
                hCurStroke.Parent = hueCursor

                -- 3. Live Preview & Hex Input Row
                local bottomRow = Instance.new("Frame")
                bottomRow.Size = UDim2.new(1, -16, 0, 24)
                bottomRow.Position = UDim2.new(0, 8, 0, 128)
                bottomRow.BackgroundTransparency = 1
                bottomRow.Parent = pickerFrame

                local previewBox = Instance.new("Frame")
                previewBox.Size = UDim2.new(0, 24, 0, 24)
                previewBox.BackgroundColor3 = curColor
                previewBox.BorderSizePixel = 0
                previewBox.ZIndex = 701
                previewBox.Parent = bottomRow

                local prevCorner = Instance.new("UICorner")
                prevCorner.CornerRadius = UDim.new(0, 4)
                prevCorner.Parent = previewBox

                local prevStroke = Instance.new("UIStroke")
                prevStroke.Color = theme.CardStroke
                prevStroke.Thickness = 1
                prevStroke.Parent = previewBox

                local hexInput = Instance.new("TextBox")
                hexInput.Size = UDim2.new(1, -30, 1, 0)
                hexInput.Position = UDim2.new(0, 30, 0, 0)
                hexInput.BackgroundColor3 = theme.CardInner
                hexInput.BorderSizePixel = 0
                applyFont(hexInput, "Bold")
                hexInput.Text = "#" .. curColor:ToHex():upper()
                hexInput.TextColor3 = theme.TextMain
                hexInput.TextSize = 10
                hexInput.ZIndex = 701
                hexInput.Parent = bottomRow

                local hexCorner = Instance.new("UICorner")
                hexCorner.CornerRadius = UDim.new(0, 4)
                hexCorner.Parent = hexInput

                local hexStroke = Instance.new("UIStroke")
                hexStroke.Color = theme.CardStroke
                hexStroke.Thickness = 1
                hexStroke.Parent = hexInput

                -- 4. Editable RGB Inputs Row
                local rgbRow = Instance.new("Frame")
                rgbRow.Size = UDim2.new(1, -16, 0, 22)
                rgbRow.Position = UDim2.new(0, 8, 0, 156)
                rgbRow.BackgroundTransparency = 1
                rgbRow.Parent = pickerFrame

                local rgbLayout = Instance.new("UIListLayout")
                rgbLayout.FillDirection = Enum.FillDirection.Horizontal
                rgbLayout.Padding = UDim.new(0, 4)
                rgbLayout.Parent = rgbRow

                local function createRgbBox(labelTxt, initialVal)
                    local f = Instance.new("Frame")
                    f.Size = UDim2.new(0.333, -3, 1, 0)
                    f.BackgroundColor3 = theme.CardInner
                    f.BorderSizePixel = 0
                    f.ZIndex = 701
                    f.Parent = rgbRow

                    local fc = Instance.new("UICorner")
                    fc.CornerRadius = UDim.new(0, 3)
                    fc.Parent = f

                    local fs = Instance.new("UIStroke")
                    fs.Color = theme.CardStroke
                    fs.Thickness = 1
                    fs.Parent = f

                    local lbl = Instance.new("TextLabel")
                    lbl.Size = UDim2.new(0, 12, 1, 0)
                    lbl.Position = UDim2.new(0, 3, 0, 0)
                    lbl.BackgroundTransparency = 1
                    applyFont(lbl, "Bold")
                    lbl.Text = labelTxt
                    lbl.TextColor3 = theme.TextMuted
                    lbl.TextSize = 9
                    lbl.ZIndex = 702
                    lbl.Parent = f

                    local tb = Instance.new("TextBox")
                    tb.Size = UDim2.new(1, -16, 1, 0)
                    tb.Position = UDim2.new(0, 14, 0, 0)
                    tb.BackgroundTransparency = 1
                    applyFont(tb, "Medium")
                    tb.Text = tostring(math.floor(initialVal * 255))
                    tb.TextColor3 = theme.TextMain
                    tb.TextSize = 9.5
                    tb.ZIndex = 702
                    tb.Parent = f

                    return tb
                end

                local rBox = createRgbBox("R", curColor.R)
                local gBox = createRgbBox("G", curColor.G)
                local bBox = createRgbBox("B", curColor.B)

                local ColorObj = {
                    Value = curColor,
                    H = h,
                    S = s,
                    V = v,
                    IsOpen = false,
                    Callbacks = callback and { callback } or {},
                    Type = "ColorPicker"
                }

                local function updateColor(newH, newS, newV)
                    ColorObj.H = newH or ColorObj.H
                    ColorObj.S = newS or ColorObj.S
                    ColorObj.V = newV or ColorObj.V

                    local finalColor = Color3.fromHSV(ColorObj.H, ColorObj.S, ColorObj.V)
                    ColorObj.Value = finalColor

                    svBox.BackgroundColor3 = Color3.fromHSV(ColorObj.H, 1, 1)
                    svCursor.Position = UDim2.new(ColorObj.S, 0, 1 - ColorObj.V, 0)
                    hueCursor.Position = UDim2.new(ColorObj.H, 0, 0.5, 0)
                    previewBox.BackgroundColor3 = finalColor
                    anchorButton.BackgroundColor3 = finalColor
                    hexInput.Text = "#" .. finalColor:ToHex():upper()

                    rBox.Text = tostring(math.floor(finalColor.R * 255))
                    gBox.Text = tostring(math.floor(finalColor.G * 255))
                    bBox.Text = tostring(math.floor(finalColor.B * 255))

                    for _, cb in ipairs(ColorObj.Callbacks) do
                        pcall(cb, finalColor)
                    end
                end

                function ColorObj:SetValue(col)
                    self.Value = col
                    local nh, ns, nv = col:ToHSV()
                    updateColor(nh, ns, nv)
                end

                function ColorObj:OnChanged(fn)
                    table.insert(self.Callbacks, fn)
                end

                function ColorObj:TogglePicker(open)
                    if open == nil then open = not self.IsOpen end
                    self.IsOpen = open

                    if open then
                        if ZeroLib.ActivePopover and ZeroLib.ActivePopover.Close then
                            ZeroLib.ActivePopover.Close()
                        end

                        local absPos = anchorButton.AbsolutePosition
                        local absSize = anchorButton.AbsoluteSize
                        pickerFrame.Position = UDim2.new(0, absPos.X - 160, 0, absPos.Y + absSize.Y + 4)
                        pickerFrame.Visible = true
                        pickerFrame.Size = UDim2.new(0, 184, 0, 0)
                        fastTween(pickerFrame, { Size = UDim2.new(0, 184, 0, 186) }, 0.16)

                        ZeroLib.ActivePopover = {
                            Instance = pickerFrame,
                            Close = function() ColorObj:TogglePicker(false) end
                        }
                    else
                        fastTween(pickerFrame, { Size = UDim2.new(0, 184, 0, 0) }, 0.12).Completed:Connect(function()
                            if not self.IsOpen then pickerFrame.Visible = false end
                        end)
                        if ZeroLib.ActivePopover and ZeroLib.ActivePopover.Instance == pickerFrame then
                            ZeroLib.ActivePopover = nil
                        end
                    end
                end

                local slidingSV = false
                local svBtn = Instance.new("TextButton")
                svBtn.Size = UDim2.new(1, 0, 1, 0)
                svBtn.BackgroundTransparency = 1
                svBtn.Text = ""
                svBtn.ZIndex = 706
                svBtn.Parent = svBox

                svBtn.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        slidingSV = true
                        local relX = math.clamp((input.Position.X - svBox.AbsolutePosition.X) / svBox.AbsoluteSize.X, 0, 1)
                        local relY = math.clamp((input.Position.Y - svBox.AbsolutePosition.Y) / svBox.AbsoluteSize.Y, 0, 1)
                        updateColor(nil, relX, 1 - relY)
                    end
                end)

                local slidingHue = false
                local hueBtn = Instance.new("TextButton")
                hueBtn.Size = UDim2.new(1, 0, 1, 0)
                hueBtn.BackgroundTransparency = 1
                hueBtn.Text = ""
                hueBtn.ZIndex = 706
                hueBtn.Parent = hueBar

                hueBtn.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        slidingHue = true
                        local relX = math.clamp((input.Position.X - hueBar.AbsolutePosition.X) / hueBar.AbsoluteSize.X, 0, 1)
                        updateColor(relX, nil, nil)
                    end
                end)

                local endConn = UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        slidingSV = false
                        slidingHue = false
                    end
                end)
                table.insert(ZeroLib.Connections, endConn)

                local moveConn = UserInputService.InputChanged:Connect(function(input)
                    if slidingSV and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                        local relX = math.clamp((input.Position.X - svBox.AbsolutePosition.X) / svBox.AbsoluteSize.X, 0, 1)
                        local relY = math.clamp((input.Position.Y - svBox.AbsolutePosition.Y) / svBox.AbsoluteSize.Y, 0, 1)
                        updateColor(nil, relX, 1 - relY)
                    elseif slidingHue and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                        local relX = math.clamp((input.Position.X - hueBar.AbsolutePosition.X) / hueBar.AbsoluteSize.X, 0, 1)
                        updateColor(relX, nil, nil)
                    end
                end)
                table.insert(ZeroLib.Connections, moveConn)

                hexInput.FocusLost:Connect(function()
                    local raw = hexInput.Text:gsub("#", "")
                    local ok, col = pcall(Color3.fromHex, raw)
                    if ok and col then
                        ColorObj:SetValue(col)
                    end
                end)

                local function parseRgb()
                    local r = math.clamp(tonumber(rBox.Text) or 0, 0, 255) / 255
                    local g = math.clamp(tonumber(gBox.Text) or 0, 0, 255) / 255
                    local b = math.clamp(tonumber(bBox.Text) or 0, 0, 255) / 255
                    ColorObj:SetValue(Color3.new(r, g, b))
                end

                rBox.FocusLost:Connect(parseRgb)
                gBox.FocusLost:Connect(parseRgb)
                bBox.FocusLost:Connect(parseRgb)

                anchorButton.MouseButton1Click:Connect(function()
                    ColorObj:TogglePicker()
                end)

                ZeroLib.Options[cpId] = ColorObj
                return ColorObj
            end

            -- 1. TOGGLE COMPONENT
            function Group:AddToggle(id, toggleConfig)
                local text = toggleConfig.Text or id
                local default = toggleConfig.Default or false
                local callback = toggleConfig.Callback

                local row = Instance.new("Frame")
                row.Size = UDim2.new(1, 0, 0, 20)
                row.BackgroundTransparency = 1
                row.Parent = container

                local label = Instance.new("TextLabel")
                label.Size = UDim2.new(1, -74, 1, 0)
                label.BackgroundTransparency = 1
                applyFont(label, "Medium")
                label.Text = text
                label.TextColor3 = default and theme.TextMain or theme.TextMuted
                label.TextSize = 10
                label.TextXAlignment = Enum.TextXAlignment.Left
                label.Parent = row

                local subContainer = Instance.new("Frame")
                subContainer.Size = UDim2.new(0, 74, 1, 0)
                subContainer.Position = UDim2.new(1, -74, 0, 0)
                subContainer.BackgroundTransparency = 1
                subContainer.Parent = row

                local subLayout = Instance.new("UIListLayout")
                subLayout.FillDirection = Enum.FillDirection.Horizontal
                subLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
                subLayout.VerticalAlignment = Enum.VerticalAlignment.Center
                subLayout.Padding = UDim.new(0, 4)
                subLayout.Parent = subContainer

                local switch = Instance.new("TextButton")
                switch.Size = UDim2.new(0, 30, 0, 15)
                switch.BackgroundColor3 = default and theme.Accent or theme.CardInner
                switch.BorderSizePixel = 0
                switch.Text = ""
                switch.Parent = subContainer

                local swCorner = Instance.new("UICorner")
                swCorner.CornerRadius = UDim.new(1, 0)
                swCorner.Parent = switch

                local knob = Instance.new("Frame")
                knob.Size = UDim2.new(0, 11, 0, 11)
                knob.Position = default and UDim2.new(1, -13, 0.5, -5.5) or UDim2.new(0, 2, 0.5, -5.5)
                knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                knob.BorderSizePixel = 0
                knob.Parent = switch

                local knobCorner = Instance.new("UICorner")
                knobCorner.CornerRadius = UDim.new(1, 0)
                knobCorner.Parent = knob

                local ToggleObj = {
                    Value = default,
                    Callbacks = callback and { callback } or {},
                    Type = "Toggle"
                }

                function ToggleObj:UpdateVisuals()
                    local curTheme = ZeroLib.Themes[ZeroLib.ActiveTheme]
                    local targetPos = self.Value and UDim2.new(1, -13, 0.5, -5.5) or UDim2.new(0, 2, 0.5, -5.5)
                    local targetBg = self.Value and curTheme.Accent or curTheme.CardInner
                    fastTween(knob, { Position = targetPos }, 0.12)
                    fastTween(switch, { BackgroundColor3 = targetBg }, 0.12)
                    label.TextColor3 = self.Value and curTheme.TextMain or curTheme.TextMuted
                end

                function ToggleObj:SetValue(val)
                    self.Value = val
                    self:UpdateVisuals()
                    for _, fn in ipairs(self.Callbacks) do
                        pcall(fn, val)
                    end
                end

                function ToggleObj:OnChanged(fn)
                    table.insert(self.Callbacks, fn)
                end

                switch.MouseButton1Click:Connect(function()
                    ToggleObj:SetValue(not ToggleObj.Value)
                end)

                -- INLINE KEYBIND & KEYPICKER
                function ToggleObj:AddKeybind(kbId, kbConfig)
                    kbConfig = kbConfig or {}
                    local rawDefault = kbConfig.Default
                    local kbDefault = Enum.KeyCode.Unknown
                    if typeof(rawDefault) == "EnumItem" then
                        kbDefault = rawDefault
                    elseif type(rawDefault) == "string" then
                        kbDefault = Enum.KeyCode[rawDefault] or Enum.KeyCode.Unknown
                    end

                    local kbMode = kbConfig.Mode or "Toggle"
                    local kbCallback = kbConfig.Callback

                    local kbBtn = Instance.new("TextButton")
                    kbBtn.Size = UDim2.new(0, 36, 0, 15)
                    kbBtn.BackgroundColor3 = theme.CardInner
                    kbBtn.BorderSizePixel = 0
                    applyFont(kbBtn, "Bold")
                    kbBtn.Text = kbDefault.Name ~= "Unknown" and kbDefault.Name or "NONE"
                    kbBtn.TextColor3 = theme.TextMuted
                    kbBtn.TextSize = 8.5
                    kbBtn.LayoutOrder = 1
                    kbBtn.Parent = subContainer

                    local kCorner = Instance.new("UICorner")
                    kCorner.CornerRadius = UDim.new(0, 3)
                    kCorner.Parent = kbBtn

                    local kStroke = Instance.new("UIStroke")
                    kStroke.Color = theme.CardStroke
                    kStroke.Thickness = 1
                    kStroke.Parent = kbBtn

                    ZeroLib:RegisterThemeObject(kbBtn, "BackgroundColor3", "CardInner")
                    ZeroLib:RegisterThemeObject(kStroke, "Color", "CardStroke")

                    local KeybindObj = {
                        Value = kbDefault,
                        Mode = kbMode,
                        Binding = false,
                        Callbacks = kbCallback and { kbCallback } or {},
                        Type = "Keybind"
                    }

                    function KeybindObj:OnChanged(fn)
                        table.insert(self.Callbacks, fn)
                    end

                    function KeybindObj:SetValue(key)
                        if typeof(key) == "EnumItem" then
                            self.Value = key
                        elseif type(key) == "string" then
                            self.Value = Enum.KeyCode[key] or Enum.KeyCode.Unknown
                        end
                        kbBtn.Text = self.Value.Name ~= "Unknown" and self.Value.Name or "NONE"
                        for _, fn in ipairs(self.Callbacks) do
                            pcall(fn, self.Value)
                        end
                    end

                    kbBtn.MouseButton1Click:Connect(function()
                        KeybindObj.Binding = true
                        kbBtn.Text = "..."
                        kbBtn.TextColor3 = ZeroLib.Themes[ZeroLib.ActiveTheme].Accent
                    end)

                    local kbConn = UserInputService.InputBegan:Connect(function(input, gpe)
                        if KeybindObj.Binding and not gpe then
                            if input.UserInputType == Enum.UserInputType.Keyboard then
                                KeybindObj.Binding = false
                                if input.KeyCode == Enum.KeyCode.Escape then
                                    KeybindObj:SetValue(Enum.KeyCode.Unknown)
                                else
                                    KeybindObj:SetValue(input.KeyCode)
                                end
                                kbBtn.TextColor3 = ZeroLib.Themes[ZeroLib.ActiveTheme].TextMuted
                            end
                        elseif not gpe and input.KeyCode == KeybindObj.Value and KeybindObj.Value ~= Enum.KeyCode.Unknown then
                            if KeybindObj.Mode == "Toggle" then
                                ToggleObj:SetValue(not ToggleObj.Value)
                            elseif KeybindObj.Mode == "Hold" then
                                ToggleObj:SetValue(true)
                            end
                            for _, fn in ipairs(KeybindObj.Callbacks) do
                                pcall(fn, ToggleObj.Value)
                            end
                        end
                    end)
                    table.insert(ZeroLib.Connections, kbConn)

                    local kbEndConn = UserInputService.InputEnded:Connect(function(input, gpe)
                        if not gpe and input.KeyCode == KeybindObj.Value and KeybindObj.Mode == "Hold" then
                            ToggleObj:SetValue(false)
                        end
                    end)
                    table.insert(ZeroLib.Connections, kbEndConn)

                    ZeroLib.Options[kbId or (id .. "_Keybind")] = KeybindObj
                    return KeybindObj
                end

                ToggleObj.AddKeyPicker = ToggleObj.AddKeybind

                -- INLINE PRO COLORPICKER
                function ToggleObj:AddColorPicker(cpId, cpConfig)
                    local cpDefault = cpConfig.Default or Color3.fromRGB(239, 68, 68)
                    local cpCallback = cpConfig.Callback

                    local colorBox = Instance.new("TextButton")
                    colorBox.Size = UDim2.new(0, 16, 0, 15)
                    colorBox.BackgroundColor3 = cpDefault
                    colorBox.BorderSizePixel = 0
                    colorBox.Text = ""
                    colorBox.LayoutOrder = 2
                    colorBox.Parent = subContainer

                    local cCorner = Instance.new("UICorner")
                    cCorner.CornerRadius = UDim.new(0, 3)
                    cCorner.Parent = colorBox

                    local cStroke = Instance.new("UIStroke")
                    cStroke.Color = theme.CardStroke
                    cStroke.Thickness = 1
                    cStroke.Parent = colorBox

                    ZeroLib:RegisterThemeObject(cStroke, "Color", "CardStroke")

                    return createProColorPicker(cpId or (id .. "_Color"), cpDefault, cpCallback, colorBox)
                end

                ZeroLib.Toggles[id] = ToggleObj
                return ToggleObj
            end

            -- 2. BUTTON COMPONENT
            function Group:AddButton(btnConfig, callbackArg)
                local text, callback
                if type(btnConfig) == "table" then
                    text = btnConfig.Text or "Button"
                    callback = btnConfig.Func or btnConfig.Callback or function() end
                else
                    text = tostring(btnConfig or "Button")
                    callback = callbackArg or function() end
                end

                local btn = Instance.new("TextButton")
                btn.Size = UDim2.new(1, 0, 0, 24)
                btn.BackgroundColor3 = theme.CardInner
                btn.BorderSizePixel = 0
                applyFont(btn, "Bold")
                btn.Text = text
                btn.TextColor3 = theme.TextMain
                btn.TextSize = 10.5
                btn.Parent = container

                local bCorner = Instance.new("UICorner")
                bCorner.CornerRadius = UDim.new(0, 4)
                bCorner.Parent = btn

                local bStroke = Instance.new("UIStroke")
                bStroke.Color = theme.CardStroke
                bStroke.Thickness = 1
                bStroke.Parent = btn

                ZeroLib:RegisterThemeObject(btn, "BackgroundColor3", "CardInner")
                ZeroLib:RegisterThemeObject(btn, "TextColor3", "TextMain")
                ZeroLib:RegisterThemeObject(bStroke, "Color", "CardStroke")

                btn.MouseButton1Click:Connect(function()
                    fastTween(btn, { Size = UDim2.new(1, -2, 0, 23) }, 0.06).Completed:Connect(function()
                        fastTween(btn, { Size = UDim2.new(1, 0, 0, 24) }, 0.06)
                    end)
                    pcall(callback)
                end)

                return btn
            end

            -- 3. SLIDER COMPONENT
            function Group:AddSlider(id, sliderConfig)
                local text = sliderConfig.Text or id
                local min = sliderConfig.Min or 0
                local max = sliderConfig.Max or 100
                local default = sliderConfig.Default or min
                local rounding = sliderConfig.Rounding or 0
                local suffix = sliderConfig.Suffix or ""
                local callback = sliderConfig.Callback

                local row = Instance.new("Frame")
                row.Size = UDim2.new(1, 0, 0, 30)
                row.BackgroundTransparency = 1
                row.Parent = container

                local label = Instance.new("TextLabel")
                label.Size = UDim2.new(1, -60, 0, 14)
                label.BackgroundTransparency = 1
                applyFont(label, "Medium")
                label.Text = text
                label.TextColor3 = theme.TextMuted
                label.TextSize = 10
                label.TextXAlignment = Enum.TextXAlignment.Left
                label.Parent = row

                local valLabel = Instance.new("TextLabel")
                valLabel.Size = UDim2.new(0, 60, 0, 14)
                valLabel.Position = UDim2.new(1, -60, 0, 0)
                valLabel.BackgroundTransparency = 1
                applyFont(valLabel, "Bold")
                valLabel.Text = tostring(default) .. suffix
                valLabel.TextColor3 = theme.Accent
                valLabel.TextSize = 10
                valLabel.TextXAlignment = Enum.TextXAlignment.Right
                valLabel.Parent = row

                local sliderBar = Instance.new("TextButton")
                sliderBar.Size = UDim2.new(1, 0, 0, 6)
                sliderBar.Position = UDim2.new(0, 0, 0, 18)
                sliderBar.BackgroundColor3 = theme.CardInner
                sliderBar.BorderSizePixel = 0
                sliderBar.Text = ""
                sliderBar.Parent = row

                local barCorner = Instance.new("UICorner")
                barCorner.CornerRadius = UDim.new(1, 0)
                barCorner.Parent = sliderBar

                local fill = Instance.new("Frame")
                local startPercent = math.clamp((default - min) / (max - min), 0, 1)
                fill.Size = UDim2.new(startPercent, 0, 1, 0)
                fill.BackgroundColor3 = theme.Accent
                fill.BorderSizePixel = 0
                fill.Parent = sliderBar

                local fillCorner = Instance.new("UICorner")
                fillCorner.CornerRadius = UDim.new(1, 0)
                fillCorner.Parent = fill

                ZeroLib:RegisterThemeObject(label, "TextColor3", "TextMuted")
                ZeroLib:RegisterThemeObject(sliderBar, "BackgroundColor3", "CardInner")
                ZeroLib:RegisterThemeObject(valLabel, "TextColor3", "Accent")
                ZeroLib:RegisterThemeObject(fill, "BackgroundColor3", "Accent")

                local SliderObj = {
                    Value = default,
                    Callbacks = callback and { callback } or {},
                    Type = "Slider"
                }

                function SliderObj:UpdateVisuals()
                    local curTheme = ZeroLib.Themes[ZeroLib.ActiveTheme]
                    valLabel.TextColor3 = curTheme.Accent
                    fill.BackgroundColor3 = curTheme.Accent
                end

                local function updateSlider(input)
                    local percent = math.clamp((input.Position.X - sliderBar.AbsolutePosition.X) / sliderBar.AbsoluteSize.X, 0, 1)
                    local rawVal = min + (max - min) * percent
                    local finalVal = round(rawVal, rounding)
                    SliderObj.Value = finalVal
                    fill.Size = UDim2.new(percent, 0, 1, 0)
                    valLabel.Text = tostring(finalVal) .. suffix
                    for _, fn in ipairs(SliderObj.Callbacks) do
                        pcall(fn, finalVal)
                    end
                end

                function SliderObj:SetValue(val)
                    val = math.clamp(val, min, max)
                    self.Value = val
                    local percent = math.clamp((val - min) / (max - min), 0, 1)
                    fill.Size = UDim2.new(percent, 0, 1, 0)
                    valLabel.Text = tostring(val) .. suffix
                    for _, fn in ipairs(self.Callbacks) do
                        pcall(fn, val)
                    end
                end

                function SliderObj:OnChanged(fn)
                    table.insert(self.Callbacks, fn)
                end

                local sliding = false
                sliderBar.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        sliding = true
                        updateSlider(input)
                    end
                end)

                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        sliding = false
                    end
                end)

                UserInputService.InputChanged:Connect(function(input)
                    if sliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                        updateSlider(input)
                    end
                end)

                ZeroLib.Options[id] = SliderObj
                return SliderObj
            end

            -- 4. DROPDOWN COMPONENT (FULL DICTIONARY & INDEX RESOLUTION SUPPORT)
            function Group:AddDropdown(id, dropConfig)
                local text = dropConfig.Text or id
                local values = dropConfig.Values or {}
                local isMulti = dropConfig.Multi or false
                local rawDefault = dropConfig.Default
                local callback = dropConfig.Callback

                -- 1. Resolve Initial Value
                local initialValue
                if isMulti then
                    initialValue = {}
                    if type(rawDefault) == "table" then
                        for k, v in pairs(rawDefault) do
                            if type(k) == "number" and type(v) == "string" then
                                initialValue[v] = true
                            elseif type(k) == "string" and v == true then
                                initialValue[k] = true
                            end
                        end
                    elseif type(rawDefault) == "string" then
                        initialValue[rawDefault] = true
                    end
                else
                    if type(rawDefault) == "number" then
                        initialValue = values[rawDefault] or values[1] or ""
                    elseif type(rawDefault) == "string" then
                        initialValue = rawDefault
                    else
                        initialValue = values[1] or ""
                    end
                end

                local row = Instance.new("Frame")
                row.Size = UDim2.new(1, 0, 0, 38)
                row.BackgroundTransparency = 1
                row.Parent = container

                local label = Instance.new("TextLabel")
                label.Size = UDim2.new(1, 0, 0, 14)
                label.BackgroundTransparency = 1
                applyFont(label, "Medium")
                label.Text = text
                label.TextColor3 = theme.TextMuted
                label.TextSize = 10
                label.TextXAlignment = Enum.TextXAlignment.Left
                label.Parent = row

                local function getDisplayText(val)
                    if isMulti then
                        local selected = {}
                        for _, item in ipairs(values) do
                            if val and val[item] == true then
                                table.insert(selected, item)
                            end
                        end
                        return #selected > 0 and table.concat(selected, ", ") or "None selected"
                    else
                        return tostring(val or "")
                    end
                end

                local dropBtn = Instance.new("TextButton")
                dropBtn.Size = UDim2.new(1, 0, 0, 22)
                dropBtn.Position = UDim2.new(0, 0, 0, 16)
                dropBtn.BackgroundColor3 = theme.CardInner
                dropBtn.BorderSizePixel = 0
                applyFont(dropBtn, "Medium")
                dropBtn.Text = "  " .. getDisplayText(initialValue)
                dropBtn.TextColor3 = theme.TextMain
                dropBtn.TextSize = 10
                dropBtn.TextXAlignment = Enum.TextXAlignment.Left
                dropBtn.Parent = row

                local dCorner = Instance.new("UICorner")
                dCorner.CornerRadius = UDim.new(0, 4)
                dCorner.Parent = dropBtn

                local dStroke = Instance.new("UIStroke")
                dStroke.Color = theme.CardStroke
                dStroke.Thickness = 1
                dStroke.Parent = dropBtn

                local arrow = Instance.new("TextLabel")
                arrow.Size = UDim2.new(0, 16, 1, 0)
                arrow.Position = UDim2.new(1, -18, 0, 0)
                arrow.BackgroundTransparency = 1
                applyFont(arrow, "Bold")
                arrow.Text = "▼"
                arrow.TextColor3 = theme.TextMuted
                arrow.TextSize = 8
                arrow.Parent = dropBtn

                ZeroLib:RegisterThemeObject(label, "TextColor3", "TextMuted")
                ZeroLib:RegisterThemeObject(dropBtn, "BackgroundColor3", "CardInner")
                ZeroLib:RegisterThemeObject(dropBtn, "TextColor3", "TextMain")
                ZeroLib:RegisterThemeObject(dStroke, "Color", "CardStroke")

                local dropMenu = Instance.new("ScrollingFrame")
                dropMenu.Name = "DropMenu_" .. id
                dropMenu.Size = UDim2.new(0, 200, 0, 0)
                dropMenu.BackgroundColor3 = theme.CardBg
                dropMenu.BorderSizePixel = 0
                dropMenu.ClipsDescendants = true
                dropMenu.Visible = false
                dropMenu.ZIndex = 600
                dropMenu.ScrollBarThickness = 2
                dropMenu.Parent = ZeroLib.PopoverLayer

                local mCorner = Instance.new("UICorner")
                mCorner.CornerRadius = UDim.new(0, 4)
                mCorner.Parent = dropMenu

                local mStroke = Instance.new("UIStroke")
                mStroke.Color = theme.CardStroke
                mStroke.Thickness = 1
                mStroke.Parent = dropMenu

                local mLayout = Instance.new("UIListLayout")
                mLayout.Padding = UDim.new(0, 2)
                mLayout.SortOrder = Enum.SortOrder.LayoutOrder
                mLayout.Parent = dropMenu

                local DropObj = {
                    Value = initialValue,
                    Values = values,
                    Multi = isMulti,
                    Callbacks = callback and { callback } or {},
                    IsOpen = false,
                    LastCloseTime = 0,
                    Type = "Dropdown"
                }

                local function isItemSelected(valName)
                    if isMulti then
                        return DropObj.Value and DropObj.Value[valName] == true
                    else
                        return DropObj.Value == valName
                    end
                end

                local function rebuildMenu()
                    local curTheme = ZeroLib.Themes[ZeroLib.ActiveTheme]
                    for _, c in ipairs(dropMenu:GetChildren()) do
                        if c:IsA("TextButton") then c:Destroy() end
                    end

                    for _, v in ipairs(DropObj.Values) do
                        local selected = isItemSelected(v)
                        local itemBtn = Instance.new("TextButton")
                        itemBtn.Size = UDim2.new(1, -4, 0, 20)
                        itemBtn.Position = UDim2.new(0, 2, 0, 0)
                        itemBtn.BackgroundColor3 = selected and curTheme.CardInner or curTheme.CardBg
                        itemBtn.BackgroundTransparency = selected and 0 or 1
                        itemBtn.BorderSizePixel = 0
                        applyFont(itemBtn, "Medium")
                        itemBtn.Text = (isMulti and (selected and "  ✓ " or "  - ") or "  ") .. tostring(v)
                        itemBtn.TextColor3 = selected and curTheme.Accent or curTheme.TextMuted
                        itemBtn.TextSize = 10
                        itemBtn.TextXAlignment = Enum.TextXAlignment.Left
                        itemBtn.ZIndex = 601
                        itemBtn.Parent = dropMenu

                        local iCorner = Instance.new("UICorner")
                        iCorner.CornerRadius = UDim.new(0, 3)
                        iCorner.Parent = itemBtn

                        itemBtn.MouseButton1Click:Connect(function()
                            if isMulti then
                                if not DropObj.Value then DropObj.Value = {} end
                                if DropObj.Value[v] == true then
                                    DropObj.Value[v] = nil
                                else
                                    DropObj.Value[v] = true
                                end
                                DropObj:SetValue(DropObj.Value)
                                rebuildMenu()
                            else
                                DropObj:SetValue(v)
                                DropObj:ToggleMenu(false)
                            end
                        end)
                    end
                    dropMenu.CanvasSize = UDim2.new(0, 0, 0, #DropObj.Values * 22)
                end

                function DropObj:ToggleMenu(open)
                    if open == nil then open = not self.IsOpen end

                    local absPos = dropBtn.AbsolutePosition
                    local absSize = dropBtn.AbsoluteSize

                    if open then
                        if os.clock() - self.LastCloseTime < 0.15 then return end

                        if ZeroLib.ActivePopover and ZeroLib.ActivePopover.Close then
                            ZeroLib.ActivePopover.Close()
                        end

                        self.IsOpen = true
                        rebuildMenu()
                        dropMenu.Position = UDim2.new(0, absPos.X, 0, absPos.Y - 4)
                        dropMenu.Size = UDim2.new(0, absSize.X, 0, 0)
                        dropMenu.BackgroundTransparency = 0.4
                        dropMenu.Visible = true

                        local totalH = math.min(140, #DropObj.Values * 22 + 4)
                        tween(dropMenu, TweenInfo.new(0.18, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
                            Size = UDim2.new(0, absSize.X, 0, totalH),
                            Position = UDim2.new(0, absPos.X, 0, absPos.Y + absSize.Y + 3),
                            BackgroundTransparency = 0
                        })
                        tween(arrow, TweenInfo.new(0.18, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), { Rotation = 180 })

                        ZeroLib.ActivePopover = {
                            Instance = dropMenu,
                            Close = function() DropObj:ToggleMenu(false) end
                        }
                    else
                        self.IsOpen = false
                        self.LastCloseTime = os.clock()

                        tween(arrow, TweenInfo.new(0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Rotation = 0 })
                        local closeTw = tween(dropMenu, TweenInfo.new(0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                            Size = UDim2.new(0, absSize.X, 0, 0),
                            Position = UDim2.new(0, absPos.X, 0, absPos.Y - 3),
                            BackgroundTransparency = 0.5
                        })

                        closeTw.Completed:Connect(function()
                            if not self.IsOpen then dropMenu.Visible = false end
                        end)

                        if ZeroLib.ActivePopover and ZeroLib.ActivePopover.Instance == dropMenu then
                            ZeroLib.ActivePopover = nil
                        end
                    end
                end

                function DropObj:UpdateVisuals()
                    local curTheme = ZeroLib.Themes[ZeroLib.ActiveTheme]
                    dropBtn.BackgroundColor3 = curTheme.CardInner
                    dropBtn.TextColor3 = curTheme.TextMain
                    dStroke.Color = curTheme.CardStroke
                    dropMenu.BackgroundColor3 = curTheme.CardBg
                    mStroke.Color = curTheme.CardStroke
                    rebuildMenu()
                end

                function DropObj:SetValue(val)
                    if self.Multi then
                        if type(val) == "table" then
                            local dict = {}
                            for k, v in pairs(val) do
                                if type(k) == "number" and type(v) == "string" then
                                    dict[v] = true
                                elseif type(k) == "string" and v == true then
                                    dict[k] = true
                                end
                            end
                            self.Value = dict
                        elseif type(val) == "string" then
                            self.Value = { [val] = true }
                        end
                    else
                        if type(val) == "number" then
                            self.Value = self.Values[val] or self.Values[1] or ""
                        else
                            self.Value = val
                        end
                    end

                    dropBtn.Text = "  " .. getDisplayText(self.Value)
                    for _, fn in ipairs(self.Callbacks) do
                        pcall(fn, self.Value)
                    end
                end

                function DropObj:SetValues(newVals)
                    self.Values = newVals
                    if self.Multi then
                        self.Value = {}
                        self:SetValue({})
                    else
                        if not table.find(newVals, self.Value) then
                            self:SetValue(newVals[1] or "")
                        end
                    end
                    rebuildMenu()
                end

                function DropObj:OnChanged(fn)
                    table.insert(self.Callbacks, fn)
                end

                dropBtn.MouseButton1Click:Connect(function()
                    if DropObj.IsOpen then
                        DropObj:ToggleMenu(false)
                    else
                        DropObj:ToggleMenu(true)
                    end
                end)

                ZeroLib.Options[id] = DropObj
                return DropObj
            end

            -- 5. COMPACT INPUT
            function Group:AddInput(id, inputConfig)
                local text = inputConfig.Text or id
                local default = inputConfig.Default or ""
                local placeholder = inputConfig.Placeholder or "Type here..."
                local callback = inputConfig.Callback

                local row = Instance.new("Frame")
                row.Size = UDim2.new(1, 0, 0, 38)
                row.BackgroundTransparency = 1
                row.Parent = container

                local label = Instance.new("TextLabel")
                label.Size = UDim2.new(1, 0, 0, 14)
                label.BackgroundTransparency = 1
                applyFont(label, "Medium")
                label.Text = text
                label.TextColor3 = theme.TextMuted
                label.TextSize = 10
                label.TextXAlignment = Enum.TextXAlignment.Left
                label.Parent = row

                local boxFrame = Instance.new("Frame")
                boxFrame.Size = UDim2.new(1, 0, 0, 22)
                boxFrame.Position = UDim2.new(0, 0, 0, 16)
                boxFrame.BackgroundColor3 = theme.CardInner
                boxFrame.BorderSizePixel = 0
                boxFrame.Parent = row

                local bCorner = Instance.new("UICorner")
                bCorner.CornerRadius = UDim.new(0, 4)
                bCorner.Parent = boxFrame

                local boxStroke = Instance.new("UIStroke")
                boxStroke.Color = theme.CardStroke
                boxStroke.Thickness = 1
                boxStroke.Parent = boxFrame

                local textBox = Instance.new("TextBox")
                textBox.Size = UDim2.new(1, -12, 1, 0)
                textBox.Position = UDim2.new(0, 6, 0, 0)
                textBox.BackgroundTransparency = 1
                applyFont(textBox, "Regular")
                textBox.Text = default
                textBox.PlaceholderText = placeholder
                textBox.TextColor3 = theme.TextMain
                textBox.PlaceholderColor3 = theme.TextDark
                textBox.TextSize = 10
                textBox.TextXAlignment = Enum.TextXAlignment.Left
                textBox.Parent = boxFrame

                ZeroLib:RegisterThemeObject(label, "TextColor3", "TextMuted")
                ZeroLib:RegisterThemeObject(boxFrame, "BackgroundColor3", "CardInner")
                ZeroLib:RegisterThemeObject(boxStroke, "Color", "CardStroke")
                ZeroLib:RegisterThemeObject(textBox, "TextColor3", "TextMain")

                local InputObj = {
                    Value = default,
                    Callbacks = callback and { callback } or {},
                    Type = "Input"
                }

                function InputObj:SetValue(val)
                    self.Value = val
                    textBox.Text = tostring(val)
                    for _, fn in ipairs(self.Callbacks) do
                        pcall(fn, val)
                    end
                end

                function InputObj:OnChanged(fn)
                    table.insert(self.Callbacks, fn)
                end

                textBox.FocusLost:Connect(function()
                    InputObj.Value = textBox.Text
                    for _, fn in ipairs(InputObj.Callbacks) do
                        pcall(fn, textBox.Text)
                    end
                end)

                ZeroLib.Options[id] = InputObj
                return InputObj
            end

            -- 6. STANDALONE COLORPICKER
            function Group:AddColorPicker(id, cpConfig)
                local text = cpConfig.Text or id
                local defaultColor = cpConfig.Default or Color3.fromRGB(239, 68, 68)
                local callback = cpConfig.Callback

                local row = Instance.new("Frame")
                row.Size = UDim2.new(1, 0, 0, 22)
                row.BackgroundTransparency = 1
                row.Parent = container

                local label = Instance.new("TextLabel")
                label.Size = UDim2.new(1, -30, 1, 0)
                label.BackgroundTransparency = 1
                applyFont(label, "Medium")
                label.Text = text
                label.TextColor3 = theme.TextMuted
                label.TextSize = 10
                label.TextXAlignment = Enum.TextXAlignment.Left
                label.Parent = row

                local colorBox = Instance.new("TextButton")
                colorBox.Size = UDim2.new(0, 22, 0, 16)
                colorBox.Position = UDim2.new(1, -22, 0.5, -8)
                colorBox.BackgroundColor3 = defaultColor
                colorBox.BorderSizePixel = 0
                colorBox.Text = ""
                colorBox.Parent = row

                local cCorner = Instance.new("UICorner")
                cCorner.CornerRadius = UDim.new(0, 3)
                cCorner.Parent = colorBox

                local cStroke = Instance.new("UIStroke")
                cStroke.Color = theme.CardStroke
                cStroke.Thickness = 1
                cStroke.Parent = colorBox

                ZeroLib:RegisterThemeObject(label, "TextColor3", "TextMuted")
                ZeroLib:RegisterThemeObject(cStroke, "Color", "CardStroke")

                return createProColorPicker(id, defaultColor, callback, colorBox)
            end

            -- 7. LABEL & DIVIDER (WITH INLINE KEYPICKER / COLORPICKER SUPPORT)
            function Group:AddLabel(text)
                local row = Instance.new("Frame")
                row.Size = UDim2.new(1, 0, 0, 18)
                row.BackgroundTransparency = 1
                row.Parent = container

                local label = Instance.new("TextLabel")
                label.Size = UDim2.new(1, -50, 1, 0)
                label.BackgroundTransparency = 1
                applyFont(label, "Regular")
                label.Text = text
                label.TextColor3 = theme.TextMuted
                label.TextSize = 10
                label.TextWrapped = true
                label.TextXAlignment = Enum.TextXAlignment.Left
                label.Parent = row

                ZeroLib:RegisterThemeObject(label, "TextColor3", "TextMuted")

                local subContainer = Instance.new("Frame")
                subContainer.Size = UDim2.new(0, 50, 1, 0)
                subContainer.Position = UDim2.new(1, -50, 0, 0)
                subContainer.BackgroundTransparency = 1
                subContainer.Parent = row

                local subLayout = Instance.new("UIListLayout")
                subLayout.FillDirection = Enum.FillDirection.Horizontal
                subLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
                subLayout.VerticalAlignment = Enum.VerticalAlignment.Center
                subLayout.Padding = UDim.new(0, 4)
                subLayout.Parent = subContainer

                local LabelObj = {
                    Instance = label,
                    Row = row,
                    Text = text
                }

                function LabelObj:SetText(newTxt)
                    self.Text = newTxt
                    label.Text = newTxt
                end

                function LabelObj:AddKeybind(kbId, kbConfig)
                    kbConfig = kbConfig or {}
                    local rawDefault = kbConfig.Default
                    local kbDefault = Enum.KeyCode.Unknown
                    if typeof(rawDefault) == "EnumItem" then
                        kbDefault = rawDefault
                    elseif type(rawDefault) == "string" then
                        kbDefault = Enum.KeyCode[rawDefault] or Enum.KeyCode.Unknown
                    end

                    local kbMode = kbConfig.Mode or "Toggle"
                    local kbCallback = kbConfig.Callback

                    local kbBtn = Instance.new("TextButton")
                    kbBtn.Size = UDim2.new(0, 36, 0, 15)
                    kbBtn.BackgroundColor3 = theme.CardInner
                    kbBtn.BorderSizePixel = 0
                    applyFont(kbBtn, "Bold")
                    kbBtn.Text = kbDefault.Name ~= "Unknown" and kbDefault.Name or "NONE"
                    kbBtn.TextColor3 = theme.TextMuted
                    kbBtn.TextSize = 8.5
                    kbBtn.Parent = subContainer

                    local kCorner = Instance.new("UICorner")
                    kCorner.CornerRadius = UDim.new(0, 3)
                    kCorner.Parent = kbBtn

                    local kStroke = Instance.new("UIStroke")
                    kStroke.Color = theme.CardStroke
                    kStroke.Thickness = 1
                    kStroke.Parent = kbBtn

                    ZeroLib:RegisterThemeObject(kbBtn, "BackgroundColor3", "CardInner")
                    ZeroLib:RegisterThemeObject(kStroke, "Color", "CardStroke")

                    local KeybindObj = {
                        Value = kbDefault,
                        Mode = kbMode,
                        Binding = false,
                        Callbacks = kbCallback and { kbCallback } or {},
                        Type = "Keybind"
                    }

                    function KeybindObj:OnChanged(fn)
                        table.insert(self.Callbacks, fn)
                    end

                    function KeybindObj:SetValue(key)
                        if typeof(key) == "EnumItem" then
                            self.Value = key
                        elseif type(key) == "string" then
                            self.Value = Enum.KeyCode[key] or Enum.KeyCode.Unknown
                        end
                        kbBtn.Text = self.Value.Name ~= "Unknown" and self.Value.Name or "NONE"
                        for _, fn in ipairs(self.Callbacks) do
                            pcall(fn, self.Value)
                        end
                    end

                    kbBtn.MouseButton1Click:Connect(function()
                        KeybindObj.Binding = true
                        kbBtn.Text = "..."
                        kbBtn.TextColor3 = ZeroLib.Themes[ZeroLib.ActiveTheme].Accent
                    end)

                    local kbConn = UserInputService.InputBegan:Connect(function(input, gpe)
                        if KeybindObj.Binding and not gpe then
                            if input.UserInputType == Enum.UserInputType.Keyboard then
                                KeybindObj.Binding = false
                                if input.KeyCode == Enum.KeyCode.Escape then
                                    KeybindObj:SetValue(Enum.KeyCode.Unknown)
                                else
                                    KeybindObj:SetValue(input.KeyCode)
                                end
                                kbBtn.TextColor3 = ZeroLib.Themes[ZeroLib.ActiveTheme].TextMuted
                            end
                        elseif not gpe and input.KeyCode == KeybindObj.Value and KeybindObj.Value ~= Enum.KeyCode.Unknown then
                            for _, fn in ipairs(KeybindObj.Callbacks) do
                                pcall(fn, KeybindObj.Value)
                            end
                        end
                    end)
                    table.insert(ZeroLib.Connections, kbConn)

                    ZeroLib.Options[kbId] = KeybindObj
                    return KeybindObj
                end

                LabelObj.AddKeyPicker = LabelObj.AddKeybind

                function LabelObj:AddColorPicker(cpId, cpConfig)
                    local cpDefault = cpConfig.Default or Color3.fromRGB(239, 68, 68)
                    local cpCallback = cpConfig.Callback

                    local colorBox = Instance.new("TextButton")
                    colorBox.Size = UDim2.new(0, 16, 0, 15)
                    colorBox.BackgroundColor3 = cpDefault
                    colorBox.BorderSizePixel = 0
                    colorBox.Text = ""
                    colorBox.Parent = subContainer

                    local cCorner = Instance.new("UICorner")
                    cCorner.CornerRadius = UDim.new(0, 3)
                    cCorner.Parent = colorBox

                    local cStroke = Instance.new("UIStroke")
                    cStroke.Color = theme.CardStroke
                    cStroke.Thickness = 1
                    cStroke.Parent = colorBox

                    ZeroLib:RegisterThemeObject(cStroke, "Color", "CardStroke")

                    return createProColorPicker(cpId, cpDefault, cpCallback, colorBox)
                end

                setmetatable(LabelObj, {
                    __index = function(t, k)
                        return label[k]
                    end,
                    __newindex = function(t, k, v)
                        label[k] = v
                    end
                })

                return LabelObj
            end

            function Group:AddDivider()
                local div = Instance.new("Frame")
                div.Size = UDim2.new(1, 0, 0, 1)
                div.BackgroundColor3 = theme.CardStroke
                div.BorderSizePixel = 0
                div.Parent = container

                ZeroLib:RegisterThemeObject(div, "BackgroundColor3", "CardStroke")
                return div
            end

            return Group
        end

        function Tab:AddLeftGroupbox(title)
            return createGroupbox(leftColumn, title)
        end

        function Tab:AddRightGroupbox(title)
            return createGroupbox(rightColumn, title)
        end

        table.insert(Window.Tabs, Tab)

        if #Window.Tabs == 1 then
            Tab:Select()
        end

        return Tab
    end

    return Window
end

-- =============================================================================
-- CONFIG SYSTEM
-- =============================================================================
local ConfigManager = { Folder = "arcane_configs" }

function ConfigManager:Init()
    if makefolder and not isfolder(self.Folder) then makefolder(self.Folder) end
end

function ConfigManager:Save(name)
    self:Init()
    local data = { Toggles = {}, Options = {} }

    for k, v in pairs(ZeroLib.Toggles) do
        data.Toggles[k] = v.Value
    end

    for k, v in pairs(ZeroLib.Options) do
        if v.Type == "Slider" or v.Type == "Input" or v.Type == "Dropdown" then
            data.Options[k] = v.Value
        elseif v.Type == "Keybind" then
            data.Options[k] = v.Value.Name
        elseif v.Type == "ColorPicker" then
            data.Options[k] = v.Value:ToHex()
        end
    end

    local json = HttpService:JSONEncode(data)
    if writefile then
        writefile(self.Folder .. "/" .. name .. ".json", json)
        ZeroLib:Notify({ Title = "Config Saved", Content = "Đã lưu config: " .. name, Type = "Success" })
    end
end

function ConfigManager:Load(name)
    self:Init()
    local path = self.Folder .. "/" .. name .. ".json"
    if readfile and isfile and isfile(path) then
        local json = readfile(path)
        local ok, data = pcall(HttpService.JSONDecode, HttpService, json)
        if ok and data then
            if data.Toggles then
                for k, v in pairs(data.Toggles) do
                    if ZeroLib.Toggles[k] then ZeroLib.Toggles[k]:SetValue(v) end
                end
            end
            if data.Options then
                for k, v in pairs(data.Options) do
                    if ZeroLib.Options[k] then
                        if ZeroLib.Options[k].Type == "Keybind" then
                            local key = Enum.KeyCode[v] or Enum.KeyCode.Unknown
                            ZeroLib.Options[k]:SetValue(key)
                        elseif ZeroLib.Options[k].Type == "ColorPicker" then
                            local col = Color3.fromHex(v)
                            if col then ZeroLib.Options[k]:SetValue(col) end
                        else
                            ZeroLib.Options[k]:SetValue(v)
                        end
                    end
                end
            end
            ZeroLib:Notify({ Title = "Config Loaded", Content = "Đã nạp config: " .. name, Type = "Success" })
        end
    else
        ZeroLib:Notify({ Title = "Config Error", Content = "Không tìm thấy file config: " .. name, Type = "Error" })
    end
end

function ConfigManager:GetConfigs()
    self:Init()
    local list = {}
    if listfiles then
        for _, p in ipairs(listfiles(self.Folder)) do
            local fName = p:match("([^/\\\\]+)%.json$")
            if fName then table.insert(list, fName) end
        end
    end
    return #list > 0 and list or {"default"}
end

ZeroLib.ConfigManager = ConfigManager

return ZeroLib
