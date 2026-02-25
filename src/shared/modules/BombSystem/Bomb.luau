local Bomb = {}
Bomb.__index = Bomb

function Bomb.new(
	bombModel: Model,
	wall: Instance,
	destroyedWall: Instance,
	debrisModel: Instance?,
	doExplosion: boolean?
)
	local self = setmetatable({}, Bomb)

	self.bombModel = bombModel:Clone()
	self.wall = wall
	self.destroyedWall = destroyedWall
	self.debrisModel = debrisModel
	self.doExplosion = doExplosion

	return self
end

function Bomb:Explode(countdown: number, bombPlacementLocation: Vector3)
	self.bombModel:SetPrimaryPartCFrame(CFrame.new(bombPlacementLocation))

	self.bombModel.Parent = workspace

	task.wait(countdown)

	if self.wall then
		self.wall:Destroy()
	end

	if self.destroyedWall then
		self.destroyedWall.Parent = workspace
	end

	if self.debrisModel then
		local debris = self.debrisModel:Clone()
		debris:SetPrimaryPartCFrame(CFrame.new(bombPlacementLocation))
		debris.Parent = workspace
	end

	if self.doExplosion then
		local explosion = Instance.new("Explosion")
		explosion.Position = bombPlacementLocation
		explosion.BlastRadius = 10
		explosion.BlastPressure = 50000
		explosion.Parent = workspace
	end

	self.bombModel:Destroy()
end

return Bomb
