
Thingling = Class("Thingling", Enemy)

local states = 
{
	walk = 
	{
		set = function(self)
				self.vx = self.dir == "right" and 50 or -50
				self.animation = self.animations.walk
			end,
		update = function(self,dt)
				self.animation:update(dt * clamp((math.abs(self.vx * 4) / self.maxLateralSpeed),0,1))
				if self.x + self:getWidth() > self.props.limit[2] and self.vx > 0 then
					self.vx = -self.vx
				elseif self.x < self.props.limit[1] and self.vx < 0 then
					self.vx = -self.vx
				end
				self.dir = self.vx < 0 and "left" or "right"
			end,
		leave = function() end
	},
	attack = 
	{
		set = function(self)
			self.vx = 0
			self.animation = self.animations.attack
			self.animation:reset()
		end,
		update = function(self,dt)
			if self.animation:update(dt) == "complete" then
				self:setState("walk")
			end
		end,
		leave = function() end
	},
	hurt = 
	{
		set = function(self,dx,dy)
			self.animation = self.animations.hurt
			self.onGround = false
			dx = saturate(dx)
			self.vx = dx * 200
			self.vy = -200
		end,
		update = function(self,dt)
			if self.onGround then
				self:setState("walk")
				self.isHurt = false
			end
		end
	}
		
}

function Thingling:hitWall(dir)
	self.vx = dir == "left" and 50 or -50
end

function Thingling:initialize(x,y,props)
	props = props or {}
	props.limit = props.limit or {0,320}
	Enemy.initialize(self,x,y,props)
	self.animations = 
	{
		walk = Animation("gfx/enemies/thinglingWalk.png", 3, {offset = "bottom middle"}),
		attack = Animation("gfx/enemies/thinglingAttack.png", 3, {offset = "bottom middle"}),
		hurt = Animation("gfx/enemies/thinglingHurt.png", 1, {offset = "bottom middle"})
	}
	self.drops = { {20, "Potion"}, {20, "Ether"},{50, "Short Sword"}}
	self.friction = false
	self.states = states
end

function Thingling:collide(with,vx,vy)
	if with == player and self.state == "walk" then
		if player:hurt(1,vx,vy) then
			self:setState("attack")
		end
		
	end
end

function Thingling:wake()
	self:setState("walk")
end

Enemies["Thingling"] = Thingling