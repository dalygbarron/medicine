--- This module returns a constructor for a raycaster object which takes
-- a mapping of numeric codes to quads for the sprites those codes represent.
-- It can then take a 2d map of codes, a position, and a looking angle and
-- renders an image of what it sees

local vec = require 'vec'
local util = require 'util'

local bgr, bgg, bgb, bga = 0.8, 0.9, 1, 1

return function (shaders, camDist, camPlane)
    return {
        draw = function (map, layers, ceiling, time, x, y, vx, vy)
            love.graphics.setPointSize(1.5)
            love.graphics.clear(bgr, bgg, bgb, bga)
            local cdx, cdy = vec.times(vx, vy, camDist)
            local cpx, cpy = vec.times(vy, -vx, camPlane)
            local width = love.graphics.getWidth()
            local halfWidth = width * 0.5
            local height = love.graphics.getHeight()
            local halfHeight = height * 0.5
            -- Cast floors
            local rx0, ry0 = vec.minus(cdx, cdy, cpx, cpy)
            local rx1, ry1 = vec.plus(cdx, cdy, cpx, cpy)
            for iy = ceiling and 1 or halfHeight, height do
                local rowDistance = math.abs(halfHeight / (iy - halfHeight))
                if iy < halfHeight then rowDistance = rowDistance * layers end
                local fsx, fsy = vec.times(
                    rowDistance,
                    rowDistance,
                    vec.times(
                        1 / width,
                        1 / width,
                        vec.minus(rx1, ry1, rx0, ry0)
                    )
                )
                local fx, fy = vec.plus(
                    x,
                    y,
                    vec.times(rx0, ry0, rowDistance)
                )
                for ix = 1, width do
                    local ffx = math.floor(fx)
                    local ffy = math.floor(fy)
                    if fx >= 1 and fy >= 1 and map[ffx] and map[ffx][ffy] then
                        local tx, ty = vec.minus(
                            fx,
                            fy,
                            math.floor(fx),
                            math.floor(fy)
                        )
                        love.graphics.setColor(util.mixColours(
                            2 / rowDistance,
                            bgr,
                            bgg,
                            bgb,
                            bga, 
                            shaders[1](tx, ty, time)
                        ))
                        love.graphics.points(ix, iy)
                    end
                    fx = fx + fsx
                    fy = fy + fsy
                end
            end
            -- Cast walls
            for iz = layers, 1, -1 do
                for ix = -halfWidth, halfWidth do
                    local mx = math.floor(x)
                    local my = math.floor(y)
                    local side = 0
                    local sx = 0
                    local sy = 0
                    local sdx = 0
                    local sdy = 0
                    local hit = false
                    local prop = ix / halfWidth
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
                        if side == 0 then hitDist = (mx - x + (1 - sx) / 2) / rx
                        else hitDist = (my - y + (1 - sy) / 2) / ry
                        end
                        if hitDist == 0 then hitDist = 0.001 end
                        local invDist = 1 / hitDist
                        local lineHeight = height * invDist
                        local offset = lineHeight * (iz - 1)
                        local bottom = -lineHeight * 0.5 + halfHeight - offset
                        local top = lineHeight * 0.5 + halfHeight - offset
                        local wallX = 0
                        if side == 0 then wallX = y + hitDist * ry
                        else wallX = x + hitDist * rx
                        end
                        wallX = wallX - math.floor(wallX)
                        local step = 1 / lineHeight
                        for iy = math.max(bottom, 0), math.min(top, height - 1) do
                            love.graphics.setColor(util.mixColours(
                                invDist,
                                bgr,
                                bgg,
                                bgb,
                                bga, 
                                shaders[map[mx][my]](
                                    wallX,
                                    (iy - bottom) * step,
                                    time
                                )
                            ))
                            love.graphics.points(ix + width * 0.5, iy)
                        end
                    end
                end
            end
        end
    }
end
