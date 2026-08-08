-- ====================================================================================
-- ZARSHUB | AUTO SPRINKLER v2.0
-- Game: Grow a Garden
-- ====================================================================================

local Players           = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService      = game:GetService("TweenService")
local UserInputService  = game:GetService("UserInputService")
local CoreGui           = (typeof(gethui) == "function") and gethui() or game:GetService("CoreGui")
local LocalPlayer       = Players.LocalPlayer

if CoreGui:FindFirstChild("ZarsHubSprinkler") then CoreGui.ZarsHubSprinkler:Destroy() end

-- ====================================================================================
-- THEME
-- ====================================================================================
local T = {
    BG          = Color3.fromRGB(13, 15, 25),
    Surface     = Color3.fromRGB(18, 22, 36),
    Card        = Color3.fromRGB(22, 28, 46),
    CardHover   = Color3.fromRGB(28, 36, 58),
    Border      = Color3.fromRGB(38, 50, 85),
    Accent      = Color3.fromRGB(99, 102, 241),
    AccentDim   = Color3.fromRGB(55, 58, 150),
    AccentGlow  = Color3.fromRGB(129, 132, 255),
    Green       = Color3.fromRGB(52, 211, 153),
    GreenDim    = Color3.fromRGB(20, 90, 65),
    Red         = Color3.fromRGB(248, 113, 113),
    RedDim      = Color3.fromRGB(120, 40, 40),
    Yellow      = Color3.fromRGB(251, 191, 36),
    Toggle      = Color3.fromRGB(37, 99, 235),
    TextPrimary = Color3.fromRGB(241, 245, 249),
    TextSub     = Color3.fromRGB(100, 120, 160),
    TextMuted   = Color3.fromRGB(60, 75, 110),
}

-- ====================================================================================
-- HELPERS
-- ====================================================================================
local function corner(p, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r or 8)
    c.Parent = p; return c
end

local function stroke(p, col, thick)
    local s = Instance.new("UIStroke")
    s.Color = col or T.Border; s.Thickness = thick or 1
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Parent = p; return s
end

local function tw(obj, props, t, style)
    TweenService:Create(obj,
        TweenInfo.new(t or 0.15, style or Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        props):Play()
end

local function uipad(p, all)
    local u = Instance.new("UIPadding")
    u.PaddingTop    = UDim.new(0, all)
    u.PaddingBottom = UDim.new(0, all)
    u.PaddingLeft   = UDim.new(0, all)
    u.PaddingRight  = UDim.new(0, all)
    u.Parent = p; return u
end

local function vlist(p, pad)
    local l = Instance.new("UIListLayout")
    l.FillDirection = Enum.FillDirection.Vertical
    l.SortOrder = Enum.SortOrder.LayoutOrder
    l.Padding = UDim.new(0, pad or 0)
    l.Parent = p; return l
end

local function hlist(p, pad)
    local l = Instance.new("UIListLayout")
    l.FillDirection = Enum.FillDirection.Horizontal
    l.SortOrder = Enum.SortOrder.LayoutOrder
    l.VerticalAlignment = Enum.VerticalAlignment.Center
    l.Padding = UDim.new(0, pad or 0)
    l.Parent = p; return l
end

-- ====================================================================================
-- ROOT
-- ====================================================================================
local Root = Instance.new("ScreenGui")
Root.Name = "ZarsHubSprinkler"; Root.ResetOnSpawn = false
Root.ZIndexBehavior = Enum.ZIndexBehavior.Global
Root.DisplayOrder = 99; Root.Parent = CoreGui

-- ====================================================================================
-- SIDEBAR
-- ====================================================================================
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 44, 0, 340)
Sidebar.Position = UDim2.new(0.5, -240, 0.5, -170)
Sidebar.BackgroundColor3 = T.Surface
Sidebar.BorderSizePixel = 0; Sidebar.ZIndex = 10; Sidebar.Parent = Root
corner(Sidebar, 10); stroke(Sidebar, T.Border)

local SBList = Instance.new("UIListLayout")
SBList.FillDirection = Enum.FillDirection.Vertical
SBList.SortOrder = Enum.SortOrder.LayoutOrder
SBList.Padding = UDim.new(0, 4)
SBList.HorizontalAlignment = Enum.HorizontalAlignment.Center
SBList.Parent = Sidebar
uipad(Sidebar, 8)

local SBLogo = Instance.new("Frame")
SBLogo.Size = UDim2.new(0, 28, 0, 28)
SBLogo.BackgroundColor3 = T.Accent
SBLogo.BorderSizePixel = 0; SBLogo.LayoutOrder = 1; SBLogo.ZIndex = 11; SBLogo.Parent = Sidebar
corner(SBLogo, 8)

local SBLogoTxt = Instance.new("TextLabel")
SBLogoTxt.Size = UDim2.new(1,0,1,0)
SBLogoTxt.BackgroundTransparency = 1; SBLogoTxt.Text = "Z"
SBLogoTxt.TextColor3 = Color3.fromRGB(255,255,255); SBLogoTxt.TextSize = 14
SBLogoTxt.Font = Enum.Font.GothamBold
SBLogoTxt.TextXAlignment = Enum.TextXAlignment.Center
SBLogoTxt.ZIndex = 12; SBLogoTxt.Parent = SBLogo

local navItems = {
    {icon="🏠", label="Main"},
    {icon="🛒", label="Shop"},
    {icon="🔗", label="Webhook"},
    {icon="🔄", label="Trade"},
    {icon="⚙️", label="Misc", active=true},
    {icon="🍂", label="Fall"},
    {icon="🐾", label="Pets"},
    {icon="⚙", label="Settings"},
}

for i, nav in ipairs(navItems) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 28, 0, 28)
    btn.BackgroundColor3 = nav.active and T.Accent or Color3.fromRGB(0,0,0)
    btn.BackgroundTransparency = nav.active and 0 or 0.8
    btn.Text = nav.icon
    btn.TextSize = 14; btn.Font = Enum.Font.GothamBold
    btn.LayoutOrder = i + 1; btn.ZIndex = 11; btn.Parent = Sidebar
    corner(btn, 6)
    btn.MouseEnter:Connect(function()
        if not nav.active then tw(btn,{BackgroundTransparency=0.5}) end
    end)
    btn.MouseLeave:Connect(function()
        if not nav.active then tw(btn,{BackgroundTransparency=0.8}) end
    end)
end

-- ====================================================================================
-- MAIN PANEL
-- ====================================================================================
local Win = Instance.new("Frame")
Win.Name = "Window"
Win.Size = UDim2.new(0, 390, 0, 340)
Win.Position = UDim2.new(0.5, -196, 0.5, -170)
Win.BackgroundColor3 = T.BG
Win.BorderSizePixel = 0; Win.Active = true; Win.Draggable = true
Win.ClipsDescendants = false; Win.ZIndex = 10; Win.Parent = Root
corner(Win, 10); stroke(Win, T.Border, 1.5)

local TopLine = Instance.new("Frame")
TopLine.Size = UDim2.new(1, -60, 0, 2)
TopLine.Position = UDim2.new(0, 30, 0, 0)
TopLine.BackgroundColor3 = T.Accent
TopLine.BackgroundTransparency = 0.5
TopLine.BorderSizePixel = 0; TopLine.ZIndex = 12; TopLine.Parent = Win
corner(TopLine, 1)

-- ====================================================================================
-- HEADER
-- ====================================================================================
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 44)
Header.BackgroundColor3 = T.Surface
Header.BorderSizePixel = 0; Header.ZIndex = 11; Header.Parent = Win
corner(Header, 10)

local HFix = Instance.new("Frame")
HFix.Size = UDim2.new(1, 0, 0, 10); HFix.Position = UDim2.new(0, 0, 1, -10)
HFix.BackgroundColor3 = T.Surface; HFix.BorderSizePixel = 0; HFix.ZIndex = 11; HFix.Parent = Header

local BreadFrame = Instance.new("Frame")
BreadFrame.Size = UDim2.new(1, -80, 1, 0)
BreadFrame.Position = UDim2.new(0, 12, 0, 0)
BreadFrame.BackgroundTransparency = 1; BreadFrame.ZIndex = 12; BreadFrame.Parent = Header
hlist(BreadFrame, 6)

local Brand = Instance.new("TextLabel")
Brand.Size = UDim2.new(0, 70, 1, 0)
Brand.BackgroundTransparency = 1; Brand.Text = "ZarsHub"
Brand.TextColor3 = T.TextPrimary; Brand.TextSize = 13
Brand.Font = Enum.Font.GothamBold
Brand.TextXAlignment = Enum.TextXAlignment.Left
Brand.ZIndex = 12; Brand.Parent = BreadFrame

local GameBadge = Instance.new("Frame")
GameBadge.Size = UDim2.new(0, 110, 0, 22)
GameBadge.BackgroundColor3 = T.AccentDim
GameBadge.BorderSizePixel = 0; GameBadge.ZIndex = 12; GameBadge.Parent = BreadFrame
corner(GameBadge, 11)

local GameBadgeTxt = Instance.new("TextLabel")
GameBadgeTxt.Size = UDim2.new(1, 0, 1, 0)
GameBadgeTxt.BackgroundTransparency = 1; GameBadgeTxt.Text = "Grow a Garden"
GameBadgeTxt.TextColor3 = T.AccentGlow; GameBadgeTxt.TextSize = 10
GameBadgeTxt.Font = Enum.Font.GothamBold
GameBadgeTxt.TextXAlignment = Enum.TextXAlignment.Center
GameBadgeTxt.ZIndex = 13; GameBadgeTxt.Parent = GameBadge

local function hBtn(xOff, bg, sym)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0, 24, 0, 24)
    b.Position = UDim2.new(1, xOff, 0.5, -12)
    b.BackgroundColor3 = bg; b.Text = sym
    b.TextColor3 = Color3.fromRGB(255,255,255)
    b.TextSize = 10; b.Font = Enum.Font.GothamBold
    b.ZIndex = 13; b.Parent = Header; corner(b, 5)
    b.MouseEnter:Connect(function() tw(b,{BackgroundTransparency=0.3}) end)
    b.MouseLeave:Connect(function() tw(b,{BackgroundTransparency=0}) end)
    return b
end

local BtnX   = hBtn(-8,  T.Red,    "✕")
local BtnMin = hBtn(-36, T.Yellow, "−")
local BtnMax = hBtn(-64, Color3.fromRGB(40,50,80), "□")

BtnX.MouseButton1Click:Connect(function()
    tw(Win, {BackgroundTransparency=1}, 0.2)
    task.delay(0.22, function() Root:Destroy() end)
end)

local isMinimized = false
BtnMin.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    if isMinimized then
        tw(Win, {Size=UDim2.new(0,390,0,44)}, 0.2)
    else
        tw(Win, {Size=UDim2.new(0,390,0,340)}, 0.2)
    end
end)
BtnMax.MouseButton1Click:Connect(function()
    tw(Win, {Size=UDim2.new(0,460,0,420)}, 0.2, Enum.EasingStyle.Back)
end)

-- ====================================================================================
-- SECTION LABEL
-- ====================================================================================
local SectionHeader = Instance.new("Frame")
SectionHeader.Size = UDim2.new(1, -24, 0, 36)
SectionHeader.Position = UDim2.new(0, 12, 0, 50)
SectionHeader.BackgroundColor3 = T.Surface
SectionHeader.BorderSizePixel = 0; SectionHeader.ZIndex = 11; SectionHeader.Parent = Win
corner(SectionHeader, 8); stroke(SectionHeader, T.Border)

local SHInner = Instance.new("Frame")
SHInner.Size = UDim2.new(1, -20, 1, 0)
SHInner.Position = UDim2.new(0, 10, 0, 0)
SHInner.BackgroundTransparency = 1; SHInner.ZIndex = 12; SHInner.Parent = SectionHeader
hlist(SHInner, 8)

local SHDot = Instance.new("Frame")
SHDot.Size = UDim2.new(0, 8, 0, 8)
SHDot.BackgroundColor3 = T.Accent; SHDot.BorderSizePixel = 0
SHDot.ZIndex = 13; SHDot.Parent = SHInner; corner(SHDot, 4)

local SHTitle = Instance.new("TextLabel")
SHTitle.Size = UDim2.new(0, 200, 1, 0)
SHTitle.BackgroundTransparency = 1; SHTitle.Text = "Auto Sprinkler"
SHTitle.TextColor3 = T.TextPrimary; SHTitle.TextSize = 13
SHTitle.Font = Enum.Font.GothamBold
SHTitle.TextXAlignment = Enum.TextXAlignment.Left
SHTitle.ZIndex = 13; SHTitle.Parent = SHInner

local VerBadge = Instance.new("Frame")
VerBadge.Size = UDim2.new(0, 36, 0, 18)
VerBadge.BackgroundColor3 = T.Card; VerBadge.BorderSizePixel = 0
VerBadge.ZIndex = 13; VerBadge.Parent = SHInner; corner(VerBadge, 5)
local VerTxt = Instance.new("TextLabel")
VerTxt.Size = UDim2.new(1,0,1,0); VerTxt.BackgroundTransparency = 1
VerTxt.Text = "v2.0"; VerTxt.TextColor3 = T.TextMuted; VerTxt.TextSize = 9
VerTxt.Font = Enum.Font.Gotham; VerTxt.TextXAlignment = Enum.TextXAlignment.Center
VerTxt.ZIndex = 14; VerTxt.Parent = VerBadge

-- ====================================================================================
-- SCROLL CONTENT
-- ====================================================================================
local Content = Instance.new("ScrollingFrame")
Content.Size = UDim2.new(1, -24, 1, -96)
Content.Position = UDim2.new(0, 12, 0, 92)
Content.BackgroundTransparency = 1; Content.BorderSizePixel = 0
Content.ScrollBarThickness = 3; Content.ScrollBarImageColor3 = T.AccentDim
Content.CanvasSize = UDim2.new(0,0,0,0); Content.AutomaticCanvasSize = Enum.AutomaticSize.Y
Content.ClipsDescendants = false; Content.ZIndex = 10; Content.Parent = Win
vlist(Content, 0)

-- ====================================================================================
-- ROW BUILDERS
-- ====================================================================================
local function makeRow(labelText, order)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 40)
    row.BackgroundColor3 = T.Card
    row.BorderSizePixel = 0; row.LayoutOrder = order; row.ZIndex = 11; row.Parent = Content

    if order % 2 == 0 then
        row.BackgroundColor3 = T.Surface
    end

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0.52, -10, 1, 0)
    lbl.Position = UDim2.new(0, 12, 0, 0)
    lbl.BackgroundTransparency = 1; lbl.Text = labelText
    lbl.TextColor3 = T.TextPrimary; lbl.TextSize = 11
    lbl.Font = Enum.Font.GothamMedium
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.ZIndex = 12; lbl.Parent = row

    local sep = Instance.new("Frame")
    sep.Size = UDim2.new(1, 0, 0, 1); sep.Position = UDim2.new(0, 0, 1, -1)
    sep.BackgroundColor3 = T.Border; sep.BackgroundTransparency = 0.6
    sep.BorderSizePixel = 0; sep.ZIndex = 11; sep.Parent = row

    return row
end

local function makeToggle(row, defaultOn, onChange)
    local track = Instance.new("Frame")
    track.Size = UDim2.new(0, 38, 0, 20)
    track.Position = UDim2.new(1, -50, 0.5, -10)
    track.BackgroundColor3 = defaultOn and T.Toggle or T.Border
    track.BorderSizePixel = 0; track.ZIndex = 13; track.Parent = row
    corner(track, 10)

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 16, 0, 16)
    knob.Position = defaultOn and UDim2.new(1,-18,0.5,-8) or UDim2.new(0,2,0.5,-8)
    knob.BackgroundColor3 = Color3.fromRGB(255,255,255)
    knob.BorderSizePixel = 0; knob.ZIndex = 14; knob.Parent = track
    corner(knob, 8)

    local state = defaultOn
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1,0,1,0); btn.BackgroundTransparency = 1
    btn.Text = ""; btn.ZIndex = 15; btn.Parent = track

    btn.MouseButton1Click:Connect(function()
        state = not state
        tw(track, {BackgroundColor3 = state and T.Toggle or T.Border})
        tw(knob, {Position = state and UDim2.new(1,-18,0.5,-8) or UDim2.new(0,2,0.5,-8)})
        if onChange then onChange(state) end
    end)

    return function() return state end
end

-- Global Dropdown Handler
local GDrop = Instance.new("ScrollingFrame")
GDrop.BackgroundColor3 = T.Card; GDrop.BorderSizePixel = 0
GDrop.Visible = false; GDrop.ZIndex = 300
GDrop.CanvasSize = UDim2.new(0,0,0,0); GDrop.AutomaticCanvasSize = Enum.AutomaticSize.Y
GDrop.ScrollBarThickness = 3; GDrop.ScrollBarImageColor3 = T.AccentDim
GDrop.Parent = Root; corner(GDrop, 8); stroke(GDrop, T.Border)
uipad(GDrop, 4)
vlist(GDrop, 2)

UserInputService.InputBegan:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseButton1
    or inp.UserInputType == Enum.UserInputType.Touch then
        task.defer(function() GDrop.Visible = false end)
    end
end)

local function openDrop(anchor, items, onSelect)
    for _, c in ipairs(GDrop:GetChildren()) do
        if c:IsA("TextButton") or c:IsA("TextLabel") then c:Destroy() end
    end
    local ap = anchor.AbsolutePosition; local as = anchor.AbsoluteSize
    GDrop.Position = UDim2.new(0, ap.X, 0, ap.Y + as.Y + 3)
    GDrop.Size     = UDim2.new(0, as.X, 0, math.min(#items * 26 + 8, 160))
    GDrop.Visible  = true
    for _, name in ipairs(items) do
        local opt = Instance.new("TextButton")
        opt.Size = UDim2.new(1,0,0,24); opt.BackgroundColor3 = T.Card
        opt.Text = "  "..name; opt.TextColor3 = T.TextPrimary; opt.TextSize = 11
        opt.Font = Enum.Font.Gotham; opt.TextXAlignment = Enum.TextXAlignment.Left
        opt.ZIndex = 301; opt.Parent = GDrop; corner(opt,5)
        opt.MouseEnter:Connect(function() tw(opt,{BackgroundColor3=T.CardHover}) end)
        opt.MouseLeave:Connect(function() tw(opt,{BackgroundColor3=T.Card}) end)
        opt.MouseButton1Click:Connect(function()
            GDrop.Visible=false; if onSelect then onSelect(name) end
        end)
    end
end

local function makeDropRow(labelText, items, default, order)
    local row = makeRow(labelText, order)

    local dropBtn = Instance.new("TextButton")
    dropBtn.Size = UDim2.new(0.44, -12, 0, 26)
    dropBtn.Position = UDim2.new(0.54, 0, 0.5, -13)
    dropBtn.BackgroundColor3 = T.Surface; dropBtn.Text = default .. "  ▾"
    dropBtn.TextColor3 = T.Accent; dropBtn.TextSize = 10
    dropBtn.Font = Enum.Font.GothamMedium
    dropBtn.TextXAlignment = Enum.TextXAlignment.Center
    dropBtn.ZIndex = 13; dropBtn.Parent = row; corner(dropBtn, 6); stroke(dropBtn, T.Border)

    local selected = default

    dropBtn.MouseButton1Click:Connect(function()
        if GDrop.Visible then GDrop.Visible=false; return end
        openDrop(dropBtn, items, function(name)
            selected = name
            local display = #name > 16 and name:sub(1,14).."…" or name
            dropBtn.Text = display .. "  ▾"
        end)
    end)

    return function() return selected end
end

-- ====================================================================================
-- RANGKAIAN MENU (UI ELEMENT)
-- ====================================================================================
local sprinklerList = {
    "Common Sprinkler", "Uncommon Sprinkler", "Rare Sprinkler", 
    "Legendary Sprinkler", "Super Sprinkler", "Syrup Sprinkler", "Super Syrup Sprinkler"
}
local plantList = {
    "Atlantic Giant Pumpkin", "Giant Pumpkin", "Watermelon", "Carrot"
}

local getSelectedSprinkler = makeDropRow("Select Sprinkler", sprinklerList, "Super Syrup Sprinkler", 1)
local getSelectedPlant     = makeDropRow("Target Plant", plantList, "Atlantic Giant Pumpkin", 2)

-- Status Row
local statusRow = makeRow("Status Automation", 3)
local statusVal = Instance.new("TextLabel")
statusVal.Size = UDim2.new(0.44, -12, 0, 26)
statusVal.Position = UDim2.new(0.54, 0, 0.5, -13)
statusVal.BackgroundTransparency = 1; statusVal.Text = "IDLE"
statusVal.TextColor3 = T.Yellow; statusVal.TextSize = 11
statusVal.Font = Enum.Font.GothamBold
statusVal.TextXAlignment = Enum.TextXAlignment.Center
statusVal.ZIndex = 13; statusVal.Parent = statusRow

-- Master Toggle Row
local toggleRow = makeRow("Enable Auto Sprinkler", 4)
local getAutoState = makeToggle(toggleRow, false, function(state)
    if state then
        statusVal.Text = "RUNNING"
        statusVal.TextColor3 = T.Green
    else
        statusVal.Text = "IDLE"
        statusVal.TextColor3 = T.Yellow
    end
end)

-- ====================================================================================
-- LOGIKA AUTOMATION (PLOT SCANNER & BUFFER FIRE)
-- ====================================================================================
local function getClosestPlant(plantName)
    local character = LocalPlayer.Character
    local hrpPos = character and character:FindFirstChild("HumanoidRootPart") and character.HumanoidRootPart.Position or Vector3.new(0, 0, 0)

    local plots = workspace:FindFirstChild("Plots")
    if not plots then return nil end
    
    local myPlot = plots:FindFirstChild(LocalPlayer.Name) or plots:FindFirstChild(tostring(LocalPlayer.UserId))
    local searchFolder = myPlot or workspace
    
    local closestPlant = nil
    local shortestDist = math.huge
    local targetNameLower = string.lower(plantName)

    for _, obj in ipairs(searchFolder:GetDescendants()) do
        if obj:IsA("Model") then
            local objNameLower = string.lower(obj.Name)
            if string.find(objNameLower, targetNameLower) or string.find(objNameLower, "pumpkin") or string.find(objNameLower, "seed") then
                local rootPart = obj:FindFirstChild("Base") or obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
                if rootPart then
                    local dist = (hrpPos - rootPart.Position).Magnitude
                    if dist < 120 and dist < shortestDist then
                        shortestDist = dist
                        closestPlant = obj
                    end
                end
            end
        end
    end
    return closestPlant
end

local function placeSprinklerEvent(sprinklerName, plantModel)
    local character = LocalPlayer.Character
    local backpack = LocalPlayer:FindFirstChild("Backpack")
    if not character or not backpack then return false end

    local sprinklerTool = backpack:FindFirstChild(sprinklerName) or character:FindFirstChild(sprinklerName)
    if not sprinklerTool then return false end

    local targetPart = plantModel:FindFirstChild("Base") or plantModel.PrimaryPart or plantModel:FindFirstChildWhichIsA("BasePart")
    if not targetPart then return false end
    
    local placePosition = targetPart.Position + Vector3.new(3, 0, 3)

    local success = pcall(function()
        local nameLength = #sprinklerName
        local buf = buffer.create(16 + nameLength)
        
        buffer.writeu8(buf, 0, 44) 
        buffer.writeu8(buf, 1, 0)
        buffer.writef32(buf, 2, placePosition.X)
        buffer.writef32(buf, 6, placePosition.Y)
        buffer.writef32(buf, 10, placePosition.Z)
        buffer.writeu8(buf, 14, nameLength)
        buffer.writestring(buf, 15, sprinklerName)
        buffer.writeu8(buf, 15 + nameLength, 1)

        local remoteEvent = ReplicatedStorage:FindFirstChild("SharedModules")
            and ReplicatedStorage.SharedModules:FindFirstChild("Packet")
            and ReplicatedStorage.SharedModules.Packet:FindFirstChild("RemoteEvent")

        if remoteEvent then
            remoteEvent:FireServer(buf, { sprinklerTool })
        end
    end)

    return success
end

-- Loop Eksekusi Utama
task.spawn(function()
    local timeLeft = 0
    while true do
        task.wait(1)
        if getAutoState() then
            if timeLeft <= 0 then
                local curSprinkler = getSelectedSprinkler()
                local curPlant     = getSelectedPlant()
                local targetObj    = getClosestPlant(curPlant)
                
                if targetObj then
                    statusVal.Text = "Placing..."
                    statusVal.TextColor3 = T.AccentGlow
                    
                    local success = placeSprinklerEvent(curSprinkler, targetObj)
                    if success then
                        timeLeft = 120
                    else
                        statusVal.Text = "Tool Empty!"
                        statusVal.TextColor3 = T.Red
                        task.wait(3)
                    end
                else
                    statusVal.Text = "Plant Not Found"
                    statusVal.TextColor3 = T.Red
                    task.wait(2)
                end
            else
                timeLeft = timeLeft - 1
                statusVal.Text = string.format("Next: %02d:%02d", math.floor(timeLeft/60), timeLeft%60)
                statusVal.TextColor3 = T.Green
            end
        end
    end
end)
