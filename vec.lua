--- Contains code for vector operations. It does not use a vector class but
-- just returns multiple things. There are times when that falls apart
-- annoyingly but that is how it is on this bitch of an earth.

local vec = {}

--- Tells you the length of the given vector. Tries to optimise if possible but
-- sometimes you've just gotta calculate a square root.
-- @param x is the first part of the vector.
-- @param y is the second part of the vector.
-- @return the vector length.
function vec.len(x, y)
    if x == 0 then
        if y == 0 then
            return 0
        end
        return y
    elseif y == 0 then
        return x
    end
    return math.sqrt(x * x + y * y)
end

--- Normalises the given vector.
-- @param x is the first part of the vector.
-- @param y is the second part of the vector.
-- @return a vector with the same direction but a length of one.
function vec.norm(x, y)
    local len = vec.len(x, y)
    return x / len, y / len
end

--- Returns the addition of two vectors or a vector and a scalar
-- @param x  is the first part of the first vector.
-- @param y  is the second part of the first vector.
-- @param sx is the first part of the second vector or the scalar.
-- @param sy is the second part of the second vector if included.
-- @return the new vector.
function vec.plus(x, y, sx, sy)
    if not sy then return x + sx, y + sx end
    return x + sx, y + sy
end

--- Returns the subtraction of two vectors or a vector and a scalar.
-- @param x  is the first part of the first vector.
-- @param y  is the second part of the first vector.
-- @param sx is the first part of the second vector or the scalar.
-- @param sy is the second part of the second vector if included.
-- @return the result of the subtraction in two components.
function vec.minus(x, y, sx, sy)
    if not sy then return x - sx, y - sx end
    return x - sx, y - sy
end

--- Multiplies a vector and returns both results as seperate numbers. The thing
-- to multiply by can be either a scalar or another vector
-- @param x  is the first item of the first vector.
-- @param y  is the second item of the first vector.
-- @param sx is the first item of the second vector or the scalar value.
-- @param sy is the second item of the second vector or can be omitted.
-- @return the two values of the multiplied vecor.
function vec.times(x, y, sx, sy)
    if not sy then return x * sx, y * sx end
    return x * sx, y * sy
end

return vec
