local gameConstructor = require 'game'
local raycasterConstructor = require 'raycaster'
local util = require 'util'

local game = nil
local map = {
    {1, 2, 0, 2, 1, 0, 0, 0},
    {1, 0, 0, 0, 1, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 2},
    {1, 0, 0, 0, 1, 0, 0, 0},
    {1, 2, 0, 2, 1, 0, 0, 0}
}
local angle = 0
local time = 0

function freakyShader(x, y, time)
    return util.wrapAroundZero(x + time, 1), util.wrapAroundZero(y + time, 1), 1.0, 1.0
end

function love.load()
    game = gameConstructor('assets/')
    local a = assert(game.assets.getImageData('rockwallFlat.png'))
    local b = assert(game.assets.getImageData('grass.png'))
    raycaster = raycasterConstructor(
        {util.createImageShader(a), util.createImageShader(b)},
        0.6,
        0.7
    )
end

function love.update(delta)
    angle = angle + delta
    time = time + delta
end

function love.draw(delta)
    love.graphics.clear(1, 0, 0)
    raycaster.draw(map, atlas, time, 3, 2, math.cos(angle), math.sin(angle))
end
