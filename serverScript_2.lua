--P32


--Sends Gui to player instead of keeping tons of Gui in itself
game.ReplicatedStorage.callGui.OnServerEvent:Connect(function(player,screen)
if game.Players:FindFirstChild(player.Name) ~= nil then
if game.Players:FindFirstChild(player.Name).PlayerGui.screenGui:FindFirstChild(screen) == nil then
local toClone = script.guiMap:FindFirstChild(screen):Clone()
toClone.Parent = game.Players:FindFirstChild(player.Name).PlayerGui.screenGui
end
end
end)

--Filters the name
game.ReplicatedStorage.filterName.OnServerEvent:Connect(function(player,text)
local success, response = pcall(function()
	local textService = game:GetService("TextService")
	filteredText  = textService:FilterStringAsync(text, player.UserId)
end)
local function getFilteredMessage()
	local success, errorMessage = pcall(function()
		filteredMessage = filteredText:GetNonChatStringForUserAsync(player.UserId)
	end)
end
print(filteredMessage)
if success then
game.ReplicatedStorage.filterName:FireClient(player,filteredMessage)
else
filteredText = ""
game.ReplicatedStorage.filterName:FireClient(player,filteredMessage)
end
end)
