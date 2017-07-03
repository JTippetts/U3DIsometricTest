-- Introduction to Urho3D

-- Rotation smooth

-- Attempt to smooth out sudden changes in rotation of a unit

RotationSmoothing=ScriptObject()

--[[
function RotationSmoothing:Start()
	self:SubscribeToEvent(self.node, "SetRotationAngle", "RotationSmoothing:HandleSetRotationAngle")
	self:SubscribeToEvent("Update", "RotationSmoothing:HandleUpdate")
	
	self.rotationvel=10
	self.currentquat=Quaternion(0,Vector3(0,-1,0))
	self.targetquat=Quaternion(0,Vector3(0,-1,0))

end

function RotationSmoothing:HandleSetRotationAngle(eventType, eventData)
	local angle=eventData:GetFloat("angle")
	self.targetquat=Quaternion(angle,Vector3(0,-1,0))
end

function RotationSmoothing:HandleUpdate(eventType, eventData)
	local dt=eventData:GetFloat("TimeStep")
	local step=dt*self.rotationvel
	self.currentquat=self.currentquat:Slerp(self.targetquat, step)
	self.node:SetRotation(self.currentquat)
end
]]



function RotationSmoothing:Start()
	self:SubscribeToEvent(self.node, "SetRotationAngle", "RotationSmoothing:HandleSetRotationAngle")
	self:SubscribeToEvent("Update", "RotationSmoothing:HandleUpdate")
	self:SubscribeToEvent("Report", "RotationSmoothing:HandleReport")
	
	self.rotationvel=720
	self.curangle=0
	self.nextangle=0
	self.lastuse=0
	self.lastusedelta=0
end

function RotationSmoothing:HandleReport(eventType, eventData)
	print("Smoothing angles: "..self.curangle..", "..self.nextangle.."\n")
	print("Last deltas: "..self.lastuse..", "..self.lastusedelta.."\n")
end

function RotationSmoothing:HandleSetRotationAngle(eventType, eventData)
	local angle=eventData["angle"]:GetFloat()
	while angle<0 do angle=angle+360 end
	while angle>=360 do angle=angle-360 end
	--print("Old next angle: "..self.nextangle.."  New next angle: "..angle.."  Current angle: "..self.curangle.."\n")
	self.nextangle=angle
end

function RotationSmoothing:HandleUpdate(eventType, eventData)
	local dt=eventData["TimeStep"]:GetFloat()
	local delta1=self.nextangle-self.curangle
	local delta2=(self.nextangle+360)-self.curangle
	local delta3=(self.nextangle-360)-self.curangle
	
	local m1,m2,m3=math.abs(delta1),math.abs(delta2),math.abs(delta3)
	local use=math.min(m1,m2,m3)
	local usedelta
	
	if use<0.001 then
		self.curangle=self.nextangle
		self.node:SetRotation(Quaternion(self.curangle,Vector3(0,-1,0)))
		return
	end
	
	if use==math.abs(delta1) then
		usedelta=delta1
	elseif use==math.abs(delta2) then
		usedelta=delta2
	else
		usedelta=delta3
	end
	self.lastuse=use
	self.lastusedelta=usedelta
	
	local sign=1
	if usedelta<0 then sign=-1 end
	
	local step=dt*self.rotationvel
	step=math.min(step,use)
	self.curangle=self.curangle+step*sign
	
	while self.curangle>=360 do self.curangle=self.curangle-360 end
	while self.curangle<0 do self.curangle=self.curangle+360 end 
	self.node:SetRotation(Quaternion(self.curangle,Vector3(0,-1,0)))
end