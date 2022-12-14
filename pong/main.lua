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
	Bigfont = love.graphics.newFont('font.ttf', 16)

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

    sounds = {
        ['paddle_hit'] = love.audio.newSource('sounds/paddle_hit.wav', 'static'),
        ['score'] = love.audio.newSource('sounds/score.wav', 'static'),
        ['wall_hit'] = love.audio.newSource('sounds/wall_hit.wav', 'static')
    }

	pointsToWin = 5
	gameState = 'newGame'
	winner = 0
	scores = {p1=0, p2=0}
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
			sounds['paddle_hit']:play()
		elseif collides(gameBall, player2) then
			gameBall:redirectX(player2.x - gameBall.width)
			sounds['paddle_hit']:play()
		end
	
		if gameBall.y < 0 then
			gameBall:redirectY(0)
			sounds['wall_hit']:play()
		elseif gameBall.y > VIRTUAL_HEIGHT - gameBall.height then
			gameBall:redirectY(VIRTUAL_HEIGHT - gameBall.height)
			sounds['wall_hit']:play()
		end

		if gameBall.x + gameBall.width < 0 then
			sounds['score']:play()
			scores.p2 = scores.p2 + 1
			gameBall:reset(VIRTUAL_WIDTH/2 - 4, VIRTUAL_HEIGHT/2 - 4)

			if scores.p2 >= pointsToWin then
				gameState = 'endGame'
				winner = 2
			end

		elseif gameBall.x > VIRTUAL_WIDTH then
			sounds['score']:play()
			scores.p1 = scores.p1 + 1
			gameBall:reset(VIRTUAL_WIDTH/2 - 4, VIRTUAL_HEIGHT/2 - 4)

			if scores.p1 >= pointsToWin then
				gameState = 'endGame'
				winner = 1
			end
		end
	
		gameBall:update(dt)
	end
end

function love.draw()
	push:apply('start')
	
	local bg = {55/255, 55/255, 68/255, 1}
	love.graphics.clear(bg)
	
	love.graphics.setFont(Bigfont)
	if gameState == 'newGame' then
		love.graphics.printf("PRESS ENTER TO START", 0, 0, VIRTUAL_WIDTH, 'center')
	elseif gameState == 'playing' then
		love.graphics.printf(tostring(scores.p1), VIRTUAL_WIDTH / 2 - 20, 30, VIRTUAL_WIDTH, "left")
		love.graphics.printf(tostring(scores.p2), VIRTUAL_WIDTH / 2 + 15, 30, VIRTUAL_WIDTH, "left")
	elseif gameState == 'endGame' then
		love.graphics.printf('GAME OVER', 0, 50, VIRTUAL_WIDTH, 'center')
		love.graphics.printf('PLAYER '.. tostring(winner) .. ' WINS', 0, 75, VIRTUAL_WIDTH, 'center')
	end
	
	love.graphics.setFont(Smallfont)
	love.graphics.printf(tostring(love.timer.getFPS()), 5, 5, VIRTUAL_WIDTH)

	gameBall:render()
	player1:render()
	player2:render()

	push:apply('end')
end

function love.keypressed(key)
	if key == 'escape' then
		love.event.quit()
	end
	if gameState == 'newGame'then
		if key == 'enter' or key == 'return' then
			gameState = 'playing'
		end
	elseif gameState == 'endGame' then
		if key == 'enter' or key == 'return' then
			scores.p1 = 0
			scores.p2 = 0
			gameState = 'playing'
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