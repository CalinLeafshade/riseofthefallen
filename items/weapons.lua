
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
		attachment = nil
	}) -- no id, special item 

Item("Short Sword",12,
	{
		range = 32,
		power = 6,
		damageType = "normal",
		speed = 1,
		animation = "fists",
		attachment = "sword"
	}) -- no id, special item 



