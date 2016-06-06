-- game object

require('vector')
object = {}

function object:new(x, y, angle, speed, accel)
    local newObj = {
        x = x or 0,
        y = y or 0,
        angle = angle or 0,
        speed_vector = vector:new(),
        accel_vector = vector:new(),
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

--function object:getVector()
--    local x = math.cos(math.rad(self.angle)) * self.speed
--    local y = math.sin(math.rad(self.angle)) * self.speed
--    return x, y
--end

function object:addAngle(angle)
    self.angle = self.angle + angle

    if self.angle > 360 then
        self.angle = self.angle - 360
    elseif self.angle < 0 then
        self.angle = self.angle + 360
    end

    self.accel_vector:setAngle(self.angle)
end

function object:drawDebugVector(vector, r, g, b)
    local x = math.cos(math.rad(vector.angle)) * vector.magnitude * 100
    local y = math.sin(math.rad(vector.angle)) * vector.magnitude * 100
    love.graphics.setColor(r, g, b)
    love.graphics.line(self.x, self.y, self.x + x, self.y + y)
--    graph.print('coord: ' .. x .. ' | ' .. y, self.x, self.y + 70, 0, 2, 2)
end

function object:drawDebug()
    self:drawDebugVector(self.speed_vector, 255, 255, 255)
    self:drawDebugVector(self.accel_vector, 255, 255, 0)
    love.graphics.line(self.x, self.y, self.x + self.speed_vector.x, self.y + self.speed_vector.y)
    self:drawDebugVector(vector:new(0,0,self.angle,1), 255, 0, 0)
end

function object:updateObject()
    -- ускорение: пересчет вектора скорости
--    local xyFin = self.speed_vector + self.accel_vector
--    self.speed_vector = xyFin

    aX, aY = self.speed_vector:getVector()
    bX, bY = self.accel_vector:getVector()
    xyFin = { aX + bX, aY + bY }
    self.speed_vector.x = self.speed_vector.x + xyFin[1]
    self.speed_vector.y = self.speed_vector.y + xyFin[2]

    -- положение, с учетом вектора скорости
--    self.x = self.x + math.cos(math.rad(self.speed_vector.angle)) * self.speed_vector.magnitude
--    self.y = self.y + math.sin(math.rad(self.speed_vector.angle)) * self.speed_vector.magnitude

    self.x = self.x + self.speed_vector.x
    self.y = self.y + self.speed_vector.y
end