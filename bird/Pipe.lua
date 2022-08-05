Pipe = Class{}


PIPE_IMAGE = love.graphics.newImage('pipe.png')
PIPE_GAP = 110
PIPE_SCROLL_SPEED = 100

function Pipe:init(x)
    self.x = x

    self.height = math.random(30, VIRTUAL_HEIGHT - PIPE_GAP - 50)
    self.width = PIPE_IMAGE:getWidth()

    self.gap = PIPE_GAP

    self.dx = PIPE_SCROLL_SPEED

    self.image = PIPE_IMAGE
end

function Pipe:update(dt)
    self.x = self.x - self.dx * dt
end

function Pipe:render()
    love.graphics.draw(self.image, self.x, 0, math.pi, 1, 1, self.width, self.height)
    love.graphics.draw(self.image, self.x, self.height + self.gap)
end