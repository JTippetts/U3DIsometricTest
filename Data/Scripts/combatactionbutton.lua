-- Goblinson Crusoe
-- Combat Action Button

require 'Scripts/Class'
require 'Scripts/gc_uieases'
require 'Scripts/gc_objectinstancing'
require 'Scripts/gc_uiinstancing'

--------------------------------------------

CombatActionButton2=class(function(self, position, parent, hotkey)
	self.active=false
	self.shown=false
	self.spell=nil
	self.hotkey=hotkey
	
	local desc=
	{
		Name="Button",
		Type="Button",
		Style=uistyles.CombatActionButton,
		Position=IntVector2(position.x, position.y),
		ImageRect=IntRect(0,0, 64, 64),
	}
	
	if not parent then parent=ui.root end
	self.element=InstanceUI(desc, parent)
	if not self.element then return end
	
	if self.hotkey then
		local hkdesc=
		{
			Type="Text",
			Style=uistyles.HotKeyText,
			Position=IntVector2(44,38),
			Text=tostring(self.hotkey)
		}
		local e=InstanceUI(hkdesc,self.element)
		e.visible=true
		e.enabled=true
	end
	
	self:Hide()
	self:Deactivate()
end)

function CombatActionButton2:SetPosition(posx, posy)
	if self.element then self.element:SetPosition(posx,posy) end
end

function CombatActionButton2:Show()
	if not self.element then return end
	if self.element then self.element.visible=true end
	self.shown=true
end

function CombatActionButton2:Hide()
	if not self.element then return end
	if self.element then self.element.visible=false end
	self.shown=false
end

function CombatActionButton2:Activate()
	if not self.element then return end
	if not self.spell then return end
	
	local startoffset=self.spell.startoffset
	
	
	self.element:SetImageRect(IntRect(startoffset.x+64, startoffset.y, startoffset.x+128, startoffset.y+64))
	self.element.enabled=true
	self.active=true
end

function CombatActionButton2:Deactivate()
	if not self.element then return end
	if not self.spell then return end
	
	local startoffset=self.spell.startoffset
	
	self.element:SetImageRect(IntRect(startoffset.x, startoffset.y, startoffset.x+64, startoffset.y+64))
	self.element.enabled=false
	self.active=false
end

function CombatActionButton2:CalculateSpellActivation(movementpoints)
	if self.active then
		if self.spell==nil or self.spell.movementcost>movementpoints then self:Deactivate() return end
	else
		if self.spell and self.spell.movementcost<=movementpoints then self:Activate() return end
	end
end

function CombatActionButton2:SetSpell(spell, movementpoints)
	if not self.element then return end
	self.spell=spell
	if self.spell then
		--print("Setting spell\n")
		if movementpoints then
			self:CalculateSpellActivation(movementpoints)
		else
			self:Deactivate()
		end
	else
		--print("Spell nil\n")
		self.element:SetImageRect(IntRect(0,0,64,64))
		self.element.enabled=false
	end
end

function CombatActionButton2:Destroy()
	if self.element then self.element:Remove() end
	self.element=nil
end
