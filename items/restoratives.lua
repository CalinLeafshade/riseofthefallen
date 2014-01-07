
local healFunc = function(self) 
	player:restoreHealth(self.strength)
	player:removeItem(self)
end

local manaFunc = function(self) 
	player:restoreMana(self.strength)
	player:removeItem(self)
end

local function makePotion(name, tileid, strength, useFunc)
	local p = Item(name,tileid)
	p.strength = strength
	p.use = useFunc
end

makePotion("Potion", 1, 20, healFunc)
makePotion("High Potion", 1, 40, healFunc)
makePotion("Super Potion", 1, 100, healFunc)

makePotion("Ether", 1, 20, manaFunc)
makePotion("Mega Ether", 1, 50, manaFunc)


