Paddle = Class{}


function Paddle:init(x, y, width, height, color)
    self.x = x
    self.y = y
    
    self.dy = 200
    
    self.width = width
    self.height = height

    self.color = color
end

function Paddle:render()
    love.graphics.setColor(self.color)
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end

function Paddle:goUp(dt)
    self.y = math.max(self.y - self.dy * dt, 5)
end

function Paddle:goDown(dt)
    self.y = math.min(self.y + self.dy * dt, VIRTUAL_HEIGHT - self.height - 5)
end