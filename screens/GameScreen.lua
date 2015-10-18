local utils 		= require "utils"
local Screen 		= require "screens.Screen"
local PolarObject 	= require "objects.PolarObject"
local Ring 			= require "rings.Ring"

local GameScreen = Core.class(Screen)

function GameScreen:load(...)
	self.gameContainer = Sprite.new()
	-- self:setAnchorPoint(0.5, 0.5)
	self.gameContainer:setPosition(screenWidth / 2, screenHeight / 2)
	self:addChild(self.gameContainer)

	self.currentRing = 1

	self.rings = {}
	for i = 1, 4 do
		self.rings[i] = Ring.new(i, 1)
		self.gameContainer:addChild(self.rings[i])
	end

	self.p = PolarObject.new(self.rings[self.currentRing].radius, 0, 20)
	self.gameContainer:addChild(self.p)

	self:addEventListener(Event.KEY_DOWN, GameScreen.onKeyDown, self)
end

function GameScreen:onKeyDown(e)
	-- ring movement
	local newRing = self.currentRing
	if e.keyCode == KeyCode.DOWN then
		newRing = newRing - 1
		if newRing < 1 then 
			newRing = 1;
		end
		self.currentRing = newRing
		self.p:setRadius(self.rings[self.currentRing].radius)
	elseif e.keyCode == KeyCode.UP then
		newRing = newRing + 1
		if newRing > 4 then 
			newRing = 4;
		end

		self.currentRing = newRing
		self.p:setRadius(self.rings[self.currentRing].radius)
	end

	-- ring morphing
	if e.keyCode == KeyCode.LEFT then
		for i = 1, 4 do
			self.rings[i]:swapState(self.rings[i].state - 1)
		end
	elseif e.keyCode == KeyCode.RIGHT then

		for i = 1, 4 do
			self.rings[i]:swapState(self.rings[i].state + 1)
		end
	end
end

function GameScreen:unload()

end

function GameScreen:update(deltaTime)
	self.p:update(deltaTime)
	for i = 1, 4 do
		self.rings[i]:update(deltaTime)
	end
end

return GameScreen