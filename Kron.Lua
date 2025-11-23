-- Custom UI Library | Полностью деобфусцирован из customui.txt
-- MoonSec V3 + Luraph v14.4.2 — полностью удалены

local Library = {}

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- Основной контейнер
function Library:Window(options)
    options = options or {}
    local title = options.Title or "Custom Library"
    local size = options.Size or UDim2.new(0, 550, 0, 600)

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Parent = CoreGui
    ScreenGui.Name = "CustomLibrary_" .. math.random(1000, 9999)

    local MainFrame = Instance.new("Frame")
    MainFrame.Size = size
    MainFrame.Position = UDim2.new(0.5, -size.X.Offset/2, 0.5, -size.Y.Offset/2)
    MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = ScreenGui
    MainFrame.ClipsDescendants = true

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = MainFrame

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, 0, 0, 40)
    TitleLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    TitleLabel.Text = title
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextSize = 16
    TitleLabel.Parent = MainFrame

    local TitleCorner = Instance.new("UICorner")
    TitleCorner.CornerRadius = UDim.new(0, 8)
    TitleCorner.Parent = TitleLabel

    local TabContainer = Instance.new("Frame")
    TabContainer.Size = UDim2.new(1, 0, 0, 35)
    TabContainer.Position = UDim2.new(0, 0, 0, 40)
    TabContainer.BackgroundTransparency = 1
    TabContainer.Parent = MainFrame

    local ContentFrame = Instance.new("Frame")
    ContentFrame.Size = UDim2.new(1, -10, 1, -85)
    ContentFrame.Position = UDim2.new(0, 5, 0, 80)
    ContentFrame.BackgroundTransparency = 1
    ContentFrame.Parent = MainFrame

    local Tabs = {}

    local function MakeDraggable(frame)
        local dragging, dragInput, dragStart, startPos
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

        frame.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement then
                dragInput = input
            end
        end)

        RunService.RenderStepped:Connect(function()
            if dragging and dragInput then
                local delta = dragInput.Position - dragStart
                frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end)
    end

    MakeDraggable(TitleLabel)

    function Tabs:Tab(name)
        local TabButton = Instance.new("TextButton")
        TabButton.Size = UDim2.new(0, 120, 1, 0)
        TabButton.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
        TabButton.Text = name
        TabButton.TextColor3 = Color3.fromRGB(200, 200, 200)
        TabButton.Font = Enum.Font.Gotham
        TabButton.Parent = TabContainer
        TabButton.LayoutOrder = #TabContainer:GetChildren()

        local TabContent = Instance.new("Frame")
        TabContent.Size = UDim2.new(1, 0, 1, 0)
        TabContent.BackgroundTransparency = 1
        TabContent.Visible = false
        TabContent.Parent = ContentFrame

        local TabCorner = Instance.new("UICorner")
        TabCorner.CornerRadius = UDim.new(0, 6)
        TabCorner.Parent = TabButton

        local UIListLayout = Instance.new("UIListLayout")
        UIListLayout.Padding = UDim.new(0, 8)
        UIListLayout.Parent = TabContent

        if #Tabs == 0 then
            TabButton.BackgroundColor3 = Color3.fromRGB(60, 120, 255)
            TabButton.TextColor3 = Color3.new(1,1,1)
            TabContent.Visible = true
        end

        TabButton.MouseButton1Click:Connect(function()
            for _, tab in pairs(Tabs) do
                tab.Button.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
                tab.Button.TextColor3 = Color3.fromRGB(200, 200, 200)
                tab.Content.Visible = false
            end
            TabButton.BackgroundColor3 = Color3.fromRGB(60, 120, 255)
            TabButton.TextColor3 = Color3.new(1,1,1)
            TabContent.Visible = true
        end)

        local Tab = {}

        function Tab:Button(text, callback)
            local Button = Instance.new("TextButton")
            Button.Size = UDim2.new(1, 0, 0, 35)
            Button.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
            Button.Text = text
            Button.TextColor3 = Color3.new(1,1,1)
            Button.Font = Enum.Font.Gotham
            Button.Parent = TabContent

            local BtnCorner = Instance.new("UICorner")
            BtnCorner.CornerRadius = UDim.new(0, 6)
            BtnCorner.Parent = Button

            Button.MouseButton1Click:Connect(function()
                spawn(callback)
            end)

            Button.MouseEnter:Connect(function()
                TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(70, 70, 80)}):Play()
            end)

            Button.MouseLeave:Connect(function()
                TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(45, 45, 50)}):Play()
            end)
        end

        function Tab:Toggle(text, default, callback)
            local Toggle = Instance.new("TextButton")
            Toggle.Size = UDim2.new(1, 0, 0, 35)
            Toggle.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
            Toggle.Text = text .. " [OFF]"
            Toggle.TextColor3 = Color3.new(1,1,1)
            Toggle.Parent = TabContent

            local ToggleCorner = Instance.new("UICorner")
            ToggleCorner.CornerRadius = UDim.new(0, 6)
            ToggleCorner.Parent = Toggle

            local enabled = default or false

            if enabled then
                Toggle.Text = text .. " [ON]"
                Toggle.BackgroundColor3 = Color3.fromRGB(60, 120, 255)
            end

            Toggle.MouseButton1Click:Connect(function()
                enabled = not enabled
                if enabled then
                    Toggle.Text = text .. " [ON]"
                    TweenService:Create(Toggle, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60, 120, 255)}):Play()
                else
                    Toggle.Text = text .. " [OFF]"
                    TweenService:Create(Toggle, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(45, 45, 50)}):Play()
                end
                spawn(function() callback(enabled) end)
            end)
        end

        table.insert(Tabs, {Button = TabButton, Content = TabContent})
        return Tab
    end

    return Tabs
end

return Library
