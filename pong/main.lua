push = require 'push'
Class = require'class'
require 'Ball'
require 'Paddle'

-- windows true dimensions
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

-- virtual window dimensions
VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

function love.load()
	-- no filters applied in the graphics
    love.graphics.setDefaultFilter('nearest', 'nearest')

	Smallfont = love.graphics.newFont('font.ttf', 8)

	-- create window
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = false,
        vsync = true
    })

	local paddleWidth = 5
	local paddleHeight = 30

	gameBall = Ball(VIRTUAL_WIDTH/2 - 4, VIRTUAL_HEIGHT/2 - 4, 4, {1,1,1,1})
	player1 = Paddle(5, VIRTUAL_HEIGHT / 2 - paddleHeight/2, paddleWidth, paddleHeight, {125/255, 206/255, 19/255, 1})
	player2 = Paddle(VIRTUAL_WIDTH - paddleWidth - 5, VIRTUAL_HEIGHT / 2 - paddleHeight/2, paddleWidth, paddleHeight, {235/255, 29/255, 54/255, 1})

	gameState = 'newGame'
end

function love.update(dt)

	if gameState == 'playing' then
		
		if love.keyboard.isDown('s') then
			player1:goDown(dt)
		end
		if love.keyboard.isDown('w') then
			player1:goUp(dt)
		end
	
		if love.keyboard.isDown('down') then
			player2:goDown(dt)
		end
		if love.keyboard.isDown('up') then
			player2:goUp(dt)
		end
	
		if collides(gameBall, player1) then
			gameBall:redirectX(player1.x + player1.width)
		elseif collides(gameBall, player2) then
			gameBall:redirectX(player2.x - gameBall.width)
		end
	
		if gameBall.y < 0 then
			gameBall:redirectY()
		elseif gameBall.y > VIRTUAL_HEIGHT - gameBall.height then
			gameBall:redirectY()
		end
	
		gameBall:update(dt)
	end
end

function love.draw()
	push:apply('start')
	
	local bg = {55/255, 55/255, 68/255, 1}
	love.graphics.clear(bg)
	
	if gameState == 'newGame' then
		love.graphics.printf("PRESS ENTER TO START", 0, 0, VIRTUAL_WIDTH, 'center')
	end

	love.graphics.setFont(Smallfont)
	love.graphics.printf(tostring(love.timer.getFPS()), 5, 5, VIRTUAL_WIDTH)


	gameBall:render()
	player1:render()
	player2:render()

	push:apply('end')
end

function love.keypressed(key)
	if gameState == 'newGame'then
		if key == 'enter' or key == 'return' then
			gameState = 'playing'
		end
	elseif gameState == 'playing' then
		if key == 'enter' or key == 'return' then
			gameBall:reset(VIRTUAL_WIDTH/2 - 4, VIRTUAL_HEIGHT/2 - 4)
		elseif key == 'escape' then
			love.event.quit()
		end
	end
end

function collides(a, b)	
	if a.x > b.x + b.width or a.x + a.width < b.x then
		return false
	end

	if a.y > b.y + b.height or a.y + a.height < b.y then
		return false
	end

	return true
end