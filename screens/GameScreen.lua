local utils = require "utils"
local Screen = require "screens.Screen"
local PolarObject = require "objects.PolarObject"

local GameScreen = Core.class(Screen)

function GameScreen:load(...)
	self.gameContainer = Sprite.new()
	-- self:setAnchorPoint(0.5, 0.5)
	self.gameContainer:setPosition(screenWidth / 2, screenHeight / 2)
	self:addChild(self.gameContainer)

	self.p = PolarObject.new(10, 0, 20)
	self.gameContainer:addChild(self.p)
	-- DEBUG
	self.periods = 0
	self.time    = 1
	self.periodsCounter = TextField.new(nil, "Frequency: " .. tostring(self.periods))
	self.periodsCounter:setTextColor(0xFFFFFF)
	self.periodsCounter:setPosition(0, self.periodsCounter:getHeight())
	self:addChild(self.periodsCounter)
end

function GameScreen:unload()

end

function GameScreen:update(deltaTime)
	self.p:update(deltaTime)
	self.periodsCounter:setText("Frequency: " .. tostring(self.p.angularVelocity / 2 / math.pi))
end

return GameScreen