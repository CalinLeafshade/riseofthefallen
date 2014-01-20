
HurtableObject = Class("HurtableObject", MapObject)

function HurtableObject:initialize(x,y,props,hp)
	MapObject.initialize(self,x,y,props)
	self.hp = hp
	self.lastHurt = 1
	self.hurtTime = 0.5
end

function MapObject:isInvincible()
	return love.timer.getTime() - self.lastHurt < self.hurtTime 
end

function HurtableObject:update( ... )
	MapObject.update(self,...)
	self.alpha = self:isInvincible() and 128 or 255
end
function HurtableObject:hurt(pwr,dx,dy,dmgType)
	if self.state == "hurt" then return end
	self.lastHurt = love.timer.getTime()
	local x = self:getCenter()
	local y = self.y
	Bubble(x,y - 15,pwr,{200,0,0})
	self.hp = self.hp - pwr
	print(dx,dy)
	self:setState("hurt",dx,dy,dmgType)
	if self.hp <= 0 then
		self.hp = 0
		self:die()
	end
end