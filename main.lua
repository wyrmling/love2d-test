graph = love.graphics
kb = love.keyboard
require('camera')
require('vector')
require('object')
require('rocket')
require('maid64')
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
local some_rocket
local rotate_rate = 150
local accel_rate = 0.5
local group = {}

local scrolled = 0
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
--    canvas = love.graphics.newCanvas(320, 240)
--    canvas:setFilter('nearest', 'nearest')
--    love.graphics.setBlendMode("alpha", "premultiplied")

--    maid64.setup(320)

--    love.window.setMode(320, 240, {resizable=true, vsync=false, minwidth=40, minheight=30, fullscreen = true})

    kb.setKeyRepeat(true)
    camera:move(1100, -185)
    player_ship = Rocket:new('ship', rocket_default.x, rocket_default.y)
    player_ship.rand_color = false
    some_rocket = Rocket:new('some rocket', rocket_default.x, rocket_default.y, 0, 0, 0.01)
end

-- dt - 1/x часть секунды, в которую происходит обработка
function love.update(dt)
    local oldScaleX = camera.scaleX
    local oldScaleY = camera.scaleY
    if scrolled > 0 then
        camera:scale(10/15)
    elseif scrolled < 0 then
        camera:scale(15/10)
    end
    scrolled = 0
    local newScaleX = camera.scaleX
    local newScaleY = camera.scaleY
    -- screen center
    local width = (love.graphics.getWidth()*oldScaleX - love.graphics.getWidth()*newScaleX)/2
    local height = (love.graphics.getHeight()*oldScaleY - love.graphics.getHeight()*newScaleY)/2
    camera:move(width, height)


    if kb.isDown('left') then
        player_ship:addAngle(-rotate_rate * dt)
    end
    if kb.isDown('right') then
        player_ship:addAngle(rotate_rate * dt)
    end
    if kb.isDown('up') then
        player_ship.accel = accel_rate
    end
    if kb.isDown('down') then
        player_ship.accel = -accel_rate
    end

    if kb.isDown('space') then
        camera:move(player_ship.x, player_ship.y)
    end

    rockets_update(dt)
end

function love.draw()
--    maid64.start()


    camera:set()

    -- camera fixed to object
    camera:move(player_ship.speed_vector.x, player_ship.speed_vector.y)

    draw_planets()

    -- rocket draw
    rockets_draw()

--debug.debug()

    if love.mouse.isDown(1) then
        local curMouseX, curMouseY = camera:mousePosition()
        camera:move(-curMouseX + mouse.pressed.x, -curMouseY + mouse.pressed.y)
    end

    -- cursor
    local camX, camY = camera:mousePosition()
    graph.setColor(255, 0, 0)
    graph.circle('fill', camX, camY, 50, 100)
    graph.setColor(0, 255, 0)
    graph.circle('fill', camX, camY, 10, 100)

    camera:unset()

    draw_UI()
--    maid64.finish()
end

--function love.resize(w, h)
--    -- this is used to resize the screen correctly
--    maid64.resize(w, h)
--end

-- TODO: добавить паузу!

function draw_UI()
    local major, minor, revision, codename = love.getVersion()
    local str = string.format("Version %d.%d.%d - %s", major, minor, revision, codename)
    local camX, camY = camera:mousePosition()
    graph.print(str, 20, 20)
    graph.print('FPS: '..love.timer.getFPS(), 10, 50)
    graph.print('x: ' .. tostring(love.mouse.getX()), 20, 70)
    graph.print('real x: ' .. camX .. ' y: ' .. camY, 20, 80)
    graph.print('new x: ' .. 1024 * camera.scaleX / 2 .. ' y: ' .. camY, 20, 90)
    graph.print('real screen: ' .. camera.scaleX * love.graphics.getWidth() .. ' y: ' .. camera.scaleY * love.graphics.getHeight(), 20, 100)
--    graph.print('speed: L: ' .. player_ship.speed_vector.magnitude .. ' A: ' .. player_ship.speed_vector.angle, 20, 110)
--    graph.print('accel: L: ' .. player_ship.accel_vector.magnitude .. ' A: ' .. player_ship.accel_vector.angle, 20, 120)
    graph.print('count: ' .. #group, 20, 130)
end

function draw_planets()
    local distance = 0
    for key, planet in pairs(planets) do
        local r, g, b = unpack(planet.color)
        local radius = planet.r / 500
        if distance ~= 0 then distance = distance + radius + 100 end
        graph.setColor(r * 255, g * 255, b * 255)
        graph.circle('fill', distance, 0, radius, 100)
        graph.print(planet.name, distance, 50, 0, 2, 2)
        distance = distance + radius + 100
    end
end

function rockets_draw()
    player_ship:draw()
    player_ship:drawDebug()

    some_rocket:draw()
    some_rocket:drawDebug()

    for k, ship in ipairs(group) do
        ship:draw()
        ship:drawDebug()
        print('x y: ' .. ship.speed_vector.x .. ' ' .. ship.speed_vector.y .. ' angle_to_player: ' .. ship.angle_to_player)
    end
end

function rockets_update(dt)
    player_ship:updateObject(dt)

    some_rocket:updateObject(dt)

    for k, ship in ipairs(group) do
        ship.angle_to_player = ship:angleTo(player_ship)
        if (ship.angle_to_player - ship.angle > 0) then
            ship:addAngle(5)
        elseif (ship.angle_to_player - ship.angle < 0) then
            ship:addAngle(-5)
        end
        ship:updateObject()
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
        local width = (love.graphics.getWidth() * oldScaleX - love.graphics.getWidth() * newScaleX) / 2
        local height = (love.graphics.getHeight() * oldScaleY - love.graphics.getHeight() * newScaleY) / 2

        -- mouse center
--        local cur_x, cur_y = camera:mousePosition()
--        local width = (love.graphics.getWidth()*oldScaleX - cur_x)/2
--        local height = (love.graphics.getHeight()*oldScaleY - cur_y)/2

        camera:move(width, height)

    elseif key == 's' then
        camera:scale(1.5)
    elseif key == 'a' then
        camera:rotate(-math.pi/180)
    elseif key == 'd' then
        camera:rotate(math.pi/180)
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
        player_ship.accel = 0
    elseif key == 'down' then
        player_ship.accel = 0
    end
end

-- TODO: smooth scrolling
function love.wheelmoved(x, y)
    -- TODO: перенести масштабирование в камеру (фактически в draw)
--    local oldScaleX = camera.scaleX
--    local oldScaleY = camera.scaleY
    if y > 0 then
        scrolled = 1
--        camera:scale(10/15)
    elseif y < 0 then
        scrolled = -1
--        camera:scale(15/10)
    else
        scrolled = 0
    end
--    local newScaleX = camera.scaleX
--    local newScaleY = camera.scaleY
--    -- screen center
--    local width = (love.graphics.getWidth()*oldScaleX - love.graphics.getWidth()*newScaleX)/2
--    local height = (love.graphics.getHeight()*oldScaleY - love.graphics.getHeight()*newScaleY)/2
--    camera:move(width, height)
end

function love.mousepressed(x, y, button, istouch)
    print(camera:mousePosition())
    mouse.pressed.x, mouse.pressed.y = camera:mousePosition()
    graph.print('x: ' .. x, 20, 70)
end