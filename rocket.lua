-- game object

require 'vector'
require 'object'
local class = require 'middleclass'
Rocket = class('Rocket', Object)
--[[
    rotate_angle

    speed:angle (установка, отладка)
    speed:magnitude (установка, отладка)
    speed:x,y (вычисление, отладка)

    accel:angle (установка)
    accel:magnitude (установка, отладка)
    accel:x,y (вычисление, отладка)
--]]

Rocket.fuel = 0
Rocket.fuel_rate = 1

function Rocket:initialize(name, x, y, angle, speed, accel)
    Object.initialize(self, name, x, y, angle, speed, accel)
    self.rand_color = true
end

--function Rocket:updateObject(dt)
--    Object.updateObject(self, dt)
--end

function Rocket:stop()
end

function Rocket:moveTo()
end

function Rocket:angleTo(other)
    -- ху корабля минус ху второго корабля = нормированный вектор
    local x = other.x - self.x
    local y = other.y - self.y
    local phi = math.deg(math.atan2(y, x))
    if (phi < 0) then
        phi = 360 + phi
    end
    return phi
end