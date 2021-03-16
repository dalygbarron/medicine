local gameConstructor = require 'game'
local raycasterConstructor = require 'raycaster'
local util = require 'util'

local game = nil
local quad = nil
local map = {
    {1, 2, 0, 2, 1, 0, 0, 0},
    {1, 0, 0, 0, 1, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 2},
    {1, 0, 0, 0, 1, 0, 0, 0},
    {1, 2, 0, 2, 1, 0, 0, 0}
}
local angle = 0

function love.load()
    game = gameConstructor('assets/sprites.csv', 'assets/sprites.png')
    quad = assert(game.atlas.getQuad('sprites/rockwallFlat.png'))
    raycaster = raycasterConstructor({quad}, 0.6, 0.7)
end

function love.update(delta)
    angle = angle + delta
end

function love.draw(delta)
    love.graphics.clear(1, 0, 0)
    raycaster.draw(map, atlas, 3, 3, math.cos(angle), math.sin(angle))
    game.atlas.draw()
end
