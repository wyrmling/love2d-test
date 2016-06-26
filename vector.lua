-- vector object

vector = {}

function vector:new(x, y)
    local newObj = {
        x = x or 0,
        y = y or 0,
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

function vector.__add(a, b)
    return vector:new(a.x+b.x, a.y+b.y)
end

function vector:angleTo(other)
    if other then
        return math.atan2(self.y, self.x) - math.atan2(other.y, other.x)
    end
    return math.atan2(self.y, self.x)
end