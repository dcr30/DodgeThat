local utils = require "utils"

local PolarObject = Core.class(Sprite)

-- all angle measures are in radians
function PolarObject:init(radius, angle, velocity)
	-- Polar coordinates
	self.polarAngle  = utils.setDefaultIfNil(angle,  0)
	self.polarRadius = utils.setDefaultIfNil(radius, 1)
	self.velocity    = utils.setDefaultIfNil(velocity, 0)
	
	self.angularVelocity = self.velocity / self.polarRadius
	self.currentPolarRadius = self.polarRadius
	self.lineSwitchSpeed = 0
end

function PolarObject:setTexture(texture)
	local newTexture = utils.setDefaultIfNil(texture, Texture.new("assets/debug.png"))
	if self.bmp then 
		self.bmp:setTexture(newTexture)
	else 
		self.bmp = Bitmap.new(newTexture)
		self:addChild(self.bmp)
	end
	self.bmp:setAnchorPoint(0.5, 0.5)
	self.radius = self.bmp:getWidth() / 2
end

function PolarObject:update(deltaTime)
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