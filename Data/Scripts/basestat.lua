require 'Scripts/Class'
require 'Scripts/linkedlist'

-- Stat class
-- Implement a buffable stat class, that maintains a list of bonuses/penalties to a stat, maintains a base/current value for the state

BaseStat=class(function(self,startingval, clamplow, clamphigh)
	self.baseval=startingval
	self.multbonuses=LinkedList()
	self.addbonuses=LinkedList()
	self.clamplow=clamplow
	self.clamphigh=clamphigh
end)

function BaseStat:SumBonuses(args)
	local p=args.list
	local val=0
	while p do
		val=val+p.value.value
		p=p.next
	end
	return val
end

function BaseStat:ModifyBase(val)
	self.baseval=self.baseval+val
end

function BaseStat:GetValue()
	local value=self.baseval
	local multiplier, adder=1+self:SumBonuses(self.multbonuses),self:SumBonuses(self.addbonuses)
	value=value*multiplier+adder
	if self.clamplow then
		if value<self.clamplow then value=self.clamplow end
	end
	
	if self.clamphigh then
		if value>self.clamphigh then value=self.clamphigh end
	end
	
	return value
end

function BaseStat:AddMultBonus(val)
	local t={value=val}
	self.multbonuses:push_front(t)
	return t
end

function BaseStat:RemoveMultBonus(which)
	self.multbonuses:remove(which)
end

function BaseStat:AddAddBonus(val)
	local t={value=val}
	self.addbonuses:push_front(t)
end

function BaseStat:RemoveAddBonus(which)
	self.addbonuses:remove(which)
end
