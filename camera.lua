camera = {}
camera.x = 0
camera.y = 0
camera.scaleX = 1
camera.scaleY = 1
camera.rotation = 0

function camera:set()
    love.graphics.push()

--    love.graphics.setCanvas(canvas)
--    love.graphics.clear()

    love.graphics.rotate(-self.rotation)
    love.graphics.scale(1 / self.scaleX, 1 / self.scaleY)
    love.graphics.translate(-self.x, -self.y)
end

function camera:unset()
--    love.graphics.setCanvas()
--    local x = 0
--    local y = 0
--    local scaler = 5
--    love.graphics.setColor(255,255,255)
--    love.graphics.draw(canvas, x, y, 0, scaler, scaler)

    love.graphics.pop()
end

function camera:move(dx, dy)
    self.x = self.x + (dx or 0)
    self.y = self.y + (dy or 0)
end

function camera:rotate(dr)
    self.rotation = self.rotation + dr
end

function camera:scale(sx, sy)
    sx = sx or 1
    self.scaleX = self.scaleX * sx
    self.scaleY = self.scaleY * (sy or sx)
end

function camera:setPosition(x, y)
    self.x = x or self.x
    self.y = y or self.y
end

function camera:setScale(sx, sy)
    self.scaleX = sx or self.scaleX
    self.scaleY = sy or self.scaleY
end

function camera:mousePosition()
    return love.mouse.getX() * self.scaleX + self.x, love.mouse.getY() * self.scaleY + self.y
end