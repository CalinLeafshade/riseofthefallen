
require('mapobject')

Player = Class("Player",MapObject)

local animations = 
{
	walk = Animation("gfx/player/playerWalk.png",4, {offset = "bottom middle"}),
	idle = Animation("gfx/player/playerIdle.png",1),
	hurt = Animation("gfx/player/playerHurt.png",1),
	jump = Animation("gfx/player/playerJump.png",1),
	fall = Animation("gfx/player/playerFall.png",1),
	attackGround = Animation("gfx/player/playerAttack.png",5, {speed = 0.07}),
	attackAir = Animation("gfx/player/playerAttackAir.png",4, {speed = 0.07})
}

local states = 
{
	idle = 
	{
		canAttack = true,
		set = function(self)
			self.animation = self.animations.idle
			self.animation:reset()
		end,
		update = function(self)
			if math.abs(self.vx) > 0 and self.onGround then
				self:setState("walk")
			end				
		end,
		leave = function() end
	},
	walk = 
	{
		canAttack = true,
		set = function(self)
			self.animation = self.animations.walk
		end,
		update = function(self,dt)
			self.animation:update(dt * clamp((math.abs(self.vx * 4) / self.maxLateralSpeed),0,1))
			if math.abs(self.vx) < 10 and self.onGround then
				self.vx = 0
				self:setState("idle")
			end
			if self.vy > 150 then
				self:setState("fall")
			end
			
		end,
		leave = function() end
	},
	jump =
	{
		canAttack = true,
		set = function(self)
			self.animation = self.animations.jump
		end,
		update = function(self)
			if self.vy > 0 then
				self:setState("fall")
			end
		end,
		leave = function() end
	},
	fall = 
	{
		canAttack = true,
		set = function(self)
			self.onGround = false
			self.animation = self.animations.fall
		end,
		update = function(self)
			if self.onGround then
				self:setState("idle")
			end
		end,
		leave = function() end
	},
	attack = 
	{
		set = function(self)
			if self.onGround then
				self.animation = self.animations["attackGround"]
				self.vx = 0
				self.ax = 0
			else
				self.animation = self.animations["attackAir"]
			end
		end,
		update = function(self,dt)
			if self.onGround then
				self.vx = 0
				self.ax = 0
			end
			local s = self.animation:update(dt)
			if s == "complete" then
				self:setState("idle")
			elseif s == "frame" then
				
			end
		end,
		leave = function() end
	},
	hurt = 
	{
		set = function(self,vx,vy)
			local vx = self.dir == "left" and 100 or -100
			self.vx = vx
			self.vy = -200
			self.onGround = false
			self.isHurt = true
			self.animation = self.animations.hurt
		end,
		update = function(self, dt)
			self.ax = 0
			if self.onGround then
				self:setState("idle")
				self.isHurt = false
			end
		end,
		leave = function(self,dt)
			
		end
	
	}
}

function Player:initialize(x,y,props)
	MapObject.initialize(self,x,y,props)
	self.maxHealth = 50
	self.health = 50
	self.mana = 50
	self.maxMana = 100
	self.power = 10
	self.range = 32
	self.animations = animations
	self.states = states
	self.friction = true
	self:setState("idle")
end

function Player:jump()
	if not self.onGround then return end
	self:setState("jump")
	self.vy = -400
	self.onGround = false
	
end

function Player:interact()
	local o = self:getOverlappingObjects()
	for i,v in ipairs(o) do
		v:interact()
	end
end

function Player:hurt(pwr,vx,vy)
	if self.state == "hurt" or self:isInvincible() then
		return false
	end
	self.lastHurt = love.timer.getTime()
	self.health = self.health - pwr
	print("player was hurt")
	local x = self:getCenter()
	local y = self.y
	Bubble(x,y - 15,pwr,{200,0,0})
	self:setState("hurt",vx,vy)
	return true
end

function Player:drop()
	self.y = self.y + 1
	self.onGround = false
	self:setState("fall")
end

function Player:setState(...)
	local t = {...}
	print("player state set to " .. t[1])
	MapObject.setState(self,...)
end

function Player:attack()
	if not self:getState().canAttack then return end
	self:setState("attack")
	local tx,ty = self:getCenter()
	local range = self.dir == "left" and -self.range or self.range
	local o = {}
	for x = tx,tx + range, range < 0 and -1 or 1 do
		local oo = self.map:getObjectsAt(x,ty)
		for i,v in ipairs(oo) do
			o[v] = v
		end
	end
	o[self] = nil -- dont attack player
	for i,v in pairs(o) do
		v:hurt(self.power, v.x - self.x, v.y - self.y)
	end
end

function Player:leaveEdge(edge)
	local cx,cy = self:getCell()
	print(edge,cx,cy)
	world:changeMap(cx,cy)
end



function Player:getWidth() return 14 end
function Player:getHeight() return 28 end