--Made by Rouxhaver
--(I swear im not racist)
players = game:GetService("Players")
lp = players.LocalPlayer
mouse = lp:GetMouse()
camera = workspace.CurrentCamera

heads = {}

function addplayer(player)
	local index = heads[#heads + 1]
	spawn(function()
		while task.wait() do
			local character = player.Character
			if not character then break end
			headinfo = {}
			headinfo.head = character:WaitForChild("Head")
			table.insert(heads,headinfo)
			while character.Parent do
				task.wait()
			end
		end
	end)
end

for i,player in pairs(players:GetPlayers()) do
	if player ~= lp then
		addplayer(player)
	end
end

players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Wait()
	addplayer(player)
end)

game:GetService("RunService").RenderStepped:Connect(function()
	for i,head in pairs(heads) do
		if not head.tracer then
			local tracer = Drawing.new("Line")
			tracer.Visible = true
			tracer.Color = head.head.Color
			tracer.Thickness = 2
			head.tracer = tracer
		end
		local getposition = camera:WorldToViewportPoint(head.head.Position)
		head.tracer.From = Vector2.new(mouse.X, mouse.Y+35)

		if getposition.Z > 0 then do
			head.tracer.To = Vector2.new(getposition.X, getposition.Y)
		end else
			local ViewportSize = camera.ViewportSize
			local newX = ViewportSize.X/2 + (ViewportSize.X/2 - getposition.X)
			local newY = ViewportSize.Y/2 + (ViewportSize.Y/2 - getposition.Y)
			if newX < ViewportSize.X then
				newY = math.clamp(newY, ViewportSize.Y, math.huge)
			end
			head.tracer.To = Vector2.new(newX, newY)
		end
		if not head.head.Parent or not head.head.Parent.Parent then
			head.tracer:Remove()
			table.remove(heads, i)
		end
	end
end)
