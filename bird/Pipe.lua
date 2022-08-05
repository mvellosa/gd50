Pipe = Class{}

function Pipe:init(x, height, gap, dx, image)
    self.x = x

    self.height = height

    self.gap = gap

    self.dx = dx

    self.image = image
end

function Pipe:update(dt)
    self.x = self.x - self.dx * dt
end

function Pipe:render()
    love.graphics.draw(self.image, self.x, 0, math.pi, 1, 1, self.image:getWidth(), self.height)
    love.graphics.draw(self.image, self.x, self.height + self.gap)
end