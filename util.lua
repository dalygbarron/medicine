--- This module just contains useful functions that almost feel like the kind
-- of shit a standard library might provide except they were not provided so
-- I made them.

local util = {}

--- Tells you if the given strings consist of whitespace only. They all have to
-- be fully white so consider everything you pass to be logically anded
-- together.
-- @param ... is all the strings to check.
-- @return true if they are all fully white and false if not.
function util.white(...)
    local args = {...}
    for i, v in ipairs(args) do
        if string.match(v, '%g') then
            return false
        end
    end
    return true
end

--- Takes a number and wraps it between a maximum value and 0.
-- @param value is the value to wrap
-- @param max   is the value at which it wraps back to 0.
-- @return the wrapped version.
function util.wrapAroundZero(value, max)
    if value < 0 then
        return max - math.abs(math.fmod(value, max))
    else
        return math.fmod(value, max)
    end
end

--- Takes a number and wraps it between two other numbers. Wrapping is
-- inclusive of min, but exclusive of max if you catch my drift.
-- @param value is the value to wrap.
-- @param min   is the value before which it wraps back to max.
-- @param max   is the value at which it wraps back to min.
-- @return the wrapped version.
function util.wrap(value, min, max)
    return min + util.wrapAroundZero(value - min, max - min)
end

--- Takes a value and stops it from leaving a certain bound by making it hit
-- a wall.
-- @param value is the value to clamp.
-- @param min   is the lowest possible value we can return.
-- @param max   is the highest possible value we can return.
-- @return the version of the value whose wings have been clipped in accordance
--         with min and max.
function util.clamp(value, min, max)
    return math.max(min, math.min(value, max))
end

--- Kind of like clamp except it literally has to be one of them and nothing
-- else. Another way of saying it is it just chooses the closest of two
-- options. There is no in between allowed even if it's split midway. If it's
-- midway then essentially either is as valid as the other so what you get is
-- arbitrary.
-- @param value is the value used to choose.
-- @param a     is the first choice.
-- @param b     is the second choice.
-- @return the one that was closer
function util.closer(value, a, b)
    if math.abs(value - a) < math.abs(value - b) then return a
    else return b
    end
end

--- Draws a love image thingy by passing the middle point instead of the top
-- left corner.
-- @param img is the image to draw.
-- @param x   is the x position to draw.
-- @param y   is the y position to draw.
-- @param rot is the rotation to draw with but defaults to 0.
function util.drawCentered(img, x, y, rot)
    if not rot then rot = 0 end
    love.graphics.draw(
        img,
        x,
        y,
        rot,
        1,
        1,
        img:getWidth() / 2,
        img:getHeight() / 2
    )
end

--- Converts polar coordinates into cartesian coordinates.
-- @param angle     is the angle for the point to be from the origin point
-- @param magnitude is the distance for the point to be from origin
-- @return two values, the x and y of the cartsian coordinates.
function util.polar(angle, magnitude)
    return math.cos(angle) * magnitude, math.sin(angle) * magnitude
end

--- Finds the angle between two tables that have got x and y values.
-- @param a is the thing to look from.
-- @param b is the thing to look to.
-- @return the angle from a's position to b's.
function util.angleBetween(a, b)
    return math.atan2(b.y - a.y, b.x - a.x)
end

--- Gets the squared distance between two points. The point of this is that
-- it's faster than getting the actual distance due to not needing to calculate
-- a square root, and you can make use of this in some places instead.
-- @param ax is the first point's x value
-- @param ay is the first point's y value
-- @param bx is the second point's x value
-- @param by is the second point's y value
-- @return the squared distance between these two points.
function util.distanceSquared(ax, ay, bx, by)
    local x = ax - bx
    local y = ay - by
    return x * x + y * y
end

--- Gets the distance between two points.
-- @param ax is the first point's x value
-- @param ay is the first point's y value
-- @param bx is the second point's x value
-- @param by is the second point's y value
-- @return the distance between these two points.
function util.distance(ax, ay, bx, by)
    return math.sqrt(util.distanceSquared(ax, ay, bx, by))
end

--- Hot waits in a coroutine that expects to receive a time delta value each
-- time it yields.
-- @param time is the time to wait for
function util.wait(time)
    local count = 0
    while count < time do
        count = count + coroutine.yield()
    end
    return count
end

--- Takes an iterator and iterates over it and turns it into a table.
-- @param iter is the iterator that it is flattening into a table.
-- @return the table.
function util.flatten(iter)
    local items = {}
    for v in iter do
        table.insert(items, v)
    end
    return items
end

--- Returns a function which when passed an x and y value just returns the
-- pixel at that location.
-- @param imgData is the image data to get it from.
-- @return the shader function thingy.
function util.createImageShader(imgData)
    local width = imgData:getWidth() - 1
    local height = imgData:getHeight() - 1
    return function (x, y, time)
        return imgData:getPixel(
            util.wrapAroundZero(x * width, width),
            util.wrapAroundZero(y * height, height)
        )
    end
end

--- Mixes two colours together, with the second colour imposing over the first
-- to the degree specified by the power parameter.
-- @param power is the degree to which the second colour covers the first.
-- @param r1    is the red of the first colour.
-- @param g1    is the green of the first colour.
-- @param b1    is the blue of the first colour.
-- @param a1    is the alpha of the first colour.
-- @param r2    is the red of the second colour.
-- @param g2    is the green of the second colour.
-- @param b2    is the blue of the second colour.
-- @param a2    is the alpha of the second colour.
-- @return all the components of the new colour, r, g, b, a.
function util.mixColours(power, r1, g1, b1, a1, r2, g2, b2, a2)
    power = util.clamp(power, 0, 1)
    if power == 0 then
        return r1, g1, b1, a1
    elseif power == 1 then
        return r2, g2, b2, a2
    end
    local anti = 1 - power
    return r1 * anti + r2 * power,
        g1 * anti + g2 * power,
        b1 * anti + b2 * power,
        a1 * anti + a2 * power
end

return util

