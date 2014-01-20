
HealthGUI = 
{
	picker = love.graphics.newImage("gfx/gui/gui_spellPicker.png"),	
	cap = love.graphics.newImage("gfx/gui/gui_barCap.png"),
	bars = 
	{
		empty = love.graphics.newImage("gfx/gui/gui_emptyBar.png"),
		hp = love.graphics.newImage("gfx/gui/gui_hpBar.png"),
		mana = love.graphics.newImage("gfx/gui/gui_manaBar.png"),
	},
	hp = 0,
	mana = 0
}

for i,v in ipairs(HealthGUI.bars) do
	v:setFilter("linear","linear")
end

function HealthGUI:update(dt)
	self.hp = lerp(self.hp, player.hp, dt * 2)
	self.mana = lerp(self.mana, player.mp, dt * 2)
end

function HealthGUI:draw()
	local function drawBar(t,x,y,value,maxValue,width)
		love.graphics.draw(self.cap,x,y)
		love.graphics.draw(self.cap,x + width,y)
		love.graphics.draw(self.bars.empty,x,y,0,width,1)
		local w = value/maxValue * width
		love.graphics.draw(self.bars[t],x,y,0,w,1)
	end
	
	love.graphics.draw(self.picker,0,156)
	drawBar("hp",29,164,self.hp, player:getStat("hp"), 60)
	drawBar("mana",29,170,self.mana, player:getStat("mp"), 60)
	
end

