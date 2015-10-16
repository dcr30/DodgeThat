local utils = require "utils"
local ScreenManager = require "screens.ScreenManager"

application:setBackgroundColor(0x170D0F)

screenWidth, screenHeight = utils:getScreenSize()
mainScale = screenHeight / 128
screenWidth, screenHeight = screenWidth / mainScale, screenHeight / mainScale

-- Setup screen manager
screenManager = ScreenManager.new()
screenManager:setScale(mainScale)
stage:addChild(screenManager)
screenManager:loadScreen("MenuScreen", false)