local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- Create the main GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "HackGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = game.CoreGui

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 220, 0, 270)
mainFrame.Position = UDim2.new(0.5, -110, 0.5, -135)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Parent = screenGui

-- Add smooth corners to the main frame
local mainFrameCorner = Instance.new("UICorner")
mainFrameCorner.CornerRadius = UDim.new(0, 12)
mainFrameCorner.Parent = mainFrame

-- Add a subtle shadow
local shadow = Instance.new("ImageLabel")
shadow.Name = "Shadow"
shadow.AnchorPoint = Vector2.new(0.5, 0.5)
shadow.BackgroundTransparency = 1
shadow.Position = UDim2.new(0.5, 0, 0.5, 0)
shadow.Size = UDim2.new(1, 47, 1, 47)
shadow.ZIndex = 0
shadow.Image = "rbxassetid://6014261993"
shadow.ImageColor3 = Color3.new(0, 0, 0)
shadow.ImageTransparency = 0.5
shadow.SliceCenter = Rect.new(49, 49, 450, 450)
shadow.ScaleType = Enum.ScaleType.Slice
shadow.SliceScale = 1
shadow.Parent = mainFrame

-- Add falling stars
local function createStar()
    local star = Instance.new("Frame")
    star.BackgroundColor3 = Color3.new(1, 1, 1)
    star.BackgroundTransparency = 0.7
    star.BorderSizePixel = 0
    star.Size = UDim2.new(0, math.random(1, 2), 0, math.random(1, 2))
    star.Position = UDim2.new(math.random(), 0, math.random(-0.5, 0), 0)
    star.Parent = mainFrame
    
    local uiCorner = Instance.new("UICorner")
    uiCorner.CornerRadius = UDim.new(1, 0)
    uiCorner.Parent = star
    
    return star
end

local stars = {}
for i = 1, 30 do
    stars[i] = createStar()
end

RunService.RenderStepped:Connect(function(dt)
    for _, star in ipairs(stars) do
        star.Position = star.Position + UDim2.new(0, 0, dt * 0.03, 0)
        if star.Position.Y.Scale > 1 then
            star.Position = UDim2.new(math.random(), 0, -0.1, 0)
        end
    end
end)

local title = Instance.new("TextLabel")
title.Name = "Title"
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundTransparency = 1
title.Text = "Smooth Hack Menu"
title.TextColor3 = Color3.new(1, 1, 1)
title.TextSize = 24
title.Font = Enum.Font.GothamBold
title.Parent = mainFrame

-- Create buttons
local function createButton(name, position)
    local button = Instance.new("TextButton")
    button.Name = name .. "Button"
    button.Size = UDim2.new(0.9, 0, 0, 40)
    button.Position = UDim2.new(0.05, 0, 0, position)
    button.BackgroundColor3 = Color3.fromRGB(75, 0, 130)
    button.Text = name
    button.TextColor3 = Color3.new(1, 1, 1)
    button.TextSize = 18
    button.Font = Enum.Font.GothamSemibold
    button.Parent = mainFrame
    
    local uiCorner = Instance.new("UICorner")
    uiCorner.CornerRadius = UDim.new(0, 8)
    uiCorner.Parent = button
    
    local uiStroke = Instance.new("UIStroke")
    uiStroke.Color = Color3.fromRGB(100, 25, 155)
    uiStroke.Thickness = 1
    uiStroke.Parent = button
    
    button.MouseEnter:Connect(function()
        game:GetService("TweenService"):Create(button, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(95, 20, 150)}):Play()
    end)
    
    button.MouseLeave:Connect(function()
        game:GetService("TweenService"):Create(button, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(75, 0, 130)}):Play()
    end)
    
    return button
end

local silentAimbotButton = createButton("Silent Aimbot", 50)
local espButton = createButton("ESP", 100)
local chamsButton = createButton("Chams", 150)
local instantReloadButton = createButton("Instant Reload", 200)

-- Variables
local silentAimbotEnabled = false
local espEnabled = false
local chamsEnabled = false
local instantReloadEnabled = false
local chamsConnection

-- Functions
local function toggleSilentAimbot()
    silentAimbotEnabled = not silentAimbotEnabled
    silentAimbotButton.Text = "Silent Aimbot " .. (silentAimbotEnabled and "[ON]" or "[OFF]")
    
    if silentAimbotEnabled then
        local players = game:GetService("Players")
        local player = players.LocalPlayer
        
        function ClosestPlayer()
            local plr
            local closest = math.huge
            if player.Team == nil then
                for i,v in next, players:GetPlayers() do
                    if v ~= player and v.Character and v.Character.Humanoid.Health > 0 then
                        local mag = (player.Character.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).Magnitude
                        if mag < closest then
                            closest = mag
                            plr = v
                        end
                    end
                end
            else
                for i,v in next, players:GetPlayers() do
                    if v ~= player and v.Team ~= player.Team and v.Character and v.Character.Humanoid.Health > 0 then
                        local mag = (player.Character.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).Magnitude
                        if mag < closest then
                            closest = mag
                            plr = v
                        end
                    end
                end
            end
            return plr
        end
        
        local mt = getrawmetatable(game)
        local oldnc = mt.__namecall
        setreadonly(mt, false)
        
        mt.__namecall = newcclosure(function(self, ...)
            local args, method = {...}, getnamecallmethod()
            if method == "FireServer" and args[1] == "ShootSound" then
                local plr = ClosestPlayer()
                game:GetService("ReplicatedStorage").Remotes.GunShot:FireServer(
                    plr,
                    workspace.CurrentCamera:FindFirstChildOfClass("Model").Name,
                    require(game:GetService("ReplicatedFirst"):WaitForChild("Shared"):WaitForChild("RemoteUtils")).PackVector(plr.Character.Head.Position),
                    plr.Character.Head,
                    "Default"
                )
                return oldnc(self, unpack(args))
            end
            return oldnc(self, ...)
        end)
        
        setreadonly(mt, true)
    else
        local mt = getrawmetatable(game)
        setreadonly(mt, false)
        mt.__namecall = oldnc
        setreadonly(mt, true)
    end
end

local function toggleESP()
    espEnabled = not espEnabled
    espButton.Text = "ESP " .. (espEnabled and "[ON]" or "[OFF]")
    
    if espEnabled then
        local enemyteam = game.Workspace.Players:GetChildren()[1]
        local friendlyteam = game.Workspace.Players:GetChildren()[2]
        while espEnabled do
            for _,v in enemyteam:GetDescendants() do
                if v.ClassName == "Model" and not v:FindFirstChild("Highlight") then
                    local h = Instance.new("Highlight", v)
                    h.FillColor = Color3.new(1,0,0)
                    h.FillTransparency = 0.4
                end
            end
            for _,v in friendlyteam:GetDescendants() do
                if v.ClassName == "Model" and not v:FindFirstChild("Highlight") then
                    local h = Instance.new("Highlight", v)
                    h.FillColor = Color3.new(0.227451, 1, 0.054902)
                    h.FillTransparency = 0.8
                end
            end
            wait(0.1)
        end
    else
        for _, player in pairs(game.Workspace.Players:GetDescendants()) do
            if player:IsA("Model") and player:FindFirstChild("Highlight") then
                player.Highlight:Destroy()
            end
        end
    end
end

local function toggleChams()
    chamsEnabled = not chamsEnabled
    chamsButton.Text = "Chams " .. (chamsEnabled and "[ON]" or "[OFF]")
    
    if chamsEnabled then
        chamsConnection = RunService.Stepped:Connect(function()
            for i,v in pairs(game.Workspace.CurrentCamera:GetChildren()) do
                for i2,v2 in pairs(v:GetChildren()) do
                    if v2.ClassName == "Part" or v2.ClassName == "MeshPart" then
                        v2.Color = Color3.fromHSV(tick()%5/5,1,1)
                        v2.Material = Enum.Material.ForceField
                    end 
                end
            end
            for i,v in pairs(game.Workspace.CurrentCamera:GetDescendants()) do
                if v.Name == "SightMark" then
                    v.SurfaceGui.Border.Scope.ImageColor3 = Color3.fromHSV(tick()%5/5,1,1)
                end
            end 
        end)
    else
        if chamsConnection then
            chamsConnection:Disconnect()
        end
        for i,v in pairs(game.Workspace.CurrentCamera:GetDescendants()) do
            if v:IsA("BasePart") then
                v.Material = Enum.Material.Plastic
                v.Color = Color3.new(1, 1, 1)
            elseif v.Name == "SightMark" then
                v.SurfaceGui.Border.Scope.ImageColor3 = Color3.new(1, 1, 1)
            end
        end
    end
end

local function toggleInstantReload()
    instantReloadEnabled = not instantReloadEnabled
    instantReloadButton.Text = "Instant Reload " .. (instantReloadEnabled and "[ON]" or "[OFF]")
    
    local gunModule = require(game:GetService("Players").LocalPlayer.PlayerGui.GUI.Client.Functions.Weapons)
    local oldReload = gunModule.reload
    
    if instantReloadEnabled then
        gunModule.reload = function(...)
            local args = {...}
            args[2] = 0
            return oldReload(unpack(args))
        end
    else
        gunModule.reload = oldReload
    end
end

-- Connect buttons
silentAimbotButton.MouseButton1Click:Connect(toggleSilentAimbot)
espButton.MouseButton1Click:Connect(toggleESP)
chamsButton.MouseButton1Click:Connect(toggleChams)
instantReloadButton.MouseButton1Click:Connect(toggleInstantReload)

-- Enable dragging
local dragging = false
local dragStart = nil
local startPos = nil

mainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
    end
end)

mainFrame.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

-- Toggle visibility with Insert key
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.Insert then
        mainFrame.Visible = not mainFrame.Visible
    end
end)

print("Script loaded. Press Insert to toggle menu visibility.")
