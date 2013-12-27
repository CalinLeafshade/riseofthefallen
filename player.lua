
Player = MapObject(130,70)

Player.friction = true

function Player:jump()
	if not self.onGround then return end
	self:setState("jump")
	self.vy = -400
	self.onGround = false
	
end

function Player:hurt(pwr,vx,vy)
	if self.state == "hurt" or self:isInvincible() then
		return 
	end
	self.lastHurt = love.timer.getTime()
	print("player was hurt")
	self:setState("hurt",vx,vy)
end

function Player:attack()
	self:setState("attack")
end

Player.animations = 
{
	walk = Animation("gfx/player/playerWalk.png",4, {offset = "bottom middle"}),
	idle = Animation("gfx/player/playerIdle.png",1),
	hurt = Animation("gfx/player/playerHurt.png",1),
	jump = Animation("gfx/player/playerJump.png",1),
	fall = Animation("gfx/player/playerFall.png",1),
	attackGround = Animation("gfx/player/playerAttack.png",5, {speed = 0.05}),
	attackAir = Animation("gfx/player/playerAttackAir.png",3, {speed = 0.05})
}

Player.animation = Player.animations["idle"]

Player.states = 
{
	idle = 
	{
		set = function(self)
			self.animation = self.animations.idle
			self.animation:reset()-- = self.animations.idle
		end,
		update = function(self)
			if math.abs(self.ax) > 0 and self.onGround then
				self:setState("walk")
			end				
		end,
		leave = function() end
	},
	walk = 
	{
		set = function(self)
			self.animation = self.animations.walk
		end,
		update = function(self,dt)
			self.animation:update(dt * clamp((math.abs(self.vx * 4) / self.maxLateralSpeed),0,1))
			if math.abs(self.vx) < 1 and self.onGround then
				self:setState("idle")
			end
			
		end,
		leave = function() end
	},
	jump =
	{
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
		set = function(self)
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

function Player:getWidth() return 14 end
function Player:getHeight() return 28 end