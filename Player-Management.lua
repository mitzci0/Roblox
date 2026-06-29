-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "UsernameGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")


-- Main Window
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 560, 0, 330)
frame.Position = UDim2.new(0.5, -280, 0.5, -165)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
frame.BorderSizePixel = 0
frame.Parent = screenGui


-- Rounded corners
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 22)
corner.Parent = frame


-- Window border
local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(90, 70, 140)
stroke.Thickness = 3
stroke.Parent = frame


-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,0,0,60)
title.Position = UDim2.new(0,0,0,10)
title.BackgroundTransparency = 1
title.Text = "Player Management"
title.TextColor3 = Color3.fromRGB(255,255,255)
title.Font = Enum.Font.GothamBlack
title.TextScaled = true
title.Parent = frame


-- Description
local desc = Instance.new("TextLabel")
desc.Size = UDim2.new(0.9,0,0,35)
desc.Position = UDim2.new(0.05,0,0.25,0)
desc.BackgroundTransparency = 1
desc.Text = "Enter username to Kick Player"
desc.TextColor3 = Color3.fromRGB(180,180,190)
desc.Font = Enum.Font.GothamMedium
desc.TextScaled = true
desc.Parent = frame


-- Username Box
local usernameTextBox = Instance.new("TextBox")
usernameTextBox.Size = UDim2.new(0.8,0,0,60)
usernameTextBox.Position = UDim2.new(0.1,0,0.42,0)

usernameTextBox.BackgroundColor3 = Color3.fromRGB(45,45,60)
usernameTextBox.BorderSizePixel = 0

usernameTextBox.PlaceholderText = ""
usernameTextBox.PlaceholderColor3 = Color3.fromRGB(150,150,160)

usernameTextBox.TextColor3 = Color3.fromRGB(255,255,255)
usernameTextBox.Text = ""
usernameTextBox.TextScaled = true
usernameTextBox.Font = Enum.Font.GothamBold

usernameTextBox.ClearTextOnFocus = false
usernameTextBox.Parent = frame


local boxCorner = Instance.new("UICorner")
boxCorner.CornerRadius = UDim.new(0,14)
boxCorner.Parent = usernameTextBox


local boxStroke = Instance.new("UIStroke")
boxStroke.Color = Color3.fromRGB(100,80,160)
boxStroke.Thickness = 2
boxStroke.Parent = usernameTextBox



-- Credit bottom right
local credit = Instance.new("TextLabel")
credit.Size = UDim2.new(0,220,0,25)
credit.Position = UDim2.new(1,-235,1,-35)
credit.BackgroundTransparency = 1
credit.Text = "mitzci0 on GitHub <3"
credit.TextColor3 = Color3.fromRGB(160,160,170)
credit.Font = Enum.Font.GothamMedium
credit.TextScaled = true
credit.TextXAlignment = Enum.TextXAlignment.Right
credit.Parent = frame



-- OK Button
local submitButton = Instance.new("TextButton")
submitButton.Size = UDim2.new(0.45,0,0,60)
submitButton.Position = UDim2.new(0.275,0,0.68,0)

submitButton.BackgroundColor3 = Color3.fromRGB(150,80,255)
submitButton.BorderSizePixel = 0

submitButton.Text = "OK"
submitButton.TextColor3 = Color3.fromRGB(255,255,255)
submitButton.TextScaled = true
submitButton.Font = Enum.Font.GothamBlack

submitButton.Parent = frame


local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0,16)
buttonCorner.Parent = submitButton


local buttonStroke = Instance.new("UIStroke")
buttonStroke.Color = Color3.fromRGB(220,180,255)
buttonStroke.Thickness = 3
buttonStroke.Parent = submitButton



-- Button Hover
submitButton.MouseEnter:Connect(function()
	submitButton.BackgroundColor3 = Color3.fromRGB(180,110,255)
end)

submitButton.MouseLeave:Connect(function()
	submitButton.BackgroundColor3 = Color3.fromRGB(150,80,255)
end)



-- Button Function
local function onButtonClick()
	local username = usernameTextBox.Text
	local player = game.Players:FindFirstChild(username)

	if player then
		player:Kick("You are banned from this experience.")
	else
		warn("Player not found.")
	end
end

submitButton.MouseButton1Click:Connect(onButtonClick)



-- Dragging System
local UserInputService = game:GetService("UserInputService")

local dragging = false
local dragStart
local startPos


frame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = frame.Position

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)


UserInputService.InputChanged:Connect(function(input)
	if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then

		local delta = input.Position - dragStart

		frame.Position = UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset + delta.X,
			startPos.Y.Scale,
			startPos.Y.Offset + delta.Y
		)

	end
end)
