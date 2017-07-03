-- Goblinson Crusoe
-- Container Spellbook

require 'Scripts/gc_uistyles'
require 'Scripts/gc_uiinstancing'
require 'Scripts/gc_combatactionbutton'

ContainerSpellbook=class(function(self, position, owner, parent, buttonhandler, closehandler)
	local windowwidth=352
	local windowheight=544
	local viewwidth=320
	local viewheight=512
	self.buttonhandler=buttonhandler
	self.closehandler=closehandler
	
	local desc=
	{
		Name="Background",
		Type="UIElement",
		Position=IntVector2(position.x, position.y),
		Size=IntVector2(windowwidth, windowheight),
		
		
		--[[
		Name="Background",
		Type="BorderImage",
		Texture="Textures/buttons.png",
		ImageRect=IntRect(0,0,63,63),
		Border=IntRect(16,16,16,16),
		Position=IntVector2(position.x, position.y),
		Size=IntVector2(windowwidth, windowheight),
		--]]
		children=
		{
			{
				Name="HeaderBackground",
				Type="BorderImage",
				Texture="Textures/buttons.png",
				ImageRect=IntRect(960,0,1023,63),
				Border=IntRect(16,16,16,16),
				Position=IntVector2(0,0),
				Size=IntVector2(windowwidth,32),
				children=
				{
					{
						Name="Title",
						Type="Text",
						Style=uistyles.SpellbookTitleText,
						Text="Default Spellbook",
						HorizontalAlignment=HA_CENTER,
						VerticalAlignment=VA_CENTER
					},
					
					{
						Name="CloseButton",
						Type="Button",
						Style=spellbookstyles.SpellbookCloseButton,
						Position=IntVector2(windowwidth-32,0),
					},
				}
			},
			
			{
				Name="PanelBackground",
				Type="BorderImage",
				Texture="Textures/buttons.png",
				ImageRect=IntRect(960,0,1023,63),
				Border=IntRect(16,16,16,16),
				Position=IntVector2(0,32),
				Size=IntVector2(windowwidth,windowheight-32),
				children=
				{
					{
						Name="BookView",
						Type="ScrollView",
					
						Position=IntVector2(8,8),
						Size=IntVector2(windowwidth-16, windowheight-48),
						ContentElement=
						{
							Name="ButtonContainer",
							Type="UIElement",
							Position=IntVector2(0,0),
							Size=IntVector2(windowwidth-48, 0),
						},
						
						AutoVisible=true,
						Opacity=0,
						Color=Color(0,0,0),
						HorizontalScrollBar=
						{
							Type="ScrollBar",
							MinSize=IntVector2(32,32),
							BackButton=
							{
								Type="Button",
								Style=uistyles.LeftScrollButtonLarge
							},
							ForwardButton=
							{
								Type="Button",
								Style=uistyles.RightScrollButtonLarge
							},
							Slider=
							{
								Type="Slider",
								Texture="Textures/buttons.png",
								ImageRect=IntRect(0,0,1,1),
								Knob=
								{
									Type="BorderImage",
									Style=uistyles.LeftRightSliderKnobLarge
								},
							},
						},
				
						VerticalScrollBar=
						{
							Type="ScrollBar",
							MinSize=IntVector2(32,32),
							BackButton=
							{
								Type="Button",
								Style=uistyles.UpScrollButtonLarge
							},
							ForwardButton=
							{
								Type="Button",
								Style=uistyles.DownScrollButtonLarge
							},
							Slider=
							{
								Type="Slider",
								Texture="Textures/buttons.png",
								ImageRect=IntRect(0,0,1,1),
								Knob=
								{
									Type="BorderImage",
									Style=uistyles.UpDownSliderKnobLarge
								},
							},
						},
					},
				}
			}
		}
	}
	
	self.book=InstanceUI(desc,parent)
	self.owner=owner
	self.closebutton=self.book:GetChild("CloseButton", true)
	self.buttoncontainer=self.book:GetChild("ButtonContainer", true)
	self.title=self.book:GetChild("Title", true)
	self.view=self.book:GetChild("BookView", true)
	self.boxes={}
end)

function ContainerSpellbook:Destroy()
	self.owner=nil
	self.book:RemoveAllChildren()
	self.book:Remove()
	self.book=nil
	self.closebutton=nil
	self.buttoncontainer=nil
	self.title=nil
	self.view=nil
	self.boxes=nil
end

function ContainerSpellbook:Open(skills, title, sorted)
	if not self.book or not self.buttoncontainer or not self.owner then print("Container spellbook not correctly inited.\n") return end
	local myui=self.owner:GetScriptObject("CombatPlayerUI2")
	if not myui then return end
	
	--self.book.enabled=true
	self.book.visible=true
	
	self.title:SetText(title)
	
	local y=0
	
	local skill
	for _,skill in pairs(skills) do
		local desc=
		{
			Type="UIElement",
			Position=IntVector2(0,y),
			Size=IntVector2(320,64),
		}
		
		local box=InstanceUI(desc, self.buttoncontainer)
		
		local button=CombatActionButton2({x=0,y=0}, box, nil)
		button:SetSpell(skill)
		button:Show()
		
		local textdesc=
		{
			Name="Text",
			Type="Text",
			Style=spellbookstyles.SpellbookDescriptionText,
			Position=IntVector2(64,0),
			--Size=IntVector2(256,64),
			Width=256,
			--Text=skill.description,
			Text=GenerateSkillDescription(skill,self.owner),
			WordWrap=true,
		}
		
		local element=InstanceUI(textdesc, box)
		box:SetHeight(math.max(element:GetHeight(), 64))
		
		table.insert(self.boxes, {box=box, button=button})
		myui:SubscribeToEvent(button.element, "Released", self.buttonhandler) --"CombatPlayerUI2:HandleContainerSpellbookButton"
		y=y+box:GetHeight()
	end
	
	self.buttoncontainer:SetHeight(y)
	if sorted==true then
		self:ActivationSort()
	else
		self:ActivateAll()
	end
	myui:SubscribeToEvent(self.closebutton, "Released", self.closehandler) --"CombatPlayerUI2:HandleContainerSpellbookCloseButton"
end

function ContainerSpellbook:FindSpell(element)
	local box
	for _,box in pairs(self.boxes) do
		if box.button.element==element then return box.button.spell end
	end
	return nil
end

function ContainerSpellbook:Close()
	if not self.book or not self.buttoncontainer or not self.owner then print("Container spellbook not correctly inited.\n") return end
	
	self.book.visible=false
	--self.book.enabled=false
	
	local myui=self.owner:GetScriptObject("CombatPlayerUI2")
	if not myui then return end
	
	local box
	for _,box in pairs(self.boxes) do
		myui.instance:UnsubscribeFromEvents(box.button.element)
	end
	
	self.boxes={}
	self.buttoncontainer:RemoveAllChildren()
	self.buttoncontainer:SetHeight(0)
	myui.instance:UnsubscribeFromEvents(self.closebutton)
end

function ContainerSpellbook:CheckResources(spell,resources)
	if not spell.resources and not spell.spendresources then return true end
	if not resources then return false end
	
	if spell.spendresources and not resources:HasResources(spell.spendresources) then return false end
	if spell.resources and not resources:HasResources(spell.resources) then return false end
	return true
end


function ContainerSpellbook:ActivationSort()
	-- Sort the skills in the bar into empty, active and inactive, based on if they are castable and set
	local box
	local active={}
	local inactive={}
	local empty={}
	
	local mp=0
	local cqueue, resources
	if self.owner then
		cqueue=self.owner:GetScriptObject("CombatCommandQueue")
		resources=self.owner:GetScriptObject("ResourceInventory")
		
		if not cqueue or not resources then return end
	end
	
	for _,box in pairs(self.boxes) do
		local button=box.button
		if button.spell==nil then table.insert(empty, box)
		else
			if self:CheckResources(button.spell, resources) then
				button:CalculateSpellActivation(cqueue.movementpoints)
				if button.active then table.insert(active,box) else table.insert(inactive,box) end
			else
				button:Deactivate()
				table.insert(inactive,box)
			end
		end
	end
	
	local y=0
	
	for _,box in pairs(active) do
		box.box:SetPosition(0,y)
		y=y+box.box:GetHeight()
	end
	
	for _,box in pairs(inactive) do
		box.box:SetPosition(0,y)
		y=y+box.box:GetHeight()
	end
	
	self.buttoncontainer:SetHeight(y)
	self.view:SetContentElement(self.buttoncontainer)
end

function ContainerSpellbook:ActivateAll()
	local box
	for _,box in pairs(self.boxes) do
		box.button:Activate()
	end
end