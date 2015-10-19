local PolarObject = require "objects.PolarObject"

local Player = Core.class(PolarObject)

Player.LINE_SWITCH_TIME = 0.2

function Player:init(radius, angle, velocity)
	self.switchingLine = false

	local texture = Texture.new("assets/player.png", false)
	self:setTexture(texture)
end

function Player:update(deltaTime)
	if self.switchingLine then 
		self.currentPolarRadius = self.currentPolarRadius  + self.lineSwitchSpeed * deltaTime
		if math.abs(self.polarRadius - self.currentPolarRadius) < math.abs(2 * self.lineSwitchSpeed * deltaTime) then 
			self.currentPolarRadius = self.polarRadius
			self.switchingLine = false
		end
		self.angularVelocity = self.velocity / self.currentPolarRadius
	end
	self.super.update(self, deltaTime)
end

function Player:setRadius(radius)
	self.super.setRadius(self, radius)
	self.switchingLine = true
	self.lineSwitchSpeed = (self.polarRadius - self.currentPolarRadius) / Player.LINE_SWITCH_TIME
end

return Player