-- Goblinson Crusoe
-- Skill Bar

require 'Scripts/gc_skills'
require 'Scripts/Class'
require 'Scripts/gc_uistyles'
require 'Scripts/gc_combatactionbutton'

SkillBar=class(function(self, position, orientation, owner, parent)
	if parent==nil then parent=ui.root end
	
	self.buttons={}
	self.owner=owner
	
	self.orientation=orientation
	if orientation=="vertical" then
		self.element=InstanceUI({Type="UIElement", Position=IntVector2(position.x, position.y), MinWidth=64, MinHeight=64, MaxWidth=80}, parent)
	else
		self.element=InstanceUI({Type="UIElement", Position=IntVector2(position.x, position.y), MinWidth=64, MinHeight=64, MaxHeight=80}, parent)
	end
end)

function SkillBar:Destroy()
	local c
	for _,c in pairs(self.buttons) do
		if c.element then c.element:Remove() end
		c.element=nil
	end
	self.buttons=nil
end

function SkillBar:Clear()
	local c
	for _,c in pairs(self.buttons) do
		if c.element then c.element:Remove() end
	end
	self.buttons={}
end

function SkillBar:AddSkill(skill, hotkey)
	local x,y
	if self.orientation=="vertical" then
		x=0
		y=#self.buttons*64
	else
		x=#self.buttons*64
		y=0
	end
	
	local button=CombatActionButton2({x=x,y=y}, self.element, hotkey)
	button:SetSpell(skill)
	button:Show()
	table.insert(self.buttons, button)
	
	local w,h
	if self.orientation=="vertical" then
		w=80
		h=#self.buttons*64+16
	else
		w=#self.buttons*64+16
		h=80
	end
	
	return button
end

function SkillBar:CheckResources(spell,resources)
	if not spell.resources and not spell.spendresources then return true end
	if not resources then return false end
	
	if spell.spendresources and not resources:HasResources(spell.spendresources) then return false end
	if spell.resources and not resources:HasResources(spell.resources) then return false end
	return true
end

function SkillBar:DeactivateAll()
	local c
	for _,c in pairs(self.buttons) do
		c:Deactivate()
	end
end

function SkillBar:Activation()
	local c
	local mp=0
	local cqueue, resources
	if self.owner then
		cqueue=self.owner:GetScriptObject("CombatCommandQueue")
		resources=self.owner:GetScriptObject("ResourceInventory")
		mp=cqueue.movementpoints
	end
	
	for _,c in pairs(self.buttons) do
		if c.spell then
			if self:CheckResources(c.spell, resources) then
				c:CalculateSpellActivation(mp)
			else
				c:Deactivate()
			end
		end
	end
	
	local x,y=0,0
	local xinc,yinc
	if self.orientation=="vertical" then xinc=0 yinc=64 else xinc=64 yinc=0 end
	
	for _,c in pairs(self.buttons) do
		c:SetPosition(x,y)
		x=x+xinc
		y=y+yinc
	end
	self.element:SetSize(x,y)
end

function SkillBar:ActivateAll()
	local c
	for _,c in pairs(self.buttons) do
		c:Activate()
	end
end

function SkillBar:FindHotkeyedSkill(hotkey)
	if self.element==nil or self.element.visible==false or self.element.enabled==false then return nil end
	local c
	for _,c in pairs(self.buttons) do
		if c.hotkey and c.hotkey==hotkey then return c end
	end
	return nil
end

function SkillBar:ActivationSort()
	-- Sort the skills in the bar into empty, active and inactive, based on if they are castable and set
	local c
	local active={}
	local inactive={}
	local empty={}
	
	local mp=0
	local cqueue, resources
	if self.owner then
		cqueue=self.owner:GetScriptObject("CombatCommandQueue")
		resources=self.owner:GetScriptObject("ResourceInventory")
	end
	
	for _,c in pairs(self.buttons) do
		if c.spell==nil then table.insert(empty, c)
		else
			if self:CheckResources(c.spell, resources) then
				c:CalculateSpellActivation(cqueue.movementpoints)
				if c.active then table.insert(active,c) else table.insert(inactive,c) end
			else
				c:Deactivate()
				table.insert(inactive,c)
			end
		end
	end
	
	local x,y=0,0
	local xinc,yinc
	if self.orientation=="vertical" then xinc=0 yinc=64 else xinc=64 yinc=0 end
	
	for _,c in pairs(active) do
		c:SetPosition(x,y)
		x=x+xinc
		y=y+yinc
	end
	
	for _,c in pairs(inactive) do
		c:SetPosition(x,y)
		x=x+xinc
		y=y+yinc
	end
	
	self.element:SetSize(x,y)
	
	for _,c in pairs(empty) do
		c:SetPosition(x,y)
		c.visible=false
		x=x+xinc
		y=y+yinc
	end
end

function SkillBar:Show()
	self.element.visible=true
end

function SkillBar:Hide()
	self.element.visible=false
end

function SkillBar:FindSpell(element)
	-- Search the buttons and see if one of them is the element in question
	local button
	for _,button in pairs(self.buttons) do
		if element==button.element then return button.spell end
	end
end