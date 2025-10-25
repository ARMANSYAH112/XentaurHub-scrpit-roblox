local Luna = loadstring(game:HttpGet("https://raw.githubusercontent.com/Nebula-Softworks/Luna-Interface-Suite/refs/heads/main/source.lua", true))()

-- Get player username
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Username = LocalPlayer.Name

-- HttpService untuk JSON
local HttpService = game:GetService("HttpService")

-- Nama file storage
local StorageFileName = "XentaurHub_Scripts.json"

-- Load saved scripts dari file
local SavedScripts = {}
local function LoadScripts()
	local success = pcall(function()
		if isfile(StorageFileName) then
			local jsonData = readfile(StorageFileName)
			SavedScripts = HttpService:JSONDecode(jsonData)
		end
	end)
	if not success then
		SavedScripts = {}
	end
end

-- Save scripts ke file
local function SaveScripts()
	pcall(function()
		local jsonData = HttpService:JSONEncode(SavedScripts)
		writefile(StorageFileName, jsonData)
	end)
end

-- Load scripts saat pertama kali
LoadScripts()

local Window = Luna:CreateWindow({
	Name = "XentaurHub",
	Subtitle = nil,
	LogoID = "96513335118849",
	LoadingEnabled = true,
	LoadingTitle = "XentaurHub",
	LoadingSubtitle = "by ArmansyahOfc",

	ConfigSettings = {
		RootFolder = nil,
		ConfigFolder = "XentaurHub"
	},

	KeySettings = {
		Title = "Xentaur Key",
		Subtitle = "Key System",
		Note = "Enter your key and press Enter",
		SaveInRoot = false,
		SaveKey = true,
		Key = {"Ok", "ArmansyahOfc"},
		SecondAction = {
			Enabled = false,
			Type = "None",
			Parameter = ""
		}
	}
})

-- Home Tab
Window:CreateHomeTab({
	SupportedExecutors = {},
	DiscordInvite = "1234",
	Icon = 2,
})

-- Tab Add Script
local AddScriptTab = Window:CreateTab({
	Name = "Add Script",
	Icon = "add",
	ImageSource = "Material",
	ShowTitle = true
})

AddScriptTab:CreateParagraph({
	Title = "Add Your Script",
	Text = "Klik tombol Publish untuk menambah script baru"
})

AddScriptTab:CreateButton({
	Name = "Publish",
	Description = "Tambah script baru",
	Callback = function()
		-- Buat popup GUI
		local ScreenGui = Instance.new("ScreenGui")
		ScreenGui.Name = "ScriptInputGUI"
		ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
		ScreenGui.ResetOnSpawn = false
		
		local MainFrame = Instance.new("Frame")
		MainFrame.Parent = ScreenGui
		MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
		MainFrame.BorderSizePixel = 2
		MainFrame.BorderColor3 = Color3.fromRGB(60, 60, 60)
		MainFrame.Position = UDim2.new(0.5, -200, 0.5, -200)
		MainFrame.Size = UDim2.new(0, 400, 0, 400)
		
		local UICorner = Instance.new("UICorner")
		UICorner.CornerRadius = UDim.new(0, 10)
		UICorner.Parent = MainFrame
		
		local Title = Instance.new("TextLabel")
		Title.Parent = MainFrame
		Title.BackgroundTransparency = 1
		Title.Size = UDim2.new(1, 0, 0, 40)
		Title.Font = Enum.Font.GothamBold
		Title.Text = "Tambah Script Baru"
		Title.TextColor3 = Color3.fromRGB(255, 255, 255)
		Title.TextSize = 18
		
		-- Nama Script
		local NameLabel = Instance.new("TextLabel")
		NameLabel.Parent = MainFrame
		NameLabel.BackgroundTransparency = 1
		NameLabel.Position = UDim2.new(0.05, 0, 0, 50)
		NameLabel.Size = UDim2.new(0.9, 0, 0, 20)
		NameLabel.Font = Enum.Font.Gotham
		NameLabel.Text = "Nama Script:"
		NameLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
		NameLabel.TextSize = 14
		NameLabel.TextXAlignment = Enum.TextXAlignment.Left
		
		local NameBox = Instance.new("TextBox")
		NameBox.Parent = MainFrame
		NameBox.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
		NameBox.BorderSizePixel = 1
		NameBox.BorderColor3 = Color3.fromRGB(60, 60, 60)
		NameBox.Position = UDim2.new(0.05, 0, 0, 75)
		NameBox.Size = UDim2.new(0.9, 0, 0, 35)
		NameBox.Font = Enum.Font.Gotham
		NameBox.PlaceholderText = "Contoh: Xperi"
		NameBox.Text = ""
		NameBox.TextColor3 = Color3.fromRGB(255, 255, 255)
		NameBox.TextSize = 14
		NameBox.ClearTextOnFocus = false
		
		local NameCorner = Instance.new("UICorner")
		NameCorner.CornerRadius = UDim.new(0, 6)
		NameCorner.Parent = NameBox
		
		-- Script Code
		local CodeLabel = Instance.new("TextLabel")
		CodeLabel.Parent = MainFrame
		CodeLabel.BackgroundTransparency = 1
		CodeLabel.Position = UDim2.new(0.05, 0, 0, 120)
		CodeLabel.Size = UDim2.new(0.9, 0, 0, 20)
		CodeLabel.Font = Enum.Font.Gotham
		CodeLabel.Text = "Script:"
		CodeLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
		CodeLabel.TextSize = 14
		CodeLabel.TextXAlignment = Enum.TextXAlignment.Left
		
		local CodeBox = Instance.new("TextBox")
		CodeBox.Parent = MainFrame
		CodeBox.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
		CodeBox.BorderSizePixel = 1
		CodeBox.BorderColor3 = Color3.fromRGB(60, 60, 60)
		CodeBox.Position = UDim2.new(0.05, 0, 0, 145)
		CodeBox.Size = UDim2.new(0.9, 0, 0, 100)
		CodeBox.Font = Enum.Font.Gotham
		CodeBox.PlaceholderText = "Contoh: loadstring(game:HttpGet(...))()"
		CodeBox.Text = ""
		CodeBox.TextColor3 = Color3.fromRGB(255, 255, 255)
		CodeBox.TextSize = 12
		CodeBox.MultiLine = true
		CodeBox.TextWrapped = true
		CodeBox.TextXAlignment = Enum.TextXAlignment.Left
		CodeBox.TextYAlignment = Enum.TextYAlignment.Top
		CodeBox.ClearTextOnFocus = false
		
		local CodeCorner = Instance.new("UICorner")
		CodeCorner.CornerRadius = UDim.new(0, 6)
		CodeCorner.Parent = CodeBox
		
		-- By
		local ByLabel = Instance.new("TextLabel")
		ByLabel.Parent = MainFrame
		ByLabel.BackgroundTransparency = 1
		ByLabel.Position = UDim2.new(0.05, 0, 0, 255)
		ByLabel.Size = UDim2.new(0.9, 0, 0, 20)
		ByLabel.Font = Enum.Font.Gotham
		ByLabel.Text = "By:"
		ByLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
		ByLabel.TextSize = 14
		ByLabel.TextXAlignment = Enum.TextXAlignment.Left
		
		local ByBox = Instance.new("TextBox")
		ByBox.Parent = MainFrame
		ByBox.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
		ByBox.BorderSizePixel = 1
		ByBox.BorderColor3 = Color3.fromRGB(60, 60, 60)
		ByBox.Position = UDim2.new(0.05, 0, 0, 280)
		ByBox.Size = UDim2.new(0.9, 0, 0, 35)
		ByBox.Font = Enum.Font.Gotham
		ByBox.PlaceholderText = "Contoh: ArmansyahOfc"
		ByBox.Text = ""
		ByBox.TextColor3 = Color3.fromRGB(255, 255, 255)
		ByBox.TextSize = 14
		ByBox.ClearTextOnFocus = false
		
		local ByCorner = Instance.new("UICorner")
		ByCorner.CornerRadius = UDim.new(0, 6)
		ByCorner.Parent = ByBox
		
		-- Buttons
		local AddButton = Instance.new("TextButton")
		AddButton.Parent = MainFrame
		AddButton.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
		AddButton.Position = UDim2.new(0.05, 0, 0, 340)
		AddButton.Size = UDim2.new(0.4, 0, 0, 40)
		AddButton.Font = Enum.Font.GothamBold
		AddButton.Text = "Tambah"
		AddButton.TextColor3 = Color3.fromRGB(255, 255, 255)
		AddButton.TextSize = 16
		
		local AddCorner = Instance.new("UICorner")
		AddCorner.CornerRadius = UDim.new(0, 8)
		AddCorner.Parent = AddButton
		
		local CancelButton = Instance.new("TextButton")
		CancelButton.Parent = MainFrame
		CancelButton.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
		CancelButton.Position = UDim2.new(0.55, 0, 0, 340)
		CancelButton.Size = UDim2.new(0.4, 0, 0, 40)
		CancelButton.Font = Enum.Font.GothamBold
		CancelButton.Text = "Batal"
		CancelButton.TextColor3 = Color3.fromRGB(255, 255, 255)
		CancelButton.TextSize = 16
		
		local CancelCorner = Instance.new("UICorner")
		CancelCorner.CornerRadius = UDim.new(0, 8)
		CancelCorner.Parent = CancelButton
		
		-- Button Actions
		AddButton.MouseButton1Click:Connect(function()
			local name = NameBox.Text
			local code = CodeBox.Text
			local by = ByBox.Text
			
			if name ~= "" and code ~= "" and by ~= "" then
				table.insert(SavedScripts, {
					Name = name,
					Code = code,
					By = by
				})
				
				SaveScripts()
				
				Luna:Notification({
					Title = "Berhasil!",
					Content = "Script '" .. name .. "' berhasil ditambahkan!",
					Image = "check_circle",
					Time = 3
				})
				
				RefreshAllScriptsTab()
				ScreenGui:Destroy()
			else
				Luna:Notification({
					Title = "Error!",
					Content = "Semua field harus diisi!",
					Image = "error",
					Time = 3
				})
			end
		end)
		
		CancelButton.MouseButton1Click:Connect(function()
			ScreenGui:Destroy()
		end)
		
		-- Parent to CoreGui
		ScreenGui.Parent = game:GetService("CoreGui")
	end
})

local HttpService = game:GetService("HttpService")
local DataStoreService = game:GetService("DataStoreService")
local ScriptStore = DataStoreService:GetDataStore("PublicScripts_v1")

-- Konfigurasi
local REFRESH_INTERVAL = 30 -- Auto refresh setiap 30 detik
local SavedScripts = {}
local Username = game.Players.LocalPlayer.Name

-- Load Scripts dari DataStore
function LoadScriptsFromCloud()
	local success, data = pcall(function()
		return ScriptStore:GetAsync("AllScripts")
	end)
	
	if success and data then
		SavedScripts = HttpService:JSONDecode(data)
		RefreshAllScriptsTab()
		Luna:Notification({
			Title = "Loaded!",
			Content = "Scripts berhasil dimuat dari cloud!",
			Image = "cloud_download",
			Time = 2
		})
	else
		SavedScripts = {}
		Luna:Notification({
			Title = "Info",
			Content = "Belum ada script di cloud",
			Image = "info",
			Time = 2
		})
	end
end

-- Save Scripts ke DataStore
function SaveScriptsToCloud()
	local success, err = pcall(function()
		local jsonData = HttpService:JSONEncode(SavedScripts)
		ScriptStore:SetAsync("AllScripts", jsonData)
	end)
	
	if success then
		Luna:Notification({
			Title = "Saved!",
			Content = "Scripts berhasil disimpan ke cloud!",
			Image = "cloud_upload",
			Time = 2
		})
	else
		Luna:Notification({
			Title = "Error!",
			Content = "Gagal menyimpan ke cloud: " .. tostring(err),
			Image = "error",
			Time = 5
		})
	end
end

-- Auto Refresh
spawn(function()
	while wait(REFRESH_INTERVAL) do
		LoadScriptsFromCloud()
	end
end)

-- Tab All Scripts
local AllScriptsTab = Window:CreateTab({
	Name = "All Script",
	Icon = "list",
	ImageSource = "Material",
	ShowTitle = true
})

-- Button untuk Manual Refresh
AllScriptsTab:CreateButton({
	Name = "🔄 Refresh Scripts",
	Description = "Muat ulang scripts dari cloud",
	Callback = function()
		LoadScriptsFromCloud()
	end
})

local ScriptElements = {}

function RefreshAllScriptsTab()
	-- Hapus semua element kecuali button refresh
	for _, element in pairs(ScriptElements) do
		if element and element.Destroy then
			pcall(function() element:Destroy() end)
		end
	end
	ScriptElements = {}
	
	if #SavedScripts == 0 then
		local emptyLabel = AllScriptsTab:CreateLabel({
			Text = "Belum ada script tersimpan. Klik 'Refresh Scripts' untuk memuat.",
			Style = 2
		})
		table.insert(ScriptElements, emptyLabel)
	else
		for i, script in ipairs(SavedScripts) do
			local scriptBtn = AllScriptsTab:CreateButton({
				Name = script.Name,
				Description = "By: " .. script.By .. " | " .. os.date("%d/%m/%Y", script.Timestamp or 0),
				Callback = function()
					ShowScriptDetail(i, script)
				end
			})
			table.insert(ScriptElements, scriptBtn)
		end
	end
end

function ShowScriptDetail(index, script)
	local DetailTab = Window:CreateTab({
		Name = script.Name .. " Detail",
		Icon = "description",
		ImageSource = "Material",
		ShowTitle = true
	})
	
	DetailTab:CreateButton({
		Name = "Kembali",
		Description = "Kembali ke All Script",
		Callback = function()
			pcall(function() DetailTab:Destroy() end)
		end
	})
	
	DetailTab:CreateLabel({
		Text = "By: " .. script.By,
		Style = 2
	})
	
	DetailTab:CreateLabel({
		Text = "Name Script: " .. script.Name,
		Style = 2
	})
	
	DetailTab:CreateLabel({
		Text = "Published: " .. os.date("%d/%m/%Y %H:%M", script.Timestamp or 0),
		Style = 2
	})
	
	DetailTab:CreateLabel({
		Text = "Script: " .. script.Code,
		Style = 1
	})
	
	DetailTab:CreateButton({
		Name = "Copy Script",
		Description = "Copy script ke clipboard",
		Callback = function()
			setclipboard(script.Code)
			Luna:Notification({
				Title = "Copied!",
				Content = "Script berhasil di copy!",
				Image = "content_copy",
				Time = 2
			})
		end
	})
	
	DetailTab:CreateButton({
		Name = "Execute",
		Description = "Auto run script",
		Callback = function()
			local success, err = pcall(function()
				loadstring(script.Code)()
			end)
			if success then
				Luna:Notification({
					Title = "Success!",
					Content = "Script berhasil dijalankan!",
					Image = "check_circle",
					Time = 3
				})
			else
				Luna:Notification({
					Title = "Error!",
					Content = "Gagal menjalankan script: " .. tostring(err),
					Image = "error",
					Time = 5
				})
			end
		end
	})
	
	-- Tombol Delete untuk admin atau pemilik script
	if Username == "knobaeyyyy" or Username == script.By then
		DetailTab:CreateButton({
			Name = "Delete",
			Description = Username == "knobaeyyyy" and "Hapus script ini (Admin)" or "Hapus script kamu",
			Callback = function()
				table.remove(SavedScripts, index)
				SaveScriptsToCloud()
				
				Luna:Notification({
					Title = "Deleted!",
					Content = "Script '" .. script.Name .. "' berhasil dihapus!",
					Image = "delete",
					Time = 3
				})
				pcall(function() DetailTab:Destroy() end)
				RefreshAllScriptsTab()
			end
		})
	end
end

-- Tab Publish Script
local PublishTab = Window:CreateTab({
	Name = "Publish Script",
	Icon = "publish",
	ImageSource = "Material",
	ShowTitle = true
})

local TempScript = {
	Name = "",
	Code = ""
}

PublishTab:CreateParagraph({
	Title = "Info",
	Text = "Publish script kamu agar bisa digunakan oleh player lain!"
})

PublishTab:CreateInput({
	Name = "Script Name",
	PlaceholderText = "Masukkan nama script...",
	RemoveTextAfterFocusLost = false,
	Callback = function(Text)
		TempScript.Name = Text
	end
})

PublishTab:CreateInput({
	Name = "Script Code",
	PlaceholderText = "Paste script code disini...",
	RemoveTextAfterFocusLost = false,
	Callback = function(Text)
		TempScript.Code = Text
	end
})

PublishTab:CreateButton({
	Name = "📤 Publish Script",
	Description = "Upload script ke cloud",
	Callback = function()
		if TempScript.Name == "" or TempScript.Code == "" then
			Luna:Notification({
				Title = "Error!",
				Content = "Nama dan code script tidak boleh kosong!",
				Image = "error",
				Time = 3
			})
			return
		end
		
		local newScript = {
			Name = TempScript.Name,
			By = Username,
			Code = TempScript.Code,
			Timestamp = os.time()
		}
		
		table.insert(SavedScripts, 1, newScript) -- Tambah di awal array
		SaveScriptsToCloud()
		
		Luna:Notification({
			Title = "Published!",
			Content = "Script '" .. TempScript.Name .. "' berhasil dipublish!",
			Image = "check_circle",
			Time = 3
		})
		
		-- Reset form
		TempScript.Name = ""
		TempScript.Code = ""
		
		-- Refresh tab
		wait(1)
		LoadScriptsFromCloud()
	end
})

-- Load scripts saat pertama kali
LoadScriptsFromCloud()

-- Tab Example
local Tab = Window:CreateTab({
	Name = "Tab Example",
	Icon = "view_in_ar",
	ImageSource = "Material",
	ShowTitle = true
})

Tab:CreateParagraph({
	Title = "info",
	Text = "idk how to change icon"
})

Tab:CreateButton({
	Name = "Button Example!",
	Description = nil,
	Callback = function()
	end
})

Tab:CreateColorPicker({
	Name = "Color Picker Example",
	Color = Color3.fromRGB(86, 171, 128),
	Flag = "ColorPicker1",
	Callback = function(Value)
	end
}, "ColorPicker")

Tab:CreateSlider({
	Name = "Slider Example",
	Range = {0, 200},
	Increment = 5,
	CurrentValue = 100,
	Callback = function(Value)
	end
}, "Slider")

Tab:CreateDropdown({
	Name = "Dropdown Example",
	Description = nil,
	Options = {"Option 1","Option 2"},
	CurrentOption = {"Option 1"},
	MultipleOptions = false,
	SpecialType = nil,
	Callback = function(Options)
	end
}, "Dropdown")

Tab:CreateToggle({
	Name = "Toggle Example",
	Description = nil,
	CurrentValue = false,
	Callback = function(Value)
	end
}, "Toggle")

Tab:CreateBind({
	Name = "Bind Example",
	Description = nil,
	CurrentBind = "Q",
	HoldToInteract = false,
	Callback = function(BindState)
	end,
	OnChangedCallback = function(Bind)
	end,
}, "Bind")

Tab:CreateLabel({
	Text = "Label Example",
	Style = 2
})
