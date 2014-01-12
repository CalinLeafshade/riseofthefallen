
require('mapobject')

Player = Class("Player",MapObject)

local animations = 
{
	walk = Animation("gfx/player/playerWalk.png",4, {offset = "bottom middle"}),
	idle = Animation("gfx/player/playerIdle.png",1),
	hurt = Animation("gfx/player/playerHurt.png",1),
	jump = Animation("gfx/player/playerJump.png",1),
	fall = Animation("gfx/player/playerFall.png",1),
	attack = 
	{
		fists = 
		{
			ground = Animation("gfx/player/playerAttackFist.png",5, {speed = 0.07}),
			air = Animation("gfx/player/playerAttackFist.png",5, {speed = 0.07}),
		}
	}

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
		update = function(self,dt)
			if math.abs(self.vx) > 0 and self.onGround then
				self:setState("walk")
			end	
			self:handleWet(dt, self.dir == "right" and -5 or 5, 10)
		end,
		leave = function() end
	},
	walk = 
	{
		canAttack = true,
		set = function(self)
			self.animation = self.animations.walk
			self.animation:reset()
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
			self:handleWet(dt, self.dir == "right" and -6 or 6, 10)
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
		set = function(self, weapon)
			if self.onGround then
				self.animation = self.animations.attack[weapon.animation].ground
				self.attachment = weapon.attachment and WeaponAttachments[weapon.attachment].ground
				self.animation:reset()
				self.vx = 0
				self.ax = 0
			else
				self.animation = self.animations.attack[weapon.animation].air
				self.attachment = weapon.attachment and WeaponAttachments[weapon.attachment].air
				self.animation:reset()
			end
		end,
		update = function(self,dt)
			if self.onGround then
				self.vx = 0
				self.ax = 0
			end
			local s = self.animation:update(dt)
			if self.attachment then
				self.attachment.frame = self.animation.frame
			end
			if s == "complete" then
				self:setState("idle")
			elseif s == "frame" then
				
			end
		end,
		leave = function(self)
			self.attachment = nil
		end
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
	self.animations = animations
	self.states = states
	self.friction = true
	self.equipped = { weapon = Items["Short Sword"]}
	self:setState("idle")
	self.items = {}
end

function Player:handleWet( dt,x,y )
	if self.wet then
		local r = round(self.wet)
		self.wet = self.wet - dt
		if r ~= round(self.wet) then
			local cx,cy = self:getCenter()
			self.map:attachObject(Drop(cx + x, cy + y,0,0))
		end			
		if self.wet < 0 then
			self.wet = false
		end
	end
end

function Player:getWeapon()
	return self.equipped.weapon or Items.Fists
end

function Player:pickUp(item)
	self.items[item] = (self.items[item] or 0) + 1
	display(item.name)
	log(nil, "Picked up " .. item.name)
end

function Player:restoreHealth(val)
	self.health = math.min(self.health + val, self.maxHealth)
end

function Player:restoreMana(val)
	self.mana = math.min(self.mana + val, self.maxMana)
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
 
function Player:attack()
	if not self:getState().canAttack then return end
	local w = self:getWeapon()
	self:setState("attack",w)
	local tx,ty = self:getCenter()
	local range = self.dir == "left" and -w.range or w.range
	local o = {}
	for x = tx,tx + range, range < 0 and -1 or 1 do
		local oo = self.map:getObjectsAt(x,ty)
		for i,v in ipairs(oo) do
			o[v] = v
		end
	end
	o[self] = nil -- dont attack player
	for i,v in pairs(o) do
		print(v, v.solid)
		if v.solid and not v.static then
			v:hurt(w.power, v.x - self.x, v.y - self.y)
		end
	end
end

function Player:leaveEdge(edge)
	local cx,cy = self:getCell()
	print(edge,cx,cy)
	world:changeMap(cx,cy)
end


function Player:getWidth() return 14 end
function Player:getHeight() return 28 end