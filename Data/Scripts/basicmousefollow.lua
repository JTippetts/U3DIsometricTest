-- Introduction to Urho3D

-- Basic Mouse Follow Controller

BasicMouseFollow=ScriptObject()

function BasicMouseFollow:Start()
	self:SubscribeToEvent("Update", "BasicMouseFollow:HandleUpdate")
	
	self.speed=2
	self.vm=VariantMap()
	
	
end

function BasicMouseFollow:HandleUpdate(eventType, eventData)
	local dt=eventData:GetFloat("TimeStep")
	
	if input:GetMouseButtonDown(MOUSEB_LEFT) then
		self.node:SendEvent("RequestMouseGround", self.vm)
		
		local ground=self.vm:GetVector3("ground")
		local x,y,z=self.node:GetWorldPositionXYZ()
		
		--------------------------------------------------
		-- Functionality to follow mouse straight
		
		--local dx=ground.x-x
		--local dz=ground.z-z
		--local len=math.sqrt(dx*dx+dz*dz)
		--dx=(dx/len)*self.speed*dt
		--dz=(dz/len)*self.speed*dt
		
		-------------------------------------------------
		-- Functionality to follow path
		
		local path=self.node:GetScene():GetComponent("NavigationMesh"):FindPath(self.node:GetPosition(), ground)
		
		if path:Size()<=1 then print("No path\n") return end
		
		local step=path[1]
		
		local dx=step.x-x
		local dz=step.z-z
		local len=math.sqrt(dx*dx+dz*dz)
		dx=(dx/len)*self.speed*dt
		dz=(dz/len)*self.speed*dt
		
		
		-- Implement hacky run
		if input:GetMouseButtonDown(MOUSEB_RIGHT) then dx=dx*4 dz=dz*4 end
		
		self.node:SetWorldPositionXYZ(x+dx,y,z+dz)
	end
end