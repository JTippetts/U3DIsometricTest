AnimationMap=ScriptObject()

function AnimationMap:Start()
	self:SubscribeToEvent(self.node, "PlayAnimation", "AnimationMap:HandlePlayAnimation")
	self.animations={}
	self.currentanimation=""
end

function AnimationMap:Finalize()
	if self.animations["start"] then
		local controller=self.node:GetComponent("AnimationController")
		if controller==nil then return end
		local animname=self.animations["start"]
		if animname then
			controller:StopLayer(0,0)
			controller:Play(animname,0,true,0)
		end
	end
end

function AnimationMap:HandlePlayAnimation(eventType, eventData)
	local controller=self.node:GetComponent("AnimationController")
	if controller==nil then return end
	
	local a=eventData["animation"]:GetString()
	if a==self.currentanimation then
		local speed=1
		if eventData["speed"] then speed=eventData["speed"]:GetFloat() end
		if speed==0 then speed=1 end
		controller:SetSpeed(self.animations[self.currentanimation], speed)
		return 
	end
	
	local animname=self.animations[a]
	if not animname then print("Animation not found: "..a.."\n") return end
	
	self.currentanimation=a
	
	local loop=eventData["loop"]:GetBool()
	controller:StopLayer(0,0.2)
	controller:Play(animname, 0, loop, 0.2)
	local speed=1
	if eventData["speed"] then speed=eventData["speed"]:GetFloat() end
	controller:SetSpeed(self.animations[animname],speed)
end