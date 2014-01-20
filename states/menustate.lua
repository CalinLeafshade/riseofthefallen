
require("gui.gui")
require("gui.itemgui")
require('gui.guioptionnormal')

MenuState = State("MenuState")
MenuState.opaque = false

local function makeEquipFilter(slot)
	if slot then
		return function (item)
			return item.canEquip and item.canEquip[slot]
		end
	else
		return function (item)
			return item.canEquip
		end
	end
end

local lg = love.graphics

local selectorGui = GUI(250,0,70,180)

MenuState.stack = {selectorGui}

local selectedItem
local selectedSlot
local screens
screens = {
	{
		name = "Status",
		guis = { GUI(0,0,250,180, {
				draw = function(self)
					GUI.draw(self)

					lg.draw(Portraits.player, 245,5,0,-1,1)

					lg.setFont(Fonts.betterPixels)
					lg.print("HP  " .. player.hp .. "/" .. player:getStat("hp"), 8,10)
					lg.print("MP  " .. player.mp .. "/" .. player:getStat("mp"), 8,25)

					lg.print("ATK  " .. player:getStat("atk"), 8,42)
					lg.print("DEF  " .. player:getStat("def"), 8,56)

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
						focus = function (self)
							self.selected = 1
							selectedItem = nil
							selectedSlot = nil
						end,
						blur = function (self)
							
						end,
						receiveInput = function (self, input)
							if input == "up" then
								self.selected = math.max(self.selected - 1, 1)
							elseif input == "down" then
								self.selected = math.min(self.selected + 1, 5)
							elseif input == "select" then
								local slots = {"weapon", "armor", "acc1", "acc2", "spell"}
								selectedSlot = slots[self.selected]
								MenuState:push(screens.Equip.guis[2])
							end
						end,
						draw = function(self)
							GUI.draw(self)

							local active = self.isActive

							local function setColor(num)
								love.graphics.setColor((active and self.selected == num) and Color.White or Color.Grey)
							end

							love.graphics.setFont(Fonts.tiny)

							setColor(1)
							love.graphics.print("WEAPON",18,3)
							setColor(2)
							love.graphics.print("ARMOR",18,18)
							setColor(3)
							love.graphics.print("ACC 1",18,33)
							setColor(4)
							love.graphics.print("ACC 2",18,47)
							setColor(5)
							love.graphics.print("SPELL",18,60)

							if active then
								local ys = {3,18,33,47,60}
								love.graphics.setColor(Color.White)
								self:drawSelector(16, ys[self.selected] + Fonts.tiny:getHeight() / 2 + 1)
							end

							local function drawStat(stat, x, y)
								local oldStat, newStat = player:getStat(stat, selectedItem, selectedSlot)

								local s = oldStat
								if oldStat < newStat then
									love.graphics.setColor(Color.LightBlue)
									s = newStat
								elseif oldStat > newStat then
									love.graphics.setColor(Color.DarkRed)
									s = newStat
								else
									love.graphics.setColor(Color.White)
								end

								love.graphics.print(s,x,y)

							end

							love.graphics.setColor(Color.White)
							love.graphics.print("HP", 203 , 12)
							love.graphics.print("MP", 203 , 22)
							love.graphics.print("ATK", 203 , 32)
							love.graphics.print("DEF", 203 , 42)

							drawStat("hp", 230, 12)
							drawStat("mp", 230, 22)
							drawStat("atk", 230, 32)
							drawStat("def", 230, 42)

							love.graphics.setColor(Color.White)
							love.graphics.setFont(Fonts.betterPixels)

							local item = player.equipped.weapon
							item:draw(48,4)
							love.graphics.print(item.name, 68, 5)

							local item = player.equipped.armor
							local t = "----"
							if item then
								item:draw(48, 19)
								t = item.name
							end
							love.graphics.print(t,68, 20)

							local item = player.equipped.acc1
							local t = "----"
							if item then
								item:draw(48, 33)
								t = item.name
							end
							love.graphics.print(t,68, 34)

							local item = player.equipped.acc2
							local t = "----"
							if item then
								item:draw(48, 48)
								t = item.name
							end
							love.graphics.print(t,68, 49)

							local item = player.equipped.spell
							local t = "----"
							if item then
								item:draw(48, 62)
								t = item.name
							end
							love.graphics.print(t,68, 63)

						end
					}),
					--middle
					ItemGUI(0,80,250,60, {
						onItemChange = function(self,item)
							selectedItem = item
						end,
						onItemSelect = function (self,item)
							player:equip(item,selectedSlot)
							MenuState:back()
						end,
						focus = function (self)
							self:setFilter(makeEquipFilter(selectedSlot))
							ItemGUI.focus(self)
						end,
						blur = function (self)
							self:setFilter(makeEquipFilter())
							ItemGUI.blur(self)
						end,
						filter = makeEquipFilter()
					}),
					--bottom
					GUI(0,140,250,40, {
						draw = function (self)
							GUI.draw(self)
							if selectedItem then
								love.graphics.printf(selectedItem.description or "", self.x + 8, self.y + 5, self.width - 16, "left")
							end
						end
					}),

				},
		onSelect = function (self)
			MenuState:push(self.guis[1])
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
