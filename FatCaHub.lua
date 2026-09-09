local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")

local LocalPlayer = Players.LocalPlayer

-- ====================================================================
-- 0. KIỂM TRA MAP (SEA CHECK)
-- ====================================================================
local MAP_SEAS = {
    [85211729168715] = 1,    -- Sea 1
    [79091703265657] = 2,    -- Sea 2
    [100117331123089] = 3    -- Sea 3
}

local currentSea = MAP_SEAS[game.PlaceId]
if not currentSea then
    LocalPlayer:Kick("PlaceId không hợp lệ!")
    return
end

local Sea1 = currentSea == 1
local Sea2 = currentSea == 2
local Sea3 = currentSea == 3

-- ====================================================================
-- KHỞI TẠO NHÂN VẬT
-- ====================================================================
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

LocalPlayer.CharacterAdded:Connect(function(newChar)
    Character = newChar
    HumanoidRootPart = newChar:WaitForChild("HumanoidRootPart")
end)

-- ====================================================================
-- 1. KHỞI TẠO CỬA SỔ UI (FLUENT) & ADDONS
-- ====================================================================
local Fluent = loadstring(game:HttpGet("https://raw.githubusercontent.com/Mr-PMC/FluentUI/refs/heads/master/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/Mr-PMC/FluentUI/refs/heads/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/Mr-PMC/FluentUI/refs/heads/master/Addons/InterfaceManager.lua"))()

-- TÊN THƯ MỤC CONFIG CỦA HUB
SaveManager:SetFolder("FatCatHub")
InterfaceManager:SetFolder("FatCatHub")

local Window = Fluent:CreateWindow({
    Title = "Fat Cat Hub",
    SubTitle = "v2.5 Full Edition | Sea " .. tostring(currentSea),
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

-- 2. KHỞI TẠO 12 TAB CHÍNH
local TabDefinitions = {
    {"Info", "Info", "info"},
    {"Farm", "Farm", "sword"},
    {"StackFarming", "Stack Farming", "layers"},
    {"ItemShop", "Item & Shop", "package"},
    {"ServerHopFarm", "Server Hop", "server"},
    {"ESPStats", "ESP & Stats", "eye"},
    {"FruitRaid", "Fruits & Raid", "apple"},
    {"TeleportPvP", "Teleport & PvP", "map-pin"},
    {"Race", "Race V4", "shield"},
    {"SeaEvent", "Sea Events", "waves"},
    {"Setting", "Settings", "settings"},
    {"DiscordWebhook", "Discord Webhook", "message-circle"}
}

local Tabs = {}
for _, tabData in ipairs(TabDefinitions) do
    Tabs[tabData[1]] = Window:AddTab({ Title = tabData[2], Icon = tabData[3] })
end

-- ====================================================================
-- 3. BỘ MẪU CÁC THÀNH PHẦN GIAO DIỆN (FLUENT COMPONENTS)
-- ====================================================================

-- [1. PARAGRAPH]
Tabs.Farm:AddParagraph({
    Title = "Hướng Dẫn Sử Dụng",
    Content = "Đang hoạt động tại: Sea " .. tostring(currentSea) .. "\nChọn các chức năng bên dưới để bắt đầu Farm."
})

-- [2. TOGGLE]
Tabs.Farm:AddSection("Cấu Hình Công Tắc")
local ExampleToggle = Tabs.Farm:AddToggle("ExampleToggle", { 
    Title = "Tên Công Tắc (Toggle)", 
    Description = "Mô tả ngắn gọn chức năng ở đây",
    Default = false 
})
ExampleToggle:OnChanged(function(Value)
    if Value then
        task.spawn(function()
            while Fluent.Options.ExampleToggle and Fluent.Options.ExampleToggle.Value do
                pcall(function()
                    -- Code chạy ngầm ở đây
                end)
                task.wait(0.1)
            end
        end)
    end
end)

-- [3. BUTTON]
Tabs.Farm:AddSection("Cấu Hình Nút Bấm")
Tabs.Farm:AddButton({
    Title = "Tên Nút Bấm (Button)",
    Description = "Bấm vào để kích hoạt hành động 1 lần",
    Callback = function()
        -- Logic thực thi ở đây
    end
})

-- [4. DROPDOWN]
Tabs.Farm:AddSection("Cấu Hình Menu Chọn")
local ExampleDropdown = Tabs.Farm:AddDropdown("ExampleDropdown", {
    Title = "Danh Sách Chọn (Dropdown)",
    Values = {"Lựa chọn 1", "Lựa chọn 2", "Lựa chọn 3", "Lựa chọn 4", "Lựa chọn 5"},
    Default = "Lựa chọn 1",
    Multi = false,
    Callback = function(Value)
        -- Logic xử lý khi chọn
    end
})

-- [5. SLIDER]
Tabs.Farm:AddSection("Cấu Hình Thanh Trượt")
local ExampleSlider = Tabs.Farm:AddSlider("ExampleSlider", {
    Title = "Thanh Trượt Giá Trị (Slider)",
    Description = "Kéo để thay đổi giá trị số",
    Default = 300,
    Min = 100,
    Max = 500,
    Rounding = 0,
    Callback = function(Value)
        -- Logic xử lý khi kéo slider
    end
})

-- [6. INPUT]
Tabs.Farm:AddSection("Cấu Hình Ô Nhập Text")
local ExampleInput = Tabs.Farm:AddInput("ExampleInput", {
    Title = "Ô Nhập Liệu (Input)",
    Default = "",
    Placeholder = "Nhập văn bản vào đây...",
    Numeric = false,
    Finished = true,
    Callback = function(Value)
        -- Logic xử lý khi nhập xong
    end
})

-- [7. COLORPICKER]
Tabs.Farm:AddSection("Cấu Hình Chọn Màu")
local ExampleColorpicker = Tabs.Farm:AddColorpicker("ExampleColorpicker", {
    Title = "Bảng Chọn Màu (Colorpicker)",
    Default = Color3.fromRGB(255, 255, 255),
    Callback = function(Value)
        -- Value kiểu Color3
    end
})

-- ====================================================================
-- 4. QUẢN LÝ CONFIG TỰ ĐỘNG (AUTO SAVE / AUTO LOAD)
-- ====================================================================

SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)

SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})

-- TÊN FILE CONFIG TRỰC TIẾP: Têngame_Têntàikhoản
local DEFAULT_CONFIG = "BloxFruits_" .. LocalPlayer.Name
local autoSaveActive = true

-- Chỉnh Theme & Keybind giao diện
InterfaceManager:BuildInterfaceSection(Tabs.Setting)

-- NÚT RESET CONFIG TRONG TAB SETTING
Tabs.Setting:AddSection("Đặt Lại Cấu Hình")

Tabs.Setting:AddButton({
    Title = "Reset Config",
    Description = "Xóa file cấu hình đã lưu. Vui lòng re-execute lại script để về mặc định.",
    Callback = function()
        autoSaveActive = false
        
        pcall(function()
            local filePath = "FatCatHub/settings/" .. DEFAULT_CONFIG .. ".json"
            if isfile and isfile(filePath) then
                delfile(filePath)
            end
        end)

        Fluent:Notify({
            Title = "Fat Cat Hub",
            Content = "Đã xóa file Config! Vui lòng re-execute lại Script để áp dụng mặc định.",
            Duration = 5
        })
    end
})

-- TỰ ĐỘNG TẢI CONFIG KHI BẮT ĐẦU CHẠY SCRIPT
pcall(function()
    SaveManager:Load(DEFAULT_CONFIG)
end)

-- TỰ ĐỘNG LƯU CONFIG NGẦM MỖI 2 GIÂY
task.spawn(function()
    while task.wait(2) do
        if autoSaveActive then
            pcall(function()
                SaveManager:Save(DEFAULT_CONFIG)
            end)
        end
    end
end)

Window:SelectTab(1)

Fluent:Notify({
    Title = "Fat Cat Hub",
    Content = "Đã tải giao diện và cấu hình: " .. DEFAULT_CONFIG,
    Duration = 4
})
