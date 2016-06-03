-- vector object

vector = {}

function vector:new(x, y, angle, speed)
    local newObj = {
        x = x or 0,
        y = y or 0,
        angle = angle or 0,
        speed = speed or 0,
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
    self.angle = angle
    self.x = self.x + math.cos(math.rad(self.angle)) * self.speed
    self.y = self.y + math.sin(math.rad(self.angle)) * self.speed
    return self.x, self.y
end