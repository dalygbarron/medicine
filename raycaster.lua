--- This module returns a constructor for a raycaster object which takes
-- a mapping of numeric codes to quads for the sprites those codes represent.
-- It can then take a 2d map of codes, a position, and a looking angle and
-- renders an image of what it sees

local vec = require 'vec'

return function (shaders, camDist, camPlane)
    -- Create segment quads for each block type.
    return {
        draw = function (map, atlas, time, x, y, vx, vy)
            love.graphics.setPointSize(1.5)
            local cdx, cdy = vec.times(vx, vy, camDist)
            local cpx, cpy = vec.times(vy, -vx, camPlane)
            local width = love.graphics.getWidth()
            local height = love.graphics.getHeight()
            for ix = -width * 0.5, width * 0.5 do
                local mx = math.floor(x)
                local my = math.floor(y)
                local side = 0
                local sx = 0
                local sy = 0
                local sdx = 0
                local sdy = 0
                local hit = false
                local prop = ix / (width * 0.5)
                local rx, ry = vec.plus(
                    cpx * prop,
                    cpy * prop,
                    cdx,
                    cdy
                )
                local ddx = math.abs(1 / rx)
                local ddy = math.abs(1 / ry)
                if rx < 0 then
                    sx = -1
                    sdx = (x - mx) * ddx
                else
                    sx = 1
                    sdx = (mx + 1 - x) * ddx
                end
                if ry < 0 then
                    sy = -1
                    sdy = (y - my) * ddy
                else
                    sy = 1
                    sdy = (my + 1 - y) * ddy
                end
                while true do
                    if sdx < sdy then
                        sdx = sdx + ddx
                        mx = mx + sx
                        side = 0
                    else
                        sdy = sdy + ddy
                        my = my + sy
                        side = 1
                    end
                    if mx < 1 or my < 1 or not map[mx] or not map[mx][my] then
                        break
                    elseif map[mx][my] ~= 0 then
                        hit = true
                        break
                    end
                end
                if hit then
                    if side == 0 then
                        hitDist = (mx - x + (1 - sx) / 2) / rx
                    else
                        hitDist = (my - y + (1 - sy) / 2) / ry
                    end
                    local lineHeight = height / hitDist
                    local bottom = -lineHeight / 2 + height / 2
                    if bottom < 0 then bottom = 0 end
                    local top = lineHeight / 2 + height / 2
                    if top >= height then top = height - 1 end
                    local wallX = 0
                    if side == 0 then
                        wallX = y + hitDist * ry
                    else
                        wallX = x + hitDist * rx
                    end
                    wallX = wallX - math.floor(wallX)
                    local step = 1 / lineHeight
                    local texPos = (bottom - height * 0.5 + lineHeight * 0.5) * step
                    for iy = bottom, top do
                        texPos = texPos + step
                        love.graphics.setColor(shaders[map[mx][my]](
                            wallX,
                            texPos,
                            time
                        ))
                        love.graphics.points(ix + width * 0.5, iy)
                    end
                end
            end
        end
    }
end
