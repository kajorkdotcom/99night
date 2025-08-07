-- Ultimate Mobile GUI | 99 Nights Forest | ChatGPT x Jockkiez

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Char:WaitForChild("Humanoid")
local HRP = Char:WaitForChild("HumanoidRootPart")
local UIS = game:GetService("UserInputService")

-- 🌐 GUI Container
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "ForestHub"
gui.ResetOnSpawn = false

-- 🌟 Floating Button (☰)
local toggleButton = Instance.new("TextButton", gui)
toggleButton.Size = UDim2.new(0, 40, 0, 40)
toggleButton.Position = UDim2.new(1, -60, 0.5, -20)
toggleButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
toggleButton.Text = "☰"
toggleButton.TextScaled = true
toggleButton.TextColor3 = Color3.new(1,1,1)

-- 📦 Main Menu
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 250, 0, 420)
frame.Position = UDim2.new(0, 20, 0.4, -200)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.Visible = false

-- 🔃 Drag Menu
local dragging, dragInput, dragStart, startPos
frame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = frame.Position
	end
end)

UIS.InputChanged:Connect(function(input)
	if dragging and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
		local delta = input.Position - dragStart
		frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)

UIS.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = false
	end
end)

-- ☰ Toggle visibility
toggleButton.MouseButton1Click:Connect(function()
	frame.Visible = not frame.Visible
end)

-- 🔽 Collapse Button
local collapseBtn = Instance.new("TextButton", frame)
collapseBtn.Size = UDim2.new(1, 0, 0, 30)
collapseBtn.Text = "🔽"
collapseBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
collapseBtn.TextColor3 = Color3.new(1,1,1)
collapseBtn.TextScaled = true

local collapsed = false
collapseBtn.MouseButton1Click:Connect(function()
	collapsed = not collapsed
	for _, v in ipairs(frame:GetChildren()) do
		if v:IsA("TextButton") and v ~= collapseBtn then
			v.Visible = not collapsed
		end
	end
	collapseBtn.Text = collapsed and "🔼" or "🔽"
end)

-- 🧩 Layout
local layout = Instance.new("UIListLayout", frame)
layout.Padding = UDim.new(0, 6)

-- 📌 Create Button Function
function addButton(text, callback)
	local btn = Instance.new("TextButton", frame)
	btn.Size = UDim2.new(1, -20, 0, 40)
	btn.Position = UDim2.new(0, 10, 0, 0)
	btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	btn.TextColor3 = Color3.new(1,1,1)
	btn.Font = Enum.Font.Gotham
	btn.TextSize = 15
	btn.Text = text
	btn.Visible = true
	btn.MouseButton1Click:Connect(callback)
	return btn
end

-- 🔪 Kill Aura
local aura = false
addButton("🔪 Toggle Kill Aura", function()
	aura = not aura
	if aura then
		task.spawn(function()
			while aura do
				for _, mob in pairs(workspace.Mobs:GetChildren()) do
					if mob:FindFirstChild("Humanoid") and mob:FindFirstChild("HumanoidRootPart") then
						if (mob.HumanoidRootPart.Position - HRP.Position).Magnitude < 10 then
							mob.Humanoid.Health = 0
						end
					end
				end
				task.wait(0.2)
			end
		end)
	end
end)

-- 📦 Bring Items
local bring = false
addButton("📦 Toggle Bring Items", function()
	bring = not bring
	if bring then
		task.spawn(function()
			while bring do
				for _, item in pairs(workspace:GetChildren()) do
					if item:IsA("Part") and (item.Name == "Wood" or item.Name == "Fuel") then
						item.CFrame = HRP.CFrame + Vector3.new(0,2,0)
					end
				end
				task.wait(0.5)
			end
		end)
	end
end)

-- 👁 ESP
addButton("👁 Enable ESP", function()
	for _, obj in pairs(workspace:GetDescendants()) do
		if obj:IsA("Model") and (obj.Name == "Chest" or obj.Name == "LostChild") and not obj:FindFirstChildOfClass("Highlight") then
			local hl = Instance.new("Highlight", obj)
			hl.FillColor = Color3.fromRGB(0, 255, 150)
		end
	end
end)

-- 🚀 TP to LostChild
addButton("🚀 Teleport to Lost Child", function()
	for _, child in pairs(workspace:GetChildren()) do
		if child.Name == "LostChild" and child:IsA("Model") and child.PrimaryPart then
			HRP.CFrame = child.PrimaryPart.CFrame + Vector3.new(0,3,0)
			break
		end
	end
end)

-- 🌙 Night Vision
addButton("🌙 Toggle Night Vision", function()
	game.Lighting.FogEnd = 100000
	game.Lighting.ClockTime = 14
end)

-- 🍗 Auto Heal
local heal = false
addButton("🍗 Toggle Auto Heal", function()
	heal = not heal
	if heal then
		task.spawn(function()
			while heal do
				if Humanoid.Health < Humanoid.MaxHealth * 0.6 then
					for _, item in pairs(LocalPlayer.Backpack:GetChildren()) do
						if item:IsA("Tool") and item.Name:lower():find("bandage") then
							item.Parent = Char
							item:Activate()
						end
					end
				end
				task.wait(1)
			end
		end)
	end
end)

-- ❌ Close GUI
addButton("❌ Close Menu", function()
	gui:Destroy()
end)
