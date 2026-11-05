
--==================================================
-- BLUE & BLACK RPG ADMIN UI
-- PG ADMIN V2 COMMANDS MERGED
-- MOBILE | TABLET | PC
--==================================================

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- SETTINGS
local BLUE = Color3.fromRGB(0,170,255)
local DARKBLUE = Color3.fromRGB(0,65,125)
local BLACK = Color3.fromRGB(8,10,16)
local PANEL = Color3.fromRGB(12,15,23)
local WHITE = Color3.fromRGB(255,255,255)
local RED = Color3.fromRGB(190,45,55)

local SpeedValue = 16
local JumpValue = 50
local SavedTransparency = {}

local DiscordInvite = "https://discord.gg/4WMhDgFCz"

-- REMOVE OLD GUI
local Old = PlayerGui:FindFirstChild("BlueRPG_UI")
if Old then Old:Destroy() end

--==================================================
-- SCREEN GUI
--==================================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BlueRPG_UI"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.DisplayOrder = 100
ScreenGui.Parent = PlayerGui

--==================================================
-- MAIN PANEL
--==================================================

local Main = Instance.new("Frame")
Main.Name = "MainPanel"
Main.Size = UDim2.fromOffset(460,360)
Main.AnchorPoint = Vector2.new(0.5,0.5)
Main.Position = UDim2.fromScale(0.5,0.5)
Main.BackgroundColor3 = BLACK
Main.BorderSizePixel = 0
Main.ClipsDescendants = true
Main.Parent = ScreenGui

Instance.new("UICorner",Main).CornerRadius = UDim.new(0,8)

local Scale = Instance.new("UIScale")
Scale.Parent = Main

local function UpdateScale()
    local Camera = workspace.CurrentCamera
    if not Camera then return end

    local Viewport = Camera.ViewportSize

    local WidthScale = (Viewport.X - 32) / 460
    local HeightScale = (Viewport.Y - 32) / 360

    Scale.Scale = math.clamp(
        math.min(WidthScale,HeightScale),
        0.45,
        1.15
    )
end

local function ConnectCamera(Camera)
    if not Camera then return end
    Camera:GetPropertyChangedSignal("ViewportSize"):Connect(UpdateScale)
    UpdateScale()
end

ConnectCamera(workspace.CurrentCamera)

workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
    ConnectCamera(workspace.CurrentCamera)
end)

--==================================================
-- ANIMATED BLUE BORDER
--==================================================

local Border = Instance.new("UIStroke")
Border.Thickness = 3
Border.Color = BLUE
Border.Parent = Main

local Gradient = Instance.new("UIGradient")
Gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0,Color3.fromRGB(0,40,120)),
    ColorSequenceKeypoint.new(0.5,BLUE),
    ColorSequenceKeypoint.new(1,Color3.fromRGB(0,40,120))
})
Gradient.Parent = Border

task.spawn(function()
    while ScreenGui.Parent do
        local T = TweenService:Create(
            Gradient,
            TweenInfo.new(2,Enum.EasingStyle.Linear),
            {Rotation = 360}
        )
        T:Play()
        T.Completed:Wait()
        Gradient.Rotation = 0
    end
end)

-- INNER PANEL

local Inner = Instance.new("Frame")
Inner.Size = UDim2.new(1,-12,1,-12)
Inner.Position = UDim2.fromOffset(6,6)
Inner.BackgroundColor3 = PANEL
Inner.BorderSizePixel = 0
Inner.Parent = Main

Instance.new("UICorner",Inner).CornerRadius = UDim.new(0,6)

--==================================================
-- HEADER
--==================================================

local Header = Instance.new("Frame")
Header.Size = UDim2.new(1,0,0,58)
Header.BackgroundTransparency = 1
Header.Parent = Inner

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1,-110,0,35)
Title.Position = UDim2.fromOffset(12,3)
Title.BackgroundTransparency = 1
Title.Text = "COMMAND PANEL"
Title.TextColor3 = BLUE
Title.Font = Enum.Font.GothamBold
Title.TextSize = 19
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local Subtitle = Instance.new("TextLabel")
Subtitle.Size = UDim2.new(1,-110,0,16)
Subtitle.Position = UDim2.fromOffset(13,35)
Subtitle.BackgroundTransparency = 1
Subtitle.Text = "BLUE & BLACK RPG ADMIN"
Subtitle.TextColor3 = Color3.fromRGB(120,155,185)
Subtitle.Font = Enum.Font.Gotham
Subtitle.TextSize = 9
Subtitle.TextXAlignment = Enum.TextXAlignment.Left
Subtitle.Parent = Header

local Minimize = Instance.new("TextButton")
Minimize.Size = UDim2.fromOffset(38,32)
Minimize.Position = UDim2.new(1,-48,0,10)
Minimize.BackgroundColor3 = DARKBLUE
Minimize.Text = "—"
Minimize.TextColor3 = WHITE
Minimize.TextSize = 22
Minimize.Font = Enum.Font.GothamBold
Minimize.Parent = Header

Instance.new("UICorner",Minimize).CornerRadius = UDim.new(0,6)

local Reopen = Instance.new("TextButton")
Reopen.Size = UDim2.fromOffset(55,55)
Reopen.Position = UDim2.new(0,15,0.5,0)
Reopen.AnchorPoint = Vector2.new(0,0.5)
Reopen.BackgroundColor3 = DARKBLUE
Reopen.Text = "RPG"
Reopen.TextColor3 = WHITE
Reopen.TextSize = 17
Reopen.Font = Enum.Font.GothamBold
Reopen.Visible = false
Reopen.Parent = ScreenGui

Instance.new("UICorner",Reopen).CornerRadius = UDim.new(0,10)

Minimize.Activated:Connect(function()
    Main.Visible = false
    Reopen.Visible = true
end)

Reopen.Activated:Connect(function()
    Main.Visible = true
    Reopen.Visible = false
end)

--==================================================
-- TAB BAR
--==================================================

local TabHolder = Instance.new("Frame")
TabHolder.Size = UDim2.new(1,-24,0,38)
TabHolder.Position = UDim2.fromOffset(12,62)
TabHolder.BackgroundTransparency = 1
TabHolder.Parent = Inner

local TabLayout = Instance.new("UIListLayout")
TabLayout.FillDirection = Enum.FillDirection.Horizontal
TabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
TabLayout.VerticalAlignment = Enum.VerticalAlignment.Center
TabLayout.Padding = UDim.new(0,5)
TabLayout.Parent = TabHolder

local Content = Instance.new("Frame")
Content.Size = UDim2.new(1,-28,1,-118)
Content.Position = UDim2.fromOffset(14,106)
Content.BackgroundColor3 = BLACK
Content.BorderSizePixel = 0
Content.ClipsDescendants = true
Content.Parent = Inner

Instance.new("UICorner",Content).CornerRadius = UDim.new(0,5)

--==================================================
-- PAGE SYSTEM
--==================================================

local TabNames = {"MAIN","SPEED","JUMP","INFO"}
local Pages = {}
local TabButtons = {}

local function CreatePage(Name)
    local Page = Instance.new("ScrollingFrame")
    Page.Name = Name
    Page.Size = UDim2.fromScale(1,1)
    Page.BackgroundTransparency = 1
    Page.BorderSizePixel = 0
    Page.ScrollBarThickness = 4
    Page.ScrollBarImageColor3 = BLUE
    Page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    Page.CanvasSize = UDim2.new(0,0,0,0)
    Page.Visible = false
    Page.Parent = Content

    local Layout = Instance.new("UIListLayout")
    Layout.Padding = UDim.new(0,8)
    Layout.SortOrder = Enum.SortOrder.LayoutOrder
    Layout.Parent = Page

    local Padding = Instance.new("UIPadding")
    Padding.PaddingTop = UDim.new(0,10)
    Padding.PaddingBottom = UDim.new(0,12)
    Padding.PaddingLeft = UDim.new(0,10)
    Padding.PaddingRight = UDim.new(0,10)
    Padding.Parent = Page

    Pages[Name] = Page
    return Page
end

for _,Name in ipairs(TabNames) do
    CreatePage(Name)
end

--==================================================
-- TAB BUTTONS
--==================================================

local function SwitchTab(Name)
    for Tab,Page in pairs(Pages) do
        Page.Visible = Tab == Name
    end

    for Tab,B in pairs(TabButtons) do
        B.BackgroundColor3 =
            Tab == Name and DARKBLUE or PANEL
    end
end

for _,Name in ipairs(TabNames) do
    local B = Instance.new("TextButton")
    B.Name = Name
    B.Size = UDim2.new(0.25,-5,1,0)
    B.BackgroundColor3 = PANEL
    B.Text = Name
    B.TextColor3 = WHITE
    B.TextSize = 11
    B.Font = Enum.Font.GothamBold
    B.AutoButtonColor = false
    B.Parent = TabHolder

    Instance.new("UICorner",B).CornerRadius = UDim.new(0,5)

    local S = Instance.new("UIStroke")
    S.Color = BLUE
    S.Thickness = 1
    S.Parent = B

    TabButtons[Name] = B

    B.Activated:Connect(function()
        SwitchTab(Name)
    end)
end

--==================================================
-- UI HELPERS
--==================================================

local function Label(Page,Text)
    local L = Instance.new("TextLabel")
    L.Size = UDim2.new(1,-8,0,32)
    L.BackgroundTransparency = 1
    L.Text = Text
    L.TextColor3 = WHITE
    L.TextSize = 13
    L.Font = Enum.Font.GothamBold
    L.TextXAlignment = Enum.TextXAlignment.Left
    L.Parent = Page
    return L
end

local function Button(Page,Text,Callback,Color)
    local B = Instance.new("TextButton")
    B.Size = UDim2.new(1,-8,0,42)
    B.BackgroundColor3 = Color or DARKBLUE
    B.Text = Text
    B.TextColor3 = WHITE
    B.TextSize = 13
    B.Font = Enum.Font.GothamBold
    B.AutoButtonColor = true
    B.Parent = Page

    Instance.new("UICorner",B).CornerRadius = UDim.new(0,6)

    local S = Instance.new("UIStroke")
    S.Color = BLUE
    S.Thickness = 1
    S.Parent = B

    B.Activated:Connect(Callback)
    return B
end

local function GetHumanoid()
    local Character = Player.Character
    return Character and Character:FindFirstChildOfClass("Humanoid")
end

local function InputBox(Page,Name,Default,Placeholder)
    local Box = Instance.new("TextBox")
    Box.Name = Name
    Box.Size = UDim2.new(1,-8,0,43)
    Box.BackgroundColor3 = Color3.fromRGB(18,25,38)
    Box.TextColor3 = WHITE
    Box.PlaceholderColor3 = Color3.fromRGB(140,160,185)
    Box.Text = Default
    Box.PlaceholderText = Placeholder
    Box.TextSize = 15
    Box.Font = Enum.Font.GothamBold
    Box.ClearTextOnFocus = false
    Box.MultiLine = false
    Box.TextEditable = true
    Box.Parent = Page

    Instance.new("UICorner",Box).CornerRadius = UDim.new(0,6)

    return Box
end

--==================================================
-- TAB 1: MAIN COMMANDS
--==================================================

local MainPage = Pages.MAIN

Label(MainPage,"MAIN COMMANDS")

Button(MainPage,"HEAL CHARACTER",function()
    local H = GetHumanoid()
    if H then
        H.Health = H.MaxHealth
    end
end)

Button(MainPage,"RESET CHARACTER",function()
    local H = GetHumanoid()
    if H then
        H.Health = 0
    end
end,RED)

Button(MainPage,"RESPAWN",function()
    local H = GetHumanoid()
    if H then
        H.Health = 0
    end
end)

local function SetInvisible(State)
    local Character = Player.Character
    if not Character then return end

    for _,Obj in ipairs(Character:GetDescendants()) do
        if Obj:IsA("BasePart") or Obj:IsA("Decal") then
            if State then
                if SavedTransparency[Obj] == nil then
                    SavedTransparency[Obj] = Obj.Transparency
                end

                Obj.Transparency = 1
            elseif SavedTransparency[Obj] ~= nil then
                Obj.Transparency = SavedTransparency[Obj]
            end
        end
    end

    if not State then
        table.clear(SavedTransparency)
    end
end

Button(MainPage,"INVISIBLE",function()
    SetInvisible(true)
end)

Button(MainPage,"VISIBLE",function()
    SetInvisible(false)
end)

--==================================================
-- TAB 2: SPEED
--==================================================

local SpeedPage = Pages.SPEED

Label(SpeedPage,"SPEED SETTINGS")

local SpeedDisplay = Label(
    SpeedPage,
    "Current WalkSpeed: 16"
)

local SpeedBox = InputBox(
    SpeedPage,
    "CustomSpeedInput",
    "16",
    "Enter speed (16-200)"
)

local function ApplySpeed()
    local V = tonumber(SpeedBox.Text)

    if not V then
        SpeedDisplay.Text = "Enter a valid number!"
        return
    end

    SpeedValue = math.clamp(V,16,200)
    SpeedBox.Text = tostring(SpeedValue)

    local H = GetHumanoid()
    if H then
        H.WalkSpeed = SpeedValue
    end

    SpeedDisplay.Text = "Current WalkSpeed: "..SpeedValue
end

SpeedBox.FocusLost:Connect(function(EnterPressed)
    if EnterPressed then
        ApplySpeed()
    end
end)

Button(SpeedPage,"APPLY SPEED",ApplySpeed)

Button(SpeedPage,"RESET SPEED",function()
    SpeedValue = 16
    SpeedBox.Text = "16"

    local H = GetHumanoid()
    if H then H.WalkSpeed = 16 end

    SpeedDisplay.Text = "Current WalkSpeed: 16"
end,RED)

--==================================================
-- TAB 3: JUMP
--==================================================

local JumpPage = Pages.JUMP

Label(JumpPage,"JUMP SETTINGS")

local JumpDisplay = Label(
    JumpPage,
    "Current JumpPower: 50"
)

local JumpBox = InputBox(
    JumpPage,
    "CustomJumpInput",
    "50",
    "Enter jump power (0-200)"
)

local function ApplyJump()
    local V = tonumber(JumpBox.Text)

    if not V then
        JumpDisplay.Text = "Enter a valid number!"
        return
    end

    JumpValue = math.clamp(V,0,200)
    JumpBox.Text = tostring(JumpValue)

    local H = GetHumanoid()

    if H then
        H.UseJumpPower = true
        H.JumpPower = JumpValue
    end

    JumpDisplay.Text = "Current JumpPower: "..JumpValue
end

JumpBox.FocusLost:Connect(function(EnterPressed)
    if EnterPressed then
        ApplyJump()
    end
end)

Button(JumpPage,"APPLY JUMP",ApplyJump)

Button(JumpPage,"RESET JUMP",function()
    JumpValue = 50
    JumpBox.Text = "50"

    local H = GetHumanoid()

    if H then
        H.UseJumpPower = true
        H.JumpPower = 50
    end

    JumpDisplay.Text = "Current JumpPower: 50"
end,RED)

--==================================================
-- TAB 4: PLAYER INFORMATION
--==================================================

local InfoPage = Pages.INFO

Label(InfoPage,"PLAYER INFORMATION")

local InfoLabels = {}

local function InfoLine(Name)
    local L = Label(InfoPage,Name)
    L.TextSize = 11
    InfoLabels[Name] = L
end

InfoLine("Username")
InfoLine("Display Name")
InfoLine("User ID")
InfoLine("Account Age")
InfoLine("Health")
InfoLine("WalkSpeed")
InfoLine("JumpPower")

local function UpdateInfo()
    local H = GetHumanoid()

    InfoLabels["Username"].Text =
        "Username: "..Player.Name

    InfoLabels["Display Name"].Text =
        "Display Name: "..Player.DisplayName

    InfoLabels["User ID"].Text =
        "User ID: "..Player.UserId

    InfoLabels["Account Age"].Text =
        "Account Age: "..Player.AccountAge.." days"

    if H then
        InfoLabels["Health"].Text =
            "Health: "..math.floor(H.Health)

        InfoLabels["WalkSpeed"].Text =
            "WalkSpeed: "..H.WalkSpeed

        InfoLabels["JumpPower"].Text =
            "JumpPower: "..H.JumpPower
    end
end

-- SUPPORT

Label(InfoPage,"SUPPORT")

local SupportButton

SupportButton = Button(
    InfoPage,
    "JOIN SUPPORT SERVER",
    function()
        local Success = pcall(function()
            GuiService:OpenBrowserWindow(DiscordInvite)
        end)

        if not Success then
            SupportButton.Text = "OPENING NOT SUPPORTED"

            task.delay(2,function()
                if SupportButton.Parent then
                    SupportButton.Text = "JOIN SUPPORT SERVER"
                end
            end)
        end
    end,
    DARKBLUE
)

local DiscordText = Label(InfoPage,DiscordInvite)
DiscordText.TextWrapped = true
DiscordText.TextSize = 10
DiscordText.TextColor3 = BLUE

Button(InfoPage,"COPY DISCORD INVITE",function()
    if typeof(setclipboard) == "function" then
        local Success = pcall(setclipboard,DiscordInvite)

        if Success then
            SupportButton.Text = "INVITE COPIED!"

            task.delay(2,function()
                if SupportButton.Parent then
                    SupportButton.Text = "JOIN SUPPORT SERVER"
                end
            end)
        end
    end
end)

Label(InfoPage,"BLUE & BLACK RPG ADMIN")

--==================================================
-- CHARACTER RESPAWN SUPPORT
--==================================================

Player.CharacterAdded:Connect(function(Character)
    task.wait(0.5)

    local H = Character:WaitForChild("Humanoid")

    H.WalkSpeed = SpeedValue
    H.UseJumpPower = true
    H.JumpPower = JumpValue

    table.clear(SavedTransparency)
    UpdateInfo()
end)

--==================================================
-- LIVE INFORMATION
--==================================================

task.spawn(function()
    while ScreenGui.Parent do
        UpdateInfo()
        task.wait(1)
    end
end)

--==================================================
-- DRAGGING SYSTEM
--==================================================

local Dragging = false
local DragStart
local StartPosition

Header.InputBegan:Connect(function(Input)
    if Input.UserInputType == Enum.UserInputType.MouseButton1
    or Input.UserInputType == Enum.UserInputType.Touch then

        Dragging = true
        DragStart = Input.Position
        StartPosition = Main.Position
    end
end)

UserInputService.InputChanged:Connect(function(Input)
    if Dragging and (
        Input.UserInputType == Enum.UserInputType.MouseMovement
        or Input.UserInputType == Enum.UserInputType.Touch
    ) then

        local Delta = Input.Position - DragStart

        Main.Position = UDim2.new(
            StartPosition.X.Scale,
            StartPosition.X.Offset + Delta.X,
            StartPosition.Y.Scale,
            StartPosition.Y.Offset + Delta.Y
        )
    end
end)

UserInputService.InputEnded:Connect(function(Input)
    if Input.UserInputType == Enum.UserInputType.MouseButton1
    or Input.UserInputType == Enum.UserInputType.Touch then
        Dragging = false
    end
end)

--==================================================
-- INITIALIZE
--==================================================

SwitchTab("MAIN")
UpdateInfo()

print("BLUE & BLACK RPG ADMIN UI LOADED")
