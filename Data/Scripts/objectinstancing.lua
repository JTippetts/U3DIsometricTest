-- Introduction to Urho3D

-- Object Instancing

function InstanceNode(desc, parent, name)
	if name==nil then name="" end
	local node=parent:CreateChild(name, LOCAL)
	if desc.Position then
		node:SetPosition(Vector3(desc.Position.x, desc.Position.y, desc.Position.z))
	end
	
	if desc.Direction then
		node:SetDirection(Vector3(desc.Direction.x, desc.Direction.y, desc.Direction.z))
	elseif desc.Rotation then
		if desc.Rotation.angle then
			node:SetRotation(Quaternion(desc.Rotation.angle, Vector3(desc.Rotation.x, desc.Rotation.y, desc.Rotation.z)))
		else
			node:SetRotation(Quaternion(desc.Rotation.w, desc.Rotation.x, desc.Rotation.y, desc.Rotation.z))
		end
	end
	
	if desc.Scale then
		node:SetScale(Vector3(desc.Scale.x, desc.Scale.y, desc.Scale.z))
	end
	
	if desc.Vars then
		local name,val
		for name,val in pairs(desc.Vars) do
			--if type(val)=="number" then node:GetVars():SetFloat(name, val)
			--elseif type(val)=="string" then node:GetVars():SetString(name, val) 
			--elseif val==nil or val==true or val==false then node:GetVars():SetBool(name, val)
			node:GetVars()[name]=val
			--end
		end
	end
	
	return node
end

function InstanceComponent(desc, node, scriptparams)
	local Type=desc.Type
	
	if Type=="BillboardSet" or Type=="ParticleEmitter" then
		local m=node:CreateComponent(Type)
		--if desc.Material then m:SetMaterial(cache:GetResource("Material", desc.Material)) end
		if desc.NumBillboards then m:SetNumBillboards(desc.NumBillboards) end
		if desc.Scaled~=nil then m:SetScaled(desc.Scaled) end
		if desc.Relative~=nil then m:SetRelative(desc.Relative) end
		m:SetSorted(desc.Sorted)
		--m:SetFaceCamera(desc.FaceCamera)
		if desc.AnimationLodBias~=nil then m:SetAnimationLodBias(desc.AnimationLodBias) end
		
		if Type=="ParticleEmitter" then
			if desc.Filename then
				--local eff=ParticleEffect:new(context)
				--eff:Load(cache:GetResource("XMLFile", desc.Filename))
				local eff=cache:GetResource("ParticleEffect", desc.Filename)
				m:SetEffect(eff)
				m:ApplyEffect()
			else
				local eff=ParticleEffect:new(context)
				
				--if desc.Material then m:SetMaterial(cache:GetResource("Material", desc.Material)) end
				if desc.Relative~=nil then eff:SetRelative(desc.Relative) end
				if desc.Material then eff.material=cache:GetResource("Material", desc.Material) end
				if desc.NumParticles then eff:SetNumParticles(desc.NumParticles) end
				if desc.MinEmissionRate then eff:SetMinEmissionRate(desc.MinEmissionRate) end
				if desc.MaxEmissionRate then eff:SetMaxEmissionRate(desc.MaxEmissionRate) end
				if desc.EmitterType then eff:SetEmitterType(desc.EmitterType) end
				if desc.EmitterSize then eff:SetEmitterSize(desc.EmitterSize) end
				if desc.ActiveTime then eff:SetActiveTime(desc.ActiveTime) end
				if desc.InactiveTime then eff:SetInactiveTime(desc.InactiveTime) end
				if desc.UpdateInvisible then eff:SetUpdateInvisible(desc.UpdateInvisible) end
				if desc.MinTimeToLive then eff:SetMinTimeToLive(desc.MinTimeToLive) end
				if desc.MaxTimeToLive then eff:SetMaxTimeToLive(desc.MaxTimeToLive) end
				if desc.MinParticleSize then eff:SetMinParticleSize(desc.MinParticleSize) end
				if desc.MaxParticleSize then eff:SetMaxParticleSize(desc.MaxParticleSize) end
				if desc.MinDirection then eff:SetMinDirection(desc.MinDirection) end
				if desc.MaxDirection then eff:SetMaxDirection(desc.MaxDirection) end
				if desc.MinVelocity then eff:SetMinVelocity(desc.Velocity) end
				if desc.MaxVelocity then eff:SetMaxVelocity(desc.Vleocity) end
				if desc.MinRotation then eff:SetMinRotation(desc.MinRotation) end
				if desc.MaxRotation then eff:SetMaxRotation(desc.MaxRotation) end
				if desc.MinRotationSpeed then eff:SetMinRotationSpeed(desc.MinRotationSpeed) end
				if desc.MaxRotationSpeed then eff:SetMaxRotationSpeed(desc.MaxRotationSpeed) end
				if desc.ConstantForce then eff:SetConstantForce(desc.ConstantForce) end
				if desc.DampingForce then eff:SetDampingForce(desc.DampingForce) end
				if desc.SizeAdd then eff:SetSizeAdd(desc.SizeAdd) end
				if desc.SizeMul then eff:SetSizeMul(desc.SizeMul) end
	
				if desc.Color then eff:AddColorTime(desc.Color,0) end
				if desc.Colors then
					--eff:SetNumColors(desc.Colors.NumColors)
					local c
					for c=1,#desc.Colors,1 do
						eff:AddColorTime(desc.Colors[c].Color, desc.Colors[c].Time)
					end
				end
				if desc.TextureFrames then
					local f
					for f=1,#desc.TextureFrames,1 do
						eff:AddTextureTime(desc.TextureFrames[c].UV, desc.TextureFrames[c].Time)
					end
				end
				m:SetEffect(eff)
				--m:ApplyEffect()
			end
		end
	elseif Type=="StaticModel" then
		local m=node:CreateComponent("StaticModel")
		m:SetModel(cache:GetResource("Model", desc.Model))
		m:SetMaterial(cache:GetResource("Material", desc.Material))
		if desc.OcclusionLodLevel then m:SetOcclusionLodLevel(desc.OcclusionLodLevel) end
		if desc.CastShadows then m.castShadows=desc.CastShadows end
	elseif Type=="AnimatedModel" then
		local m=node:CreateComponent("AnimatedModel")
		m:SetModel(cache:GetResource("Model", desc.Model))
		m:SetMaterial(cache:GetResource("Material", desc.Material))
		if desc.OcclusionLodLevel then m:SetOcclusionLodLevel(desc.OcclusionLodLevel) end
		if desc.CastShadows then m.castShadows=desc.CastShadows end
	elseif Type=="AnimationController" then
		local a=node:CreateComponent("AnimationController")
	elseif Type=="Light" then
		local l=node:CreateComponent("Light")
		
		if desc.LightType then l:SetLightType(desc.LightType) end
		if desc.PerVertex then l:SetPerVertex(desc.PerVertex) end
		if desc.Color then l:SetColor(Color(desc.Color.r, desc.Color.g, desc.Color.b)) end
		if desc.SpecularIntensity then l:SetSpecularIntensity(desc.SpecularIntensity) end
		if desc.Range then l:SetRange(desc.Range) end
		if desc.Fov then l:SetFov(desc.Fov) end
		if desc.AspectRatio then l:SetAspectRatio(desc.AspectRatio) end
		if desc.FadeDistance then l:SetFadeDistance(desc.FadeDistance) end
		if desc.ShadowFadeDistance then l:SetShadowFadeDistance(desc.ShadowFadeDistance) end
		if desc.ShadowBias then
			local p=BiasParameters(desc.ShadowBias.ConstantBias, desc.ShadowBias.SlopeScaledBias, desc.ShadowBias.NormalBias)
			l:SetShadowBias(p)
		end
		if desc.ShadowCascade then
			local ba=1
			if desc.ShadowCascade.BiasAutoAdjust then ba=desc.ShadowCascade.BiasAutoAdjust end
			local p=CascadeParameters(desc.ShadowCascade.Split1, desc.ShadowCascade.Split2, desc.ShadowCascade.Split3, desc.ShadowCascade.Split4, desc.ShadowCascade.FadeStart, ba)
			l:SetShadowCascade(p)
		end
		
		if desc.ShadowFocus then
			local p=FocusParameters(desc.ShadowFocus.Focus, desc.ShadowFocus.NonUniform, desc.ShadowFocus.AutoSize, desc.ShadowFocus.Quantize, desc.ShadowFocus.MinView)
			l:SetShadowFocus(p)
		end
		if desc.ShadowIntensity then l:SetShadowIntensity(desc.ShadowIntensity) end
		if desc.ShadowResolution then l:SetShadowResolution(desc.ShadowResolution) end
		if desc.ShadowNearFarRatio then l:SetShadowNearFarRatio(desc.ShadowNearFarRatio) end
		if desc.CastShadows then l.castShadows=true end
	elseif Type=="Zone" then
		local z=node:CreateComponent("Zone")
		
		if desc.AmbientColor then z:SetAmbientColor(Color(desc.AmbientColor.r, desc.AmbientColor.g, desc.AmbientColor.b)) end
		if desc.FogColor then z:SetFogColor(Color(desc.FogColor.r, desc.FogColor.g, desc.FogColor.b)) end
		if desc.FogStart then z:SetFogStart(desc.FogStart) end
		if desc.FogEnd then z:SetFogEnd(desc.FogEnd) end
		if desc.Priority then z:SetPriority(desc.Priority) end
		if desc.Override then z:SetOverride(desc.Override) end
		if desc.AmbientGradient then z:SetAmbientGradient(desc.AmbientGradient) end
		
		if desc.BoundingBox then
			z:SetBoundingBox(desc.BoundingBox)
		end
	elseif Type=="Text3D" then
		local t=node:CreateComponent("Text3D")
		
		if desc.Text then t:SetText(desc.Text) end
		if desc.Font then
			if desc.FontSize then
				t:SetFont(desc.Font, desc.FontSize)
			else
				t:SetFont(desc.Font)
			end
		end
		if desc.HorizontalAlignment then t:SetHorizontalAlignment(desc.HorizontalAlignment) end
		if desc.VerticalAlignment then t:SetVerticalAlignment(desc.VerticalAlignment) end
		if desc.TextAlignment then t:SetTextAlignment(desc.TextAlignment) end
		if desc.RowSpacing then t:SetRowSpacing(desc.RowSpacing) end
		if desc.WordWrap then t:SetWordWrap(desc.WordWrap) end
		if desc.TextEffect then t:SetTextEffect(desc.TextEffect) end
		if desc.EffectColor then t:SetEffectColor(Color(desc.EffectColor.r,desc.EffectColor.g,desc.EffectColor.b)) end
		if desc.EffectBias then t:SetEffectDepthBias(desc.EffectDepthBias) end
		if desc.Width then t:SetWidth(desc.Width) end
		if desc.FixedScreenSize then t:SetFixedScreenSize(desc.FixedScreenSize) end
		if desc.Color then
			if desc.Color.Corners then
				local corner
				for _,corner in pairs(desc.Color.Corners) do
					t:SetColor(corner.Corner, Color(corner.r, corner.g, corner.b))
				end
			else
				t:SetColor(Color(desc.Color.r, desc.Color.g, desc.Color.b))
			end
		end
		if desc.Opacity then t:SetOpacity(desc.Opacity) end
		--if desc.FaceCamera then t:SetFaceCamera(desc.FaceCamera) end
		-- TODO: Handle face camera modes
		if desc.FaceCamera then t:SetFaceCameraMode(FC_ROTATE_XYZ) end
		if desc.Material then t:SetMaterial(cache:GetResource("Material", desc.Material)) end
	elseif Type=="PhysicsWorld" then
		if desc.Gravity then t:SetGravity(Vector3(desc.Gravity.x, desc.Gravity.y, desc.Gravity.z)) end
		if desc.NumIterations then t:SetNumIterations(desc.NumIterations) end
		t:SetInterpolation(desc.Interpolation)
		t:SetInternalEdge(desc.InternalEdge)
		t:SetSplitImpulse(desc.SplitImpulse)
		if desc.MaxNetworkAngularVelocity then t:SetMaxNetworkAngularVelocity(desc.MaxNetworkAngularVelocity) end
	elseif Type=="Contraint" then
		if desc.ConstraintType then t:SetConstraintType(desc.ConstraintType) end
		if desc.Position then t:SetPosition(Vector3(desc.Position.x, desc.Position.y, desc.Position.z)) end
		if desc.Rotation then
			if desc.Rotation.angle then
				node:SetRotation(Quaternion(desc.Rotation.angle, Vector3(desc.Rotation.x, desc.Rotation.y, desc.Rotation.z)))
			else
				node:SetRotation(Quaternion(desc.Rotation.w, desc.Rotation.x, desc.Rotation.y, desc.Rotation.z))
			end
		end
		if desc.Axis then t:SetAxis(Vector3(desc.Axis.x, desc.Axis.y, desc.Axis.z)) end
		if desc.WorldPosition then t:SetWorldPosition(Vector3(desc.WorldPosition.x, desc.WorldPosition.y, desc.WorldPosition.z)) end
		if desc.LowLimit then t:SetLowLimit(Vector2(desc.LowLimit.x, desc.LowLimit.y)) end
		if desc.HighLimit then t:SetHighLimit(Vector2(desc.HighLimit.x, desc.HighLimit.y)) end
		if desc.ERP then t:SetERP(desc.ERP) end
		if desc.CFM then t:SetCFM(desc.CFM) end
		t:SetDisableCollision(desc.DisableCollision)
	elseif Type=="CollisionShape" then
		if desc.Box then
			t:SetBox(desc.Box.Size, desc.Box.Position, desc.Box.Rotation)
		end
		if desc.Sphere then t:SetSphere(desc.Sphere.Diameter, desc.Sphere.Position, desc.Sphere.Rotation) end
		if desc.StaticPlane then t:SetStaticPlane(desc.StaticPlane.Position, desc.StaticPlane.Rotation) end
		if desc.Cylinder then t:SetCylinder(desc.Cylinder.Diameter, desc.Cylinder.Height, desc.Cylinder.Position, desc.Cylinder.Rotation) end
		if desc.Capsule then t:SetCapsule(desc.Capsule.Diameter, desc.Capsule.Height, desc.Capsule.Position, desc.Capsule.Rotation) end
		if desc.Cone then t:SetCone(desc.Cone.Diameter, desc.Cone.Height, desc.Cone.Position, desc.Cone.Rotation) end
		if desc.TriangleMesh then t:SetTriangleMesh(resourcecache:GetResource("Model",desc.ConvexHull.Model), desc.TriangleMesh.LodLevel, desc.TriangleMesh.Scale, desc.TriangleMesh.Position, desc.TriangleMesh.Rotation) end
		if desc.ConvexHull then t:SetConvexHull(resourcecache:GetResource("Model",desc.ConvexHull.Model), desc.ConvexHull.LodLevel, desc.ConvexHull.Scale, desc.ConvexHull.Position, desc.ConvexHull.Rotation) end
		if desc.Terrain then t:SetTerrain() end
		if desc.ShapeType then t:SetShapeType(desc.ShapeType) end
		if desc.Size then t:SetSize(desc.Size) end
		if desc.Position then t:SetPosition(desc.Position) end
		if desc.Rotation then t:SetRotation(desc.Rotation) end
		if desc.Transform then t:SetTransform(desc.Transform.Position, desc.Transform.Rotation) end
		if desc.Margin then t:SetMargin(desc.Margin) end
		if desc.Model then t:SetModel(resourcecache:GetResource("Model",desc.Model)) end
		if desc.LodLevel then t:SetLodLevel(desc.LodLevel) end
	elseif Type=="RigidBody" then
		if desc.Mass then t:SetMass(desc.Mass) end
		if desc.Position then t:SetPosition(desc.Position) end
		if desc.Rotation then t:SetRotation(desc.Rotation) end
		if desc.Transform then t:SetTransform(desc.Transform.Position, desc.Transform.Rotation) end
		if desc.LinearVelocity then t:SetLinearVelocity(desc.LinearVelocity) end
		if desc.LinearFactor then t:SetLinearFactor(desc.LinearFactor) end
		if desc.LinearRestThreshold then t:SetLinearRestThreshold(desc.LinearRestThreshold) end
		if desc.LinearDamping then t:SetLinearDamping(desc.LinearDamping) end
		if desc.AngularVelocity then t:SetAngularVelocity(desc.AngularVelocity) end
		if desc.AngularFactor then t:SetAngularFactor(desc.AngularFactor) end
		if desc.AngularDamping then t:SetAngularDamping(desc.AngularDamping) end
		if desc.Friction then t:SetFriction(desc.Friction) end
		if desc.AnisotropicFriction then t:SetAnisotropicFriction(desc.AnisotropicFriction) end
		if desc.RollingFriction then t:SetRollingFriction(desc.RollingFriction) end
		if desc.Restitution then t:SetRestitution(desc.Restitution) end
		if desc.ContactProcessingThreshold then t:SetContactProcessingThreshold(desc.ContactProcessingThreshold) end
		if desc.CcdRadius then t:SetCcdRadius(desc.CcdRadius) end
		if desc.CcdMotionThreshold then t:SetCcdMotionThreshold(desc.CcdMotionThreshold) end
		if desc.UseGravity==false then t:SetUseGravity(false) else t:SetUseGravity(true) end
		t:setKinematic(desc.Kinematic)
		if desc.GravityOverride then t:SetGravityOverride(desc.GravityOverride) end
		t:SetPhantom(desc.Phantom)
		if desc.CollisionLayer then t:SetCollisionLayer(desc.CollisionLayer) end
		if desc.CollisionMask then t:SetCollisionMask(desc.CollisionMask) end
		if desc.CollisionEventMode then t:SetCollisionEventMode(desc.CollisionEVentMode) end
	
	elseif Type=="ScriptObject" then
		if desc.Filename then require(desc.Filename) end
		local s=node:CreateScriptObject(desc.Classname)
		if not s then print("Could not create script object "..desc.Classname) return end
		
		local params=desc.Parameters
		if scriptparams then
			if scriptparams[desc.Classname] then params=scriptparams[desc.Classname] end
		end
		
		if params then
			local n,v
			for n,v in pairs(params) do
				-- If the script object needs to preserve invariants or do special things
				-- with parameters, can specify SetParameter method that will do the heavy
				-- lifting; otherwise, just fall through to setting internal data.
				-- Should probably also use this if the script object plans to change any of these parameters during runtime
				-- especially if the parameter is a table (which might be shared among all objects created from the same template).
				
				if s.SetParameter then
					s:SetParameter(n,v)
				else
					s[n]=v
				end
			end
		end
		
		return s
		--if s.Finalize then s:Finalize() end
		
	-- Custom components
	elseif Type=="SmoothedTransform" then
		local t=node:CreateComponent("SmoothedTransform")
	elseif Type=="HexMap" then
		local t=node:CreateComponent("HexMap")
		if desc.Width and desc.Height then t:resize(desc.Width, desc.Height) end
	elseif Type=="HoverInformation" then
		local t=node:CreateComponent("HoverInformation")
	elseif Type=="ThirdPersonCamera" then
		local t=node:CreateComponent("ThirdPersonCamera")
		if desc.CellSize then t:SetCellSize(desc.CellSize) end
		if desc.CamAngle then t:SetCamAngle(desc.CamAngle) end
		if desc.RotAngle then t:SetRotAngle(desc.RotAngle) end
		if desc.ClipDist then t:SetClipDist(desc.ClipDist) end
		if desc.ClipCamera~=nil then t:SetClipCamera(desc.ClipCamera) end
		if desc.SpringTrack~=nil then t:SetSpringTrack(desc.SpringTrack) end
		if desc.AllowPitch~=nil then t:SetAllowPitch(desc.AllowPitch) end
		if desc.AllowSpin~=nil then t:SetAllowSpin(desc.AllowSpin) end
		if desc.AllowZoom~=nil then t:SetAllowZoom(desc.AllowZoom) end
		if desc.Orthographic~=nil then t:SetOrthographic(desc.Orthographic) end
		if desc.Offset then t:SetOffset(desc.Offset) end
		if desc.MinFollow then t:SetMinFollow(desc.MinFollow) end
		if desc.MaxFollow then t:SetMaxFollow(desc.MaxFollow) end
	elseif Type=="CombatCameraController" then
		local t=node:CreateComponent("CombatCameraController")
		if desc.Offset then t:SetOffset(desc.Offset) end
	elseif Type=="HexmapPresence" then
		local t=node:CreateComponent("HexmapPresence")
	elseif Type=="StaticHexmapPresence" then
		local t=node:CreateComponent("StaticHexmapPresence")
	elseif Type=="StaticAuxHexmapPresence" then
		local t=node:CreateComponent("StaticAuxHexmapPresence")
	end
end

function InstanceObject(desc, scene)
	-- InstanceComponent only returns a value if the component is a script component
	-- Stash all script components into a table, then after the object is instanced, iterate
	-- the table and call Finalize
	if(scene==nil) then print("scene is nil") end
	local node=InstanceNode(desc, scene)
	
	local i,c
	
	local scripts={}
	
	if desc.Components then
	
		for i,c in pairs(desc.Components) do
			local s=InstanceComponent(c, node)
			if s then table.insert(scripts, s) end
		end
	end
	
	if desc.Children then
		for i,c in pairs(desc.Children) do
			InstanceObject(c, node)
		end
	end
	
	for _,c in ipairs(scripts) do if c.Finalize then c:Finalize() end end
	
	--node:SendEvent("Finalize", emptyvm)
	
	return node
end

function InstanceObjectIntoNode(desc, node)
	
	local i,c
	
	local scripts={}
	
	if desc.Components then
	
		for i,c in pairs(desc.Components) do
			local s=InstanceComponent(c, node)
			if s then table.insert(scripts, s) end
		end
	end
	
	if desc.Children then
		for i,c in pairs(desc.Children) do
			InstanceObject(c, node)
		end
	end
	
	for _,c in ipairs(scripts) do if c.Finalize then c:Finalize() end end
	
	return node
end
