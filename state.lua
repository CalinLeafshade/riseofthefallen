
State = Class("State")

function State:initialize(name)
	self.name = name
	self.opaque = true
end

local NULLFUNC = function() end

State.focus = NULLFUNC
State.blur = NULLFUNC
State.update = NULLFUNC
State.draw = NULLFUNC