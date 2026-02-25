local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local CameraShakeEvent = ReplicatedStorage.Events:WaitForChild("CameraShakeEvent")
local camera = workspace.CurrentCamera

local shaking = false

local function shakeCamera(intensity, duration)
	if shaking then
		return
	end
	shaking = true

	local startTime = tick()
	local originalCFrame = camera.CFrame

	local connection
	connection = RunService.RenderStepped:Connect(function()
		local elapsed = tick() - startTime
		if elapsed >= duration then
			connection:Disconnect()
			camera.CFrame = originalCFrame
			shaking = false
			return
		end

		local targetOffset = Vector3.new(
			(math.random() - 0.5) * 2,
			(math.random() - 0.5) * 2,
			(math.random() - 0.5) * 2
		) * intensity

		local targetCFrame = originalCFrame * CFrame.new(targetOffset)

		camera.CFrame = camera.CFrame:Lerp(targetCFrame, 0.15)
	end)
end

CameraShakeEvent.OnClientEvent:Connect(shakeCamera)
