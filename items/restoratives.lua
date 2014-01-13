
local healFunc = function(self) 
	player:restoreHealth(self.strength)
	player:removeItem(self)
end

local manaFunc = function(self) 
	player:restoreMana(self.strength)
	player:removeItem(self)
end

local function makePotion(name, des, tileid, strength, useFunc)
	local p = Item(name,tileid)
	p.description = des
	p.strength = strength
	p.use = useFunc
end

makePotion("Potion", "A small and only partially effective potion that heals.", 1, 20, healFunc)
makePotion("High Potion", "A large healing potion brewed by an respected alchemist.", 3, 40, healFunc)
makePotion("Super Potion", "A truly remarkable healing potion brewed by a master of his craft", 5, 100, healFunc)

makePotion("Ether", "A sparkling blue potion to restore mana.", 2, 20, manaFunc)
makePotion("High Ether", "A large ether potion to restore mana.", 4, 50, manaFunc)
makePotion("Super Ether", "A mana potion made by a witch of great power.", 6, 50, manaFunc)


