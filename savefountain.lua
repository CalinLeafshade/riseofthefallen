require('mapobject')

SaveFountain = Class("SaveFountain", MapObject)

function SaveFountain:initialize(x,y)
	MapObject.initialize(self,x,y)
	self.static = true
	self.solid = false
end

function SaveFountain:draw() end -- dont draw anything yet
	
function SaveFountain:interact()
	stateManager:push(SavingState)
end