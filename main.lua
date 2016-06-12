graph = love.graphics
kb = love.keyboard
require('camera')
require('vector')
require('object')
require('rocket')
rocket_default = {
    x=1600,
    y=200,
    speed = {
        x=0,
        y=0,
    }
}
--local rocket
local player_ship
local rocket
local rocket_test
local rotate_rate = 150
local accel_rate = 0.5
local group = {}

--debug.debug()


local mouse = {pressed = {} }

local planets = {
    {name = 'Sun', r = 695800, d = 0, color = {255,0,0}},
    {name = 'Mercury', r = 2439.7, d = 0.4405, color = {0.6,0.58,0,58}},
    {name = 'Venus', r = 6051.9, d = 0.7247, color = {0.75,0.74,0.71}},
    {name = 'Earth', r = 6367.4447, d = 1.009, color = {0.38,0.39,0.48}},
    {name = 'Mars', r = 3386, d = 1.543, color = {0.59,0.38,0.19}},
    {name = 'Jupiter', r = 69173, d = 5.437, color = {0.76,0.7,0.67}},
    {name = 'Saturn', r = 57316, d = 10.03, color = {0.77,0.7,0.56}},
    {name = 'Uranus', r = 25266, d = 19.96, color = {0.57,0.75,0.83}},
    {name = 'Neptune', r = 24553, d = 29.96, color = {0.56,0.75,0.88}},
}


function love.load()
--    love.window.setMode(320, 240, {resizable=true, vsync=false, minwidth=40, minheight=30, fullscreen = true})
    kb.setKeyRepeat(true)
    camera:move(1100, -185)
--    player_ship = Object:new('rocket', rocket_default.x, rocket_default.y)
    player_ship = Rocket:new('ship', rocket_default.x, rocket_default.y)
    player_ship.rand_color = false
--    rocket2 = object:new('rocket2', rocket_default.x, rocket_default.y, 0, 0, 0.01)
    rocket = Rocket:new('some rocket', rocket_default.x, rocket_default.y, 0, 0, 0.01)
    rocket:test()

--    camera = {scale = 1}
end

-- dt - 1/x часть секунды, в которую происходит обработка
function love.update(dt)
    if kb.isDown('left') then
        player_ship:addAngle(-rotate_rate * dt)
    end
    if kb.isDown('right') then
        player_ship:addAngle(rotate_rate * dt)
    end
    if kb.isDown('up') then
        player_ship.accel_vector.magnitude = accel_rate
    end
    if kb.isDown('down') then
        player_ship.accel_vector.magnitude = -accel_rate
    end

    if kb.isDown('space') then
        camera:move(player_ship.x, player_ship.y)
    end



    rockets_update()

--    table.insert(group, Rocket:new('rocket2', rocket_default.x, rocket_default.y, 180 * math.random(), 0, 0.01))
end

function love.draw()
--    graph.scale(camera.scale, camera.scale)   -- reduce everything by 50% in both X and Y coordinates
    local major, minor, revision, codename = love.getVersion()
    local str = string.format("Version %d.%d.%d - %s", major, minor, revision, codename)
    local camX, camY = camera:mousePosition()
    graph.print(str, 20, 20)
    graph.print('FPS: '..love.timer.getFPS(), 10, 50)
    graph.print('x: ' .. tostring(love.mouse.getX()), 20, 70)
    graph.print('real x: ' .. camX .. ' y: ' .. camY, 20, 80)
    graph.print('new x: ' .. 1024 * camera.scaleX / 2 .. ' y: ' .. camY, 20, 90)
    graph.print('real screen: ' .. camera.scaleX * love.graphics.getWidth() .. ' y: ' .. camera.scaleY * love.graphics.getHeight(), 20, 100)
    graph.print('speed: L ' .. player_ship.speed_vector.magnitude .. ' A ' .. player_ship.speed_vector.angle, 20, 110)
    graph.print('accel: L ' .. player_ship.accel_vector.magnitude .. ' A ' .. player_ship.accel_vector.angle, 20, 120)
    graph.print('count: ' .. #group, 20, 130)

--    aX, aY = rocket.speed_vector:getVector()
--    bX, bY = rocket.accel_vector:getVector()
--    xyFin = { aX + bX, aY + bY }
--    graph.print(' ' .. xyFin[1] .. '  ' .. xyFin[2], 20, 140)


--local width = love.graphics.getWidth()/2
--local height = love.graphics.getHeight()/2
----local width = love.graphics.getWidth()/1.5
----local height = love.graphics.getHeight()/1.5
--graph.setColor(255, 255, 0)
--graph.circle('fill', width, height, 10, 100)
--love.graphics.rectangle( 'fill', 0, 0, width, height )

    camera:set()

    -- camera fixed to object
    camera:move(player_ship.speed_vector.x, player_ship.speed_vector.y)

    -- rocket draw
    rockets_draw()

--debug.debug()

    local distance = 0
    for key, planet in pairs(planets) do
--        print(unpack(planet.color))
        local r, g, b = unpack(planet.color)
        local radius = planet.r / 500
        if distance ~= 0 then distance = distance + radius + 100 end
        graph.setColor(r*255,g*255,b*255, 120)
        graph.circle('fill', distance, 0, radius, 100)

--        love.graphics.setColor(255, 255, 255, 255)
        graph.print(planet.name, distance, 50, 0, 2, 2)
        distance = distance + radius + 100
    end


    if love.mouse.isDown(1) then
        print('cam: ', camera.x, camera.y)
        print('cam mouse pos: ', camera:mousePosition())
        print('pressed: ', x_pr, y_pr)
        print('')
        local curMouseX, curMouseY = camera:mousePosition()
        camera:move(-curMouseX + mouse.pressed.x, -curMouseY + mouse.pressed.y)
    end


--    print(camera:mousePosition())
    graph.setColor(255, 0, 0)
    graph.circle('fill', camX, camY, 50, 100)
    graph.setColor(0, 255, 0)
    graph.circle('fill', camX, camY, 10, 100)

    camera:unset()
end

-- TODO: добавить паузу!

function rocket_move(dt)
--    rocket.x = rocket.x + rocket.xvel
--    rocket.xvel = rocket.xvel * (1 - math.min(dt * rocket.friction, 1))
end

function rockets_draw()
    player_ship:draw()
    player_ship:drawDebug()

    rocket:draw()
    rocket:drawDebug()

    if rocket_test then
        rocket_test:draw()
        rocket_test:drawDebug()
    end
    for k, v in ipairs(group) do
        v:draw()
        v:drawDebug()
    end
end

function rockets_update()
    player_ship:updateObject()

    rocket:updateObject()

    if rocket_test then
        rocket_test:updateObject()
    end

    for k, v in ipairs(group) do
        v:updateObject()
    end
end

-- работает не плавно, kb.isDown из update работает плавнее
function love.keypressed(key, scancode, isrepeat)
    print(key, scancode, isrepeat)
    if key == 'w' then
        local oldScaleX = camera.scaleX
        local oldScaleY = camera.scaleY
        camera:scale(1/1.5)
        local newScaleX = camera.scaleX
        local newScaleY = camera.scaleY

        -- screen center
        local width = (love.graphics.getWidth()*oldScaleX - love.graphics.getWidth()*newScaleX)/2
        local height = (love.graphics.getHeight()*oldScaleY - love.graphics.getHeight()*newScaleY)/2

        -- mouse center
--        local cur_x, cur_y = camera:mousePosition()
--        local width = (love.graphics.getWidth()*oldScaleX - cur_x)/2
--        local height = (love.graphics.getHeight()*oldScaleY - cur_y)/2

        camera:move(width, height)

    elseif key == 's' then
        camera:scale(1.5)
--    elseif key == 'left' then
--        rocket:setAngle(rocket.angle - 1)
--    elseif key == 'right' then
--        rocket:setAngle(rocket.angle + 1)
    end

    if key == '1' then
        local angle = 360 * math.random()
        local r = Rocket:new('rocket' .. math.random(), rocket_default.x, rocket_default.y, angle, 0, 0.01)
        r:addAngle(angle)
        table.insert(group, r)
    end

    if key == 'escape' then
        love.event.quit()
    end
end

function love.keyreleased(key)
    if key == 'up' then
        player_ship.accel_vector.magnitude = 0
    elseif key == 'down' then
        player_ship.accel_vector.magnitude = 0
    end
end

function love.wheelmoved(x, y)
    if y > 0 then
        local oldScaleX = camera.scaleX
        local oldScaleY = camera.scaleY
        camera:scale(10/15)
        local newScaleX = camera.scaleX
        local newScaleY = camera.scaleY
        -- screen center
        local width = (love.graphics.getWidth()*oldScaleX - love.graphics.getWidth()*newScaleX)/2
        local height = (love.graphics.getHeight()*oldScaleY - love.graphics.getHeight()*newScaleY)/2
        camera:move(width, height)
    elseif y < 0 then
        local oldScaleX = camera.scaleX
        local oldScaleY = camera.scaleY
        camera:scale(15/10)
        local newScaleX = camera.scaleX
        local newScaleY = camera.scaleY
        -- screen center
        local width = (love.graphics.getWidth()*oldScaleX - love.graphics.getWidth()*newScaleX)/2
        local height = (love.graphics.getHeight()*oldScaleY - love.graphics.getHeight()*newScaleY)/2
        camera:move(width, height)
    end
end

function love.mousepressed(x, y, button, istouch)
--    print(x, y)
    print(camera:mousePosition())
    mouse.pressed.x, mouse.pressed.y = camera:mousePosition()
    graph.print('x: ' .. x, 20, 70)
end

function love.mousereleased(x, y, button, istouch)
--    print(x, y)
end