--string = "Some word"
graph = love.graphics
kb = love.keyboard
require('camera')
rocket = {
    x=0,
    y=0,
    speed = {
        x=0,
        y=0,
    }
}

--debug.debug()


--local function myStencilFunction()
--    kb.rectangle("fill", 225, 200, 350, 300)
--end

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
--    camera = {scale = 1}
end

function love.update(dt)
    if kb.isDown('t') then
        print('t pressed')
    end
--    test.x = test.x*dt+100
--    test.y = test.y*dt+100
    mx, my = camera:mousePosition()
    if mx > rocket.x then
        rocket.x = rocket.x+5
    else
        rocket.x = rocket.x-5
    end
    if my > rocket.y then
        rocket.y = rocket.y+5
    else
        rocket.y = rocket.y-5
    end
end

function love.draw()
--    graph.scale(camera.scale, camera.scale)   -- reduce everything by 50% in both X and Y coordinates
    local major, minor, revision, codename = love.getVersion()
    local str = string.format("Version %d.%d.%d - %s", major, minor, revision, codename)
    graph.print(str, 20, 20)
    graph.print('FPS: '..love.timer.getFPS(), 10, 50)
    graph.print('x pressed: ' .. tostring(mouseX), 20, 70)
    graph.print('x: ' .. tostring(love.mouse.getX()), 20, 80)


    camera:set()

    rocket_draw()



--debug.debug()

--    local touches = love.touch.getTouches()
--    for i, id in ipairs(touches) do
--        local x, y = love.touch.getPosition(id)
--        love.graphics.circle("fill", x, y, 20)
--    end

--    print('test')
--    love.window.setTitle('rpg-test')
--    -- draw a rectangle as a stencil. Each pixel touched by the rectangle will have its stencil value set to 1. The rest will be 0.
--    love.graphics.stencil(myStencilFunction, "replace", 1)
--
--    -- Only allow rendering on pixels which have a stencil value greater than 0.
--    love.graphics.setStencilTest("greater", 0)
--
--    graph.setColor(255, 0, 0, 120)
--    graph.circle("fill", 0, 0, 150, 50)
--
--    love.graphics.setColor(0, 255, 0, 120)
--    love.graphics.circle("fill", 500, 300, 150, 50)
--
--    love.graphics.setColor(0, 0, 255, 120)
--    love.graphics.circle("fill", 400, 400, 150, 50)
--
--    love.graphics.setStencilTest()

    local distance = 0
    for key, planet in pairs(planets) do
--        print(unpack(planet.color))
        r, g, b = unpack(planet.color)
        radius = planet.r / 500
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
        local cur_x, cur_y = camera:mousePosition()
        camera.x, camera.y = camera.x - cur_x + mouse.pressed.x, camera.y - cur_y + mouse.pressed.y
    end


    camX, camY = camera:mousePosition()
--    print(camera:mousePosition())
    graph.setColor(255, 0, 0)
    graph.circle('fill', camX, camY, 50, 100)
    graph.setColor(0, 255, 0)
    graph.circle('fill', camX, camY, 10, 100)

    camera:unset()
end

function rocket_draw()
    graph.setColor(0,0,255, 120)
    graph.circle('fill', rocket.x, rocket.y, 100, 100)
    --    mx,my = camera:mousePosition()
    graph.line(rocket.x, rocket.y, camera:mousePosition())
end

function rocket_move(dt)
    rocket.x = rocket.x + rocket.xvel
    rocket.xvel = rocket.xvel * (1 - math.min(dt * rocket.friction, 1))
end

function love.keypressed(key, scancode, isrepeat)
    print(key, scancode, isrepeat)
    if key == 'w' then
        camera:scale(0.5)
    elseif key == 's' then
        camera:scale(2)
    elseif key == 'escape' then
        love.event.quit()
    end
end

function love.wheelmoved(x, y)
    if y > 0 then
        camera:scale(10/15)
    elseif y < 0 then
        camera:scale(15/10)
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