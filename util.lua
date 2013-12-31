
local abs = math.abs
--util

function clamp(val,min,max)
	if val < min then return min
	elseif val > max then return max
	else return val end
end

--- Lerps a value
-- @param  a Lower value
-- @param  b Upper value
-- @param  t Needle
-- @return   A lerped value
function lerp (a, b, t)
    return a + (b - a) * t
end 

--- Smoothsteps a value
-- @param  edge0 Lower edge
-- @param  edge1 Upper edge
-- @param  x     Needle
-- @return       The smoothed value
function smoothstep(edge0, edge1, x)
    x = saturate((x - edge0) / (edge1 - edge0))
    return x * x * (3 - 2 * x)
end

-- fast check that returns true if 2 boxes are intersecting
function boxesIntersect(l1,t1,w1,h1, l2,t2,w2,h2)
  return l1 < l2+w2 and l1+w1 > l2 and t1 < t2+h2 and t1+h1 > t2
end

-- returns the area & minimum displacement vector given two intersecting boxes
function getOverlapAndDisplacementVector(l1,t1,w1,h1,c1x,c1y, l2,t2,w2,h2,c2x,c2y)
  local dx = l2 - l1 + (c1x < c2x and -w1 or w2)
  local dy = t2 - t1 + (c1y < c2y and -h1 or h2)
  local ax, ay = abs(dx), abs(dy)
  local area = ax * ay

  if ax < ay then return area, dx, 0 end
  return area, 0, dy
end

function round(num, idp)
  local mult = 10^(idp or 0)
  return math.floor(num * mult + 0.5) / mult
end

function string.startsWith(String,Start)
   return string.sub(String,1,string.len(Start))==Start
end

function string.endsWith(String,End)
   return End=='' or string.sub(String,-string.len(End))==End
end