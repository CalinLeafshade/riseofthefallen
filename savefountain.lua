require('mapobject')

SaveFountain = Class("SaveFountain", MapObject)

function SaveFountain:initalize(x,y)
	MapObject.initialize(self,x,y)
	self.static = true
	self.solid = false
end

function SaveFountain:draw() end -- dont draw anything yet
	
function SaveFountain:interact()
	state:save(1)
end