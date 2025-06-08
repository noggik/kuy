local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local Window = Fluent:CreateWindow({
    Title = "Mining tycoon " .. Fluent.Version,
    SubTitle = "Created by Xin",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
    Player = Window:AddTab({ Title = "Player", Icon = "user" }),
    Teleport = Window:AddTab({ Title = "Teleport", Icon = "map-pin" }),
    ["Esp ore"] = Window:AddTab({ Title = "Esp", Icon = "atom" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

local Options = Fluent.Options

local function getUniqueMeshPartNames()
    local names = {}
    local uniqueNames = {}
    
    if workspace:FindFirstChild("SpawnedBlocks") then
        for _, obj in pairs(workspace.SpawnedBlocks:GetChildren()) do
            if obj:IsA("MeshPart") and not names[obj.Name] then
                names[obj.Name] = true
                table.insert(uniqueNames, obj.Name)
            end
        end
    end
    
    return uniqueNames
end

local function applyESP(meshPart, enable)
    if enable then
        local highlight = Instance.new("Highlight")
        highlight.Name = "ESPHighlight"
        highlight.FillColor = Color3.fromRGB(255, 0, 0)
        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
        highlight.FillTransparency = 0.5
        highlight.OutlineTransparency = 0
        highlight.Parent = meshPart
        
        meshPart.CanCollide = false
        meshPart.Transparency = 0.3
    else
        local highlight = meshPart:FindFirstChild("ESPHighlight")
        if highlight then
            highlight:Destroy()
        end
        meshPart.CanCollide = true
        meshPart.Transparency = 0
    end
end

local function updateESP(selectedItems)
    if workspace:FindFirstChild("SpawnedBlocks") then
        for _, obj in pairs(workspace.SpawnedBlocks:GetChildren()) do
            if obj:IsA("MeshPart") then
                local isSelected = selectedItems[obj.Name] == true
                applyESP(obj, isSelected)
            end
        end
    end
end

do
    local meshPartNames = getUniqueMeshPartNames()
    
    local ESPDropdown = Tabs["Esp ore"]:AddDropdown("ESPDropdown", {
        Title = "ESP MeshParts",
        Description = "เลือก MeshParts ที่ต้องการ ESP",
        Values = meshPartNames,
        Multi = true,
        Default = {},
    })

    ESPDropdown:OnChanged(function(Value)
        updateESP(Value)
    end)

    Tabs["Esp ore"]:AddButton({
        Title = "รีเฟรช MeshParts",
        Description = "อัพเดทรายการ MeshParts",
        Callback = function()
            local newNames = getUniqueMeshPartNames()
            ESPDropdown:SetValues(newNames)
            Fluent:Notify({
                Title = "อัพเดทสำเร็จ",
                Content = "รายการ MeshParts ถูกอัพเดทแล้ว",
                Duration = 3
            })
        end
    })
end

local function createToggleButton()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "UIToggleButton"
    ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Name = "ToggleButton"
    ToggleButton.Parent = ScreenGui
    ToggleButton.BackgroundColor3 = Color3.fromRGB(75, 0, 130)
    ToggleButton.BorderSizePixel = 0
    ToggleButton.Position = UDim2.new(0, 20, 0, 20)
    ToggleButton.Size = UDim2.new(0, 20, 0, 20)
    ToggleButton.Font = Enum.Font.GothamBold
    ToggleButton.Text = "Xin"
    ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleButton.TextScaled = true
    ToggleButton.ZIndex = 1000

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 4)
    Corner.Parent = ToggleButton

    local Gradient = Instance.new("UIGradient")
    Gradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0.0, Color3.fromRGB(75, 0, 130)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(139, 0, 139)),
        ColorSequenceKeypoint.new(1.0, Color3.fromRGB(220, 20, 60))
    }
    Gradient.Rotation = 45
    Gradient.Parent = ToggleButton

    local Stroke = Instance.new("UIStroke")
    Stroke.Color = Color3.fromRGB(255, 255, 255)
    Stroke.Thickness = 1
    Stroke.Transparency = 0.7
    Stroke.Parent = ToggleButton

    local isUIVisible = true

    ToggleButton.MouseButton1Click:Connect(function()
        isUIVisible = not isUIVisible
        if isUIVisible then
            Window:Minimize()
            Window:Restore()
        else
            Window:Minimize()
        end
        
        local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tween = TweenService:Create(ToggleButton, tweenInfo, {
            Size = UDim2.new(0, 18, 0, 18)
        })
        tween:Play()
        tween.Completed:Connect(function()
            local tween2 = TweenService:Create(ToggleButton, tweenInfo, {
                Size = UDim2.new(0, 20, 0, 20)
            })
            tween2:Play()
        end)
    end)

    local dragging = false
    local dragStart = nil
    local startPos = nil

    local function updateInput(input)
        local delta = input.Position - dragStart
        ToggleButton.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end

    ToggleButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = ToggleButton.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    ToggleButton.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            if dragging then
                updateInput(input)
            end
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            if dragging then
                updateInput(input)
            end
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    ToggleButton.MouseEnter:Connect(function()
        local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        TweenService:Create(ToggleButton, tweenInfo, {
            Size = UDim2.new(0, 22, 0, 22)
        }):Play()
        TweenService:Create(Stroke, tweenInfo, {
            Transparency = 0.3
        }):Play()
    end)

    ToggleButton.MouseLeave:Connect(function()
        local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        TweenService:Create(ToggleButton, tweenInfo, {
            Size = UDim2.new(0, 20, 0, 20)
        }):Play()
        TweenService:Create(Stroke, tweenInfo, {
            Transparency = 0.7
        }):Play()
    end)
end

do
    Tabs.Player:AddParagraph({
        Title = "ความไวตัวละคร",
        Content = "ปรับเยอะวิิ่งไว"
    })

    local SensitivitySlider = Tabs.Player:AddSlider("CharacterSensitivity", {
        Title = "ความไวตัวละคร",
        Description = "ปรับความไวการวิ่ง (1-100)",
        Default = 50,
        Min = 1,
        Max = 100,
        Rounding = 1,
        Callback = function(Value)
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                local humanoid = LocalPlayer.Character.Humanoid
                humanoid.WalkSpeed = 16 * (Value / 50)
                print("ความไวการวิ่งถูกปรับเป็น:", Value, "WalkSpeed:", humanoid.WalkSpeed)
            end
        end
    })

    SensitivitySlider:OnChanged(function(Value)
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            local humanoid = LocalPlayer.Character.Humanoid
            humanoid.WalkSpeed = 16 * (Value / 50)
            print("ความไวตัวละครเปลี่ยนเป็น:", Value)
        end
    end)

    Tabs.Player:AddButton({
        Title = "รีเซ็ตความไว",
        Description = "รีเซ็ตความไวกลับเป็นค่าเริ่มต้น",
        Callback = function()
            SensitivitySlider:SetValue(50)
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid.WalkSpeed = 16
            end
            Fluent:Notify({
                Title = "รีเซ็ตสำเร็จ",
                Content = "ความไวตัวละครถูกรีเซ็ตแล้ว",
                Duration = 3
            })
        end
    })

    local function onCharacterAdded(character)
        local humanoid = character:WaitForChild("Humanoid")
        local currentValue = Options.CharacterSensitivity.Value or 50
        humanoid.WalkSpeed = 16 * (currentValue / 50)
        print("ตัวละครใหม่เกิด - ปรับความไวเป็น:", currentValue)
    end

    if LocalPlayer.Character then
        onCharacterAdded(LocalPlayer.Character)
    end
    LocalPlayer.CharacterAdded:Connect(onCharacterAdded)
end

do
    SaveManager:SetLibrary(Fluent)
    InterfaceManager:SetLibrary(Fluent)
    SaveManager:IgnoreThemeSettings()
    SaveManager:SetIgnoreIndexes({})
    InterfaceManager:SetFolder("PlayerControlScript")
    SaveManager:SetFolder("PlayerControlScript/configs")
    InterfaceManager:BuildInterfaceSection(Tabs.Settings)
    SaveManager:BuildConfigSection(Tabs.Settings)
end

Tabs.Teleport:AddButton({
    Title = "เหมือง",
    Description = "กดเพื่อเวาปไปเหมือง",
    Callback = function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-1882.3053, 6.75000668, -185.973892)
        end
    end
})

Window:SelectTab(1)
createToggleButton()

Fluent:Notify({
    Title = "Kanye",
    Content = "สคริปต์โหลดสำเร็จแล้ว!",
    SubContent = "By xin",
    Duration = 5
})

SaveManager:LoadAutoloadConfig()
