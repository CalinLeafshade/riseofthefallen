
WeaponAttachments = 
{
	sword = 
	{
		-- not sure if this is 100% necessary. Might depend on the animations.
		ground = Animation("gfx/weapons/sword.png",5,{speed = 0.07}),
		air = Animation("gfx/weapons/sword.png",5,{speed = 0.07})
	}
}

-- weapons

Item("Fists",0, 
	{
		range = 16,
		power = 1,
		damageType = "normal",
		speed = 1,
		animation = "fists",
		attachment = nil,
		canEquip = { weapon = true },
		description = "My fists. Reliable."
	}) 

Item("Short Sword",12,
	{
		range = 32,
		power = 6,
		damageType = "normal",
		speed = 1,
		animation = "fists",
		attachment = "sword",
		canEquip = { weapon = true },
		description = "A poorly constructed short sword."
	}) 

Item("Long Sword",11, -- TODO
	{
		range = 32,
		power = 6,
		damageType = "normal",
		speed = 1,
		canEquip = { weapon = true },
		animation = "fists",
		attachment = "sword",
		description = "TODO"
	}) 


Item("Scythe", 10, -- TODO
	{
		range = 32,
		power = 6,
		damageType = "normal",
		speed = 1,
		canEquip = { weapon = true },
		animation = "fists",
		attachment = "sword",
		description = "TODO"
	}) 


