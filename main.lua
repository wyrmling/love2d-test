graph = love.graphics
kb = love.keyboard
require('camera')
require('vector')
rocket_defualt = {
    x=1600,
    y=200,
    speed = {
        x=0,
        y=0,
    }
}
local rocket

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
    kb.setKeyRepeat(true)
    local mouseX = null
    rocket = vector:new(rocket_defualt.x, rocket_defualt.y)
    rocket.speed = 5
--    camera = {scale = 1}
end

function love.update(dt)
    if kb.isDown('t') then
        print('t pressed')
    end

    rocket:setAngle(rocket.angle + 1)
--    local dX, dY = rocket:getVector()
--    rocket.x = rocket.x + dX
--    rocket.y = rocket.y + dY
end

function love.draw()
--    graph.scale(camera.scale, camera.scale)   -- reduce everything by 50% in both X and Y coordinates
    local major, minor, revision, codename = love.getVersion()
    local str = string.format("Version %d.%d.%d - %s", major, minor, revision, codename)
    local camX, camY = camera:mousePosition()
    graph.print(str, 20, 20)
    graph.print('FPS: '..love.timer.getFPS(), 10, 50)
    graph.print('x pressed: ' .. tostring(mouseX), 20, 70)
    graph.print('x: ' .. tostring(love.mouse.getX()), 20, 80)
    graph.print('real x: ' .. camX .. ' y: ' .. camY, 20, 90)
    graph.print('new x: ' .. 1024 * camera.scaleX / 2 .. ' y: ' .. camY, 20, 100)
    graph.print('real screen: ' .. camera.scaleX * love.graphics.getWidth() .. ' y: ' .. camera.scaleY * love.graphics.getHeight(), 20, 110)

local width = love.graphics.getWidth()/2
local height = love.graphics.getHeight()/2
--local width = love.graphics.getWidth()/1.5
--local height = love.graphics.getHeight()/1.5
graph.setColor(255, 255, 0)
graph.circle('fill', width, height, 10, 100)
love.graphics.rectangle( 'fill', 0, 0, width, height )

    camera:set()

    rocket_draw()

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

function rocket_draw()
    local mx, my = camera:mousePosition()
    graph.setColor(0,0,255, 120)
    graph.circle('fill', rocket.x, rocket.y, 100, 100)
    graph.line(rocket.x, rocket.y, camera:mousePosition())
end

function rocket_move(dt)
--    rocket.x = rocket.x + rocket.xvel
--    rocket.xvel = rocket.xvel * (1 - math.min(dt * rocket.friction, 1))
end

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
    elseif key == 'escape' then
        love.event.quit()
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