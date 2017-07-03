-- Introduction to Urho3D

-- Isometric camera

IsometricCamera=ScriptObject()

function IsometricCamera:Start()
	self.cellsize=96
	self.camangle=30
	self.rotangle=45
	self.follow=10
	
	self.lookatnode=self.node:GetScene():CreateChild("LookAtNode", LOCAL)
	self.shakenode=self.lookatnode:CreateChild("ShakeNode", LOCAL)
	self.cameranode=self.shakenode:CreateChild("CameraNode", LOCAL)
	self.camera=self.cameranode:CreateComponent("Camera")
	self.camera:SetOrthographic(true)
	
	local w,h=graphics.width, graphics.height
	self.camera:SetOrthoSize(Vector2(w/(self.cellsize*math.sqrt(2)), h/(self.cellsize*math.sqrt(2))))
	self.viewport=Viewport:new(context, self.node:GetScene(), self.camera)
    renderer:SetViewport(0, self.viewport)
	
	local sin30,cos30=math.sin(self.camangle*math.pi/180), math.cos(self.camangle*math.pi/180)
	self.lookatnode:SetRotation(Quaternion(self.rotangle, Vector3(0,1,0)))
	--self.cameranode:SetPositionXYZ(0, sin30*self.follow, -cos30*self.follow)
	self.cameranode.position=Vector3(0, sin30*self.follow, -cos30*self.follow)
	self.cameranode:LookAt(Vector3(0,0.25,0), Vector3(0,1,0))
	--self.lookatnode:SetPositionXYZ(0,0.25,0)
	self.lookatnode.position=Vector3(64,0.25,64)
	
	self:SubscribeToEvent("Update", "IsometricCamera:HandleUpdate")
	self:SubscribeToEvent("ShakeCamera", "IsometricCamera:HandleShakeCamera")
	self:SubscribeToEvent("RequestMouseGround", "IsometricCamera:HandleRequestMouseGround")
	self:SubscribeToEvent("RequestMouseRay", "IsometricCamera:HandleRequestMouseRay")
	
	self.shakemagnitude=0
	self.shakespeed=0
	self.shaketime=0
	self.shakedamping=0
	
	self.camera:SetFarClip(60)
end

function IsometricCamera:Stop()
	
end

function IsometricCamera:GetMouseRay()
	local mousepos
	if input.mouseVisible then
		mousepos=input:GetMousePosition()
	else
		mousepos=ui:GetCursorPosition()
	end
	
	return self.camera:GetScreenRay(mousepos.x/graphics.width, mousepos.y/graphics.height)
end

function IsometricCamera:GetMouseGround()
	local ray=self:GetMouseRay()
	
	local x,y,z=self.node.position.x, self.node.position.y, self.node.position.z
	local hitdist=ray:HitDistance(Plane(Vector3(0,1,0), Vector3(0,0,0)))
	local dx=(ray.origin.x+ray.direction.x*hitdist)
	local dz=(ray.origin.z+ray.direction.z*hitdist)
	--print(dx,dz)
	return dx,dz
end

function IsometricCamera:TransformChanged()
	--self.lookatnode:SetWorldPosition(self.node:GetWorldPosition()+Vector3(0,0.25,0))
	self.lookatnode.position=Vector3(self.node.position + Vector3(0,0.25,0))
	print(self.lookatnode.position.x, self.lookatnode.position.z)
end

function IsometricCamera:HandleUpdate(eventType, eventData)
	local dt=eventData["TimeStep"]:GetFloat()
	self.shaketime=self.shaketime+dt*self.shakespeed
	local s=math.sin(self.shaketime)*self.shakemagnitude
	
	local shakepos=Vector3(math.sin(self.shaketime*3)*s, math.cos(self.shaketime)*s,0)
	self.shakemagnitude=self.shakemagnitude-self.shakedamping*dt
	if self.shakemagnitude<0 then self.shakemagnitude=0 end
	self.shakenode:SetPosition(shakepos)
	
	local wheel=input:GetMouseMoveWheel()
		--print(wheel)
	
	self.follow=self.follow-wheel*dt*20
	if self.follow<0.25 then self.follow=0.25 end
	if self.follow>15 then self.follow=15 end
	
	if input:GetMouseButtonDown(MOUSEB_RIGHT) then
		ui.cursor.visible=false
		
		local mmovey=input:GetMouseMoveY()/graphics:GetHeight()
		self.camangle=self.camangle+mmovey*600

		if self.camangle<1 then self.camangle=1 end
		if self.camangle>89 then self.camangle=89 end
		
		local mmovex=input:GetMouseMoveX()/graphics:GetWidth()
		self.rotangle=self.rotangle+mmovex*800
		while self.rotangle<0 do self.rotangle=self.rotangle+360 end
		while self.rotangle>=360 do self.rotangle=self.rotangle-360 end
		
	else
		ui.cursor.visible=true
	end
	
	self.lookatnode.position=Vector3(self.node.position + Vector3(0,0.25,0))
	local sinangle,cosangle=math.sin(self.camangle*math.pi/180), math.cos(self.camangle*math.pi/180)
	self.lookatnode:SetRotation(Quaternion(self.rotangle, Vector3(0,1,0)))
	--self.cameranode:SetPositionXYZ(0, sinangle*self.follow, -cosangle*self.follow)
	self.cameranode.position=Vector3(0, sinangle*self.follow, -cosangle*self.follow)
	self.cameranode:LookAt(self.lookatnode.position, Vector3(0,1,0))
end

function IsometricCamera:HandleShakeCamera(eventType, eventData)
	self.shakemagnitude=eventData["magnitude"]:GetFloat();
    self.shakespeed=eventData["speed"]:GetFloat();
    self.shakedamping=eventData["damping"]:GetFloat();
end

function IsometricCamera:HandleRequestMouseGround(eventType, eventData)
	local dx,dz=self:GetMouseGround()
	
	eventData["ground"]=Vector3(dx,0,dz)
end

function IsometricCamera:HandleRequestMouseRay(eventType, eventData)
	local ray=self:GetMouseRay()
	eventData["origin"]=ray.origin
	eventData["direction"]=ray.direction
end