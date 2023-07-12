--U46
--Input Beheer




--SETUP

--Alle benodigde waarden hier
inputMode = game:GetService("UserInputService")


--Pad naar statistieken

player = game.Players.LocalPlayer
workPlayer = workspace:WaitForChild(player.Name)
humanoid = workPlayer:WaitForChild("Humanoid")




--INPUT ACTIES

--ADD ANTI TEXTBOX KEYS

inputMode.InputBegan:Connect(function(inputType)
if inputType.UserInputType == Enum.UserInputType.Keyboard then
if inputType.KeyCode == Enum.KeyCode.Q then -- Use Special Action

end
if inputType.KeyCode == Enum.KeyCode.R then -- Toggle Screen Light

end
if inputType.KeyCode == Enum.KeyCode.F then -- Open Inventory

end
if inputType.KeyCode == Enum.KeyCode.C then -- Crawl

end
if inputType.KeyCode == Enum.KeyCode.Z then -- Toggle Screen Mode

end
if inputType.KeyCode == Enum.KeyCode.X then -- Open Mission Log

end
if inputType.KeyCode == Enum.KeyCode.T then -- Open Animation Screen

end
if inputType.KeyCode == Enum.KeyCode.LeftShift then -- Run
humanoid.WalkSpeed = 32
end
end
end)




inputMode.InputEnded:Connect(function(inputType)
if inputType.UserInputType == Enum.UserInputType.Keyboard then

if inputType.KeyCode == Enum.KeyCode.LeftShift then
humanoid.WalkSpeed = 16
end
end
end)
