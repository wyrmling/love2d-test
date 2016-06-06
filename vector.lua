-- vector object

vector = {}

function vector:new(x, y, angle, magnitude)
    local newObj = {
        x = x or 0,
        y = y or 0,
        angle = angle or 0,
        magnitude = magnitude or 0,
    }
    self.__index = self
    return setmetatable(newObj, self)
end

function vector:getVector()
    local x = math.cos(math.rad(self.angle)) * self.magnitude
    local y = math.sin(math.rad(self.angle)) * self.magnitude
    return x, y
end

function vector:setAngle(angle)
    self.angle = angle
end

--function vector:drawVector()
--    self.speed = self.speed + self.accel
--
--    self.x = self.x + math.cos(math.rad(self.angle)) * self.speed
--    self.y = self.y + math.sin(math.rad(self.angle)) * self.speed
--end

function vector:__add(a, b)
    aX, aY = a:getVector()
    bX, bY = b:getVector()
    return { aX + bX, aY + bY }
end