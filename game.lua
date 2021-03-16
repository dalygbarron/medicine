--- This module creates the game object and initialises some global state crap.

local assets = require 'assets'

return function (assetPrefix)
    return {
        assets = assets(assetPrefix)
    }
end
