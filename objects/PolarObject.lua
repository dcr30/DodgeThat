local utils = require "utils"
local PolarObject = Core.class(Sprite)

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
	self.bmp = Bitmap.new(Texture.new("assets/debug.png", false))
	self.bmp:setAnchorPoint(0.5, 0.5)
	self:addChild(self.bmp)
	-- Physical radius
	self.radius = self.bmp:getWidth() / 2
end

function PolarObject:update(deltaTime)
	self.polarAngle = utils.wrapAngle(self.polarAngle  +  self.angularVelocity * deltaTime)
	
	self:setX(self.polarRadius * math.cos(self.polarAngle))
	self:setY(self.polarRadius * math.sin(self.polarAngle))
end

function PolarObject:hitTestObject(obj)
	if not obj then
		print("Object given to hitTest is nil")
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