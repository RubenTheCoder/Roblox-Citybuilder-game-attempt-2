--H98
--GUI beheer




--SETUP

--Alle benodigde waarden hier
player = game.Players.LocalPlayer
workPlayer = workspace:WaitForChild(player.Name)
humanoid = workPlayer:WaitForChild("Humanoid")
id = player.UserId
gui = script.Parent
fade = gui:WaitForChild("fade")
market = game:GetService("MarketplaceService")
starterGui = game:GetService("StarterGui")


--Pad naar statistieken
playerStats = gui:WaitForChild("playerStats")
materials = playerStats:WaitForChild("materials")
condition = playerStats:WaitForChild("condition")
energy = condition:WaitForChild("energy")
food = condition:WaitForChild("food")
water = condition:WaitForChild("water")


--Stel de tweens op in een tabel
tweenStyles = {}
tweenStyles[1] = Enum.EasingStyle.Linear
tweenStyles[2] = Enum.EasingStyle.Sine
tweenStyles[3] = Enum.EasingStyle.Back
tweenStyles[4] = Enum.EasingStyle.Quad
tweenStyles[5] = Enum.EasingStyle.Quart
tweenStyles[6] = Enum.EasingStyle.Quint
tweenStyles[7] = Enum.EasingStyle.Bounce
tweenStyles[8] = Enum.EasingStyle.Elastic
tweenStyles[9] = Enum.EasingStyle.Exponential
tweenStyles[10] = Enum.EasingStyle.Circular
tweenStyles[11]= Enum.EasingStyle.Cubic


--Tween referentietabel
-- 1 = Linear
-- 2 = Sine
-- 3 = Back
-- 4 = Quad
-- 5 = Quart
-- 6 = Quint
-- 7 = Bounce
-- 8 = Elastic
-- 9 = Exponential
-- 10 = Circular
-- 11 = Cubic




--TOEWIJZING VAN KNOPPEN--

--Deze functie zal automatisch elke knop een functie geven en weet welke dankzij ingevoegde informatie van de knop
local buttons = gui:GetDescendants()
starterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, false)
for index,button in pairs(buttons) do




--VEREISTEN VOOR ACTIVATIE

--Als het een knop is zal deze activeren
if button:IsA("TextButton") and button:FindFirstChild("settings") ~= nil or button:IsA("ImageButton") and button:FindFirstChild("settings") ~= nil then
button.Activated:Connect(function()
local settingsMap = button.settings
local allowed = true
if button.Active == true then
button.Active = false


--Controleer of de kosten er zijn
if settingsMap:FindFirstChild("requiredCosts") ~= nil then
allowed = false
local costs = settingsMap:FindFirstChild("requiredCost"):GetChildren()
for index,cost in pairs(costs) do
allowed = false
if materials:FindFirstChild(cost.Name) ~= nil then
if materials:FindFirstChild(cost.Name).Value >= cost.Value then
allowed = true
end
end
end
end


--Controleert of je de gamepass hebt
if settingsMap:FindFirstChild("requiredGamePass") ~= nil then
allowed = false
if market:UserOwnsGamePassAsync(id,settingsMap.requiredGamePass.Value) then
allowed = true
end
end


--Controleert of je premium hebt
if settingsMap:FindFirstChild("requiredPremium") ~= nil then
allowed = false
if player.MembershipType == Enum.MembershipType.Premium then
allowed = true
end
end



--Controleer of de kosten er zijn en trek het ervan af, maar alleen als de rest ook klopt, deze dus als laatst
if settingsMap:FindFirstChild("requiredCostsAndSubtract") ~= nil then
allowed = false
local costs = settingsMap:FindFirstChild("requiredCostsAndSubtract"):GetChildren()
for index,cost in pairs(costs) do
allowed = false
if materials:FindFirstChild(cost.Name) ~= nil then
if materials:FindFirstChild(cost.Name).Value >= cost.Value then
allowed = true
end
end
end
if allowed == true then
for index,cost in pairs(costs) do
materials:FindFirstChild(cost.Name).Value -= cost.Value
if materials:FindFirstChild(cost.Name).Value <= 0 then
materials:FindFirstChild(cost.Name):Destroy()
end
end
end
end



--INSTANT FAAL ACTIES

--Als er niet betaald kon worden en dan geopend moet worden
if settingsMap:FindFirstChild("ifFailedOpen") ~= nil and allowed == false then
settingsMap.ifFailedOpen.Value.Visible = true
end


--Als er niet betaald kon worden en dan gesloten moet worden
if settingsMap:FindFirstChild("ifFailedClose") ~= nil and allowed == false then
settingsMap.ifFailedClose.Value.Visible = false
end


--Als er een prompt voor een pas komt omdat de speler de pas niet heeft
if settingsMap:FindFirstChild("ifFailedPromptGamePass") ~= nil and allowed == false then
market:PromptGamePassPurchase(player,settingsMap.ifFailedPromptGamePass.Value)
end


--Als er een prompt voor premium komt omdat de speler dat niet heeft
if settingsMap:FindFirstChild("ifFailedPromptPremium") ~= nil and allowed == false then
market:PromptPremiumPurchase(player)
end


--Als er een kleur word gewijzigd bij falen
if settingsMap:FindFirstChild("ifFailedChangeColor") ~= nil and allowed == false then
if settingsMap.ifFailedChangeColor.changeImageColor.Value == true then
settingsMap.ifFailedChangeColor.target.Value.ImageColor3 = settingsMap.ifFailedChangeColor.Value
else
settingsMap.ifFailedChangeColor.target.Value.BackgroundColor3 = settingsMap.ifFailedChangeColor.Value
end
end







--LANGE FAALACTIES

--Als er een kleurovergang komt bij falen
if settingsMap:FindFirstChild("ifFailedColorShift") ~= nil and allowed == false then
if settingsMap.ifFailedColorShift.changeImageColor.Value == true then
local stepR = ((settingsMap.ifFailedColorShift.target.Value.ImageColor3.R * 255) - (settingsMap.ifFailedColorShift.Value.R * 255)) / 100
local stepG = ((settingsMap.ifFailedColorShift.target.Value.ImageColor3.G * 255) - (settingsMap.ifFailedColorShift.Value.G * 255)) / 100
local stepB = ((settingsMap.ifFailedColorShift.target.Value.ImageColor3.B * 255) - (settingsMap.ifFailedColorShift.Value.B * 255)) / 100
for i=1,100 do
settingsMap.ifFailedColorShift.target.Value.ImageColor3 = Color3.fromRGB((settingsMap.ifFailedColorShift.target.Value.ImageColor3.R * 255) - stepR,(settingsMap.ifFailedColorShift.target.Value.ImageColor3.G * 255) - stepG,(settingsMap.ifFailedColorShift.target.Value.ImageColor3.B * 255) - stepB)
wait(settingsMap.ifFailedColorShift.duration.Value / 100)
end
settingsMap.ifFailedColorShift.target.Value.ImageColor3 = settingsMap.ifFailedColorShift.Value
else
local stepR = ((settingsMap.ifFailedColorShift.target.Value.BackgroundColor3.R * 255) - (settingsMap.ifFailedColorShift.Value.R * 255)) / 100
local stepG = ((settingsMap.ifFailedColorShift.target.Value.BackgroundColor3.G * 255) - (settingsMap.ifFailedColorShift.Value.G * 255)) / 100
local stepB = ((settingsMap.ifFailedColorShift.target.Value.BackgroundColor3.B * 255) - (settingsMap.ifFailedColorShift.Value.B * 255)) / 100
for i=1,100 do
settingsMap.ifFailedColorShift.target.Value.BackgroundColor3 = Color3.fromRGB((settingsMap.ifFailedColorShift.target.Value.BackgroundColor3.R * 255) - stepR,(settingsMap.ifFailedColorShift.target.Value.BackgroundColor3.G * 255 ) - stepG,(settingsMap.ifFailedColorShift.target.Value.BackgroundColor3.B * 255) - stepB)
wait(settingsMap.ifFailedColorShift.duration.Value / 100)
end
settingsMap.ifFailedColorShift.target.Value.BackgroundColor3 = settingsMap.ifFailedColorShift.Value
end
end


--Als er overgang naar een ander komt omdat er niet betaald kon worden
if settingsMap:FindFirstChild("ifFailedFadeToOther") ~= nil and allowed == false then
for i = 1,20 do
wait(0.05)
fade.BackgroundTransparency -= 0.05
end
settingsMap.ifFailedFadeToOther.target.Value.Visible = true
settingsMap.ifFailedFadeToOther.Value.Visible = false
for i = 1,20 do
wait(0.05)
fade.BackgroundTransparency += 0.05
end
end




--INSTANT ACTIES

--Als er klikgeluid in zit
if settingsMap:FindFirstChild("click") ~= nil then
settingsMap.click:Play()
end


--Als er foutgeluid in zit
if settingsMap:FindFirstChild("error") ~= nil and allowed == false then
settingsMap.error:Play()
end


--Als er geluid in zit
if settingsMap:FindFirstChild("sound") ~= nil and allowed == true then
settingsMap.sound:Play()
end


--Als er tekst moet worden afgebeeld
if settingsMap:FindFirstChild("setText") ~= nil and allowed == true then
settingsMap.setText.target.Value.Text = settingsMap.setText.Value
end


--Als er een prompt voor een pas is omdat de speler hem koopt
if settingsMap:FindFirstChild("buyGamePass") ~= nil and allowed == true then
market:PromptGamePassPurchase(player,settingsMap.buyGamePass.Value)
end


--Als er een prompt voor premium is omdat de speler hem koopt
if settingsMap:FindFirstChild("buyPremium") ~= nil and allowed == true then
market:PromptPremiumPurchase(player)
end


--Geef de speler wat hij hoort te krijgen
if settingsMap:FindFirstChild("grant") ~= nil and allowed == true then
local grants = settingsMap:FindFirstChild("grant"):GetChildren()
for index,grant in pairs(grants) do
if materials:FindFirstChild(grant.Name) == nil then
local newGrant = Instance.new("IntValue")
newGrant.Name = grant.Name
newGrant.Parent = materials
end
materials:FindFirstChild(grant.Name).Value += grant.Value
end
end


--Als er een toggle komt
if settingsMap:FindFirstChild("openOrClose") ~= nil and allowed == true then
if settingsMap.openOrClose.Value.Visible == true then
settingsMap.openOrClose.Value.Visible = false
else
settingsMap.openOrClose.Value.Visible = true
end
end


--Als er geopend moet worden
if settingsMap:FindFirstChild("openScreen") ~= nil and allowed == true then
settingsMap.openScreen.Value.Visible = true
end


--Als er geopend moet worden met tijdslimiet
if settingsMap:FindFirstChild("openScreenTimed") ~= nil and allowed == true then
settingsMap.openScreenTimed.Value.Visible = true
wait(settingsMap.openScreenTimed.duration.Value)
settingsMap.openScreenTimed.Value.Visible = false
end


--Als er gesloten moet worden
if settingsMap:FindFirstChild("closeScreen") ~= nil and allowed == true then
local toClose =settingsMap.closeScreen.Value
toClose.Visible = false
end


--Als er een kleur word gewijzigd
if settingsMap:FindFirstChild("changeColor") ~= nil and allowed == true then
if settingsMap.changeColor.changeImageColor.Value == true then
settingsMap.changeColor.target.Value.ImageColor3 = settingsMap.changeColor.Value
else
settingsMap.changeColor.target.Value.BackgroundColor3 = settingsMap.changeColor.Value
end
end


--Als de speler moet stilstaan
if settingsMap:FindFirstChild("trueFreezePlayerFalseUnfreezePlayer") ~= nil and allowed == true then
if settingsMap.trueFreezePlayerFalseUnfreezePlayer.Value == true then
humanoid.WalkSpeed = 0
humanoid.JumpHeight = 0
else
humanoid.WalkSpeed = 16
humanoid.JumpHeight = 8
end
end


--Als er een scherm verplaatst moet worden
if settingsMap:FindFirstChild("setPosition") ~= nil and allowed == true then
settingsMap.setPosition.target.Value.Position = settingsMap.setPosition.Position
end


--Als er een schermformaat aangepast moet worden
if settingsMap:FindFirstChild("setSize") ~= nil and allowed == true then
settingsMap.setSize.target.Value.Size = settingsMap.setSize.Size
end


--Als het schermformaat en de positie aangepast moeten worden
if settingsMap:FindFirstChild("setSizeAndPosition") ~= nil and allowed == true then
settingsMap.setSizeAndPosition.target.Value.Position = settingsMap.setSizeAndPosition.Position
settingsMap.setSizeAndPosition.target.Value.Size = settingsMap.setSizeAndPosition.Size
end




--LANGE ACTIES

--Als er tekst moet worden afgespeeld
if settingsMap:FindFirstChild("enterText") ~= nil and allowed == true then
for i=1,string.len(settingsMap.enterText.Value) do
settingsMap.enterText.target.Value.Text = string.sub(settingsMap.enterText.Value,1,i)
wait(0.1)
end
end


--Als er tekst moet worden afgespeeld met geluid
if settingsMap:FindFirstChild("enterTextSound") ~= nil and allowed == true then
for i=1,string.len(settingsMap.enterTextSound.Value) do
settingsMap.enterTextSound.target.Value.Text = string.sub(settingsMap.enterTextSound.Value,1,i)
settingsMap.enterTextSound.sound:Play()
wait(0.1)
end
end


--Als er tekst moet worden afgespeeld met tijdlimiet
if settingsMap:FindFirstChild("enterTextTimed") ~= nil and allowed == true then
local temp = settingsMap.enterTextTimed.target.Value.Text
for i=1,string.len(settingsMap.enterTextTimed.Value) do
settingsMap.enterTextTimed.target.Value.Text = string.sub(settingsMap.enterTextTimed.Value,1,i)
wait(0.1)
end
wait(settingsMap.enterTextTimed.duration.Value)
settingsMap.enterTextTimed.target.Value.Text = temp
end


--Als er tekst moet worden afgespeeld met geluid en met tijdlimiet
if settingsMap:FindFirstChild("enterTextSoundTimed") ~= nil and allowed == true then
local temp = settingsMap.enterTextSoundTimed.target.Value.Text
for i=1,string.len(settingsMap.enterTextSoundTimed.Value) do
settingsMap.enterTextSoundTimed.target.Value.Text = string.sub(settingsMap.enterTextSoundTimed.Value,1,i)
settingsMap.enterTextSoundTimed.sound:Play()
wait(0.1)
end
wait(settingsMap.enterTextSoundTimed.duration.Value)
settingsMap.enterTextSoundTimed.target.Value.Text = temp
end


--Als er tekst moet worden afgebeeld met tijdlimiet
if settingsMap:FindFirstChild("setTextTimed") ~= nil and allowed == true then
local temp = settingsMap.setTextTimed.target.Value.Text
settingsMap.setTextTimed.target.Value.Text = settingsMap.setTextTimed.Value
wait(settingsMap.setTextTimed.duration.Value)
settingsMap.setTextTimed.target.Value.Text = temp
end


--Als er een positie tween moet komen
if settingsMap:FindFirstChild("tweenPosition") ~= nil and allowed == true then
if settingsMap.tweenPosition.inOrOutOrInOut.Value == 1 then
settingsMap.tweenPosition.target.Value:TweenPosition(settingsMap.tweenPosition.Position,Enum.EasingDirection.In,tweenStyles[settingsMap.tweenPosition.tweenStyle.Value],settingsMap.tweenPosition.duration.Value,true)
end
if settingsMap.tweenPosition.inOrOutOrInOut.Value == 2 then
settingsMap.tweenPosition.target.Value:TweenPosition(settingsMap.tweenPosition.Position,Enum.EasingDirection.Out,tweenStyles[settingsMap.tweenPosition.tweenStyle.Value],settingsMap.tweenPosition.duration.Value,true)
end
if settingsMap.tweenPosition.inOrOutOrInOut.Value == 3 then
settingsMap.tweenPosition.target.Value:TweenPosition(settingsMap.tweenPosition.Position,Enum.EasingDirection.InOut,tweenStyles[settingsMap.tweenPosition.tweenStyle.Value],settingsMap.tweenPosition.duration.Value,true)
end
end


--Als er een formaat tween moet komen
if settingsMap:FindFirstChild("tweenSize") ~= nil and allowed == true then
if settingsMap.tweenSize.inOrOutOrInOut.Value == 1 then
settingsMap.tweenSize.target.Value:TweenSize(settingsMap.tweenSize.Size,Enum.EasingDirection.In,tweenStyles[settingsMap.tweenSize.tweenStyle.Value],settingsMap.tweenSize.duration.Value,true)
end
if settingsMap.tweenSize.inOrOutOrInOut.Value == 2 then
settingsMap.tweenSize.target.Value:TweenSize(settingsMap.tweenSize.Size,Enum.EasingDirection.Out,tweenStyles[settingsMap.tweenSize.tweenStyle.Value],settingsMap.tweenSize.duration.Value,true)
end
if settingsMap.tweenSize.inOrOutOrInOut.Value == 3 then
settingsMap.tweenSize.target.Value:TweenSize(settingsMap.tweenSize.Size,Enum.EasingDirection.InOut,tweenStyles[settingsMap.tweenSize.tweenStyle.Value],settingsMap.tweenSize.duration.Value,true)
end
end


--Als er een formaat en positie tween moet komen
if settingsMap:FindFirstChild("tweenSizeAndPosition") ~= nil and allowed == true then
if settingsMap.tweenSizeAndPosition.inOrOutOrInOut.Value == 1 then
settingsMap.tweenSizeAndPosition.target.Value:TweenSizeAndPosition(settingsMap.tweenSizeAndPosition.Size,settingsMap.tweenSizeAndPosition.Position,Enum.EasingDirection.In,tweenStyles[settingsMap.tweenSizeAndPosition.tweenStyle.Value],settingsMap.tweenSizeAndPosition.duration.Value,true)
end
if settingsMap.tweenSizeAndPosition.inOrOutOrInOut.Value == 2 then
settingsMap.tweenSizeAndPosition.target.Value:TweenSizeAndPosition(settingsMap.tweenSizeAndPosition.Size,settingsMap.tweenSizeAndPosition.Position,Enum.EasingDirection.Out,tweenStyles[settingsMap.tweenSizeAndPosition.tweenStyle.Value],settingsMap.tweenSizeAndPosition.duration.Value,true)
end
if settingsMap.tweenSizeAndPosition.inOrOutOrInOut.Value == 3 then
settingsMap.tweenSizeAndPosition.target.Value:TweenSizeAndPosition(settingsMap.tweenSizeAndPosition.Size,settingsMap.tweenSizeAndPosition.Position,Enum.EasingDirection.InOut,tweenStyles[settingsMap.tweenSizeAndPosition.tweenStyle.Value],settingsMap.tweenSizeAndPosition.duration.Value,true)
end
end


--Als er geopend moet worden met overgang
if settingsMap:FindFirstChild("openScreenFade") ~= nil and allowed == true then
for i = 1,20 do
wait(0.05)
fade.BackgroundTransparency -= 0.05
end
settingsMap.openScreenFade.Value.Visible = true
for i = 1,20 do
wait(0.05)
fade.BackgroundTransparency += 0.05
end
end


--Als er overgang naar een ander komt
if settingsMap:FindFirstChild("fadeToOtherScreen") ~= nil and allowed == true then
for i = 1,20 do
wait(0.05)
fade.BackgroundTransparency -= 0.05
end
settingsMap.fadeToOtherScreen.target.Value.Visible = true
settingsMap.fadeToOtherScreen.Value.Visible = false
for i = 1,20 do
wait(0.05)
fade.BackgroundTransparency += 0.05
end
end


--Als er opgeladen moet worden
if settingsMap:FindFirstChild("energyUp") ~= nil and allowed == true then
energy.immune.Value = true
for i = 1,settingsMap.energyUp.Value do
wait(0.1)
energy.Value += 1
end
end


--Als er eten bij moet komen
if settingsMap:FindFirstChild("foodUp") ~= nil and allowed == true then
food.immune.Value = true
for i = 1,settingsMap.foodUp.Value do
wait(0.1)
food.Value += 1
end
end


--Als er water bij moet komen
if settingsMap:FindFirstChild("waterUp") ~= nil and allowed == true then
water.immune.Value = true
for i = 1,settingsMap.waterUp.Value do
wait(0.1)
water.Value += 1
end
end


--Als er een kleurovergang komt
if settingsMap:FindFirstChild("colorShift") ~= nil and allowed == true then
if settingsMap.colorShift.changeImageColor.Value == true then
local stepR = ((settingsMap.colorShift.target.Value.ImageColor3.R * 255) - (settingsMap.colorShift.Value.R * 255)) / 100
local stepG = ((settingsMap.colorShift.target.Value.ImageColor3.G * 255) - (settingsMap.colorShift.Value.G * 255)) / 100
local stepB = ((settingsMap.colorShift.target.Value.ImageColor3.B * 255) - (settingsMap.colorShift.Value.B * 255)) / 100
for i=1,100 do
settingsMap.colorShift.target.Value.ImageColor3 = Color3.fromRGB((settingsMap.colorShift.target.Value.ImageColor3.R * 255) - stepR,(settingsMap.colorShift.target.Value.ImageColor3.G * 255) - stepG,(settingsMap.colorShift.target.Value.ImageColor3.B * 255) - stepB)
wait(settingsMap.colorShift.duration.Value / 100)
end
settingsMap.colorShift.target.Value.ImageColor3 = settingsMap.colorShift.Value
else
local stepR = ((settingsMap.colorShift.target.Value.BackgroundColor3.R * 255) - (settingsMap.colorShift.Value.R * 255)) / 100
local stepG = ((settingsMap.colorShift.target.Value.BackgroundColor3.G * 255) - (settingsMap.colorShift.Value.G * 255)) / 100
local stepB = ((settingsMap.colorShift.target.Value.BackgroundColor3.B * 255) - (settingsMap.colorShift.Value.B * 255)) / 100
for i=1,100 do
settingsMap.colorShift.target.Value.BackgroundColor3 = Color3.fromRGB((settingsMap.colorShift.target.Value.BackgroundColor3.R * 255) - stepR,(settingsMap.colorShift.target.Value.BackgroundColor3.G * 255 ) - stepG,(settingsMap.colorShift.target.Value.BackgroundColor3.B * 255) - stepB)
wait(settingsMap.colorShift.duration.Value / 100)
end
settingsMap.colorShift.target.Value.BackgroundColor3 = settingsMap.colorShift.Value
end
end


--Als de speler moet stilstaan
if settingsMap:FindFirstChild("trueFreezePlayerFalseUnfreezePlayer") ~= nil and allowed == true then
if settingsMap.trueFreezePlayerFalseUnfreezePlayer.Value == true then
humanoid.WalkSpeed = 0
humanoid.JumpHeight = 0
else
humanoid.WalkSpeed = 16
humanoid.JumpHeight = 8
end
end




--Het einde
button.Active = true
end
end)
wait()
end
gui.loadScreen.loadScreenScript.done.Value = true
end
