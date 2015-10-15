function getScreenSize()
	local width = application:getDeviceWidth()
	local height = application:getDeviceHeight()

	if string.find(application:getOrientation(), "landscape") then
		width, height = height, width
	end

	return width, height
end

screenWidth, screenHeight = getScreenSize()


function createCircleShape(radius, color, isFilled)
	if not color then color = 0xFF0000 end
	local segmentsCount = 64
	local shape = Shape.new()
	if isFilled then
		shape:setFillStyle(Shape.SOLID, color, solid)
	else
		shape:setLineStyle(2, color, 1)
	end
	shape:beginPath()
	for i = 1, segmentsCount + 1 do
		local angle = i / segmentsCount * math.pi * 2
		local x = math.cos(angle) * radius
		local y = math.sin(angle) * radius
		if i > 1 then
			shape:lineTo(x, y)
		else
			shape:moveTo(x, y)
		end
	end
	shape:endPath()
	return shape
end

local START_RADIUS = screenHeight / 2 * 0.9

local radius = START_RADIUS
local rings = {}
for i = 1, 6 do
	local circle = createCircleShape(radius, 0x595959)
	stage:addChild(circle)
	circle:setPosition(screenWidth / 2, screenHeight / 2)
	table.insert(rings, radius)
	radius = radius - 40
end

local Player = Core.class(Sprite)
function Player:init(color)
	if not color then
		color = 0x0000FF
	end
	self.circle = createCircleShape(10, color, 1)
	self:addChild(self.circle)
	self.currentRadius = 0
	self.currentRing = 1
	self.currentPosition = 0
	self.speed = 2
	self.speedMul = 1
end
function Player:update(deltaTime)
	self:setX(screenWidth / 2 + math.cos(self.currentPosition) * self.currentRadius)
	self:setY(screenHeight / 2 + math.sin(self.currentPosition) * self.currentRadius)

	self.currentPosition = self.currentPosition + self.speed * deltaTime * self.speedMul
end
function Player:setRing(ring)
	self.currentRing = math.max(math.min(ring, #rings), 1)
	self.currentRadius = rings[self.currentRing]
	self.speed = self.currentRing + 1
end


local players = {}

players[1] = Player.new()
stage:addChild(players[1])
players[1]:setRing(1)

players[2] = Player.new(0xFF0000)
stage:addChild(players[2])
players[2]:setRing(#rings - 1)
players[2].speedMul = -1

stage:addEventListener(Event.ENTER_FRAME, 
	function(e)
		for i, player in ipairs(players) do
			player:update(e.deltaTime)
		end
	end
)

stage:addEventListener(Event.KEY_DOWN, 
	function(e)
		if e.keyCode == KeyCode.UP then
			players[1]:setRing(players[1].currentRing + 1)
		elseif e.keyCode == KeyCode.DOWN then
			players[1]:setRing(players[1].currentRing - 1)
		end
	end
)

