--- This module returns the constructor for a texture atlas class that actually
-- generates it's atlas when you run the game!!! bing bing bing. Yeah so when
-- you run the atlas it searches for the output files and if they are already
-- there then it does nothing, but if they are not present it generates them.

local util = require 'util'
local ftcsv = require 'ftcsv'

function loadQuads(file, img)
    local quads = {}
    local data = assert(love.filesystem.read(file))
    local sprites, headers = ftcsv.parse(data, ',', {loadFromString=true})
    for i, sprite in ipairs(sprites) do
        assert(sprite.name)
        local x = assert(tonumber(sprite.x))
        local y = assert(tonumber(sprite.y))
        local w = assert(tonumber(sprite.w))
        local h = assert(tonumber(sprite.h))
        quads[sprite.name] = love.graphics.newQuad(x, y, w, h, img)
    end
    return quads
end

return function (txtFile, imgFile)
    local img = love.graphics.newImage(imgFile)
    local spriteBatch = love.graphics.newSpriteBatch(img, 1500)
    local quads = assert(loadQuads(txtFile, img))
    return {
        getQuad = function (name)
            return quads[name]
        end,
        drawQuad = function (quad, x, y, sx, sy)
            if not sx then sx = 1 end
            if not sy then sy = 1 end
            spriteBatch:add(quad, x, y, 0, sx, sy)
        end,
        draw = function ()
            spriteBatch:flush()
            love.graphics.draw(spriteBatch)
            spriteBatch:clear()
        end
    }
end
