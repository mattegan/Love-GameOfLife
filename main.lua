lg = love.graphics
li = love.image
lw = love.window

currentIteration = {}
calculationCanvas = {}
calculationShader = {}

windowWidth = 0
windowHeight = 0
dataWidth = 0
dataHeight = 0
sample = 1

running = false;
iterationsPerSecond = 60
time = 0;

function love.load(a)
    --  store these for later use (must be updated on window resize)
    windowWidth = lg.getWidth()
    windowHeight = lg.getHeight()

    --  how large the data buffers are (we are storing data in an image)
    dataWidth = math.ceil(windowWidth / sample)
    dataHeight = math.ceil(windowHeight / sample)

    --  create a canvas that an image can be drawn on, and then read from
    calculationCanvas = lg.newCanvas(dataWidth, dataHeight)

    --  create the shader, send the grid width and height
    calculationShader = lg.newShader("calculationShader.glsl")
    calculationShader:send("grid_width", dataWidth)
    calculationShader:send("grid_height", dataHeight)

    --  create an image to store the current iteration
    currentIteration = li.newImageData(windowWidth / sample, windowHeight / sample)

    --  testing
    -- for i = 0, 39 do
    --     currentIteration:setPixel(i, 20, 255, 255, 255, 255)
    --     -- currentIteration:setPixel(39-i, i, 255, 255, 255, 255)
    -- end

    --  testing, create a + around 20, 20
    currentIteration:setPixel(20, 19, 255, 255, 255, 255)
    currentIteration:setPixel(20, 20, 255, 255, 255, 255)
    currentIteration:setPixel(20, 21, 255, 255, 255, 255)
    --
    currentIteration:setPixel(29, 30, 255, 255, 255, 255)
    currentIteration:setPixel(30, 30, 255, 255, 255, 255)
    currentIteration:setPixel(31, 30, 255, 255, 255, 255)

end

function love.update(dt)
    if love.mouse.isDown(1, 2) then
        local x = love.mouse.getX()
        local y = love.mouse.getY()

        local imageX = math.floor(x / sample);
        local imageY = math.floor(y / sample);

        if love.mouse.isDown(1) then
            currentIteration:setPixel(imageX, imageY, 255, 255, 255, 255)
        else
            currentIteration:setPixel(imageX, imageY, 0, 0, 0, 255)
        end
    end

    if running then
        time = time + dt
        if time > (1 / iterationsPerSecond) then
            iterate()
            time = 0
        end
    else
        time = 0
    end
end

function love.draw()
    local image = lg.newImage(currentIteration)
    image:setFilter("nearest", "nearest")
    lg.draw(image, 0, 0, 0, sample)
end

function love.keypressed(key, scancode, isrepeat)
    if key == 'space' then
        running = not running
        if running then
            lw.setTitle("game of life - running")
        else
            lw.setTitle("game of life - paused")
        end
    end

    if key == 's' then
        iterate()
    end

    if key == 'up' then
        iterationsPerSecond = iterationsPerSecond + 0.5
    end

    if key == 'down' then
        iterationsPerSecond = iterationsPerSecond - 0.5
    end

    if key == 'r' then
        for x = 0, (dataWidth - 1) do
            for y = 0, (dataHeight - 1) do
                local alive = love.math.random(0, 2)
                if alive > 1 then
                    currentIteration:setPixel(x, y, 255, 255, 255, 255)
                else
                    currentIteration:setPixel(x, y, 0, 0, 0, 255)
                end
            end
        end
    end

end

function iterate()
    --  draw the current iteration into a canvas, and let the pixel shader
    --  calculate the next iteration of the grid
    lg.setCanvas(calculationCanvas)
    lg.setShader(calculationShader)
    local currentImage = lg.newImage(currentIteration)
    currentImage:setFilter("nearest", "nearest")
    lg.draw(currentImage)
    lg.setShader()
    lg.setCanvas()

    --  now, get the next iteration as image data out of the calculationCanvas
    currentIteration = calculationCanvas:newImageData()
end
