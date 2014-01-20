
Config = {
	scale = 4,
	fullscreen = false,
	vsync = true
}

function Config:load()
	-- TODO load config from disk
end

function Config:initialize( ... )
	-- TODO handle different aspect ratios
	love.window.setMode(320 * self.scale, 180 * self.scale, {vsync = self.vsync, fullscreen = self.fullscreen})
end