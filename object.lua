-- game object

require('vector')
require('class')
Object = class()

--[[
    rotate_angle

    speed:angle (установка, отладка)
    speed:magnitude (установка, отладка)
    speed:x,y (вычисление, отладка)

    accel:angle (установка)
    accel:magnitude (установка, отладка)
    accel:x,y (вычисление, отладка)
--]]

function Object:new(name, x, y, angle, speed, accel)
    local params = {
        name = name or 'object',
        x = x or 0,
        y = y or 0,
        angle = angle or 0,
        speed_vector = vector:new(),
        accel_vector = vector:new(),
        speed = speed or 0,
        accel = accel or 0,
    }
    params.rand_r = love.math.random() * 255
    params.rand_g = love.math.random() * 255
    params.rand_b = love.math.random() * 255

    return object(self, params)
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

function Object:addAngle(angle)
    self.angle = self.angle + angle

    if self.angle > 360 then
        self.angle = self.angle - 360
    elseif self.angle < 0 then
        self.angle = self.angle + 360
    end

    self.accel_vector:setAngle(self.angle)
end

function Object:drawDebugVector(vector, color)
--    local x = math.cos(math.rad(vector.angle)) * vector.magnitude * 100
--    local y = math.sin(math.rad(vector.angle)) * vector.magnitude * 100
    love.graphics.setColor(color)
    love.graphics.line(self.x, self.y, self.x + vector.x, self.y + vector.y)
--    graph.print('coord: ' .. x .. ' | ' .. y, self.x, self.y + 70, 0, 2, 2)
end

function Object:drawDebug()
    -- speed ?
    -- не меняется пока что
--    self:drawDebugVector(self.speed_vector, {255, 255, 255})

    -- accel
    love.graphics.setLineWidth(10)
    self:drawDebugVector(self.accel_vector, {255, 255, 0})

    -- real speed vector
    love.graphics.setLineWidth(1)
    self:drawDebugVector(self.speed_vector, {100, 255, 0})

    -- direction of object
--    self:drawDebugVector(vector:new(0,0,self.angle,1), 255, 0, 0)

    -- object data debug
    love.graphics.print(self.name, self.x, self.y + 10, 0, 2, 2)
    love.graphics.print('spd: ' .. self.speed, self.x, self.y + 30, 0, 2, 2)
    love.graphics.print('angle: ' .. math.floor(self.angle), self.x, self.y + 50, 0, 2, 2)
end

function Object:draw()
    local mx, my = camera:mousePosition()
    love.graphics.setColor(0,0,255, 120)
--    love.graphics.circle('fill', self.x, self.y, 100, 100)

    if self.rand_color then
        love.graphics.setColor(self.rand_r, self.rand_g, self.rand_b, 100)
    end
    love.graphics.arc('fill', self.x, self.y, 70, math.rad(self.angle)+math.pi/1.8, math.rad(self.angle)-math.pi/1.8, 2)
--    love.graphics.arc('fill', self.x, self.y, 70, 0+math.rad(self.angle), 2*math.pi+math.rad(self.angle), math.pi)
--    love.graphics.arc('fill', self.x, self.y, 180, math.rad(self.angle), math.pi, 3)

    love.graphics.setColor(255,255,255, 120)
    love.graphics.line(self.x, self.y, camera:mousePosition())
end

function Object:updateObject(dt)
    -- ускорение: пересчет вектора скорости
    self.accel_vector.x = math.cos(math.rad(self.angle)) * self.accel
    self.accel_vector.y = math.sin(math.rad(self.angle)) * self.accel

    -- speed
    self.speed_vector = self.speed_vector + self.accel_vector
    self.speed = math.sqrt(self.speed_vector.x * self.speed_vector.x + self.speed_vector.y * self.speed_vector.y)

    -- положение, с учетом вектора скорости
    self.x = self.x + self.speed_vector.x
    self.y = self.y + self.speed_vector.y
end