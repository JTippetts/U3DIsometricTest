-- Goblinson Crusoe
-- Combat Stats

require 'Scripts/gc_basestat'

CombatStats=ScriptObject()

function CombatStats:Start()
	--self.baselife=BaseStat(0)
	
	self.combatstats=
	{
		--baselife=BaseStat(0),
		
		--fire_att=BaseStat(0),
		--fire_def=BaseStat(0),
		stats=
		{
			baselife=BaseStat(0),
		},
		values=
		{
			life=0,
		}
	}
	
	--self.values=
	--{
		--life=0,
	--}
	
	self.vm=VariantMap()
	
	self:SubscribeToEvent(self.node, "TakeDamage", "CombatStats:HandleTakeDamage")
	self:SubscribeToEvent(self.node, "TakeHealing", "CombatStats:HandleTakeHealing")
	self:SubscribeToEvent(self.node, "RequestLife", "CombatStats:HandleRequestLife")
	self:SubscribeToEvent(self.node, "ModifyDamageToSend", "CombatStats:HandleModifyDamage")
	self:SubscribeToEvent(self.node, "IsDestroyable", "CombatStats:HandleIsDestroyable")
	
	self.node:GetVars():SetBool("destroyable", true)
end

--[[
function CombatStats:SetParameter(name, value)
	if name=="baselife" then self.baselife=BaseStat(value.base, value.clamplow, value.clamphigh)
	elseif name=="life" then self.values.life=value
	else
		self.stats[name]=BaseStat(value.base, value.clamplow, value.clamphigh)
	end
end
]]

function CombatStats:SetParameter(name, value)
	if name=="combatstats" then
		self.combatstats={}
		self.combatstats.stats={}
		self.combatstats.values={}
		if value.stats then
			local n,s
			for n,s in pairs(value.stats) do
				self.combatstats.stats[n]=BaseStat(s)
			end
		end
		
		if self.combatstats.stats.baselife then self.combatstats.values.life=self.combatstats.stats.baselife:GetValue() end
		
		if value.values then
			local n,v
			for n,v in pairs(value.values) do
				self.combatstats.values[n]=v
			end
		end
	end
end

function CombatStats:Finalize()
	self.combatstats.values.life=self.combatstats.stats.baselife:GetValue()
end

function CombatStats:HandleIsDestroyable(eventType, eventData)
	eventData:SetBool("destroyable", true)
	eventData:SetString("types", "")
end

function CombatStats:HandleRequestLife(eventType, eventData)
	eventData:SetUInt("life", self.combatstats.values.life)
	eventData:SetUInt("maxlife", self.combatstats.stats.baselife:GetValue())
end

function CombatStats:HandleTakeHealing(eventType, eventData)
	local amt=eventData:GetFloat("healing")
	print("Healing for: "..amt.."\n")
	self.combatstats.values.life=self.combatstats.values.life+amt
	if self.combatstats.values.life > self.combatstats.stats.baselife:GetValue() then self.combatstats.values.life=self.combatstats.stats.baselife:GetValue() end
	self.vm:SetUInt("total", amt)
	self.vm:SetUInt("life", self.combatstats.values.life)
	self.vm:SetUInt("maxlife", self.combatstats.stats.baselife:GetValue())
	self.node:SendEvent("HealingTaken", self.vm)
end

function CombatStats:AddStatMultModifier(stat,mult)
	if self.combatstats.stats[stat] then
		return self.combatstats.stats[stat]:AddMultBonus(mult)
	end
end

function CombatStats:AddStatAddModifier(stat,add)
	if self.combatstats.stats[stat] then
		return self.combatstats.stats[stat]:AddAddBonus(add)
	end
end

function CombatStats:RemoveStatMultModifier(stat, mod)
	if self.combatstats.stats[stat] then
		self.combatstats.stats[stat]:RemoveMultBonus(mod)
	end
end

function CombatStats:RemoveStatAddModifier(stat, mod)
	if self.combatstats.stats[stat] then
		self.combatstats.stats[stat]:RemoveAddBonus(mod)
	end
end

function CombatStats:GetStatValue(name)
	if self.combatstats.stats[name] then return self.combatstats.stats[name]:GetValue() end
end

function CombatStats:GetStat(name)
	return self.combatstats.stats[name]
end

function CombatStats:GetValue(name)
	return self.combatstats.values[name]
end

-- Arbiter and system stuff
function CombatStats:HandleTakeDamage(eventType, eventData)
	print("Take damage\n")
	local attacker=eventData:GetPtr("Node", "attacker")
	local attack=eventData:GetString("attack")
	local typestring=eventData:GetString("types")
	local types=string.split(typestring, ';')
	
	self.vm:SetPtr("attacker", attacker)
	self.vm:SetString("types", typestring)
	self.vm:SetString("attack", eventData:GetString("attack"))
	
	local type
	local total=0
	for _,type in pairs(types) do
		if type~="" then
			local amt=eventData:GetUInt(type)
			local absorbed,reflected,blocked,boosted
			-- TODO: Resistance/absorption/shield reduction
			amt,absorbed,reflected,blocked,boosted=self:AdjustDamageValue(type, amt)
			self.vm:SetUInt(type, amt)
			if absorbed>0 then self.vm:SetUInt(type.."_absorbed", absorbed) end
			if reflected>0 then self.vm:SetUInt(type.."_reflected", reflected) end
			if blocked>0 then self.vm:SetUInt(type.."_blocked", blocked) end
			if boosted>0 then self.vm:SetUInt(type.."_boosted", boosted) end
			
			total=total+amt
		end
	end
	
	self.combatstats.values.life=self.combatstats.values.life-total
	self.vm:SetUInt("total", total)
	self.vm:SetUInt("life", self.combatstats.values.life)
	self.vm:SetUInt("maxlife", self.combatstats.stats.baselife:GetValue())
	self.node:SendEvent("DamageTaken", self.vm)
	
	local cqueue=self.node:GetScriptObject("CombatCommandQueue")
	if self.combatstats.values.life<=0 then
		if cqueue and not cqueue.dying then
			if cqueue.ready then
				self.node:SendEvent("PrepareToDie", self.vm)
			else
				self.node:SendEvent("Die", self.vm)
			end
		end
		
	elseif self.combatstats.values.life<self.combatstats.stats.baselife:GetValue()*0.1 then
		self.node:SendEvent("LifeLow", emptyvm)
	end
	
end

function CombatStats:AdjustDamageValue(type, amt)
	-- TODO: Implement this
	-- REturn final amount, absorbed, reflected, blocked, boosted
	local absorb, reflect,block,boost=0,0,0,0
	
	if self.combatstats.stats[type.."_def"] then
		local val=self.combatstats.stats[type.."_def"]:GetValue()
		if val<0 then
			boost=math.abs(val)
			amt=amt+boost
		else 
			absorb=val
			amt=amt-absorb
			if amt<0 then amt=0 end
		end
	end
		
	return amt,absorb,reflect,block,boost
	--return amt,0,0,0,0
end

function CombatStats:HandleModifyDamage(eventType, eventData)
	-- Modify outgoing damage values based on stats.
	
	local typestring=eventData:GetString("types")
	local types=string.split(typestring, ';')
	
	local type
	for _,type in pairs(types) do
		if type~="" then
			if self.combatstats.stats[type.."_att"] then
				local amt=eventData:GetUInt(type)
				local val=self.combatstats.stats[type.."_att"]:GetValue()
				amt=amt+val
				if amt<0 then amt=0 end
				eventData:SetUInt(type,amt)
			end
		end
	end
	
end