
require('mapobject')
require('hurtableobject')

Player = Class("Player",HurtableObject)

local animations = 
{
	walk = Animation("gfx/player/playerWalk.png",6, {offset = "bottom middle"}),
	idle = Animation("gfx/player/playerIdle.png",1),
	hurt = Animation("gfx/player/playerHurt.png",1),
	jump = Animation("gfx/player/playerJump.png",1),
	fall = Animation("gfx/player/playerFall.png",1),
	attack = 
	{
		fists = 
		{
			ground = Animation("gfx/player/playerAttackFist.png",5, {speed = 0.07, loop = false}),
			air = Animation("gfx/player/playerAttackFist.png",5, {speed = 0.07, loop = false}),
		},
		swing = 
		{
			ground = Animation("gfx/player/playerAttackSwing.png",8, {speed = 0.07, loop = false}),
			air = Animation("gfx/player/playerAttackSwing.png",8, {speed = 0.07, loop = false}),
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
			self.animation:update(dt * clamp((math.abs(self.vx * 6) / self.maxLateralSpeed),0,1))
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
	wait = 
	{
		set = function (self,delay,next)
			self.waitDelay = delay
			self.nextState = next
			if delay == 0 then
				self:setState(next)
			end
		end,
		update = function (self,dt)
			self.waitDelay = self.waitDelay - dt
			if self.waitDelay <= 0 then
				self:setState(self.nextState)
			end
		end
	},
	attack = 
	{
		set = function(self, weapon)
			self.hurtByThisAttack = {}
			self.hang = nil
			if self.onGround then
				self.animation = self.animations.attack[weapon.animation].ground
				self.animation.speed = weapon.speed
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
			if self.hang then
				self.hang = self.hang - dt
				if self.hang < 0 then
					self:setState("idle")
				end
			else
				local w = self:getWeapon()
				if self.onGround then
					self.vx = 0
					self.ax = 0
				end
				local s = self.animation:update(dt)
				if self.attachment then
					self.attachment.frame = self.animation.frame
				end
				if s == "complete" then
					if w.hang then
						self.hang = w.hang
					else
						self:setState("idle")
					end
				else
					local f = self.animation.frame
					local cx,cy = self:getCenter()
					local py = self:bottom()
					local a = WeaponAttachments[w.attachment]
					local ani = WeaponAttachments[w.attachment][self.onGround and "ground" or "air"]
					for i,v in ipairs(a.hitPoints[f] or {}) do -- TODO special case for fists
						local dx = (v[1] - ani:getWidth() / 2)
						local dy = (ani:getHeight() - v[2])
						if self.dir == "left" then
							dx = -dx
						end
						local x = cx + dx
						local y = py - dy
						local o = self.map:getObjectsAt(x,y)
						for i,v in ipairs(o) do
							local vx,vy = v:getCenter()
							if v~= self and v.hurt and not self.hurtByThisAttack[v] then
								self.hurtByThisAttack[v] = true
								v:hurt(self:getStat("atk"),vx - cx, vy - cy, w.dmgType or "normal")
							end
						end
					end
				end
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
	HurtableObject.initialize(self,x,y,props)
	self.hurtTime = 2
	self.baseStats = 
	{
		hp = 100,
		mp = 100,
		atk = 1,
		def = 1,
		int = 1,
	}
	self.hp = self.baseStats.hp
	self.mp = self.baseStats.mp
	self.animations = animations
	self.states = states
	self.friction = true
	self.equipped = { 
		weapon = Items["Short Sword"],
		armor = Items["Leather Vest"],
	}
	self:setState("idle")
	self.items = {}
	for i,v in ipairs(Items) do -- Debug code, add all items
		if v.name ~= "Fists" then
			self:pickUp(v)
		end
	end
end

function Player:getStat(stat, withItem, inSlot)
	inSlot = inSlot or ""
	local base = (self.baseStats[stat] or 0)
	local new = (self.baseStats[stat] or 0)
	for i,v in pairs(self.equipped) do
		if inSlot == i and withItem then
			new = new + (withItem.stats[stat] or 0)
		else
			new = new + (v.stats[stat] or 0)
		end
		base = base + (v.stats[stat] or 0)
	end
	return base, new
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

function Player:pickUp(item, suppress)
	self.items[item] = (self.items[item] or 0) + 1
	if not suppress then
		display(item.name)
	end
	log(nil, "Picked up " .. item.name)
end

function Player:equip(item, slot)
	if not slot then
		for i,v in pairs(item.canEquip) do
			slot = i
		end
	end
	local i = self.equipped[slot]
	if i.name ~= "Fists" then
		self:pickUp(i, true)
	end
	self.equipped[slot] = item
	if self.items[item] and self.items[item] > 1 then
		self.items[item] = self.items[item] - 1
	else
		self.items[item] = nil
	end
end

function Player:restoreHealth(val)
	self.hp = math.min(self.hp + val, self:getStat("hp"))
end

function Player:restoreMana(val)
	self.mp = math.min(self.mp + val, self:getStat("mp"))
end

function Player:jump()
	if not self.onGround then return end
	self:setState("jump")
	self.vy = -320
	self.onGround = false
	
end

function Player:interact()
	local o = self:getOverlappingObjects()
	for i,v in ipairs(o) do
		v:interact()
	end
end

function Player:hurt(pwr,vx,vy, knockBack)
	if self.state == "hurt" or self:isInvincible() then
		return false
	end
	pwr = math.max(pwr - self:getStat("def"), 1)
	self.lastHurt = love.timer.getTime()
	self.hp = self.hp - pwr
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
end

function Player:leaveEdge(edge)
	local cx,cy = self:getCell()
	world:changeMap(cx,cy)
end


function Player:getWidth() return 14 end
function Player:getHeight() return 28 end