local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CameraShakeService = require(ReplicatedStorage.Shared.modules.Services.CameraShakeService)
local Bomb = {}

Bomb.__index = Bomb

function Bomb.new(bombModel: Model, wall: Instance, destroyedWall: Instance, doExplosion: boolean?)
	local self = setmetatable({}, Bomb)

	self.bombModel = bombModel:Clone()
	self.wall = wall
	self.destroyedWall = destroyedWall:Clone()
	self.doExplosion = doExplosion

	return self
end

function Bomb:Explode(
	countdown: number,
	bombPlacementLocation: CFrame,
	bombSoundEffect: number,
	tickingSoundEffect: number,
	regenWallTime: number
)
	-- condition checks
	if not self.wall:IsA("BasePart") then
		return error("Destroyable wall must be typeof 'Base Part'")
	end
	if not self.destroyedWall:IsA("Model") then
		return error("Destroyable wall must be typeof 'Model'")
	end
	if not self.bombModel:IsA("Model") then
		return error("BombModel must be typeof 'Model'")
	end

	local sound = Instance.new("Sound")
	sound.SoundId = "rbxassetid://" .. bombSoundEffect
	sound.Volume = 1
	sound.PlayOnRemove = true
	sound.Parent = self.bombModel

	local tickingSound = Instance.new("Sound")
	tickingSound.SoundId = "rbxassetid://" .. tickingSoundEffect
	tickingSound.Volume = 0.15
	tickingSound.Looped = true
	tickingSound.Parent = self.bombModel
	tickingSound:Play()

	local clonedWall = nil

	self.bombModel:PivotTo(bombPlacementLocation)

	self.bombModel.Parent = workspace

	task.wait(countdown)

	if self.wall then
		clonedWall = self.wall:Clone()
		self.wall:Destroy()
	end

	task.spawn(function()
		for i = 1, regenWallTime do
			print(i)
			task.wait(1)
		end

		self.destroyedWall:Destroy()
		clonedWall.Parent = workspace
		self:Uninitalize()
	end)

	if self.destroyedWall then
		self.destroyedWall.PrimaryPart.CFrame = self.wall.CFrame
		self.destroyedWall.Parent = workspace
	end

	task.spawn(function()
		if self.doExplosion then
			local explosion = Instance.new("Explosion")
			explosion.BlastRadius = 1
			explosion.BlastPressure = 300
			explosion.Position = bombPlacementLocation.Position
			explosion.Visible = true
			explosion.DestroyJointRadiusPercent = 0
			explosion.ExplosionType = Enum.ExplosionType.NoCraters
			explosion.Parent = workspace
		end
	end)

	task.spawn(function()
		for _, player in pairs(Players:GetPlayers()) do
			local char = player.Character or player.CharacterAdded:Wait()
			local hrp = char.PrimaryPart

			local mag = (bombPlacementLocation.Position - hrp.Position).Magnitude

			if mag <= 25 then
				CameraShakeService.ShakePlayerCamera(player, 2, 2)
			end
		end
	end)

	self.bombModel:Destroy()
	return
end

function Bomb:Uninitalize()
	self = nil
end

return Bomb
