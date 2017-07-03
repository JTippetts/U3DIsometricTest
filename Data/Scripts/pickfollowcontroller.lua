--

-- PointClickFollow Controller

-- Introduction to Urho3D

-- Point and Click Controller
-- Basic D2-ish point and click controller

PickFollowController=ScriptObject()

function PickFollowController:Start()
	self:SubscribeToEvent("Update", "PickFollowController:HandleUpdate")
	self:SubscribeToEvent("MouseButtonDown", "PickFollowController:HandleMouseButtonDown")
	self:SubscribeToEvent("MouseButtonUp", "PickFollowController:HandleMouseButtonUp")
	self:SubscribeToEvent(self.node, "AnimationTrigger", "PickFollowController:HandleAnimationTrigger")
	
	self.path=nil
	self.nextpoint, self.nextpointindex=nil,1
	self.speed=2
	self.vm=VariantMap()
	
	self.targetid=nil
	self.lmbdown=false
end

function PickFollowController:TakeStep(dt)
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

function PickFollowController:SetPath(path)
	self.path=path
	self.nextpoint=nil
	self.nextpointindex=1
end

function PickFollowController:HandleMouseButtonDown(eventType, eventData)
	local button=eventData:GetInt("Button")
	if button==MOUSEB_LEFT then
		local pick=Pick(self.node:GetScene(), 100)
		if pick and pick:GetVars():GetBool("hostile")==true then
			self.targetid=pick:GetID()
		end
	end
end

function PickFollowController:HandleMouseButtonUp(eventType, eventData)
	local button=eventData:GetInt("Button")
	if button==MOUSEB_LEFT then
		self.targetid=nil
	end
end

function PickFollowController:HandleUpdate(eventType, eventData)
	local dt=eventData:GetFloat("TimeStep")
	
	if input:GetMouseButtonDown(MOUSEB_LEFT) then
		if self.targetid then
			local target=self.node:GetScene():GetNode(self.targetid)
			if target then
				local path=self.node:GetScene():GetComponent("NavigationMesh"):FindPath(self.node:GetWorldPosition(), target:GetWorldPosition())
				self:SetPath(path)
			else
				self.node:SendEvent("RequestMouseGround", self.vm)
				local ground=self.vm:GetVector3("ground")
				local path=self.node:GetScene():GetComponent("NavigationMesh"):FindPath(self.node:GetPosition(), ground)
				self:SetPath(path)
			end
		else
			self.targetid=nil
			self.node:SendEvent("RequestMouseGround", self.vm)
			local ground=self.vm:GetVector3("ground")
			local path=self.node:GetScene():GetComponent("NavigationMesh"):FindPath(self.node:GetPosition(), ground)
			self:SetPath(path)
		end
	end
	
	if input:GetMouseButtonDown(MOUSEB_RIGHT) and self.path then self.speed=4 self.vm:SetFloat("speed", 2) else self.speed=2 self.vm:SetFloat("speed",1) end
	
	if self:TakeStep(dt) then
		self.vm:SetString("animation", "walk")
	else
		self.vm:SetString("animation", "idle")
	end
	self.vm:SetBool("loop", true)
	self.node:SendEvent("PlayAnimation", self.vm)
end

function PickFollowController:HandleAnimationTrigger(eventType, eventData)
	print("Hit\n")
end