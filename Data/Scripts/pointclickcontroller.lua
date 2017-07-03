-- Introduction to Urho3D

-- Point and Click Controller
-- Basic D2-ish point and click controller

PointClickController=ScriptObject()

function PointClickController:Start()
	self:SubscribeToEvent("Update", "PointClickController:HandleUpdate")
	self:SubscribeToEvent(self.node, "AnimationTrigger", "PointClickController:HandleAnimationTrigger")
	
	self.path=nil
	self.nextpoint, self.nextpointindex=nil,1
	self.speed=2
	self.vm=VariantMap()
end

function PointClickController:TakeStep(dt)
	local x,y,z=self.node:GetWorldPositionXYZ()
	
	if self.path==nil then return false end
	
	if self.nextpointindex>self.path:Size() then self.path=nil self.nextpoint=nil self.nextpointindex=1 return false end
	if self.nextpoint==nil then self.nextpoint=self.path[self.nextpointindex] self.nextpointindex=self.nextpointindex+1 end
	if self.nextpoint==nil then return false end
	
	local dx=self.nextpoint.x-x
	local dz=self.nextpoint.z-z
	local len=math.sqrt(dx*dx+dz*dz)
	dx=dx/len
	dz=dz/len
	
	local angle=math.atan2(dz,dx)*180/math.pi
	
	--self.node:SetRotation(Quaternion(angle+90, Vector3(0,-1,0)))
	self.vm:SetFloat("angle", angle+90)
	self.node:SendEvent("SetRotationAngle", self.vm)
	
	if len<self.speed*dt then
		-- Consider the target point "reached" and get a new target point
		self.node:SetWorldPositionXYZ(self.nextpoint.x,y,self.nextpoint.z)
		
		if self.nextpointindex>self.path:Size() then self.path=nil self.nextpoint=nil self.nextpointindex=1 return end
		self.nextpoint=self.path[self.nextpointindex]
		self.nextpointindex=self.nextpointindex+1
		return true
	else
		self.node:SetWorldPositionXYZ(x+dx*self.speed*dt, y, z+dz*self.speed*dt)
	end
	
	return true
	
end

function PointClickController:SetPath(path)
	self.path=path
	self.nextpoint=nil
	self.nextpointindex=1
end

function PointClickController:HandleUpdate(eventType, eventData)
	local dt=eventData:GetFloat("TimeStep")
	
	if input:GetMouseButtonDown(MOUSEB_LEFT) then
		self.node:SendEvent("RequestMouseGround", self.vm)
		local ground=self.vm:GetVector3("ground")
		local path=self.node:GetScene():GetComponent("NavigationMesh"):FindPath(self.node:GetPosition(), ground)
		self:SetPath(path)
	end
	
	if input:GetMouseButtonDown(MOUSEB_RIGHT) then self.speed=4 self.vm:SetFloat("speed", 2) else self.speed=2 self.vm:SetFloat("speed",1) end
	
	if self:TakeStep(dt) then
		self.vm:SetString("animation", "walk")
	else
		self.vm:SetString("animation", "idle")
	end
	self.vm:SetBool("loop", true)
	self.node:SendEvent("PlayAnimation", self.vm)
end

function PointClickController:HandleAnimationTrigger(eventType, eventData)
	print("Hit\n")
end