--- This module contains an asset repository type of thing. Basically whenever
-- you want an asset you ask for it, and the first time it is loaded from the
-- filesystem, from then on it is stored and when you ask for it again it just
-- gives it to you. There is probably some small amount of overhead so if you
-- are going to use the same asset 1000 times a frame maybe store a reference
-- to it locally. If it was needed I could add a feature to free assets that
-- are not going to be needed again for a while but I don't think it's needed
-- so who cares.

local loaders = {
    imageData = function (fullName)
        return love.image.newImageData(fullName)
    end,
    song = function (fullName)
        return love.audio.newSource(fullName, 'stream')
    end,
    sound = function (fullName)
        return love.audio.newSource(fullName, 'static')
    end
}

function get(name, kind)

end

--- The structure of this module is of one big constructor function that
-- returns the assets object. The reason for this approach is it means I can
-- treat the actual assets list as a private variable which is cute.
-- @param prefix is the string to prepend to all filenames passed to the assets
--               manager.
return function (prefix)
    local items = {}
    local get = function (name, kind)
        if not items[name] then
            items[name] = loaders[kind](prefix..name)
        end
        return items[name]
    end
    return {
        getImageData = function (name)
            return get(name, 'imageData')
        end,
        getPic = function (name)
            return love.graphics.newImage(get(name, 'imageData'))
        end,
        getSong = function (name)
            return get(name, 'song')
        end,
        getSound = function (name)
            return get(name, 'sound')
        end
    }
end
