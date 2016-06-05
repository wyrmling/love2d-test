-- vector object

vector = {}

function vector:new(x, y, angle, speed, accel)
    local newObj = {
        x = x or 0,
        y = y or 0,
        angle = angle or 0,
        speed = speed or 0,
        accel = accel or 0,
    }
    self.__index = self
    return setmetatable(newObj, self)
end

--function vector:setSpeed(speed)
--    self.speed = speed
--end
--
--function vector:getSpeed()
--    return self.speed
--end

function vector:getVector()
    local x = math.cos(math.rad(self.angle)) * self.speed
    local y = math.sin(math.rad(self.angle)) * self.speed
    return x, y
end

function vector:setAngle(angle)
    if angle > 360 then
        angle = angle - 360
    elseif angle < 0 then
        angle = angle + 360
    end
    self.angle = angle
end

function vector:drawVector()
    -- tan(a) =
    local x = math.cos(math.rad(self.angle)) * self.speed * 100
    local y = math.sin(math.rad(self.angle)) * self.speed * 100
    love.graphics.setColor(255, 255, 255)
    love.graphics.line(self.x, self.y, self.x + x, self.y + y)
    graph.print('coord: ' .. x .. ' | ' .. y, self.x, self.y+70, 0, 2, 2)

    self.speed = self.speed + self.accel

    self.x = self.x + math.cos(math.rad(self.angle)) * self.speed
    self.y = self.y + math.sin(math.rad(self.angle)) * self.speed
end