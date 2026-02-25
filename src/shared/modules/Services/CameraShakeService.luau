local CameraShakeService = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CameraShakeEvent = ReplicatedStorage.Events:WaitForChild("CameraShakeEvent")

function CameraShakeService.ShakePlayerCamera(player, intensity, duration)
	CameraShakeEvent:FireClient(player, intensity, duration)
end

return CameraShakeService
