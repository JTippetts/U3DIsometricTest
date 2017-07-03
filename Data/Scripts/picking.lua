-- Introduction to Urho3D

-- Picking utilities
pickvm=VariantMap()

function TopLevelNodeFromDrawable(drawable, scene)
	local n=drawable:GetNode()
	if not n then print("No node\n") return nil end
	while n.parent~=scene do if n.parent==nil then return nil end n=n.parent end
	--print("ID: "..n:GetID().."\n")
	return n
end

function PathPick(scene, maxDistance)
	if not maxDistance then maxDistance=100 end
	
	local hitDrawable = nil
	if (ui.cursor and not ui.cursor.visible and input.mouseVisible==false) then
		return nil
	end
	
	function isHostile(n)
		local vars=n:GetVars()
		if vars["hostile"] and vars["hostile"]:GetBool()==true then return true end
		return false
	end
	
	function isPlayer(n)
		local vars=n:GetVars()
		if vars["player"] and vars["player"]:GetBool()==true then return true end
		return false
	end
	
	SendEvent("RequestMouseRay", pickvm)
	local origin=pickvm:GetVector3("origin")
	local direction=pickvm:GetVector3("direction")
	local ray=Ray(origin,direction)

   
    local octree = scene:GetComponent("Octree")
    
	local resultvec=RayQueryResultVector()
	octree:Raycast(resultvec, ray, RAY_TRIANGLE, maxDistance, DRAWABLE_GEOMETRY)
	if resultvec:Size()==0 then return nil end
	
	local i
	for i=0,resultvec:Size()-1,1 do
		local node=TopLevelNodeFromDrawable(resultvec[i].drawable, scene)
		if not isHostile(node) and not isPlayer(node) then
			hitPos = ray.origin + ray.direction * resultvec[i].distance
			return hitPos
		end
	end
	
	return nil
end

function Pick(scene, maxDistance)
	if not maxDistance then maxDistance=100.0 end
	
	
	local hitPos = nil
    local hitDrawable = nil
	if (ui.cursor and not ui.cursor.visible and input.mouseVisible==false) then
		return nil
	end
	
	SendEvent("RequestMouseRay", pickvm)
	local origin=pickvm["origin"]:GetVector3()
	local direction=pickvm["direction"]:GetVector3()
	local ray=Ray(origin,direction)

   
    local octree = scene:GetComponent("Octree")
    --[[local result = octree:RaycastSingle(ray, RAY_TRIANGLE, maxDistance, DRAWABLE_GEOMETRY)
    if result.drawable ~= nil then
        -- Calculate hit position in world space
		--print("Got a hit\n")
        hitPos = ray.origin + ray.direction * result.distance
        hitDrawable = result.drawable
        return TopLevelNodeFromDrawable(result.drawable, scene)
    end
    ]]
	
	--local resultvec=PODVector_RayQueryResult_()
	--local resultvec=RayQueryResultVector()
	--octree:Raycast(resultvec, ray, RAY_TRIANGLE, maxDistance, DRAWABLE_GEOMETRY)
	--if resultvec:Size()==0 then return nil end
	local resultvec=octree:Raycast(ray, RAY_TRIANGLE, maxDistance, DRAWABLE_GEOMETRY)
	if #resultvec==0 then return nil end
	
	local i
	for i=1,#resultvec,1 do
		local node=TopLevelNodeFromDrawable(resultvec[i].drawable, scene)
		if node:GetVars()["hostile"] and node:GetVars()["hostile"]:GetBool() then return node end
	end
	
	return nil
end