
SavingState = State("SavingState")

SavingState.opaque = false

local h = 10
local l  = (h / 2) / math.sin(45)
local dX = math.cos(45) * l
local dY = math.sin(45) * l
local cX = dX + (l / 2)
local cY = dY
local verts = {
      0,             dY
    , dX,            0
    , dX + l,        0
    , dX + l + dX, dY
    , dX + l,      dY + dY
    , dX,            dY + dY
  }

function SavingState:focus()
	self.progress = 0
end

function SavingState:update(dt)
	self.progress = self.progress + dt / 5 -- five seconds
	if self.progress > 1 then
		savestate:save(1)
		stateManager:pop()
	end
end

local function drawHex(x,y,r,s)
	love.graphics.push()
	
	love.graphics.translate(x,y)
	love.graphics.scale(s)
	love.graphics.rotate(r)
	love.graphics.translate(-cX,-cY)

	love.graphics.polygon("fill", unpack(verts))
	love.graphics.pop()
end

function SavingState:draw()
	local r = self.progress * math.pi
	love.graphics.setBlendMode("additive")
	love.graphics.setColor(100,100,100,(1 - self.progress) * 100)
	local x,y = player:getCenter()
	drawHex(x,y,-r,self.progress * 10)
	drawHex(x,y,r,self.progress * 10)
	for i=0,6 do
		local angle = ((math.pi * 2) / 6) * i
		local xx = (math.sin(angle) * self.progress * 40) + x
		local yy = (math.cos(angle) * self.progress * 40) + y
		drawHex(xx,yy,r*2,self.progress * 5)
	end
		
	love.graphics.setBlendMode("alpha")
end