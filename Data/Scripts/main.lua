-- Introduction To Urho3D

-- Main

require 'Scripts/levelgenerator'
require 'Scripts/picking'

g_gamestate=nil
g_newgamestate=nil

g_noderemovelist={}
count=0

emptyvm=VariantMap()

function Start()
	log:Open("Urho3D.log")
	log.level=LOG_DEBUG
	SubscribeToEvent("Update", "HandleUpdate")
	renderer.numViewports=1
	
	--input:SetMouseVisible(true)
	
	cursor=Cursor:new(context)
	cursor:DefineShape(CS_NORMAL, cache:GetResource("Image", "Textures/cursor.png"), IntRect(0,0,33,33), IntVector2(5,5))
	ui.cursor=cursor
	ui.cursor.visible=true
	ui.cursor:SetPosition(ui.root.width/2, ui.root.height/2)
	
	renderer.drawShadows=true
	renderer.shadowMapSize=1024
	renderer.shadowQuality=SHADOWQUALITY_LOW_16BIT
	
	g_newgamestate=GenerateLevel({health=100})
	
end

function Stop()
	
end

function HandleUpdate(eventType, eventData)
	count=count+1
	if count==120 then
		print(collectgarbage("count").."\n")
		count=0
	end
	FlushRemovedNodes() -- Remove any nodes that were queued for removal last update
	collectgarbage()
	
	if g_newgamestate then
		if g_gamestate and g_gamestate.Stop then g_gamestate:Stop() end
		g_gamestate=g_newgamestate
		g_newgamestate=nil
		if g_gamestate and g_gamestate.Start then g_gamestate:Start() end
		return
	end
	
	if input:GetKeyPress(KEY_PRINTSCREEN) then
		local t=os.date("*t")
		local filename="screen_"..tostring(t.year).."_"..tostring(t.month).."_"..tostring(t.day).."_"..tostring(t.hour).."_"..tostring(t.min).."_"..tostring(t.sec)..".png"
		local img=Image()
		graphics:TakeScreenShot(img)
		img:SavePNG(filename)
		return
	elseif input:GetKeyPress(KEY_ESCAPE) then
		if g_gamestate and g_gamestate.Stop then g_gamestate:Stop() end
		g_gamestate=nil
		engine:Exit()
	elseif input:GetKeyPress(KEY_N) then
		g_newgamestate=GenerateLevel({health=100})
	elseif input:GetKeyPress(KEY_P) then
		local scene=playerobject:GetScene()
		RemoveNode(playerobject)
		playerobject=InstanceObject(levelobjects.player, scene)
		--playerobject:SetWorldPositionXYZ(64,0,64)
		playerobject.position=Vector3(64,0,64)
	elseif input:GetKeyPress(KEY_SPACE) then
		local vm=VariantMap()
		vm:SetFloat("speed", 15)
		vm:SetFloat("magnitude", 0.25)
		vm:SetFloat("damping", 2)
		SendEvent("ShakeCamera", vm)
	end
	
	-- Do any per-state updating as required
	local dt=eventData["TimeStep"]:GetFloat()
	if g_gamestate and g_gamestate.Update then g_gamestate:Update(dt) end
	
	-- Test picking
	if g_gamestate then
		local pick=Pick(g_gamestate.scene, 100)
		if pick then
			pick:SendEvent("Pick", emptyvm)
		end
	end
end

function RemoveNode(node)
	-- See if already queued for removal
	local n
	for _,n in ipairs(g_noderemovelist) do
		if n==node then return end
	end
	
	table.insert(g_noderemovelist, node)
	node.enabled=false
end

function FlushRemovedNodes()
	local i,n
	for i=#g_noderemovelist,1,-1 do
		n=g_noderemovelist[i]
		n:RemoveAllComponents()
		n:RemoveAllChildren()
		n:Remove()
		g_noderemovelist[i]=nil
	end
	
	g_noderemovelist={}
end