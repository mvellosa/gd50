Bird = Class{}

function Bird:init(x, y, width, height, image)
    self.x = x
    self.y = y
    
    self.width = width
    self.height = height

    self.image = image

    self.jumpForce = 500

    self.dy = 0
    self.currRotation = 0
end

function Bird:jump()
    self.dy = math.max(math.min(self.dy - self.jumpForce, -150), -250)
    self.currRotation = - math.pi / 4
end

function Bird:update(dt)
    self.y = self.y + self.dy * dt
    self.dy = self.dy + GRAVITY
    self.currRotation = math.min(self.currRotation + math.pi / 2 * dt, math.pi/2)
end

function Bird:render()
    love.graphics.draw(self.image, self.x, self.y, self.currRotation)
end