-- game object

require('vector')
require('object')
require('class')
Rocket = subclass(Object)
--[[
    rotate_angle

    speed:angle (установка, отладка)
    speed:magnitude (установка, отладка)
    speed:x,y (вычисление, отладка)

    accel:angle (установка)
    accel:magnitude (установка, отладка)
    accel:x,y (вычисление, отладка)
--]]

--function Rocket:new(name, x, y, angle, speed, accel)
----    local obj = Object:new(name, x, y, angle, speed, accel)
----    self.__index = self
----    self.rand_color = true
----    return setmetatable( self, { __index = obj} )
----    return setmetatable( obj, self )
--
--    self = Object:new(name, x, y, angle, speed, accel)
----    setmetatable(parent, self)
----    setmetatable( self, { __index = parent} )
----    self.__index = self
----    return parent
--    return self
--end
function Rocket:new(name, x, y, angle, speed, accel)
    local obj = object(self, Object:new(name, x, y, angle, speed, accel))
    obj.rand_color = true
    return obj
end

function Rocket:test()
    print('Rocket')
--    print(self.testval)
end