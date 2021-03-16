local atlas = require 'atlas'

return function (atlasTxt, atlasImg)
    return {
        atlas = atlas(atlasTxt, atlasImg)
    }
end
