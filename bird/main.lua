push = require 'push'
Class = require 'class'
require 'Bird'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

local background = love.graphics.newImage('background.png')


local ground = love.graphics.newImage('ground.png')

local bgCurrStart = 0
local groundCurrStart = 0

local bgloopLocation = 413
local groundloopLocation = VIRTUAL_WIDTH

local bgSpeed = 50
local groundSpeed = 100

GRAVITY = 10

function love.load() 
    love.graphics.setDefaultFilter('nearest', 'nearest')

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = true,
        vsync = true
    })
    player = Bird(30, 20, 30, 30, love.graphics.newImage('bird.png'))
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.update(dt)
    bgCurrStart = (bgCurrStart + bgSpeed * dt) % bgloopLocation
    groundCurrStart = (groundCurrStart + groundSpeed * dt) % groundloopLocation

    player:update(dt)
end

function love.draw()
    push:start()

    love.graphics.draw(background, -bgCurrStart, 0)
    love.graphics.draw(ground, -groundCurrStart, VIRTUAL_HEIGHT - 16)

    player:render()
    push:finish()
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    elseif key == 'space' then
        player:jump() 
    end
end