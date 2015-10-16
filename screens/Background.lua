local Background = Core.class(Sprite)

local BACKGROUND_LAYERS_COUNT 	= 4
local BACKGROUND_MAX_WIDTH 		= 512
local BACKGROUND_LAYER_ALPHA    = {0.6, 0.7, 0.8, 1}
local BACKGROUND_LAYERS_DEPTHS 	= {0.1, 0.25, 0.5, 0.75}

local EFFECTS_LEVELS_SPEED = {
	[3] = 0.1
}

function Background:init(level)
	if not level then
		level = 1
	end
	self.effectsLayer = Sprite.new()
	self.currentLevel = 0
	self:loadLevel(level)
end

function Background:loadLevel(level)
	if self.layers and #self.layers > 0 then
		for i, layer in ipairs(self.layers) do
			for i = 1, layer:getNumChildren() do
				layer:removeChildAt(1)
			end
			self:removeChild(layer)
		end
	end
	self.layers = {}
	for i = 1, BACKGROUND_LAYERS_COUNT do
		local layerTexture = Texture.new("assets/background/" .. tostring(level) .. "/" .. tostring(i) .. ".png")

		local bitmap1 = Bitmap.new(layerTexture)
		local bitmap2 = Bitmap.new(layerTexture)
		bitmap2:setY(bitmap1:getHeight())

		local layer = Sprite.new()
		layer:addChild(bitmap1)
		layer:addChild(bitmap2)
		layer:setAlpha(BACKGROUND_LAYER_ALPHA[i])
		self:addChild(layer)
		table.insert(self.layers, layer)
	end

	if self.effectsLayer:getParent() then
		self:removeChild(self.effectsLayer)
	end
	self:addChild(self.effectsLayer)

	if EFFECTS_LEVELS_SPEED[level] then
		local effectsTexture = Texture.new("assets/background/" .. tostring(level) .. "/effects.png")
		local bitmap1 = Bitmap.new(effectsTexture)
		local bitmap2 = Bitmap.new(effectsTexture)
		bitmap2:setY(bitmap1:getHeight())
		
		self.effectsLayer:addChild(bitmap1)
		self.effectsLayer:addChild(bitmap2)

		self:addChild(self.effectsLayer)
	end
	self.currentLevel = level
end

function Background:move(dy)
	for i, layer in ipairs(self.layers) do
		layer:setY(layer:getY() + dy * BACKGROUND_LAYERS_DEPTHS[i])
		if layer:getY() + layer:getHeight() < screenHeight then
			layer:setY(layer:getY() + layer:getHeight() / 2)
		elseif layer:getY() > 0 then
			layer:setY(layer:getY() - layer:getHeight() / 2)
		end
	end

	-- if EFFECTS_LEVELS_SPEED[self.currentLevel] then
	-- 	self.effectsLayer:setX(self.effectsLayer:getX() + dx)

	-- 	self.effectsLayer:setY(self.effectsLayer:getY() + EFFECTS_LEVELS_SPEED[self.currentLevel])
	-- 	if self.effectsLayer:getY() > 0 then
	-- 		self.effectsLayer:setY(self.effectsLayer:getY() - self.effectsLayer:getHeight() / 2)
	-- 	end
	-- end
end

return Background