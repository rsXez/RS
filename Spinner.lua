local spinning = false
local spinSpeed = 1

local function spinCharacter()
    while spinning and game.Players.LocalPlayer.Character do
        local root = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if root then
            root.CFrame = root.CFrame * CFrame.Angles(0, math.rad(spinSpeed), 0)
        end
        wait()
    end
end

game:GetService("UserInputService").InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.F4 then
        spinSpeed = spinSpeed + 1
        print("🌀 Скорость крутилки:", spinSpeed)
        
    elseif input.KeyCode == Enum.KeyCode.F5 then
        spinSpeed = math.max(1, spinSpeed - 1)
        print("🌀 Скорость крутилки:", spinSpeed)
        
    elseif input.KeyCode == Enum.KeyCode.F6 then
        spinning = not spinning
        if spinning then
            spinCharacter()
            print("🌀 Крутилка ВКЛ | Скорость:", spinSpeed)
        else
            print("🌀 Крутилка ВЫКЛ")
        end
    end
end)

print("🌀 Крутилка загружена! F4(+speed) F5(-speed) F6(toggle)")
