-- Player Controller
--

-- PointClickFollow Controller

-- Introduction to Urho3D

-- Point and Click Controller
-- Basic D2-ish point and click controller

--

-- PointClickFollow Controller

-- Introduction to Urho3D

-- Point and Click Controller
-- Basic D2-ish point and click controller

PlayerController=ScriptObject()

function PlayerController:Start()
	self:SubscribeToEvent("Update", "PlayerController:HandleUpdate")
	self:SubscribeToEvent("MouseButtonDown", "PlayerController:HandleMouseButtonDown")
	self:SubscribeToEvent("MouseButtonUp", "PlayerController:HandleMouseButtonUp")
	self:SubscribeToEvent(self.node, "AnimationTrigger", "PlayerController:HandleAnimationTrigger")
	
	self.path=nil
	self.nextpoint, self.nextpointindex=nil,1
	self.speed=2
	self.vm=VariantMap()
	
	self.targetid=nil
	self.lmbdown=false
	
	self.state="idle"
end

function PlayerController:TakeStep(dt)
	local x,y,z=self.node.position.x, self.node.position.y, self.node.position.z
	
	if self.path==nil then return false end
	
	if self.nextpointindex>table.maxn(self.path)+1 then self.path=nil self.nextpoint=nil self.nextpointindex=1 print("path ended") return false end
	if self.nextpoint==nil then self.nextpoint=self.path[self.nextpointindex] self.nextpointindex=self.nextpointindex+1 end
	if self.nextpoint==nil then return false end
	
	--print("path pos: "..self.nextpoint.x..","..self.nextpoint.y..","..self.nextpoint.z)
	
	local dx=self.nextpoint.x-x
	local dz=self.nextpoint.z-z
	--print("d:"..dx..","..dz)
	local len=math.sqrt(dx*dx+dz*dz)
	dx=dx/len
	dz=dz/len
	
	if len>0 then
		local angle=math.atan2(dz,dx)*180/math.pi
	
		--self.node:SetRotation(Quaternion(angle+90, Vector3(0,-1,0)))
		self.vm["angle"]=angle+90
		--print(dx,dz,angle)
		self.node:SendEvent("SetRotationAngle", self.vm)
	end
	
	if len<self.speed*dt then
		-- Consider the target point "reached" and get a new target point
		--self.node:SetWorldPositionXYZ(self.nextpoint.x,y,self.nextpoint.z)
		self.node.position=Vector3(self.nextpoint.x, y, self.nextpoint.z)
		
		if self.nextpointindex>table.maxn(self.path) then self.path=nil self.nextpoint=nil self.nextpointindex=2 return end
		self.nextpoint=self.path[self.nextpointindex]
		self.nextpointindex=self.nextpointindex+1
		--print("mypos: "..self.node.position.x..","..self.node.position.z)
		return true
	else
		--self.node:SetWorldPositionXYZ(x+dx*self.speed*dt, y, z+dz*self.speed*dt)
		self.node.position=Vector3(x+dx*self.speed*dt, y, z+dz*self.speed*dt)
	end
	--print("mypos: "..self.node.position.x..","..self.node.position.z)
	
	return true
	
end

function PlayerController:SetPath(path)
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

function PlayerController:HandleMouseButtonDown(eventType, eventData)
	local button=eventData["Button"]:GetInt()
	if button==MOUSEB_LEFT then
		local pick=Pick(self.node:GetScene(), 100)
		if pick and pick:GetVars()["hostile"] and pick:GetVars()["hostile"]:GetBool()==true then
			self.targetid=pick:GetID()
		end
	end
end

function PlayerController:HandleMouseButtonUp(eventType, eventData)
	local button=eventData["Button"]:GetInt()
	if button==MOUSEB_LEFT then
		self.targetid=nil
	end
end

function PlayerController:HandleUpdate(eventType, eventData)
	local dt=eventData["TimeStep"]:GetFloat()
	
	if input:GetMouseButtonDown(MOUSEB_LEFT) then
		if self.targetid then
			local target=self.node:GetScene():GetNode(self.targetid)
			if target then
				local path=self.node:GetScene():GetComponent("NavigationMesh"):FindPath(self.node:GetWorldPosition(), target:GetWorldPosition())
				self:SetPath(path)
			else
				self.targetid=nil
				self.node:SendEvent("RequestMouseGround", self.vm)
				local ground=self.vm["location"]:GetVector2()
				local gv3=Vector3(ground.x, 0, ground.y)
				local path=self.node:GetScene():GetComponent("NavigationMesh"):FindPath(self.node:GetPosition(), gv3)
				self:SetPath(path)
			end
		else
			self.targetid=nil
			self.node:SendEvent("RequestMouseGround", self.vm)
			local ground=self.vm["location"]:GetVector2()
			local gv3=Vector3(ground.x, 0, ground.y)
			--print("ground: "..ground.x..","..ground.y)
			local path=self.node:GetScene():GetComponent("NavigationMesh"):FindPath(self.node:GetPosition(), gv3)
			--print("pathlen: "..#path)
			self:SetPath(path)
		end
	else
		self.targetid=nil
	end
	
	--print("myloc: "..self.node.position.x..","..self.node.position.z)
	
	if input:GetMouseButtonDown(MOUSEB_RIGHT) and self.path then self.speed=4 self.vm["speed"]=2 else self.speed=2 self.vm["speed"]=1 end
	
	if self:TakeStep(dt) then
		self.vm["animation"]="walk"
	else
		self.vm["animation"]="idle"
	end
	self.vm["loop"]=true
	self.node:SendEvent("PlayAnimation", self.vm)
end

function PlayerController:HandleAnimationTrigger(eventType, eventData)
	print("Hit\n")
end

function PlayerController:CastSpell(spell, targetcoords, targetid)
	
end