-- Introduction to Urho3D

-- Level Generator

require 'Scripts/objectinstancing'
--require 'Scripts/isometriccamera'
require 'Scripts/maze'
require 'Scripts/picking'
require 'Scripts/basicmousefollow'
require 'Scripts/pointclickcontroller'
require 'Scripts/animationmap'
require 'Scripts/rotationsmoothing'
require 'Scripts/randomwandercontroller'
require 'Scripts/pickfollowcontroller'
require 'Scripts/playercontroller'
require 'Scripts/camera'


Circler=ScriptObject()

function Circler:Start()
	self:SubscribeToEvent("Update", "Circler:HandleUpdate")
	self.time=0
end

function Circler:HandleUpdate(eventType, eventData)
	local dt=eventData:GetFloat("TimeStep")
	self.time=self.time+dt*0.025
	
	local x=math.cos(self.time*2)*32+64
	local z=math.sin(self.time*1.3)*32+64
	
	self.node:SetPositionXYZ(x,0,z)
end

levelobjects=
{
	player=
	{
		Scale={x=0.5,y=0.5,z=0.5},
		Components=
		{
			--{Type="CombatCameraController", Offset=1},
			--{Type="ScriptObject", Classname="IsometricCamera"},
			{Type="ScriptObject", Classname="CameraControl"},
			{Type="ScriptObject", Classname="PlayerController"},
			{Type="ScriptObject", Classname="RotationSmoothing"},
			{Type="AnimatedModel", Model="Models/gob.mdl", Material="Materials/gob.xml", CastShadows=true},
			{Type="AnimatedModel", Model="Models/CubeSword.mdl", Material="Materials/CubeSword.xml", CastShadows=true},
			{Type="AnimationController"},
			{Type="ScriptObject", Classname="AnimationMap",
				Parameters=
				{
					animations=
					{
						walk="Models/GC_Walk.ani",
						idle="Models/GC_Idle.ani",
						start="Models/GC_Idle.ani",
						attack="Models/GC_Melee.ani",
					}
				},
			},

		},
		
		Children=
		{
			{
				Position={x=0,y=1.5,z=0.5},
				Components=
				{
					{Type="Light", LightType=LIGHT_POINT, Color={r=0.85*2,g=0.45*2,b=0.25*2}, Range=5, CastShadows=true},
				},
			},
			
			{
				Position={x=0,y=1.5,z=-0.5},
				Components=
				{
					{Type="Light", LightType=LIGHT_POINT, Color={r=0.85*2,g=0.45*2,b=0.25*2}, Range=1, CastShadows=false},
				},
			},
		}
	},
	
	combatcam=
	{
		Components=
		{
			{Type="ScriptObject", Classname="IsometricCamera", Parameters={springtrack=false,orthographic=true,allowspin=false,allowzoom=false,allowpitch=false}},
		},
	},
	
	thing=
	{
		Scale={x=0.5,y=0.5,z=0.5},
		Components=
		{
			{Type="ScriptObject", Classname="RandomWanderController"},
			{Type="ScriptObject", Classname="RotationSmoothing"},
			{Type="AnimatedModel", Model="Models/gob.mdl", Material="Materials/gob.xml", CastShadows=true},
			{Type="AnimatedModel", Model="Models/CubeSword.mdl", Material="Materials/CubeSword.xml", CastShadows=true},
			{Type="AnimationController"},
			{Type="ScriptObject", Classname="AnimationMap",
				Parameters=
				{
					animations=
					{
						walk="Models/GC_Walk.ani",
						idle="Models/GC_Idle.ani",
						start="Models/GC_Idle.ani",
						attack="Models/GC_Melee.ani",
					}
				},
			},

		},
		--[[
		Children=
		{
			{
				Position={x=0,y=1.5,z=0.5},
				Components=
				{
					{Type="Light", LightType=LIGHT_POINT, Color={r=0.85*2,g=0.45*2,b=0.25*2}, Range=5, CastShadows=true},
				},
			},
			
			{
				Position={x=0,y=1.5,z=-0.5},
				Components=
				{
					{Type="Light", LightType=LIGHT_POINT, Color={r=0.85*2,g=0.45*2,b=0.25*2}, Range=1, CastShadows=false},
				},
			},
		}]]
	},
	
	dungeonlight=
	{
		Children=
		{
			{
				Direction={x=8, y=-1, z=0},
				Components=
				{
					{Type="Light", LightType=LIGHT_DIRECTIONAL, Color={r=0.00015*2, g=0.0001*2, b=0.00005*2}}
				}
			},
			{
				Direction={x=0, y=-1, z=8},
				Components=
				{
					{Type="Light", LightType=LIGHT_DIRECTIONAL, Color={b=0.00015*2, g=0.0001*2, r=0.00005*2},CastShadows=false,}
				}
			}
		},
	},
	
	wall1=
	{
		Components=
		{
			{Type="StaticModel", Model="Models/wall1.mdl", Material="Materials/wall1.xml",CastShadows=true},
			{Type="StaticModel", Model="Models/floor.mdl", Material="Materials/floor.xml"},
		}
	},
	
	wall2=
	{
		Components=
		{
			{Type="StaticModel", Model="Models/wall2.mdl", Material="Materials/wall2.xml",CastShadows=true},
			{Type="StaticModel", Model="Models/floor.mdl", Material="Materials/floor.xml"},
		}
	},
	
	wall3=
	{
		Components=
		{
			{Type="StaticModel", Model="Models/wall3.mdl", Material="Materials/wall3.xml",CastShadows=true},
			{Type="StaticModel", Model="Models/floor.mdl", Material="Materials/floor.xml"},
		}
	},
	
	wall4=
	{
		Components=
		{
			{Type="StaticModel", Model="Models/wall4.mdl", Material="Materials/wall4.xml",CastShadows=true},
			{Type="StaticModel", Model="Models/floor.mdl", Material="Materials/floor.xml"},
		}
	},
	
	wall5=
	{
		Components=
		{
			{Type="StaticModel", Model="Models/wall5.mdl", Material="Materials/wall5.xml",CastShadows=true},
			{Type="StaticModel", Model="Models/floor.mdl", Material="Materials/floor.xml"},
		}
	},
	
	wall6=
	{
		Components=
		{
			{Type="StaticModel", Model="Models/wall6.mdl", Material="Materials/wall6.xml",CastShadows=true},
			{Type="StaticModel", Model="Models/floor.mdl", Material="Materials/floor.xml"},
		},
	},
	
	wall6a=
	{
		Components=
		{
			{Type="StaticModel", Model="Models/wall6.mdl", Material="Materials/wall6_a.xml",CastShadows=true},
			{Type="StaticModel", Model="Models/floor.mdl", Material="Materials/floor.xml"},
		},
		Children=
		{
			{
				Position={x=-0.25, y=0.5, z=0},
				Components=
				{
					{Type="Light", LightType=LIGHT_POINT, Color={r=1.5, g=0.55, b=0.25}, Range=1.75, CastShadows=true},
				}
			}
		}
	},
	
	wall7=
	{
		Components=
		{
			{Type="StaticModel", Model="Models/wall7.mdl", Material="Materials/wall7.xml",CastShadows=true},
			{Type="StaticModel", Model="Models/floor.mdl", Material="Materials/floor.xml"},
		}
	},
	
	wall8=
	{
		Components=
		{
			{Type="StaticModel", Model="Models/wall8.mdl", Material="Materials/wall8.xml",CastShadows=true},
			{Type="StaticModel", Model="Models/floor.mdl", Material="Materials/floor.xml"},
		}
	},
	
	wall9=
	{
		Components=
		{
			{Type="StaticModel", Model="Models/wall9.mdl", Material="Materials/wall9.xml",CastShadows=true},
			{Type="StaticModel", Model="Models/floor.mdl", Material="Materials/floor.xml"},
		}
	},
	
	wall9a=
	{
		Components=
		{
			{Type="StaticModel", Model="Models/wall9.mdl", Material="Materials/wall9_a.xml",CastShadows=true},
			{Type="StaticModel", Model="Models/floor.mdl", Material="Materials/floor.xml"},
		},
		Children=
		{
			{
				Position={x=0, y=0.5, z=-0.25},
				Components=
				{
					{Type="Light", LightType=LIGHT_POINT, Color={r=1.5, g=0.55, b=0.25}, Range=1.75, CastShadows=true},
				}
			}
		}
	},
	
	wall10=
	{
		Components=
		{
			{Type="StaticModel", Model="Models/wall10.mdl", Material="Materials/wall10.xml",CastShadows=true},
			{Type="StaticModel", Model="Models/floor.mdl", Material="Materials/floor.xml"},
		}
	},
	
	wall11=
	{
		Components=
		{
			{Type="StaticModel", Model="Models/wall11.mdl", Material="Materials/wall11.xml",CastShadows=true},
			{Type="StaticModel", Model="Models/floor.mdl", Material="Materials/floor.xml"},
		}
	},
	
	wall12=
	{
		Components=
		{
			{Type="StaticModel", Model="Models/wall12.mdl", Material="Materials/wall12.xml",CastShadows=true},
			{Type="StaticModel", Model="Models/floor.mdl", Material="Materials/floor.xml"},
		}
	},
	
	wall13=
	{
		Components=
		{
			{Type="StaticModel", Model="Models/wall13.mdl", Material="Materials/wall13.xml",CastShadows=true},
			{Type="StaticModel", Model="Models/floor.mdl", Material="Materials/floor.xml"},
		}
	},
	
	wall14=
	{
		Components=
		{
			{Type="StaticModel", Model="Models/wall14.mdl", Material="Materials/wall14.xml",CastShadows=true},
			{Type="StaticModel", Model="Models/floor.mdl", Material="Materials/floor.xml"},
		}
	},
	
	wall15=
	{
		Components=
		{
			{Type="StaticModel", Model="Models/wall15.mdl", Material="Materials/wall15.xml",CastShadows=true},
			{Type="StaticModel", Model="Models/floor.mdl", Material="Materials/floor.xml"},
		}
	},
	
	floor=
	{
		Components=
		{
			{Type="StaticModel", Model="Models/floor.mdl", Material="Materials/floor.xml"},
		}
	}
}


function GenerateLevel(playerdata)
	math.randomseed( tonumber(tostring(os.time()):reverse():sub(1,6)) )
	local gamestate=
	{
	}
	
	gamestate.scene=Scene(context)
	gamestate.scene:CreateComponent("Octree")
	local navmesh=gamestate.scene:CreateComponent("NavigationMesh")
	gamestate.scene:CreateComponent("Navigable")
	
	navmesh:SetAgentHeight(0.5)
	navmesh:SetAgentRadius(0.125)
	navmesh:SetAgentMaxClimb(0.01)
	navmesh:SetCellSize(0.1)
	navmesh:SetCellHeight(0.5)
	navmesh:SetTileSize(24)
	
	
	gamestate.Stop=function()
		gamestate.scene:Remove()
		gamestate.scene=nil
	end
	
	-- Test maze
	local maze=buildRandomMaze(128,128,2,8,4,12,50,100)
	--maze:dump("maze.png")
	
	InstanceObject(levelobjects.combatcam, gamestate.scene)
	
	local x,y
	for y=1,maze.height,1 do
		for x=1,maze.width,1 do
			local cell=maze:getCell(x,y)
			if cell==1 then
				local code=maze:getNeighborCode(x,y)
				local wall="wall"..code
				if code==6 or code==9 then
					if math.random(1,10)<3 then wall=wall.."a" end
				end
				local n=InstanceObject(levelobjects[wall], gamestate.scene)
				--print("Instancing wall "..wall)
				--n:SetPositionXYZ(x-1,0,y-1)
				n.position=Vector3(x-1,0,y-1)
			else
				local n=InstanceObject(levelobjects.floor, gamestate.scene)
				--n:SetPositionXYZ(x-1,0,y-1)
				n.position=Vector3(x-1,0,y-1)
			end
		end
	end

	local p=InstanceObject(levelobjects.player, gamestate.scene)
	p:SendEvent("CombatActivate")
	--p:SetWorldPositionXYZ(64,0,64)
	p.position=Vector3(64,0,64)
	local vm=VariantMap()
	--vm:SetString("animation", "idle")
	vm["animation"]="idle"
	--vm:SetBool("loop",true)
	vm["loop"]=true
	vm["speed"]=1.0
	p:SendEvent("PlayAnimation", vm)
	
	playerobject=p
	
	InstanceObject(levelobjects.dungeonlight, gamestate.scene)
	
	local c
	for c=1,500,1 do
		local n=InstanceObject(levelobjects.thing, gamestate.scene)
		--n:SetWorldPositionXYZ(math.random()*127, 0, math.random()*127)
		n.position=Vector3(math.random()*127, 0, math.random()*127)
	end
	
	navmesh:Build()
	
	return gamestate
end
