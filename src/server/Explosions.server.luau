--[[Credits:
Original Script: https://create.roblox.com/store/asset/13701040544/Better-explosions
Modified to fix deprecated issues and imporve performance by someonehere.
]]

local Duration1 = 0.2
local Duration2 = 8

local Debris = game:GetService("Debris")

function Particalize(Explosion)
	Explosion.Visible = true
	local Part = Instance.new("Part")
	Part.Name = "ExplosionParticle"
	local ticksound = Instance.new("Sound")
	ticksound.SoundId = "rbxassetid://"
	ticksound.Parent = Part
	ticksound.Volume = 100
	ticksound:Play()
	Part.Transparency = 1
	Part.Size = Vector3.new(0, 0, 0)
	Part.Anchored = true
	Part.CanCollide = false
	Part.CFrame = CFrame.new(Explosion.Position)
	Part.Parent = game.Workspace
	local C = script:GetChildren()
	for i = 1, #C do
		if C[i].className == "ParticleEmitter" then
			local Particle = C[i]:Clone()
			Particle.Parent = Part
			Particle.Enabled = true
		end
	end
	task.wait(Duration1)
	local P = Part:GetChildren()
	for i = 1, #P do
		if P[i].className == "ParticleEmitter" then
			P[i].Enabled = false
		end
	end
	task.wait(8)
	Debris:AddItem(Part, Duration2)
end

game.Workspace.DescendantAdded:Connect(function(descendant)
	if descendant:IsA("Explosion") and descendant.Visible == true then
		Particalize(descendant)
	end
end)
