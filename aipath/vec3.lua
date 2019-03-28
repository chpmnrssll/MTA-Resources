vec3 = {}
local vec3MT = {}

function vec3.new(v)
	if (not v or #v == 0) then
		v = { 0, 0, 0 }
	end
	return setmetatable(v, vec3MT)
end

vec3MT.__index = vec3

vec3MT.__add = function(v1, v2)
		return vec3.new({ v1[1] + v2[1], v1[2] + v2[2], v1[3] + v2[3] })
	end

vec3MT.__sub = function(v1, v2)
		return vec3.new({ v1[1] - v2[1], v1[2] - v2[2], v1[3] - v2[3] })
	end

vec3MT.__unm = function(v)
		return vec3.new({ -v[1], -v[2], -v[3] })
	end

vec3MT.__mul = function(v, m)
		return vec3.new({ v[1] * m, v[2] * m, v[3] * m })
	end

vec3MT.__div = function(v, d)
		if (d == 0) then
			return vec3.new()
		end
		return vec3.new({ v[1] / d, v[2] / d, v[3] / d })
	end

function vec3.len(v)
	return math.sqrt(v[1]^2 + v[2]^2 + v[3]^2)
end

function vec3.normalize(v, len)
	len = len and len or 1
	return (v / vec3.len(v)) * len
end

function vec3.dot(v1, v2)
	return v1[1] * v2[1] + v1[2] * v2[2] + v1[3] * v2[3]
end

function vec3.cross(v1, v2)
	return vec3.new({ v1[2] * v2[3] - v1[3] * v2[2], v1[3] * v2[1] - v1[1] * v2[3], v1[1] * v2[2] - v1[2] * v2[1] })
end

function vec3.scale(v, scale)
	return vec3.new({ v[1] * scale, v[2] * scale, v[3] * scale })
end

function vec3.matMul(v, m)
	local x = (v[1] * m[1][1]) + (v[2] * m[2][1]) + (v[3] * m[3][1]) + m[4][1]
	local y = (v[1] * m[1][2]) + (v[2] * m[2][2]) + (v[3] * m[3][2]) + m[4][2]
	local z = (v[1] * m[1][3]) + (v[2] * m[2][3]) + (v[3] * m[3][3]) + m[4][3]
	return vec3.new({ x, y, z })
end
