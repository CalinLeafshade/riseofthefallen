require('state')

local lg = love.graphics

MainMenu = State("MainMenu")

local selectedItem = 1
 
local main = {
	{text = "New Game", fn = function ( ... )
		NewGame()
		stateManager:pop()
		stateManager:push(MainState)
	end},
	{text = "Load Game", fn = function ( ... )
		local function loadSlot(slot)
			LoadGame(slot)
			stateManager:pop()
			stateManager:push(MainState)
		end
		local slots = SaveState.enumerate()
		local menu = {}
		for i,v in ipairs(slots) do
			local o = 
			{
				text = "Slot " .. v,
				fn = function( ... )
					local slot = v
					loadSlot(slot)
				end
			}
			table.insert(menu,o)
		end
		table.insert(menu, {text = "Return", fn = function ( ... )
			MainMenu:pop()
		end})
		selectedItem = 1
		MainMenu:push(menu)
	end},
	{text = "Quit", fn = function ( ... )
		love.event.push("quit")
	end},
}

local stack = {main}

function MainMenu:push(m)
	table.insert(stack,1,m)
end

function MainMenu:pop()
	table.remove(stack,1)
end

function MainMenu:update( dt )
	if Input:isNew("up") then
		selectedItem = math.max(selectedItem - 1,1)
	elseif Input:isNew("down") then
		selectedItem = math.min(selectedItem + 1, #stack[1])
	elseif Input:isNew("select") then
		stack[1][selectedItem].fn()
	elseif Input:isNew("back") and #stack > 1 then
		self:pop()
	end
end

function MainMenu:draw( ... )
	-- Alan - attempting at background
	--lg.setColor(Color.Black)
	--lg.rectangle("fill",0,0,320,180)
	bg = love.graphics.newImage("gfx/title.png")
	lg.draw(bg)
	lg.setFont(Fonts.betterPixels)
	for i,v in ipairs(stack[1]) do
		local c = selectedItem == i and Color.White or Color.Grey
		lg.setColor(c)
		local y = 160 - #stack[1] * 12 + i * 12
		lg.print(v.text, 130, y)
	end
end