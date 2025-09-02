-- Xentaur Hub by ArmansyahOfc
-- Satu file LocalScript. Tempatkan di StarterPlayer > StarterPlayerScripts
-- NOTE: Beberapa executor/experience mungkin butuh izin/permission khusus.
--       Gunakan di tempat yang sesuai TOS.

--// ====== SERVICES ======
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")

local LP = Players.LocalPlayer
local PlayerGui = LP:WaitForChild("PlayerGui")

--// ====== UTILS ======
local function notify(t, d)
	pcall(function()
		StarterGui:SetCore("SendNotification", {Title="Xentaur Hub", Text=t, Duration=d or 3})
	end)
	print("[Xentaur Hub] "..t)
end

local function makeDraggable(handle: GuiObject, dragArea: GuiObject?)
	dragArea = dragArea or handle
	local dragging, dragStart, startPos = false, nil, nil

	local function update(input)
		local delta = input.Position - dragStart
		dragArea.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end

	handle.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = dragArea.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then dragging = false end
			end)
		end
	end)

	handle.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			if dragging then update(input) end
		end
	end)
end

local function tween(o, info, props)
	return TweenService:Create(o, info, props)
end

-- Color helpers (neon vibes)
local neon = Color3.fromRGB(0, 255, 200)
local neon2 = Color3.fromRGB(170, 0, 255)
local dark = Color3.fromRGB(10, 10, 16)

--// ====== STATE ======
local STATE = {
	KeyAccepted = false,
	Noclip = false,
	Fly = false,
	FlySpeed = 60,
	SpeedHack = false,
	WalkSpeed = 24,
	ESP = false,
	JumpBoost = false,
	JumpPower = 50,
	Aimbot = false,
	AimFOV = 28, -- derajat
}

-- Keep refs
local UI = {}
local Connections = {}
local ESPFolder = Instance.new("Folder")
ESPFolder.Name = "XentaurESP"
ESPFolder.Parent = workspace

-- Helpers
local function getCharacter(plr)
	plr = plr or LP
	return plr.Character or plr.CharacterAdded:Wait()
end

local function getHumanoid(plr)
	local ch = getCharacter(plr)
	return ch:FindFirstChildOfClass("Humanoid")
end

local function getHRP(plr)
	local ch = getCharacter(plr)
	return ch:FindFirstChild("HumanoidRootPart")
end

--// ====== GUI BUILD ======
do
	-- Root ScreenGui
	local screen = Instance.new("ScreenGui")
	screen.Name = "XentaurHub"
	screen.IgnoreGuiInset = true
	screen.ResetOnSpawn = false
	screen.ZIndexBehavior = Enum.ZIndexBehavior.Global
	screen.Parent = PlayerGui
	UI.Screen = screen

	-- Top-right Logo (minimize)
	local logoBtn = Instance.new("ImageButton")
	logoBtn.Name = "Logo"
	logoBtn.Size = UDim2.fromOffset(64, 64)
	logoBtn.Position = UDim2.new(1, -80, 0, 16)
	logoBtn.AnchorPoint = Vector2.new(0, 0)
	logoBtn.BackgroundColor3 = dark
	logoBtn.AutoButtonColor = true
	logoBtn.BorderSizePixel = 0
	logoBtn.Image = "rbxassetid://121494566459633" -- << ganti dengan logo kamu
	logoBtn.ImageTransparency = 0
	logoBtn.Parent = screen
	makeDraggable(logoBtn, logoBtn)

	-- Glow
	local uic1 = Instance.new("UICorner", logoBtn)
	uic1.CornerRadius = UDim.new(0, 18)
	local uiS1 = Instance.new("UIStroke", logoBtn)
	uiS1.Thickness = 2
	uiS1.Color = neon

	-- MAIN FRAME
	local main = Instance.new("Frame")
	main.Name = "Main"
	main.Size = UDim2.fromOffset(480, 360)
	main.Position = UDim2.new(0.5, -240, 0.5, -180)
	main.BackgroundColor3 = Color3.fromRGB(16, 16, 26)
	main.BorderSizePixel = 0
	main.Parent = screen
	local uic = Instance.new("UICorner", main)
	uic.CornerRadius = UDim.new(0, 20)
	local stroke = Instance.new("UIStroke", main)
	stroke.Thickness = 2
	stroke.Color = neon

	makeDraggable(logoBtn, main) -- logo drag entire panel feel

	-- Header
	local header = Instance.new("TextLabel")
	header.Name = "Header"
	header.Size = UDim2.new(1, -16, 0, 44)
	header.Position = UDim2.new(0, 8, 0, 8)
	header.BackgroundTransparency = 1
	header.Text = "Xentaur Hub"
	header.TextColor3 = Color3.fromRGB(230, 255, 255)
	header.TextScaled = true
	header.Font = Enum.Font.GothamBold
	header.TextXAlignment = Enum.TextXAlignment.Left
	header.Parent = main

	local sub = Instance.new("TextLabel")
	sub.Size = UDim2.new(1, -16, 0, 18)
	sub.Position = UDim2.new(0, 8, 0, 48)
	sub.BackgroundTransparency = 1
	sub.Text = "Neon Utilities"
	sub.TextColor3 = neon2
	sub.TextSize = 16
	sub.Font = Enum.Font.Gotham
	sub.TextXAlignment = Enum.TextXAlignment.Left
	sub.Parent = main

	-- Footer
	local footer = Instance.new("TextLabel")
	footer.Size = UDim2.new(1, -16, 0, 20)
	footer.Position = UDim2.new(0, 8, 1, -28)
	footer.BackgroundTransparency = 1
	footer.Text = "©ArmansyahOfc"
	footer.TextColor3 = Color3.fromRGB(200, 200, 255)
	footer.TextSize = 14
	footer.Font = Enum.Font.Gotham
	footer.TextXAlignment = Enum.TextXAlignment.Right
	footer.Parent = main

	-- Container
	local container = Instance.new("Frame")
	container.Size = UDim2.new(1, -16, 1, -84)
	container.Position = UDim2.new(0, 8, 0, 72)
	container.BackgroundTransparency = 1
	container.Parent = main

	local list = Instance.new("UIListLayout", container)
	list.Padding = UDim.new(0, 8); list.FillDirection = Enum.FillDirection.Vertical

	-- Helper builders
	local function makeToggleRow(title, hasNumber)
		local row = Instance.new("Frame")
		row.Size = UDim2.new(1, 0, 0, 44)
		row.BackgroundColor3 = Color3.fromRGB(18, 18, 30)
		row.Parent = container
		local rc = Instance.new("UICorner", row); rc.CornerRadius = UDim.new(0, 14)
		local rs = Instance.new("UIStroke", row); rs.Color = neon; rs.Thickness = 1

		local nameL = Instance.new("TextLabel")
		nameL.Size = UDim2.new(0.45, -12, 1, 0)
		nameL.Position = UDim2.new(0, 12, 0, 0)
		nameL.BackgroundTransparency = 1
		nameL.Text = title
		nameL.TextColor3 = Color3.fromRGB(230, 255, 255)
		nameL.Font = Enum.Font.Gotham
		nameL.TextSize = 16
		nameL.TextXAlignment = Enum.TextXAlignment.Left
		nameL.Parent = row

		local toggle = Instance.new("TextButton")
		toggle.Size = UDim2.new(0, 80, 0, 28)
		toggle.Position = UDim2.new(1, -92, 0.5, -14)
		toggle.BackgroundColor3 = Color3.fromRGB(30, 30, 44)
		toggle.Text = "OFF"
		toggle.TextColor3 = Color3.fromRGB(255, 120, 120)
		toggle.Font = Enum.Font.GothamBold
		toggle.TextSize = 14
		toggle.Parent = row
		local tc = Instance.new("UICorner", toggle); tc.CornerRadius = UDim.new(0, 10)
		local ts = Instance.new("UIStroke", toggle); ts.Color = neon; ts.Thickness = 1

		local inputBox
		if hasNumber then
			inputBox = Instance.new("TextBox")
			inputBox.PlaceholderText = "angka"
			inputBox.Text = ""
			inputBox.ClearTextOnFocus = false
			inputBox.Size = UDim2.new(0, 90, 0, 28)
			inputBox.Position = UDim2.new(0.62, 0, 0.5, -14)
			inputBox.BackgroundColor3 = Color3.fromRGB(24, 24, 40)
			inputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
			inputBox.Font = Enum.Font.Gotham
			inputBox.TextSize = 14
			inputBox.Parent = row
			local ic = Instance.new("UICorner", inputBox); ic.CornerRadius = UDim.new(0, 10)
			local is = Instance.new("UIStroke", inputBox); is.Color = neon; is.Thickness = 1
		end

		return row, toggle, inputBox
	end

	-- Rows
	UI.RowNoclip, UI.TogNoclip = makeToggleRow("Noclip", false)
	UI.RowFly, UI.TogFly, UI.InFly = makeToggleRow("Fly (speed)", true)
	UI.RowSpeed, UI.TogSpeed, UI.InSpeed = makeToggleRow("Speedhack (WalkSpeed)", true)
	UI.RowESP, UI.TogESP = makeToggleRow("ESP Player (Neon)", false)
	UI.RowJump, UI.TogJump, UI.InJump = makeToggleRow("JumpBoost (tinggi)", true)
	UI.RowAim, UI.TogAim = makeToggleRow("AimBot (lock kamera)", false)

	-- Key Gate UI
local keyFrame = Instance.new("Frame")
keyFrame.Name = "KeyGate"
keyFrame.Size = UDim2.fromOffset(420, 220)
keyFrame.Position = UDim2.new(0.5, -210, 0.5, -110)
keyFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 22)
keyFrame.Parent = screen
local kgc = Instance.new("UICorner", keyFrame); kgc.CornerRadius = UDim.new(0, 18)
local kgs = Instance.new("UIStroke", keyFrame); kgs.Color = neon2; kgs.Thickness = 2

local ktitle = Instance.new("TextLabel")
ktitle.Size = UDim2.new(1, 0, 0, 38)
ktitle.Position = UDim2.new(0, 0, 0, 10)
ktitle.BackgroundTransparency = 1
ktitle.Text = "Xentaur Hub - Key System"
ktitle.TextColor3 = Color3.fromRGB(230, 255, 255)
ktitle.TextSize = 20
ktitle.Font = Enum.Font.GothamBold
ktitle.Parent = keyFrame

local keyBox = Instance.new("TextBox")
keyBox.Size = UDim2.new(1, -40, 0, 36)
keyBox.Position = UDim2.new(0, 20, 0, 64)
keyBox.PlaceholderText = "Masukkan Key di sini"
keyBox.ClearTextOnFocus = false
keyBox.Text = ""
keyBox.BackgroundColor3 = Color3.fromRGB(20, 20, 34)
keyBox.TextColor3 = Color3.fromRGB(255, 255, 255)
keyBox.Font = Enum.Font.Gotham
keyBox.TextSize = 16
keyBox.Parent = keyFrame
local kbc = Instance.new("UICorner", keyBox); kbc.CornerRadius = UDim.new(0, 10)
local kbs = Instance.new("UIStroke", keyBox); kbs.Color = neon; kbs.Thickness = 1

local btnSubmit = Instance.new("TextButton")
btnSubmit.Size = UDim2.new(0.48, -10, 0, 34)
btnSubmit.Position = UDim2.new(0, 20, 0, 114)
btnSubmit.Text = "Masukkan Key"
btnSubmit.BackgroundColor3 = Color3.fromRGB(30, 30, 44)
btnSubmit.TextColor3 = Color3.fromRGB(200, 255, 255)
btnSubmit.Font = Enum.Font.GothamBold
btnSubmit.TextSize = 16
btnSubmit.Parent = keyFrame
local bsc = Instance.new("UICorner", btnSubmit); bsc.CornerRadius = UDim.new(0, 10)
local bss = Instance.new("UIStroke", btnSubmit); bss.Color = neon; bss.Thickness = 1

local btnGet = Instance.new("TextButton")
btnGet.Size = UDim2.new(0.48, -10, 0, 34)
btnGet.Position = UDim2.new(0.52, 0, 0, 114)
btnGet.Text = "Get Key"
btnGet.BackgroundColor3 = Color3.fromRGB(30, 30, 44)
btnGet.TextColor3 = Color3.fromRGB(200, 255, 255)
btnGet.Font = Enum.Font.GothamBold
btnGet.TextSize = 16
btnGet.Parent = keyFrame
local bgc = Instance.new("UICorner", btnGet); bgc.CornerRadius = UDim.new(0, 10)
local bgs = Instance.new("UIStroke", btnGet); bgs.Color = neon; bgs.Thickness = 1

-- ❌ hint key dihapus biar gak ketahuan orang

-- Behaviors
main.Visible = false

local minimized = false
logoBtn.MouseButton1Click:Connect(function()
	minimized = not minimized
	main.Visible = not minimized and STATE.KeyAccepted
	notify(minimized and "UI disembunyikan" or "UI ditampilkan")
end)

btnSubmit.MouseButton1Click:Connect(function()
    local t = keyBox.Text or ""
    print("Key dimasukkan:", t)
    if string.lower(t) == "armansyahofc" then
        -- diterima...
    else
        print("Key salah:", t)
    end
end)

btnGet.MouseButton1Click:Connect(function()
	-- arahkan user (customize link)
	local link = "https://discord.gg/Es74bMNS"
	if setclipboard then pcall(setclipboard, link) end
	notify("Link Get Key disalin ke clipboard.")
end)

UI.Main = main
UI.KeyFrame = keyFrame
UI.Logo = logoBtn
end

--// ====== FEATURES ======

--// Noclip
do
	local noclipConn
	local function setNoclip(on)
		if on then
			if noclipConn then return end
			noclipConn = RunService.Stepped:Connect(function()
				local ch = getCharacter(LP)
				for _, part in ipairs(ch:GetDescendants()) do
					if part:IsA("BasePart") and part.CanCollide then
						part.CanCollide = false
					end
				end
			end)
		else
			if noclipConn then noclipConn:Disconnect(); noclipConn = nil end
			-- try restore default on main parts
			local ch = LP.Character
			if ch then
				for _, part in ipairs(ch:GetDescendants()) do
					if part:IsA("BasePart") then
						part.CanCollide = (part.Name == "HumanoidRootPart") -- minimal
					end
				end
			end
		end
	end

	UI.TogNoclip.MouseButton1Click:Connect(function()
		STATE.Noclip = not STATE.Noclip
		UI.TogNoclip.Text = STATE.Noclip and "ON" or "OFF"
		UI.TogNoclip.TextColor3 = STATE.Noclip and Color3.fromRGB(120,255,120) or Color3.fromRGB(255,120,120)
		setNoclip(STATE.Noclip)
		notify("Noclip: "..(STATE.Noclip and "ON" or "OFF"))
	end)
end

--// Fly (BodyVelocity + BodyGyro)
do
	--//disini code fly
	local main = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local up = Instance.new("TextButton")
local down = Instance.new("TextButton")
local onof = Instance.new("TextButton")
local TextLabel = Instance.new("TextLabel")
local plus = Instance.new("TextButton")
local speed = Instance.new("TextLabel")
local mine = Instance.new("TextButton")
local closebutton = Instance.new("TextButton")
local mini = Instance.new("TextButton")
local mini2 = Instance.new("TextButton")

main.Name = "main"
main.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
main.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
main.ResetOnSpawn = false

Frame.Parent = main
Frame.BackgroundColor3 = Color3.fromRGB(163, 255, 137)
Frame.BorderColor3 = Color3.fromRGB(103, 221, 213)
Frame.Position = UDim2.new(0.100320168, 0, 0.379746825, 0)
Frame.Size = UDim2.new(0, 190, 0, 57)

up.Name = "up"
up.Parent = Frame
up.BackgroundColor3 = Color3.fromRGB(79, 255, 152)
up.Size = UDim2.new(0, 44, 0, 28)
up.Font = Enum.Font.SourceSans
up.Text = "UP"
up.TextColor3 = Color3.fromRGB(0, 0, 0)
up.TextSize = 14.000

down.Name = "down"
down.Parent = Frame
down.BackgroundColor3 = Color3.fromRGB(215, 255, 121)
down.Position = UDim2.new(0, 0, 0.491228074, 0)
down.Size = UDim2.new(0, 44, 0, 28)
down.Font = Enum.Font.SourceSans
down.Text = "DOWN"
down.TextColor3 = Color3.fromRGB(0, 0, 0)
down.TextSize = 14.000

onof.Name = "onof"
onof.Parent = Frame
onof.BackgroundColor3 = Color3.fromRGB(255, 249, 74)
onof.Position = UDim2.new(0.702823281, 0, 0.491228074, 0)
onof.Size = UDim2.new(0, 56, 0, 28)
onof.Font = Enum.Font.SourceSans
onof.Text = "fly"
onof.TextColor3 = Color3.fromRGB(0, 0, 0)
onof.TextSize = 14.000

TextLabel.Parent = Frame
TextLabel.BackgroundColor3 = Color3.fromRGB(242, 60, 255)
TextLabel.Position = UDim2.new(0.469327301, 0, 0, 0)
TextLabel.Size = UDim2.new(0, 100, 0, 28)
TextLabel.Font = Enum.Font.SourceSans
TextLabel.Text = "FLY GUI V3"
TextLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
TextLabel.TextScaled = true
TextLabel.TextSize = 14.000
TextLabel.TextWrapped = true

plus.Name = "plus"
plus.Parent = Frame
plus.BackgroundColor3 = Color3.fromRGB(133, 145, 255)
plus.Position = UDim2.new(0.231578946, 0, 0, 0)
plus.Size = UDim2.new(0, 45, 0, 28)
plus.Font = Enum.Font.SourceSans
plus.Text = "+"
plus.TextColor3 = Color3.fromRGB(0, 0, 0)
plus.TextScaled = true
plus.TextSize = 14.000
plus.TextWrapped = true

speed.Name = "speed"
speed.Parent = Frame
speed.BackgroundColor3 = Color3.fromRGB(255, 85, 0)
speed.Position = UDim2.new(0.468421042, 0, 0.491228074, 0)
speed.Size = UDim2.new(0, 44, 0, 28)
speed.Font = Enum.Font.SourceSans
speed.Text = "1"
speed.TextColor3 = Color3.fromRGB(0, 0, 0)
speed.TextScaled = true
speed.TextSize = 14.000
speed.TextWrapped = true

mine.Name = "mine"
mine.Parent = Frame
mine.BackgroundColor3 = Color3.fromRGB(123, 255, 247)
mine.Position = UDim2.new(0.231578946, 0, 0.491228074, 0)
mine.Size = UDim2.new(0, 45, 0, 29)
mine.Font = Enum.Font.SourceSans
mine.Text = "-"
mine.TextColor3 = Color3.fromRGB(0, 0, 0)
mine.TextScaled = true
mine.TextSize = 14.000
mine.TextWrapped = true

closebutton.Name = "Close"
closebutton.Parent = main.Frame
closebutton.BackgroundColor3 = Color3.fromRGB(225, 25, 0)
closebutton.Font = "SourceSans"
closebutton.Size = UDim2.new(0, 45, 0, 28)
closebutton.Text = "X"
closebutton.TextSize = 30
closebutton.Position =  UDim2.new(0, 0, -1, 27)

mini.Name = "minimize"
mini.Parent = main.Frame
mini.BackgroundColor3 = Color3.fromRGB(192, 150, 230)
mini.Font = "SourceSans"
mini.Size = UDim2.new(0, 45, 0, 28)
mini.Text = "-"
mini.TextSize = 40
mini.Position = UDim2.new(0, 44, -1, 27)

mini2.Name = "minimize2"
mini2.Parent = main.Frame
mini2.BackgroundColor3 = Color3.fromRGB(192, 150, 230)
mini2.Font = "SourceSans"
mini2.Size = UDim2.new(0, 45, 0, 28)
mini2.Text = "+"
mini2.TextSize = 40
mini2.Position = UDim2.new(0, 44, -1, 57)
mini2.Visible = false

speeds = 1

local speaker = game:GetService("Players").LocalPlayer

local chr = game.Players.LocalPlayer.Character
local hum = chr and chr:FindFirstChildWhichIsA("Humanoid")

nowe = false

game:GetService("StarterGui"):SetCore("SendNotification", { 
	Title = "FLY GUI";
	Text = "BY ARMANSYAHOFC";
	Icon = "rbxthumb://type=Asset&id=5107182114&w=150&h=150"})
Duration = 5;

Frame.Active = true -- main = gui
Frame.Draggable = true

onof.MouseButton1Down:connect(function()

	if nowe == true then
		nowe = false

		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Flying,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.GettingUp,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Landed,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Physics,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Running,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.RunningNoPhysics,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.StrafingNoPhysics,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Swimming,true)
		speaker.Character.Humanoid:ChangeState(Enum.HumanoidStateType.RunningNoPhysics)
	else 
		nowe = true



		for i = 1, speeds do
			spawn(function()

				local hb = game:GetService("RunService").Heartbeat	


				tpwalking = true
				local chr = game.Players.LocalPlayer.Character
				local hum = chr and chr:FindFirstChildWhichIsA("Humanoid")
				while tpwalking and hb:Wait() and chr and hum and hum.Parent do
					if hum.MoveDirection.Magnitude > 0 then
						chr:TranslateBy(hum.MoveDirection)
					end
				end

			end)
		end
		game.Players.LocalPlayer.Character.Animate.Disabled = true
		local Char = game.Players.LocalPlayer.Character
		local Hum = Char:FindFirstChildOfClass("Humanoid") or Char:FindFirstChildOfClass("AnimationController")

		for i,v in next, Hum:GetPlayingAnimationTracks() do
			v:AdjustSpeed(0)
		end
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Flying,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.GettingUp,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Landed,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Physics,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Running,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.RunningNoPhysics,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.StrafingNoPhysics,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Swimming,false)
		speaker.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Swimming)
	end




	if game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid").RigType == Enum.HumanoidRigType.R6 then



		local plr = game.Players.LocalPlayer
		local torso = plr.Character.Torso
		local flying = true
		local deb = true
		local ctrl = {f = 0, b = 0, l = 0, r = 0}
		local lastctrl = {f = 0, b = 0, l = 0, r = 0}
		local maxspeed = 50
		local speed = 0


		local bg = Instance.new("BodyGyro", torso)
		bg.P = 9e4
		bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
		bg.cframe = torso.CFrame
		local bv = Instance.new("BodyVelocity", torso)
		bv.velocity = Vector3.new(0,0.1,0)
		bv.maxForce = Vector3.new(9e9, 9e9, 9e9)
		if nowe == true then
			plr.Character.Humanoid.PlatformStand = true
		end
		while nowe == true or game:GetService("Players").LocalPlayer.Character.Humanoid.Health == 0 do
			game:GetService("RunService").RenderStepped:Wait()

			if ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0 then
				speed = speed+.5+(speed/maxspeed)
				if speed > maxspeed then
					speed = maxspeed
				end
			elseif not (ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0) and speed ~= 0 then
				speed = speed-1
				if speed < 0 then
					speed = 0
				end
			end
			if (ctrl.l + ctrl.r) ~= 0 or (ctrl.f + ctrl.b) ~= 0 then
				bv.velocity = ((game.Workspace.CurrentCamera.CoordinateFrame.lookVector * (ctrl.f+ctrl.b)) + ((game.Workspace.CurrentCamera.CoordinateFrame * CFrame.new(ctrl.l+ctrl.r,(ctrl.f+ctrl.b)*.2,0).p) - game.Workspace.CurrentCamera.CoordinateFrame.p))*speed
				lastctrl = {f = ctrl.f, b = ctrl.b, l = ctrl.l, r = ctrl.r}
			elseif (ctrl.l + ctrl.r) == 0 and (ctrl.f + ctrl.b) == 0 and speed ~= 0 then
				bv.velocity = ((game.Workspace.CurrentCamera.CoordinateFrame.lookVector * (lastctrl.f+lastctrl.b)) + ((game.Workspace.CurrentCamera.CoordinateFrame * CFrame.new(lastctrl.l+lastctrl.r,(lastctrl.f+lastctrl.b)*.2,0).p) - game.Workspace.CurrentCamera.CoordinateFrame.p))*speed
			else
				bv.velocity = Vector3.new(0,0,0)
			end
			--	game.Players.LocalPlayer.Character.Animate.Disabled = true
			bg.cframe = game.Workspace.CurrentCamera.CoordinateFrame * CFrame.Angles(-math.rad((ctrl.f+ctrl.b)*50*speed/maxspeed),0,0)
		end
		ctrl = {f = 0, b = 0, l = 0, r = 0}
		lastctrl = {f = 0, b = 0, l = 0, r = 0}
		speed = 0
		bg:Destroy()
		bv:Destroy()
		plr.Character.Humanoid.PlatformStand = false
		game.Players.LocalPlayer.Character.Animate.Disabled = false
		tpwalking = false




	else
		local plr = game.Players.LocalPlayer
		local UpperTorso = plr.Character.UpperTorso
		local flying = true
		local deb = true
		local ctrl = {f = 0, b = 0, l = 0, r = 0}
		local lastctrl = {f = 0, b = 0, l = 0, r = 0}
		local maxspeed = 50
		local speed = 0


		local bg = Instance.new("BodyGyro", UpperTorso)
		bg.P = 9e4
		bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
		bg.cframe = UpperTorso.CFrame
		local bv = Instance.new("BodyVelocity", UpperTorso)
		bv.velocity = Vector3.new(0,0.1,0)
		bv.maxForce = Vector3.new(9e9, 9e9, 9e9)
		if nowe == true then
			plr.Character.Humanoid.PlatformStand = true
		end
		while nowe == true or game:GetService("Players").LocalPlayer.Character.Humanoid.Health == 0 do
			wait()

			if ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0 then
				speed = speed+.5+(speed/maxspeed)
				if speed > maxspeed then
					speed = maxspeed
				end
			elseif not (ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0) and speed ~= 0 then
				speed = speed-1
				if speed < 0 then
					speed = 0
				end
			end
			if (ctrl.l + ctrl.r) ~= 0 or (ctrl.f + ctrl.b) ~= 0 then
				bv.velocity = ((game.Workspace.CurrentCamera.CoordinateFrame.lookVector * (ctrl.f+ctrl.b)) + ((game.Workspace.CurrentCamera.CoordinateFrame * CFrame.new(ctrl.l+ctrl.r,(ctrl.f+ctrl.b)*.2,0).p) - game.Workspace.CurrentCamera.CoordinateFrame.p))*speed
				lastctrl = {f = ctrl.f, b = ctrl.b, l = ctrl.l, r = ctrl.r}
			elseif (ctrl.l + ctrl.r) == 0 and (ctrl.f + ctrl.b) == 0 and speed ~= 0 then
				bv.velocity = ((game.Workspace.CurrentCamera.CoordinateFrame.lookVector * (lastctrl.f+lastctrl.b)) + ((game.Workspace.CurrentCamera.CoordinateFrame * CFrame.new(lastctrl.l+lastctrl.r,(lastctrl.f+lastctrl.b)*.2,0).p) - game.Workspace.CurrentCamera.CoordinateFrame.p))*speed
			else
				bv.velocity = Vector3.new(0,0,0)
			end

			bg.cframe = game.Workspace.CurrentCamera.CoordinateFrame * CFrame.Angles(-math.rad((ctrl.f+ctrl.b)*50*speed/maxspeed),0,0)
		end
		ctrl = {f = 0, b = 0, l = 0, r = 0}
		lastctrl = {f = 0, b = 0, l = 0, r = 0}
		speed = 0
		bg:Destroy()
		bv:Destroy()
		plr.Character.Humanoid.PlatformStand = false
		game.Players.LocalPlayer.Character.Animate.Disabled = false
		tpwalking = false



	end





end)

local tis

up.MouseButton1Down:connect(function()
	tis = up.MouseEnter:connect(function()
		while tis do
			wait()
			game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0,1,0)
		end
	end)
end)

up.MouseLeave:connect(function()
	if tis then
		tis:Disconnect()
		tis = nil
	end
end)

local dis

down.MouseButton1Down:connect(function()
	dis = down.MouseEnter:connect(function()
		while dis do
			wait()
			game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0,-1,0)
		end
	end)
end)

down.MouseLeave:connect(function()
	if dis then
		dis:Disconnect()
		dis = nil
	end
end)


game:GetService("Players").LocalPlayer.CharacterAdded:Connect(function(char)
	wait(0.7)
	game.Players.LocalPlayer.Character.Humanoid.PlatformStand = false
	game.Players.LocalPlayer.Character.Animate.Disabled = false

end)


plus.MouseButton1Down:connect(function()
	speeds = speeds + 1
	speed.Text = speeds
	if nowe == true then


		tpwalking = false
		for i = 1, speeds do
			spawn(function()

				local hb = game:GetService("RunService").Heartbeat	


				tpwalking = true
				local chr = game.Players.LocalPlayer.Character
				local hum = chr and chr:FindFirstChildWhichIsA("Humanoid")
				while tpwalking and hb:Wait() and chr and hum and hum.Parent do
					if hum.MoveDirection.Magnitude > 0 then
						chr:TranslateBy(hum.MoveDirection)
					end
				end

			end)
		end
	end
end)
mine.MouseButton1Down:connect(function()
	if speeds == 1 then
		speed.Text = 'cannot be less than 1'
		wait(1)
		speed.Text = speeds
	else
		speeds = speeds - 1
		speed.Text = speeds
		if nowe == true then
			tpwalking = false
			for i = 1, speeds do
				spawn(function()

					local hb = game:GetService("RunService").Heartbeat	


					tpwalking = true
					local chr = game.Players.LocalPlayer.Character
					local hum = chr and chr:FindFirstChildWhichIsA("Humanoid")
					while tpwalking and hb:Wait() and chr and hum and hum.Parent do
						if hum.MoveDirection.Magnitude > 0 then
							chr:TranslateBy(hum.MoveDirection)
						end
					end

				end)
			end
		end
	end
end)

closebutton.MouseButton1Click:Connect(function()
	main:Destroy()
end)

mini.MouseButton1Click:Connect(function()
	up.Visible = false
	down.Visible = false
	onof.Visible = false
	plus.Visible = false
	speed.Visible = false
	mine.Visible = false
	mini.Visible = false
	mini2.Visible = true
	main.Frame.BackgroundTransparency = 1
	closebutton.Position =  UDim2.new(0, 0, -1, 57)
end)

mini2.MouseButton1Click:Connect(function()
	up.Visible = true
	down.Visible = true
	onof.Visible = true
	plus.Visible = true
	speed.Visible = true
	mine.Visible = true
	mini.Visible = true
	mini2.Visible = false
	main.Frame.BackgroundTransparency = 0 
	closebutton.Position =  UDim2.new(0, 0, -1, 27)
end)

--// Speedhack (WalkSpeed)
do
	local function applyWalkSpeed()
		local hum = getHumanoid(LP)
		if hum then
			if STATE.SpeedHack then
				local v = tonumber(UI.InSpeed.Text) or STATE.WalkSpeed
				STATE.WalkSpeed = math.clamp(v, 8, 300)
				hum.WalkSpeed = STATE.WalkSpeed
			else
				hum.WalkSpeed = 16
			end
		end
	end

	UI.TogSpeed.MouseButton1Click:Connect(function()
		STATE.SpeedHack = not STATE.SpeedHack
		UI.TogSpeed.Text = STATE.SpeedHack and "ON" or "OFF"
		UI.TogSpeed.TextColor3 = STATE.SpeedHack and Color3.fromRGB(120,255,120) or Color3.fromRGB(q 255,120,120)
		applyWalkSpeed()
		notify("Speedhack: "..(STATE.SpeedHack and "ON" or "OFF"))
	end)
	UI.InSpeed.FocusLost:Connect(function() if STATE.SpeedHack then applyWalkSpeed() end end)
end

--// ESP Player (Neon)
do
	--//disini code esp
	local espHighlights = {}

	local function clearESP()
		for plr, h in pairs(espHighlights) do
			if h and h.Parent then h:Destroy() end
			espHighlights[plr] = nil
		end
	end

	local function createESPFor(plr)
		if plr == LP then return end
		local ch = plr.Character
		if not ch or espHighlights[plr] then return end
		local h = Instance.new("Highlight")
		h.Name = "XentaurHighlight"
		h.FillTransparency = 1
		h.OutlineColor = neon
		h.OutlineTransparency = 0
		h.Adornee = ch
		h.Parent = ESPFolder
		espHighlights[plr] = h
	end

	local function refreshESP()
		for _, plr in ipairs(Players:GetPlayers()) do
			if STATE.ESP then
				createESPFor(plr)
			end
		end
	end

	Players.PlayerAdded:Connect(function(plr)
		if not STATE.ESP then return end
		plr.CharacterAdded:Connect(function()
			task.wait(0.3)
			createESPFor(plr)
		end)
	end)

	Players.PlayerRemoving:Connect(function(plr)
		if espHighlights[plr] then
			espHighlights[plr]:Destroy()
			espHighlights[plr] = nil
		end
	end)

	UI.TogESP.MouseButton1Click:Connect(function()
		STATE.ESP = not STATE.ESP
		UI.TogESP.Text = STATE.ESP and "ON" or "OFF"
		UI.TogESP.TextColor3 = STATE.ESP and Color3.fromRGB(120,255,120) or Color3.fromRGB(255,120,120)
		if STATE.ESP then
			refreshESP()
			notify("ESP: ON")
		else
			clearESP()
			notify("ESP: OFF")
		end
	end)
end

--// JumpBoost (JumpPower/JumpHeight)
do
	local function applyJump()
		local hum = getHumanoid(LP)
		if not hum then return end
		local v = tonumber(UI.InJump.Text) or STATE.JumpPower
		STATE.JumpPower = math.clamp(v, 20, 300)
		-- JumpPower (legacy) + JumpHeight
		pcall(function() hum.JumpPower = STATE.JumpPower end)
		-- approximate height mapping:
		pcall(function() hum.UseJumpPower = true end)
	end

	UI.TogJump.MouseButton1Click:Connect(function()
		STATE.JumpBoost = not STATE.JumpBoost
		UI.TogJump.Text = STATE.JumpBoost and "ON" or "OFF"
		UI.TogJump.TextColor3 = STATE.JumpBoost and Color3.fromRGB(120,255,120) or Color3.fromRGB(255,120,120)
		if STATE.JumpBoost then
			applyJump()
			notify("JumpBoost: ON")
		else
			local hum = getHumanoid(LP)
			if hum then
				pcall(function() hum.JumpPower = 50 end)
				pcall(function() hum.UseJumpPower = true end)
			end
			notify("JumpBoost: OFF")
		end
	end)
	UI.InJump.FocusLost:Connect(function() if STATE.JumpBoost then applyJump() end end)
end

--// AimBot (simple lock to closest target within FOV)
do
	--//disini code aimbot
	local aimConn
	local function getClosestTarget(maxFOVdeg)
		local cam = workspace.CurrentCamera
		local closestPlr, closestAngle = nil, math.rad(maxFOVdeg or STATE.AimFOV)
		for _, plr in ipairs(Players:GetPlayers()) do
			if plr ~= LP and plr.Character and plr.Character:FindFirstChild("Head") then
				local head = plr.Character.Head
				local dirTo = (head.Position - cam.CFrame.Position).Unit
				local curLook = cam.CFrame.LookVector.Unit
				local ang = math.acos(math.clamp(curLook:Dot(dirTo), -1, 1))
				if ang < closestAngle then
					closestAngle = ang
					closestPlr = plr
				end
			end
		end
		return closestPlr
	end

	local function setAimbot(on)
		if on then
			if aimConn then return end
			aimConn = RunService.RenderStepped:Connect(function()
				local target = getClosestTarget(STATE.AimFOV)
				if target and target.Character and target.Character:FindFirstChild("Head") then
					local head = target.Character.Head
					local cam = workspace.CurrentCamera
					-- Smooth lock
					local targetCF = CFrame.new(cam.CFrame.Position, head.Position)
					cam.CFrame = cam.CFrame:Lerp(targetCF, 0.25)
				end
			end)
		else
			if aimConn then aimConn:Disconnect(); aimConn=nil end
		end
	end

	UI.TogAim.MouseButton1Click:Connect(function()
		STATE.Aimbot = not STATE.Aimbot
		UI.TogAim.Text = STATE.Aimbot and "ON" or "OFF"
		UI.TogAim.TextColor3 = STATE.Aimbot and Color3.fromRGB(120,255,120) or Color3.fromRGB(255,120,120)
		setAimbot(STATE.Aimbot)
		notify("AimBot: "..(STATE.Aimbot and "ON" or "OFF"))
	end)
end

-- Safety: auto re-apply when respawn
LP.CharacterAdded:Connect(function()
	task.wait(0.5)
	if STATE.SpeedHack then UI.TogSpeed:Activate(); task.wait(); UI.TogSpeed:Activate() end
	if STATE.Noclip then UI.TogNoclip:Activate(); task.wait(); UI.TogNoclip:Activate() end
	if STATE.JumpBoost then UI.TogJump:Activate(); task.wait(); UI.TogJump:Activate() end
	if STATE.ESP then UI.TogESP:Activate(); task.wait(); UI.TogESP:Activate() end
	if STATE.Fly then UI.TogFly:Activate(); task.wait(); UI.TogFly:Activate() end
	if STATE.Aimbot then UI.TogAim:Activate(); task.wait(); UI.TogAim:Activate() end
end)

notify("Xentaur Hub siap. Klik logo untuk tampil/sembunyi. Key = ArmansyahOfc")
