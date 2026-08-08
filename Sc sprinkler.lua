-- ====================================================================================
-- ZHARHUB AUTO SPRINKLER (FINAL COMBINED & FIXED PLANT DETECTOR)
-- ====================================================================================

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CoreGui = game:GetService("CoreGui")
local PlayersGui = Players.LocalPlayer:WaitForChild("PlayerGui")

local player = Players.LocalPlayer

-- Coba bersihkan UI lama jika ada
pcall(function()
    if CoreGui:FindFirstChild("ZharHubSprinkler") then CoreGui.ZharHubSprinkler:Destroy() end
    if PlayersGui:FindFirstChild("ZharHubSprinkler") then PlayersGui.ZharHubSprinkler:Destroy() end
end)

-- Memilih wadah GUI yang paling aman agar pasti muncul
local targetParent = pcall(function() return CoreGui end) and CoreGui or PlayersGui

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ZharHubSprinkler"
screenGui.ResetOnSpawn = false
screenGui.Parent = targetParent

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 350, 0, 320)
mainFrame.Position = UDim2.new(0.5, -175, 0.5, -160)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
mainFrame.BorderColor3 = Color3.fromRGB(50, 50, 60)
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 8)

local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 35)
titleBar.BackgroundColor3 = Color3.fromRGB(35, 120, 200)
titleBar.Parent = mainFrame
Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 8)

local fixTitle = Instance.new("Frame")
fixTitle.Size = UDim2.new(1, 0, 0, 5)
fixTitle.Position = UDim2.new(0, 0, 1, -5)
fixTitle.BackgroundColor3 = Color3.fromRGB(35, 120, 200)
fixTitle.BorderSizePixel = 0
fixTitle.Parent = titleBar

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -70, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.Text = "ZharHub | Auto Sprinkler"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = titleBar

-- Tombol Close (X)
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0, 2.5)
closeBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = titleBar
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)
closeBtn.MouseButton1Click:Connect(function() screenGui:Destroy() end)

-- Tombol Minimize (-)
local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0, 30, 0, 30)
minBtn.Position = UDim2.new(1, -70, 0, 2.5)
minBtn.BackgroundColor3 = Color3.fromRGB(220, 160, 50)
minBtn.Text = "-"
minBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minBtn.Font = Enum.Font.GothamBold
minBtn.Parent = titleBar
Instance.new("UICorner", minBtn).CornerRadius = UDim.new(0, 6)

local content = Instance.new("Frame")
content.Size = UDim2.new(1, -20, 1, -45)
content.Position = UDim2.new(0, 10, 0, 40)
content.BackgroundTransparency = 1
content.Parent = mainFrame
local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 10)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Parent = content

local isMinimized = false
minBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    content.Visible = not isMinimized
    if isMinimized then
        mainFrame.Size = UDim2.new(0, 350, 0, 35) 
    else
        mainFrame.Size = UDim2.new(0, 350, 0, 320) 
    end
end)

local function createDropdown(name, options, defaultVal, zindexOffset)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, 50)
    container.BackgroundTransparency = 1
    container.Parent = content
    container.ZIndex = zindexOffset

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 15)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = Color3.fromRGB(200, 200, 200)
    label.Font = Enum.Font.Gotham
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container

    local mainBtn = Instance.new("TextButton")
    mainBtn.Size = UDim2.new(1, 0, 0, 30)
    mainBtn.Position = UDim2.new(0, 0, 0, 20)
    mainBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    mainBtn.Text = defaultVal
    mainBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    mainBtn.Font = Enum.Font.GothamSemibold
    mainBtn.TextSize = 13
    mainBtn.Parent = container
    Instance.new("UICorner", mainBtn).CornerRadius = UDim.new(0, 6)

    local listFrame = Instance.new("ScrollingFrame")
    listFrame.Size = UDim2.new(1, 0, 0, 100)
    listFrame.Position = UDim2.new(0, 0, 1, 2)
    listFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    listFrame.Visible = false
    listFrame.ZIndex = zindexOffset + 1
    listFrame.CanvasSize = UDim2.new(0, 0, 0, #options * 25)
    listFrame.ScrollBarThickness = 4
    listFrame.Parent = mainBtn
    Instance.new("UICorner", listFrame).CornerRadius = UDim.new(0, 6)
    
    local listLayout = Instance.new("UIListLayout")
    listLayout.Parent = listFrame

    local selectedValue = defaultVal

    for _, opt in ipairs(options) do
        local optBtn = Instance.new("TextButton")
        optBtn.Size = UDim2.new(1, 0, 0, 25)
        optBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
        optBtn.BorderSizePixel = 0
        optBtn.Text = "  " + opt
        optBtn.Text = "  " .. opt
        optBtn.TextColor3 = Color3.fromRGB(220, 220, 220)
        optBtn.Font = Enum.Font.Gotham
        optBtn.TextSize = 12
        optBtn.TextXAlignment = Enum.TextXAlignment.Left
        optBtn.ZIndex = zindexOffset + 1
        optBtn.Parent = listFrame

        optBtn.MouseButton1Click:Connect(function()
            selectedValue = opt
            mainBtn.Text = opt
            listFrame.Visible = false
        end)
    end

    mainBtn.MouseButton1Click:Connect(function()
        listFrame.Visible = not listFrame.Visible
    end)

    return function() return selectedValue end
end

local sprinklerList = {
    "Common Sprinkler", "Uncommon Sprinkler", "Rare Sprinkler", 
    "Legendary Sprinkler", "Super Sprinkler", "Syrup Sprinkler", "Super Syrup Sprinkler"
}
local getSelectedSprinkler = createDropdown("Select Sprinkler:", sprinklerList, "Super Syrup Sprinkler", 20)

local plantList = {
    "Atlantic Giant Pumpkin", "Giant Pumpkin", "Watermelon", "Carrot"
}
local getSelectedPlant = createDropdown("Choose Plant Target:", plantList, "Atlantic Giant Pumpkin", 10)

local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(1, 0, 0, 40)
toggleBtn.BackgroundColor3 = Color3.fromRGB(40, 160, 90)
toggleBtn.Text = "START AUTO SPRINKLER"
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 14
toggleBtn.Parent = content
Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(0, 6)

local statusBox = Instance.new("Frame")
statusBox.Size = UDim2.new(1, 0, 0, 40)
statusBox.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
statusBox.Parent = content
Instance.new("UICorner", statusBox).CornerRadius = UDim.new(0, 6)

local statusText = Instance.new("TextLabel")
statusText.Size = UDim2.new(1, 0, 1, 0)
statusText.BackgroundTransparency = 1
statusText.Text = "Status: IDLE"
statusText.TextColor3 = Color3.fromRGB(255, 170, 0)
statusText.Font = Enum.Font.GothamMedium
statusText.TextSize = 16
statusText.Parent = statusBox

local isRunning = false
local timeLeft = 0
local SPRINKLER_LIFETIME = 120

-- FUNGSI PENCARI TANAMAN FLEKSIBEL (FIX PLANT NOT FOUND)
local function getClosestPlant(plantName)
    local character = player.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return nil end
    local hrpPos = character.HumanoidRootPart.Position

    local closestPlant = nil
    local shortestDist = math.huge

    local searchKeyword = string.lower(plantName)

    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("Model") then
            local objNameLower = string.lower(obj.Name)
            if string.find(objNameLower, searchKeyword) or string.find(objNameLower, "pumpkin") then
                local rootPart = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart") or obj:FindFirstChild("Base")
                if rootPart then
                    local dist = (hrpPos - rootPart.Position).Magnitude
                    if dist < 100 and dist < shortestDist then
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
    local character = player.Character
    local backpack = player:FindFirstChild("Backpack")
    if not character or not backpack then return false end

    local sprinklerTool = backpack:FindFirstChild(sprinklerName) or character:FindFirstChild(sprinklerName)
    
    if not sprinklerTool then
        print("[ZharHub] ❌ " .. sprinklerName .. " tidak ditemukan di Inventory!")
        return false 
    end

    local targetPart = plantModel:FindFirstChild("Base") or plantModel.PrimaryPart
    if not targetPart then return false end
    
    local placePosition = targetPart.Position + Vector3.new(3, 0, 3)

    local success, err = pcall(function()
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

    if success then
        print(string.format("[ZharHub] ✅ %s dipasang otomatis!", sprinklerName))
        return true
    else
        print("[ZharHub] ⚠️ Gagal eksekusi buffer: " + tostring(err))
        return false
    end
end

toggleBtn.MouseButton1Click:Connect(function()
    isRunning = not isRunning
    if isRunning then
        toggleBtn.Text = "STOP AUTO SPRINKLER"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        timeLeft = 0 
    else
        toggleBtn.Text = "START AUTO SPRINKLER"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(40, 160, 90)
        statusText.Text = "Status: IDLE"
        statusText.TextColor3 = Color3.fromRGB(255, 170, 0)
    end
end)

task.spawn(function()
    while true do
        task.wait(1)
        if isRunning then
            if timeLeft <= 0 then
                local currentSprinkler = getSelectedSprinkler()
                local currentPlant = getSelectedPlant()
                
                local targetPlantObj = getClosestPlant(currentPlant)
                
                if targetPlantObj then
                    statusText.Text = "Placing..."
                    statusText.TextColor3 = Color3.fromRGB(0, 255, 128)
                    
                    local success = placeSprinklerEvent(currentSprinkler, targetPlantObj)
                    
                    if success then
                        timeLeft = SPRINKLER_LIFETIME 
                    else
                        statusText.Text = "Error/Empty!"
                        statusText.TextColor3 = Color3.fromRGB(255, 50, 50)
                        task.wait(3) 
                    end
                else
                    statusText.Text = "Plant Not Found!"
                    statusText.TextColor3 = Color3.fromRGB(255, 50, 50)
                    task.wait(2) 
                end
            else
                timeLeft = timeLeft - 1
                local mins = math.floor(timeLeft / 60)
                local secs = timeLeft % 60
                
                statusText.Text = string.format("Next: %02d:%02d", mins, secs)
                statusText.TextColor3 = Color3.fromRGB(200, 200, 200)
            end
        end
    end
end)
