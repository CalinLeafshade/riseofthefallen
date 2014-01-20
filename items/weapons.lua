
WeaponAttachments = 
{
	sword = 
	{
		-- not sure if this is 100% necessary. Might depend on the animations.
		ground = Animation("gfx/weapons/sword.png",5,{speed = 0.07}),
		air = Animation("gfx/weapons/sword.png",5,{speed = 0.07}),
		hitPoints = {
			{ {30,13}, { 37, 13  }, {59, 13} }, -- frame 1
			--{ { 54, 13  } },
		},
	},
	scythe = 
	{
		hitPoints = {
			{ { 23, 3  } }, -- frame 1
			{ { 37, 3  } },
			{ { 47, 21 } },
			{ { 45, 30 } },
		},
		ground = Animation("gfx/weapons/scythe.png",8,{speed = 0.07}),
		air = Animation("gfx/weapons/scythe.png",8,{speed = 0.07})	
	},	
	dagger = 
	{
		ground = Animation("gfx/weapons/dagger.png",5,{speed = 0.07}),
		air = Animation("gfx/weapons/dagger.png",5,{speed = 0.07})	
	},
}

-- weapons

Item("Fists",0, 
	{
		stats = { atk = 1 },
		damageType = "normal",
		speed = 0.07,
		animation = "fists",
		attachment = nil,
		canEquip = { weapon = true },
		description = "My fists. Reliable."
	}) 

Item("Short Sword",12,
	{
		stats = { atk = 6 },
		damageType = "normal",
		speed = 0.06,
		animation = "fists",
		attachment = "sword",
		canEquip = { weapon = true },
		description = "A poorly constructed short sword."
	}) 

Item("Long Sword",11, -- TODO
	{
		stats = { atk = 10 },
		damageType = "normal",
		speed = 0.08,
		canEquip = { weapon = true },
		hang = 0.2,
		animation = "fists",
		attachment = "sword",
		description = "TODO"
	}) 


Item("Scythe", 10, -- TODO
	{
		stats = { atk = 14 },
		damageType = "normal",
		speed = 0.07,
		triggerFrame = 4,
		canEquip = { weapon = true },
		animation = "swing",
		attachment = "scythe",
		description = "TODO"
	}) 


