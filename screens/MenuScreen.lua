local Screen 	 = require "screens.Screen"
local Background = require "screens.Background"

local MenuScreen = Core.class(Screen)

local BACKGROUND_MOVEMENT_SPEED = -100

function MenuScreen:load(...)
	self.bg = Background.new()
	self:addChild(self.bg)

	self.time = 0;
	self.logo = Bitmap.new(Texture.new("assets/logo.png", false))
	-- TODO: scaling
	self.logo:setX(screenWidth / 2 - self.logo:getWidth() / 2)
	self.logo:setY(4)
	self:addChild(self.logo)

	self.startGameButton = TextField.new(nil, "Start game")
	self.startGameButton:setTextColor(0xFFFFFF)
	self.startGameButton:setX(screenWidth / 2  - self.startGameButton:getWidth() / 2)
	self.startGameButton:setY(screenHeight / 2 + self.startGameButton:getHeight() / 2)
	self:addChild(self.startGameButton)
	self.startGameButton:addEventListener(Event.TOUCHES_END, self.onButtonClicked, self)
end

function MenuScreen:unload(...)
	self:removeChild(self.bg)
	self.bg = nil

	self:removeChild(self.logo)
	self.logo = nil

	self.startGameButton:removeEventListener(Event.TOUCHES_END, self.onButtonClicked, self)
	self:removeChild(self.startGameButton)
	self.startGameButton = nil
end

function MenuScreen:onButtonClicked(e)
	if self.startGameButton:hitTestPoint(e.touch.x, e.touch.y) then
		screenManager:loadScreen("GameScreen")
	end
end

function MenuScreen:update(deltaTime)
	if self.bg then
		self.bg:move(BACKGROUND_MOVEMENT_SPEED * deltaTime)
	end
	if self.logo then
		self.logo:setY(4 + math.cos(self.time * 3) * 2)
	end
	self.time = self.time + deltaTime
end

return MenuScreen