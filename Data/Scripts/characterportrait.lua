-- Goblinson Crusoe
-- Character Portrait

require 'Scripts/Class'
require 'Scripts/gc_uistyles'

CharacterPortrait=class(function(self, pos, portraittex, portraitrect, parent)
	local desc=
	{
		Position=IntVector2(pos.x, pos.y),
		Type="UIElement",
		Name="CharacterPortraitBase",
		children=
		{
			-- Headshot background
			{
				Type="BorderImage",
				Position=IntVector2(0,0),
				Texture="Textures/buttons.png",
				ImageRect=IntRect(960,0,1023,63),
				Border=IntRect(16,16,16,16),
				Size=IntVector2(96,96),
				Name="PortraitBackground",
				
				children=
				{
					{
						Type="Sprite",
						Texture=portraittex,
						ImageRect=portraitrect,
						Size=IntVector2(96,96),
						Name="Headshot",
					},
				}
			},
			
			-- Name background
			{
				Type="BorderImage",
				Position=IntVector2(96,0),
				Texture="Textures/buttons.png",
				ImageRect=IntRect(960,0,1023,63),
				Border=IntRect(16,16,16,16),
				Size=IntVector2(192,48),
				Name="HealthBarBackground",
				
				children=
				{
					{
						Name="CharacterName",
						Type="Text",
						Style=uistyles.MovementPointsTextDisplay,
						Color=Color(0.125, 0.5, 1),
						Text="Default",
					}
				}
			},
			
			-- Movepoints background
			{
				Type="BorderImage",
				Position=IntVector2(96,48),
				Texture="Textures/buttons.png",
				ImageRect=IntRect(960,0,1023,63),
				Border=IntRect(16,16,16,16),
				Size=IntVector2(48,48),
				Name="PointsBackground",
				
				children=
				{
					{
						Name="MovementPointsDisplay",
						Type="Text",
						Style=uistyles.MovementPointsTextDisplay,
						Text="0",
					}
				}
			},
			
			-- Health bar
			{
				Type="BorderImage",
				Position=IntVector2(144,48),
				Size=IntVector2(144,48),
				Texture="Textures/buttons.png",
				ImageRect=IntRect(960,0,1023,63),
				Border=IntRect(16,16,16,16),
				Name="HealthBarBackground",
				
				children=
				{
					{
						-- Health bar sprite
						Type="Sprite",
						Name="HealthBar",
					},
					
					{
						Type="Text",
						Name="HealthBarText",
						Style=uistyles.MovementPointsTextDisplay,
						Text="0"
					}
				}
			}
		}
	}
	
	if parent==nil then parent=ui.root end
	self.element=InstanceUI(desc, parent)
	self.points=self.element:GetChild("MovementPointsDisplay", true)
	self.head=self.element:GetChild("Headshot", true)
	self.name=self.element:GetChild("CharacterName", true)
	self.healthtext=self.element:GetChild("HealthBarText", true)
end)

function CharacterPortrait:Destroy()
	if not self.element then return end
	--self.element:RemoveAllChildren()
	self.element:Remove()
	self.element=nil
	self.points=nil
	self.head=nil
	self.name=nil
	self.healthtext=nil
end

function CharacterPortrait:Show(points, name, health, maxhealth)
	self.points:SetText(tostring(points))
	self.element.visible=true
	self.name:SetText(name)
	self:UpdateHealth(health,maxhealth)
end

function CharacterPortrait:Hide()
	self.element.visible=false
end

function CharacterPortrait:UpdateMovementPoints(points)
	self.points:SetText(tostring(points))
end

function CharacterPortrait:UpdateHealth(total, max)
	local scaling=total/max
	
	function lerp(a,b,t)
		return a+t*(b-a)
	end
	
	local color=Color(lerp(1,0.15,scaling), lerp(0,0.75,scaling), lerp(0,1,scaling))
	
	self.healthtext:SetColor(color)
	self.healthtext:SetText(tostring(total).." / "..tostring(max))
end




-- Character Portrait component

CharacterPanel=ScriptObject()

function CharacterPanel:Start()
	self.portraittex=nil
	self.portraitrect=nil
	
	self:SubscribeToEvent(self.node, "CombatActivate", "CharacterPanel:HandleCombatActivate")
	self:SubscribeToEvent(self.node, "CombatDeactivate", "CharacterPanel:HandleCombatDeactivate")
	self:SubscribeToEvent(self.node, "MovementPointsChanged", "CharacterPanel:HandleMovementPointsChanged")
	self:SubscribeToEvent(self.node, "HealingTaken", "CharacterPanel:HandleLifeChanged")
	self:SubscribeToEvent(self.node, "DamageTaken", "CharacterPanel:HandleLifeChanged")
	self:SubscribeToEvent("KillScene", "CharacterPanel:HandleKillScene")
	
	self.vm=VariantMap()
end

function CharacterPanel:Finalize()
	self.portrait=CharacterPortrait({x=0,y=ui.root.height-256}, self.portraittex, self.portraitrect, ui.root)
	self.portrait:Hide()
end

function CharacterPanel:Stop()
	--print("Stopping character panel.\n")
	if self.portrait then self.portrait:Destroy() self.portrait=nil end
	--print("Stopped\n")
end

function CharacterPanel:HandleKillScene(eventType, eventData)
	--print("Killing portrait.\n")
	if self.portrait then self.portrait:Destroy() self.portrait=nil end
end

function CharacterPanel:HandleCombatActivate(eventType, eventdata)
	if self.portrait then
		local cqueue=self.node:GetScriptObject("CombatCommandQueue")
		if not cqueue then return end
		
		self.node:SendEvent("RequestLife", self.vm)
		
		self.node:SendEvent("RequestName", self.vm)
		self.portrait:Show(cqueue.movementpoints, self.vm:GetString("name"), self.vm:GetUInt("life"), self.vm:GetUInt("maxlife"))
	end
end

function CharacterPanel:HandleCombatDeactivate(eventType, eventData)
	self.portrait:Hide()
end

function CharacterPanel:HandleMovementPointsChanged(eventType, eventData)
	local movementpoints=eventData:GetUInt("movementpoints")
	if self.portrait then self.portrait:UpdateMovementPoints(movementpoints) end
end

function CharacterPanel:HandleLifeChanged(eventType, eventData)
	if self.portrait then self.portrait:UpdateHealth(eventData:GetUInt("life"), eventData:GetUInt("maxlife")) end
end
