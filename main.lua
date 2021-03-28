lg = love.graphics
li = love.image
lw = love.window

currentIteration = {}
currentIterationImage = {}
calculationCanvas = {}
calculationShader = {}

windowWidth = 0
windowHeight = 0
dataWidth = 0
dataHeight = 0
sample = 1

running = false;
iterationsPerSecond = 200
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
    currentIterationImage = lg.newImage(currentIteration)
    currentIterationImage:setFilter("linear", "nearest")
end

function love.update(dt)
    if love.mouse.isDown(1, 2) then
        local x = love.mouse.getX()
        local y = love.mouse.getY()

        local imageX = math.floor(x / sample);
        local imageY = math.floor(y / sample);
        if imageX-1 >= 0 and imageX+1 < windowWidth and imageY-1 >= 0 and imageY+1 < windowHeight then
           if love.mouse.isDown(1) then
               if love.keyboard.isDown('g') then
                   makeGlider(imageX, imageY)
               else
                   currentIteration:setPixel(imageX, imageY, 255, 255, 255, 255)
               end
           else
               currentIteration:setPixel(imageX, imageY, 0, 0, 0, 255)
           end

           currentIterationImage:replacePixels(currentIteration)
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
    lg.draw(currentIterationImage, 0, 0, 0, sample)
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
        iterationsPerSecond = iterationsPerSecond + 5
    end

    if key == 'down' then
        iterationsPerSecond = iterationsPerSecond - 5
    end

    if key == 'r' then
        for x = 0, (dataWidth - 1) do
            for y = 0, (dataHeight - 1) do
                local alive = love.math.random(0, 4)
                if alive < 1 then
                    currentIteration:setPixel(x, y, 255, 255, 255, 255)
                else
                    currentIteration:setPixel(x, y, 0, 0, 0, 255)
                end
            end
        end
        currentIterationImage:replacePixels(currentIteration)
    end

    if key == 'c' then
        clear()
    end

    if key == 'h' then
        for x = 1, dataWidth - 4, 5 do
            for y = 1, dataHeight - 4, 5 do
                makeGlider(x, y)
            end
        end
        currentIterationImage:replacePixels(currentIteration)
    end

end

function iterate()
    --  draw the current iteration into a canvas, and let the pixel shader
    --  calculate the next iteration of the grid
    lg.setCanvas(calculationCanvas)
    lg.setShader(calculationShader)
    lg.draw(currentIterationImage)
    lg.setShader()
    lg.setCanvas()

    --  now, get the next iteration as image data out of the calculationCanvas
    currentIteration = calculationCanvas:newImageData()
    currentIterationImage = lg.newImage(currentIteration)
    currentIterationImage:setFilter("linear", "nearest")
    collectgarbage()
end

function makeGlider(x, y)
    currentIteration:setPixel(x, y - 1, 255, 255, 255, 255)
    currentIteration:setPixel(x + 1, y, 255, 255, 255, 255)
    currentIteration:setPixel(x - 1, y + 1, 255, 255, 255, 255)
    currentIteration:setPixel(x, y + 1, 255, 255, 255, 255)
    currentIteration:setPixel(x + 1, y + 1, 255, 255, 255, 255)
end

function clear()
    currentIteration = li.newImageData(windowWidth / sample, windowHeight / sample)
    currentIterationImage = lg.newImage(currentIteration)
    currentIterationImage:setFilter("linear", "nearest")
    collectgarbage()
end
