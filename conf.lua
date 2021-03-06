--conf.lua

DEBUG = true

function love.conf(t)
    t.title = "Rise of the Fallen"        -- The title of the window the game is in (string)
    t.author = "Undergrowth Games"        -- The author of the game (string)
    t.url = "http://leafsha.de"                 -- The website of the game (string)
    t.identity = "fallen"            -- The name of the save directory (string)
    t.version = "0.9.0"         -- The LÖVE version this game was made for (string)
	t.release = not DEBUG
    t.console = not t.release           -- Attach a console (boolean, Windows only)
    t.window.width = 1280        -- The window width (number)
    t.window.height = 720      -- The window height (number)
    t.window.fullscreen = false -- Enable fullscreen (boolean)
    t.window.vsync = false     -- Enable vertical sync (boolean)
    t.window.fsaa = 0           -- The number of FSAA-buffers (number)
    t.modules.joystick = true   -- Enable the joystick module (boolean)
    t.modules.audio = true      -- Enable the audio module (boolean)
    t.modules.keyboard = true   -- Enable the keyboard module (boolean)
    t.modules.event = true      -- Enable the event module (boolean)
    t.modules.image = true      -- Enable the image module (boolean)
    t.modules.graphics = true   -- Enable the graphics module (boolean)
    t.modules.timer = true      -- Enable the timer module (boolean)
    t.modules.mouse = true      -- Enable the mouse module (boolean)
    t.modules.sound = true      -- Enable the sound module (boolean)
    t.modules.physics = false    -- Enable the physics module (boolean)
end