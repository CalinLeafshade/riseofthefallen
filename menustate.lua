
require("gui.gui")
require("gui.itemgui")
require('gui.guioptionnormal')

MenuState = State("MenuState")
MenuState.opaque = false

local lg = love.graphics

local selectorGui = GUI(250,0,70,180)

MenuState.stack = {selectorGui}

local itemDescription = ""

local screens = {
	{
		name = "Status",
		guis = { GUI(0,0,250,180, {
				draw = function(self)
					GUI.draw(self)
					lg.setFont(Fonts.betterPixels)
					lg.print("HP  " .. player.health .. "/" .. player.maxHealth, 8,10)
					lg.print("MP  " .. player.mana .. "/" .. player.maxMana, 8,25)

					lg.print("ATK  12", 8,42)
					lg.print("DEF  8", 8,56)

					lg.print("STATUS  Normal", 8, 74)

					lg.print("Souls", 8, 92)
					lg.print("Harvested", 16, 108)
					lg.print("1", 85, 108)
					lg.print("Crossed", 16, 120)
					lg.print("0", 85, 120)

					lg.print("Money  $500", 8, 160)

					local t = math.floor(savestate.time)
					local s = math.floor(t % 60)
					local m = math.floor((t - s) / 60)
					local h = math.floor(m - (m % 60) / 60)
					m = m % 60
					if m < 10 then 
						m = "0" .. m
					end
					if h < 10 then
						h = "0" .. h
					end
					if s < 10 then
						s = "0" .. s
					end
					lg.print("Time  " .. h .. ":" .. m .. ":" .. s, 160, 160)

				end
			}) 
		},
		onSelect = function ( ... )
			-- body
		end
	},
	{
		name = "Equip",
		guis = { 
					--topgui
					GUI(0,0,250,80, {
						draw = function(self)
							GUI.draw(self)
							love.graphics.setFont(Fonts.tiny)
							love.graphics.print("WEAPON",8,3)
							love.graphics.print("ARMOR",8,18)
							love.graphics.print("ACC 1",8,33)
							love.graphics.print("ACC 2",8,47)
							love.graphics.print("SPELL",8,60)

							love.graphics.print("HP", 193 , 12)
							love.graphics.print(player.maxHealth, 220,12)
							love.graphics.print("MP", 193 , 22)
							love.graphics.print(player.maxMana, 220,22)
							love.graphics.print("ATK", 193 , 32)
							love.graphics.print("12", 220,32)
							love.graphics.print("DEF", 193 , 42)
							love.graphics.print("12", 220,42)

							love.graphics.setFont(Fonts.betterPixels)

							local item = player.equipped.weapon
							item:draw(38,4)
							love.graphics.print(item.name, 58, 5)

							local item = player.equipped.armor
							local t = "----"
							if item then
								item:draw(38, 19)
								t = item.name
							end
							love.graphics.print(t,58, 20)

							local item = player.equipped.acc1
							local t = "----"
							if item then
								item:draw(38, 33)
								t = item.name
							end
							love.graphics.print(t,58, 34)

							local item = player.equipped.acc2
							local t = "----"
							if item then
								item:draw(38, 48)
								t = item.name
							end
							love.graphics.print(t,58, 49)

						end
					}),
					--middle
					ItemGUI(0,80,250,60, {
						onItemChange = function(self,item)
							if item then
								itemDescription = item.description or ""
							else
								itemDescription = ""
							end
						end
					}),
					--bottom
					GUI(0,140,250,40, {
						draw = function (self)
							GUI.draw(self)
							love.graphics.printf(itemDescription, self.x + 8, self.y + 5, self.width - 16, "left")
						end
					}),

				},
		onSelect = function (self)
			MenuState:push(self.guis[2])
		end
	},
	{
		name = "Items",
		onSelect = function ( ... )
			-- body
		end
	},
	{
		name = "Abilities",
		onSelect = function ( ... )
			-- body
		end
	},
	{
		name = "Options",
		onSelect = function ( ... )
			-- body
		end
	}
}

local acceptedInput = {"up","down","left","right","select"}

for i,v in ipairs(screens) do
	
	local o = GUIOptionNormal()
	o.text = v.name
	o.screen = v
	o.onFocus = function(self)
		MenuState.active = screens[self.text]
	end
	o.onSelect = function (self)
		self.screen:onSelect()
	end
	selectorGui:addOption(o)
	screens[v.name] = v -- lookup for easy access

end

function MenuState:back()
	if #self.stack > 1 then
		local g = table.remove(self.stack, 1)
		g.isActive = false
		g:blur()
		self.stack[1].isActive = true
		self.stack[1]:focus()
	else
		stateManager:pop()
	end
end

function MenuState:push(g)
	self.stack[1].isActive = false
	table.insert(self.stack,1,g)
	self.stack[1].isActive = true
	self.stack[1]:focus()
end

function MenuState:blur()
	self.stack[1].isActive = true
end

function MenuState:focus( ... )
	self.stack = {selectorGui}
	self.active = screens.Status
	self.stack[1].isActive = true
	selectorGui.selected = 1
end

function MenuState:update(dt)
	
	for i,v in ipairs(self.active.guis or {}) do
		v:update(dt)
	end

	if Input:isNew("cancel") then
		self:back()
	end

	for i,v in ipairs(acceptedInput) do
		if Input:isNew(v) then
			self.stack[1]:receiveInput(v)
		end
	end	
end

function MenuState:draw( ... )
	selectorGui:draw()
	for i,v in ipairs(self.active.guis or {}) do
		v:draw()
	end
end
