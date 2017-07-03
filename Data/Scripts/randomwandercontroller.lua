-- Introduction to Urho3D

-- Random Wander Controller
require 'Scripts/picking'

RandomWanderController=ScriptObject()

function RandomWanderController:Start()
	self:SubscribeToEvent("Update", "RandomWanderController:HandleUpdate")
	self:SubscribeToEvent(self.node, "AnimationTrigger", "RandomWanderController:HandleAnimationTrigger")
	self:SubscribeToEvent(self.node, "Pick", "RandomWanderController:HandlePick")
	
	self.path=nil
	self.nextpoint, self.nextpointindex=nil,2
	self.speed=2
	self.vm=VariantMap()
	
	local vars=self.node:GetVars()
	vars["hostile"]=true
end

function RandomWanderController:TakeStep(dt)
	local pos=self.node.position
	local x,y,z=pos.x,pos.y,pos.z
	
	if self.path==nil then return false end
	
	if self.nextpointindex>table.maxn(self.path)+1 then self.path=nil self.nextpoint=nil self.nextpointindex=1 return false end
	if self.nextpoint==nil then self.nextpoint=self.path[self.nextpointindex] self.nextpointindex=self.nextpointindex+1 end
	if self.nextpoint==nil then return false end
	
	local dx=self.nextpoint.x-x
	local dz=self.nextpoint.z-z
	local len=math.sqrt(dx*dx+dz*dz)
	dx=dx/len
	dz=dz/len
	
	if len>0 then
		local angle=math.atan2(dz,dx)*180/math.pi
	
		--self.node:SetRotation(Quaternion(angle+90, Vector3(0,-1,0)))
		self.vm["angle"]=angle+90
		self.node:SendEvent("SetRotationAngle", self.vm)
	end
	
	if len<self.speed*dt then
		-- Consider the target point "reached" and get a new target point
		--self.node:SetWorldPositionXYZ(self.nextpoint.x,y,self.nextpoint.z)
		self.node.position=Vector3(self.nextpoint.x, y, self.nextpoint.z)
		
		if self.nextpointindex>table.maxn(self.path) then self.path=nil self.nextpoint=nil self.nextpointindex=1 return end
		self.nextpoint=self.path[self.nextpointindex]
		self.nextpointindex=self.nextpointindex+1
		return true
	else
		--self.node:SetWorldPositionXYZ(x+dx*self.speed*dt, y, z+dz*self.speed*dt)
		self.node.position=Vector3(x+dx*self.speed*dt, y, z+dz*self.speed*dt)
	end
	
	return true
end

function RandomWanderController:SetPath(path)
	function copypath()
		local p={}
		local c
		for c=1,#path,1 do
			table.insert(p, {x=path[c].x, y=path[c].y, z=path[c].z})
		end
		return p
	end
	self.path=copypath()
	self.nextpoint=nil
	self.nextpointindex=2
end

function RandomWanderController:HandleUpdate(eventType, eventData)
	local dt=eventData["TimeStep"]:GetFloat()
	
	if self.path==nil then
		--local x,y,z=self.node:GetWorldPositionXYZ()
		local x,y,z=self.node.position.x, self.node.position.y, self.node.position.z
		local ex,ey,ez=x+(math.random()*20)-10, y, z+(math.random()*20)-10
		local path=self.node:GetScene():GetComponent("NavigationMesh"):FindPath(self.node.position, Vector3(ex,ey,ez))
		self:SetPath(path)
	end
	
	if self:TakeStep(dt) then
		self.vm["animation"]="walk"
	else
		self.vm["animation"]="idle"
	end
	self.vm["loop"]=true
	self.node:SendEvent("PlayAnimation", self.vm)
	
end

function RandomWanderController:HandlePick(eventType, eventData)
	--print("Picked\n")
end

function RandomWanderController:HandleAnimationTrigger(eventType, eventData)
	print("Hit\n")
end
