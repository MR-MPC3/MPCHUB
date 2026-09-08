-------------------------------------------------------
-- SERVICES KHAI BÁO 1 LẦN DƯỚI CHỈ VIỆC GỌI SÀI
-----------------------------------------------------------
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")

-- Ưu tiên gethui() nếu executor hỗ trợ (an toàn hơn CoreGui)
local ParentGui = (gethui and gethui()) or CoreGui

local plr = Players.LocalPlayer
local RS = ReplicatedStorage

---------------------------
-- KIỂM TRA MAP
-------------------------
local MAP_SEAS = {
    [85211729168715] = 1,
    [79091703265657] = 2,
    [100117331123089] = 3
}

local currentSea = MAP_SEAS[game.PlaceId]
if not currentSea then
    plr:Kick("PlaceId không hợp lệ!")
    return
end

local Sea1 = currentSea == 1
local Sea2 = currentSea == 2
local Sea3 = currentSea == 3

-------------------------
-- CLEANUP OLD GUI
-----------------------
pcall(function()
    if ParentGui:FindFirstChild("Core") then ParentGui.Core:Destroy() end
    if ParentGui:FindFirstChild("FatCatToggle") then ParentGui.FatCatToggle:Destroy() end
end)

--------------------------------------------------
-- GIAO DIỆN LOADER VÀ BẮT ĐÀU KHỞI CHẠY LOADER
-------------------------------------------------
shared.LoaderTitle = "Đăng Ký Kênh Fat Cat Hub"
local LoaderConfig = {
    LoaderData = {
        Name = shared.LoaderTitle or "Fat Cat Hub",
        Colors = shared.LoaderColors or {
            Main = Color3.fromRGB(0, 0, 0),
            Title = Color3.fromRGB(255, 255, 255),
            LoaderBackground = Color3.fromRGB(40, 40, 40),
            LoaderSplash = Color3.fromRGB(3, 252, 3)
        }
    }
}
_G.LoaderConfig = LoaderConfig

local function TweenObject(object, duration, goals, easingStyle, easingDirection)
    if not object then return end
    local tween = TweenService:Create(object, TweenInfo.new(duration, easingStyle or Enum.EasingStyle.Quad, easingDirection or Enum.EasingDirection.Out), goals)
    tween:Play()
    return tween
end

local function CreateObject(className, props)
    local instance = Instance.new(className)
    for property, value in pairs(props) do
        if property ~= "Parent" then instance[property] = value end
    end
    instance.Parent = props.Parent
    return instance
end

local function AddUICorner(radius, parentObj)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius)
    corner.Parent = parentObj
end

local LoaderGui = CreateObject("ScreenGui", {Name = "Core", Parent = ParentGui, ResetOnSpawn = false, ZIndexBehavior = Enum.ZIndexBehavior.Sibling})
local MainFrame = CreateObject("Frame", {
    Name = "Main", Parent = LoaderGui, BackgroundColor3 = LoaderConfig.LoaderData.Colors.Main,
    BorderSizePixel = 0, ClipsDescendants = true, Position = UDim2.new(0.5, 0, 0.5, 0), AnchorPoint = Vector2.new(0.5, 0.5), Size = UDim2.new(0, 0, 0, 0)
})
AddUICorner(12, MainFrame)

local UserImage = CreateObject("ImageLabel", {
    Name = "UserImage", Parent = MainFrame, BackgroundTransparency = 1, Image = "rbxassetid://13717478897", Position = UDim2.new(0, 15, 0, 10), Size = UDim2.new(0, 50, 0, 50)
})
AddUICorner(25, UserImage)

local UserNameLabel = CreateObject("TextLabel", {
    Name = "UserName", Parent = MainFrame, BackgroundTransparency = 1, Text = "Youtube: Fat Cat",
    Position = UDim2.new(0, 75, 0, 10), Size = UDim2.new(0, 220, 0, 50), Font = Enum.Font.GothamBold,
    TextColor3 = LoaderConfig.LoaderData.Colors.Title, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left
})

local TitleLabel = CreateObject("TextLabel", {
    Name = "Title", Parent = MainFrame, BackgroundTransparency = 1, Position = UDim2.new(0, 30, 0, 65),
    Size = UDim2.new(0, 286, 0, 25), Font = Enum.Font.Gotham, RichText = true, Text = "<b>" .. LoaderConfig.LoaderData.Name .. "</b>",
    TextColor3 = LoaderConfig.LoaderData.Colors.Title, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left
})

local ProgressBG = CreateObject("Frame", {
    Name = "BG", Parent = MainFrame, AnchorPoint = Vector2.new(0.5, 0), BackgroundTransparency = 0,
    BackgroundColor3 = LoaderConfig.LoaderData.Colors.LoaderBackground, BorderSizePixel = 0, Position = UDim2.new(0.5, 0, 0, 70), Size = UDim2.new(0.85, 0, 0, 24)
})
AddUICorner(8, ProgressBG)

local ProgressBar = CreateObject("Frame", {
    Name = "Progress", Parent = ProgressBG, BackgroundColor3 = LoaderConfig.LoaderData.Colors.LoaderSplash, BorderSizePixel = 0, Size = UDim2.new(0, 0, 1, 0)
})
AddUICorner(8, ProgressBar)

local LoaderProgress = 0
local LoaderFinished = false
local LoaderFailed = false

local function SetLoaderProgress(percent)
    if LoaderFinished or LoaderFailed then return end
    percent = math.clamp(tonumber(percent) or 0, 0, 100)
    if percent < LoaderProgress then percent = LoaderProgress end
    LoaderProgress = percent
    TweenObject(ProgressBar, 0.25, {Size = UDim2.new(percent / 100, 0, 1, 0)})
end

TweenObject(MainFrame, 0.25, {Size = UDim2.new(0, 346, 0, 121)})
task.wait(0.25)
SetLoaderProgress(0)

-------------------------
-- THƯ VIỆN FLUENT UI
--------------------------
SetLoaderProgress(10)
local success, Fluent = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/MR-MPC3/Fluent/master/main.lua"))()
end)

if not success or not Fluent then
    LoaderFailed = true
    if LoaderGui and LoaderGui.Parent then LoaderGui:Destroy() end
    error("[Fat Cat Hub] Không thể tải Fluent UI! Hãy kiểm tra lại kết nối mạng hoặc Executor")
end
SetLoaderProgress(25)

local Window = Fluent:CreateWindow({
    Title = "Fat Cat Hub", 
    SubTitle = "", 
    TabWidth = 160, 
    Theme = "Dark",
    Acrylic = false,
    Size = UDim2.fromOffset(520, 320),
    --logo nút ẩn hiện menu chính
    ToggleIcon = "rbxassetid://13717478897",
})

pcall(function()
    if Window.Root then
        Window.Minimized = true
        Window.Root.Visible = false
    end
end)
SetLoaderProgress(30)

---------------------
-- CÁC TABS CHÍNH
---------------------
local TabDefinitions={
    {"Info","Info","info"},
    {"Farm","Farm","sword"},
    {"StackFarming","Stack Farming","layers"},
    {"ItemShop","Item & Shop","package"},
    {"ServerHopFarm","Server & Hop Farm","server"},
    {"ESPStats","ESP & Stats","eye"},
    {"FruitRaid","Fruits & Raid","apple"},
    {"TeleportPvP","Teleport & PvP","map-pin"},
    {"Race","Race","shield"},
    {"SeaEvent","Sea Events","waves"},
    {"Setting","Settings","settings"},
    {"DiscordWebhook","Discord Webhook","message-circle"}
}

local Tabs={}
for i,tab in ipairs(TabDefinitions) do
    local ok,result=pcall(Window.AddTab,Window,{Title=tab[2],Icon=tab[3]})
    if not ok or not result then
        result=Window:AddTab({Title=tab[2]})
    end
    Tabs[tab[1]]=result
    SetLoaderProgress(30+((i/#TabDefinitions)*20))
    task.wait()
end
SetLoaderProgress(50)

----------------------------------------------------------------
-- CONFIG SAVE LƯU DỮ LẠI DỮ LIỆU NGƯỜI DÙNG ĐỂ SÀI CHO LẦN SAU
------------------------------------------------------------------
local Options = Fluent.Options
local CONFIG_FOLDER = "FatCatHub"
local CONFIG_FILE = CONFIG_FOLDER .. "/DU_LIEU_TK_" .. tostring(plr.Name) .. ".json"
local IsResettingConfig = false
local DefaultConfig = {}
local savePending = false
local saveGeneration = 0

local function DeepCopy(value)
    if type(value) ~= "table" then return value end
    local result = {}
    for k, v in pairs(value) do result[k] = DeepCopy(v) end
    return result
end

local function EnsureConfigFolder()
    if typeof(isfolder) == "function" and typeof(makefolder) == "function" then
        if not isfolder(CONFIG_FOLDER) then pcall(makefolder, CONFIG_FOLDER) end
    end
end

local function WriteConfig(data)
    if typeof(writefile) ~= "function" then return end
    pcall(function()
        EnsureConfigFolder()
        writefile(CONFIG_FILE, HttpService:JSONEncode(data))
    end)
end

local function SaveConfig()
    if IsResettingConfig then return end
    if typeof(writefile) ~= "function" then return end
    pcall(function()
        EnsureConfigFolder()
        local data = {}
        for idx, opt in pairs(Options) do
            if opt and opt.Value ~= nil then
                data[idx] = DeepCopy(opt.Value)
            end
        end
        WriteConfig(data)
    end)
end

local function QueueSaveConfig()
    if IsResettingConfig or savePending then return end
    savePending = true
    saveGeneration = saveGeneration + 1
    local generation = saveGeneration
    task.delay(0.75, function()
        if generation ~= saveGeneration then return end
        savePending = false
        if not IsResettingConfig then SaveConfig() end
    end)
end

local function LoadConfig()
    if typeof(readfile) ~= "function" or typeof(isfile) ~= "function" then return end
    if not isfile(CONFIG_FILE) then return end
    local ok, content = pcall(readfile, CONFIG_FILE)
    if not ok or type(content) ~= "string" or content == "" then return end
    local ok2,data=pcall(function() return HttpService:JSONDecode(content) end)
    if not ok2 or type(data) ~= "table" then return end
    for idx, value in pairs(data) do
        local opt = Options[idx]
        if opt and type(opt.SetValue) == "function" then
            pcall(function() opt:SetValue(value) end)
        end
    end
end

local function CaptureDefaults()
    for idx, opt in pairs(Options) do
        if opt and opt.Value ~= nil then
            DefaultConfig[idx] = DeepCopy(opt.Value)
        end
    end
end

local function ValuesEqual(a, b)
    if type(a) ~= type(b) then return false end
    if type(a) ~= "table" then return a == b end
    for k, v in pairs(a) do
        if not ValuesEqual(v, b[k]) then return false end
    end
    for k in pairs(b) do
        if a[k] == nil then return false end
    end
    return true
end

local function ResetAllToDefault()
    if IsResettingConfig then return end
    IsResettingConfig = true
    saveGeneration = saveGeneration + 1
    savePending = false
    task.spawn(function()
        local changed = 0
        for idx, defaultValue in pairs(DefaultConfig) do
            local opt = Options[idx]
            if opt and opt.Value ~= nil and type(opt.SetValue) == "function" and not ValuesEqual(opt.Value, defaultValue) then
                pcall(function() opt:SetValue(DeepCopy(defaultValue)) end)
                changed = changed + 1
                if changed % 6 == 0 then task.wait() end
            end
        end
        WriteConfig(DeepCopy(DefaultConfig))
        IsResettingConfig = false
        Fluent:Notify({Title = "Fat Cat Hub", Content = "Đã khôi phục thiết lập mặc định!", Duration = 3})
    end)
end

local function WrapOptionsForAutoSave()
    for idx, opt in pairs(Options) do
        if opt and type(opt.SetValue) == "function" and not opt.__FatCatWrapped then
            local originalSetValue = opt.SetValue
            opt.SetValue = function(self, value, ...)
                originalSetValue(self, value, ...)
                if not IsResettingConfig then QueueSaveConfig() end
            end
            opt.__FatCatWrapped = true
        end
    end
end

SetLoaderProgress(55)

----------------------------
-- BUILD UI 
----------------------------
function BuildUI()
    Tabs.Setting:AddButton({
        Title="Khôi Phục Thiết Lập Mặc Định",
        Description="Đưa toàn bộ cài đặt về mặc định",
        Callback=function()
            ResetAllToDefault()
        end
    })
    
end

---------------------------------------
-- TIẾN TRÌNH LOADER VÀ KẾT THÚC LOADER
----------------------------------------
SetLoaderProgress(60)
BuildUI()
SetLoaderProgress(78)

CaptureDefaults()         
SetLoaderProgress(84)

LoadConfig()               
SetLoaderProgress(90)

WrapOptionsForAutoSave()  
SetLoaderProgress(96)

task.wait()
SetLoaderProgress(100)
task.wait(0.5)

local function FinishLoader()
    if LoaderFinished then return end
    LoaderFinished = true

    TweenObject(UserImage, 0.35, {ImageTransparency = 1})
    TweenObject(UserNameLabel, 0.35, {TextTransparency = 1})
    TweenObject(TitleLabel, 0.35, {TextTransparency = 1})
    TweenObject(ProgressBG, 0.35, {BackgroundTransparency = 1})
    TweenObject(ProgressBar, 0.35, {BackgroundTransparency = 1})
    task.wait(0.4)

    TweenObject(MainFrame, 0.25, {Size = UDim2.new(0, 0, 0, 0)})
    task.wait(0.3)

    if LoaderGui and LoaderGui.Parent then
        LoaderGui:Destroy()
    end
end

FinishLoader()
task.wait()
Fluent:Notify({
    Title = "Fat Cat Hub",
    Content = "Tải Xong - Anh Em Chơi Vui Vẻ",
    Duration = 10
}) 