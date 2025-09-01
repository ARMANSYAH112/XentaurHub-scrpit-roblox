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
	logoBtn.Image = "https://freeimage.host/i/KfhrL5g" -- << ganti dengan logo kamu
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

	local hint = Instance.new("TextLabel")
	hint.Size = UDim2.new(1, -40, 0, 18)
	hint.Position = UDim2.new(0, 20, 0, 156)
	hint.BackgroundTransparency = 1
	hint.Text = "Hint: Key = ArmansyahOfc"
	hint.TextColor3 = neon
	hint.TextSize = 14
	hint.Font = Enum.Font.Gotham
	hint.Parent = keyFrame

	-- Behaviors
	main.Visible = false

	local minimized = false
	logoBtn.MouseButton1Click:Connect(function()
		minimized = not minimized
		main.Visible = not minimized and STATE.KeyAccepted
		notify(minimized and "UI disembunyikan" or "UI ditampilkan")
	end)

	btnSubmit.MouseButton1Click:Connect(function()
		if string.lower(keyBox.Text or "") == "armansyahofc" then
			STATE.KeyAccepted = true
			notify("Key diterima!")
			tween(keyFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Size = UDim2.fromOffset(420, 0), BackgroundTransparency = 1}):Play()
			task.delay(0.3, function() keyFrame.Visible = false main.Visible = true end)
		else
			notify("Key salah.", 2)
		end
	end)

	btnGet.MouseButton1Click:Connect(function()
		-- arahkan user (customize link)
		local link = "https://discord.gg/Es74bMNS" -- ganti sesuai kebutuhan
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
	local bv, bg
	local moveDir = Vector3.zero
	local function setFlySpeedFromInput()
		local v = tonumber(UI.InFly.Text)
		if v and v > 0 then STATE.FlySpeed = math.clamp(v, 10, 300) end
	end

	local function onInput(input, gpe)
		if gpe then return end
		if input.UserInputType == Enum.UserInputType.Keyboard then
			local key = input.KeyCode
			if key == Enum.KeyCode.W then moveDir = Vector3.new(0,0,-1)
			elseif key == Enum.KeyCode.S then moveDir = Vector3.new(0,0,1)
			elseif key == Enum.KeyCode.A then moveDir = Vector3.new(-1,0,0)
			elseif key == Enum.KeyCode.D then moveDir = Vector3.new(1,0,0)
			elseif key == Enum.KeyCode.E then moveDir = Vector3.new(0,1,0)
			elseif key == Enum.KeyCode.Q then moveDir = Vector3.new(0,-1,0)
			end
		end
	end
	local function onEnd(input, gpe)
		if gpe then return end
		if input.UserInputType == Enum.UserInputType.Keyboard then
			moveDir = Vector3.zero
		end
	end

	local heartbeatConn, inputBeganConn, inputEndedConn
	local function setFly(on)
		local hrp = getHRP(LP)
		if not hrp then return end
		if on then
			if bv or bg then return end
			setFlySpeedFromInput()
			bg = Instance.new("BodyGyro")
			bg.P = 9e4; bg.MaxTorque = Vector3.new(9e4, 9e4, 9e4); bg.CFrame = workspace.CurrentCamera.CFrame
			bg.Parent = hrp

			bv = Instance.new("BodyVelocity")
			bv.MaxForce = Vector3.new(9e4, 9e4, 9e4)
			bv.Velocity = Vector3.zero
			bv.Parent = hrp

			inputBeganConn = UserInputService.InputBegan:Connect(onInput)
			inputEndedConn = UserInputService.InputEnded:Connect(onEnd)

			heartbeatConn = RunService.Heartbeat:Connect(function(dt)
				if not bv or not bg then return end
				local cam = workspace.CurrentCamera
				bg.CFrame = cam.CFrame
				local dirWorld = (cam.CFrame:VectorToWorldSpace(moveDir)).Unit
				if moveDir.Magnitude == 0 then
					bv.Velocity = Vector3.zero
				else
					bv.Velocity = dirWorld * STATE.FlySpeed
				end
			end)
		else
			if heartbeatConn then heartbeatConn:Disconnect(); heartbeatConn=nil end
			if inputBeganConn then inputBeganConn:Disconnect(); inputBeganConn=nil end
			if inputEndedConn then inputEndedConn:Disconnect(); inputEndedConn=nil end
			if bv then bv:Destroy(); bv=nil end
			if bg then bg:Destroy(); bg=nil end
		end
	end

	UI.TogFly.MouseButton1Click:Connect(function()
		STATE.Fly = not STATE.Fly
		UI.TogFly.Text = STATE.Fly and "ON" or "OFF"
		UI.TogFly.TextColor3 = STATE.Fly and Color3.fromRGB(120,255,120) or Color3.fromRGB(255,120,120)
		setFly(STATE.Fly)
		notify("Fly: "..(STATE.Fly and "ON" or "OFF"))
	end)
	UI.InFly.FocusLost:Connect(function(enter) if enter then end; -- update on unfocus
		local before = STATE.Fly
		if before then -- refresh speed instantly
			UI.TogFly:Activate()
			task.wait()
			UI.TogFly:Activate()
		else
			local _=setFlySpeedFromInput()
		end
	end)
end

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
		UI.TogSpeed.TextColor3 = STATE.SpeedHack and Color3.fromRGB(120,255,120) or Color3.fromRGB(255,120,120)
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
