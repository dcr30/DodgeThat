local utils = require "utils"
local PolarObject = Core.class(Sprite)

PolarObject.LINE_SWITCH_TIME = 0.5

-- all angle measures are in radians
function PolarObject:init(radius, angle, velocity)
	-- Polar coordinates
	if not angle then
		self.polarAngle = 0
	else 
		self.polarAngle = angle
	end
	if not radius then
		self.polarRadius = 1;
	else 
		self.polarRadius = radius
	end
	if not velocity then
		self.velocity = 0
	else 
		self.velocity = velocity
	end
	
	self.angularVelocity = self.velocity / self.polarRadius

	-- DEBUG texture
	self.bmp = Bitmap.new(Texture.new("assets/player.png", false))
	self.bmp:setAnchorPoint(0.5, 0.5)
	self:addChild(self.bmp)
	-- Physical radius
	self.radius = self.bmp:getWidth() / 2
	self.currentPolarRadius = self.polarRadius
	self.lineSwitchSpeed = 0
	self.switchingLine = false
end

function PolarObject:update(deltaTime)
	if self.switchingLine then 
		self.currentPolarRadius = self.currentPolarRadius  + self.lineSwitchSpeed * deltaTime
		print(self.lineSwitchSpeed)
		if math.abs(self.polarRadius - self.currentPolarRadius) < math.abs(2 * self.lineSwitchSpeed * deltaTime) then 
			self.currentPolarRadius = self.polarRadius
			self.switchingLine = false
		end
		self.angularVelocity = self.velocity / self.currentPolarRadius
		print(self.currentPolarRadius, self.polarRadius)
	end

	self.polarAngle = utils.wrapAngle(self.polarAngle  +  self.angularVelocity * deltaTime)

	self:setX((self.currentPolarRadius) * math.cos(self.polarAngle))
	self:setY((self.currentPolarRadius) * math.sin(self.polarAngle))
end

function PolarObject:setRadius(radius)
	radius = utils.setDefaultIfNil(radius, self.polarRadius)
	if (radius < 1) then
		radius = 1
	end
	self.polarRadius = radius
	self.angularVelocity = self.velocity / self.polarRadius
	self.switchingLine = true
	-- Maybe to player? 
	self.lineSwitchSpeed = (self.polarRadius - self.currentPolarRadius) / PolarObject.LINE_SWITCH_TIME
end

function PolarObject:hitTestObject(obj)
	if not obj then
		print("Object given to hitTest is nil")
		return false
	end
	
	if not (self.polarRadius == obj.polarRadius) then
		return false
	end

	local dx = (obj:getX() - self:getX())
	local dy = (obj:getY() - self:getY())
	local minDistance = self.radius + obj.radius
	if (dx * dx + dy * dy) <= minDistance * minDistance then 
		return true 
	else 
		return false
	end
end

return PolarObject