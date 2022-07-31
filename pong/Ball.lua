Ball = Class{}

function Ball:init(x, y, size, color)
    self.x = x
    self.y = y

    self.dx = math.random(2) == 1 and 150 or -150
    self.dy = math.random(2) == 1 and math.random(50, 100) or math.random(-50, -100)

    self.width = size
    self.height = size

    self.color = color
end
function Ball:reset(x, y)
    self.x = x
    self.y = y

    self.dx = math.random(2) == 1 and 150 or -150
    self.dy = math.random(2) == 1 and math.random(50, 100) or math.random(-50, -100)
end

function Ball:update(dt)
   self.x = self.x + self.dx * dt
   self.y = self.y + self.dy * dt
end

function Ball:redirectX(newX)
    self.x = newX
    self.dx = - self.dx * 1.11
    self.dy = self.dy + math.random(5) * (math.random(2) == 1 and 1 or -1)
end

function Ball:redirectY(newY)
    self.y = newY
    self.dy = - self.dy
end


function Ball:render()
    love.graphics.setColor(self.color)
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end