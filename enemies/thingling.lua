
Thingling = Class("Thingling", Enemy)



local states = 
{
	walk = 
	{
		set = function(self)
				self.vx = 50
			end,
		update = function(self,dt)
				self.animation:update(dt * clamp((math.abs(self.vx * 4) / self.maxLateralSpeed),0,1))
				if self.x + self:getWidth() > self.props.limit[2] and self.vx > 0 then
					self.vx = -self.vx
				elseif self.x < self.props.limit[1] and self.vx < 0 then
					self.vx = -self.vx
				end
			end,
		leave = function() end
	}
}

function Thingling:initialize(x,y,props)
	props = props or {}
	props.limit = props.limit or {0,320}
	Enemy.initialize(self,x,y,props)
	self.animation = Animation("gfx/enemies/thinglingWalk.png", 3, {offset = "bottom middle"})
	self.friction = false
	self.states = states
end

function Thingling:collide(with,vx,vy)
	if with == Player then
		Player:hurt(1,vx,vy)
	end
end

function Thingling:wake()
	self:setState("walk")
end

Enemies["Thingling"] = Thingling