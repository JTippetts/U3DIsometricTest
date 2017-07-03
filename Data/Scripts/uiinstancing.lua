-- Goblinson Crusoe
-- UI Instancing

function SetUIElementParameters(desc, e)
	if desc.Style then
		SetUIElementParameters(desc.Style, e)
	end
	
	if desc.Type=="BorderImage" or desc.Type=="Button" or desc.Type=="Slider" then
		if desc.Texture then
			local tex=cache:GetResource("Texture2D", desc.Texture)
			if tex then e:SetTexture(tex) end
		end
		if desc.ImageRect then e:SetImageRect(desc.ImageRect) end
		if desc.FullImageRect==true then e:SetFullImageRect() end
		if desc.Border then e:SetBorder(desc.Border) end
		if desc.HoverOffset then e:SetHoverOffset(desc.HoverOffset) end
		if desc.BlendMode then e:SetBlendMode(desc.BlendMode) end
		e:SetTiled(desc.Tiled)
	end
	
	if desc.Type=="Window" or desc.Type=="View3D" then
		e:SetMovable(desc.Movable)
		e:SetResizable(desc.Resizable)
		e:SetFixedWidthResizing(desc.FixedWidthResizing)
		e:SetFixedHeightResizing(desc.FixedHeightResizing)
		e:SetModal(desc.Modal)
		if desc.ModalShadeColor then e:SetModalShadeColor(desc.ModalShadeColor) end
		if desc.ModalFrameColor then e:SetModalFrameColor(desc.ModalFrameColor) end
		if desc.ModalFrameSize then e:SetModalFrameSize(dec.ModalFrameSize) end
		if desc.Type=="View3D" then
			if desc.Camera and desc.Scene then e:SetView(desc.Scene, desc.Camera) end
			if desc.Format then e:SetFormat(desc.Format) end
			e:SetAutoUpdate(desc.AutoUpdate)
		end
	elseif desc.Type=="Text" then
		--print("Instance text element\n")
		if desc.FontName then
			if desc.FontSize then
				e:SetFont(cache:GetResource("Font", desc.FontName), desc.FontSize)
			else
				e:SetFont(cache:GetResource("Font", desc.FontName))
			end
		end
		if desc.Text then e:SetText(desc.Text) end
		if desc.TextAlignment then e:SetTextAlignment(desc.TextAlignment) end
		if desc.RowSpacing then e:SetRowSpacing(desc.RowSpacing) end
		--if desc.WordWrap then e:SetWordWrap(desc.WordWrap) end
		e:SetWordwrap(desc.WordWrap)
		if desc.HoverColor then e:SetHoverColor(desc.HoverColor) end
		if desc.TextEffect then e:SetTextEffect(desc.TextEffect) end
		if desc.EffectColor then e:SetEffectColor(desc.EffectColor) end
	elseif desc.Type=="Button" then
		if desc.PressedOffset then e:SetPressedOffset(desc.PressedOffset) end
		if desc.PressedChildOffset then e:SetPressedChildOffset(desc.PressedChildOffset) end
		if desc.Repeat then
			e:SetRepeat(desc.Repeat.Delay, desc.Repeat.Rate)
		end
	elseif desc.Type=="Slider" then
		if desc.Orientation then e:SetOrientation(desc.Orientation) end
		if desc.Range then e:SetRange(desc.Range) end
		if desc.Value then e:SetValue(desc.Value) end
		if desc.RepeatRate then e:SetRepeatRate(desc.RepeatRate) end
	elseif desc.Type=="ScrollBar" then
		if desc.Orientation then e:SetOrientation(desc.Orientation) end
		if desc.Range then e:SetRange(desc.Range) end
		if desc.Value then e:SetValue(desc.Value) end
		if desc.ScrollStep then e:SetScrollStep(desc.ScrollStep) end
		if desc.StepFactor then e:SetStepFactor(desc.StepFactor) end
	elseif desc.Type=="ScrollView" then
		if desc.ViewPosition then e:SetViewPosition(desc.ViewPosition) end
		e:SetScrollBarsVisible(desc.HorizontalVisible, desc.VerticalVisible)
		if desc.ScrollStep then e:SetScrollStep(desc.ScrollStep) end
		if desc.PageStep then e:SetPageStep(desc.PageStep) end
		e:SetScrollBarsAutoVisible(desc.AutoVisible)
	elseif desc.Type=="Sprite" then
		if desc.HotSpot then e:SetHotSpot(desc.HotSpot) end
		if desc.Scale then e:SetScale(desc.Scale) end
		if desc.Rotation then e:SetRotation(desc.Rotation) end
		if desc.Texture then e:SetTexture(cache:GetResource("Texture2D", desc.Texture)) end
		if desc.FullImageRect and desc.FullImageRect==true then e:SetFullimageRect() end
		if desc.ImageRect then e:SetImageRect(desc.ImageRect) end
		if desc.BlendMode then e:SetBlendMode(desc.BlendMode) end
	end
	
	if desc.Position then e:SetPosition(desc.Position) end
	if desc.Size then e:SetSize(desc.Size) end
	if desc.Width then e:SetWidth(desc.Width) end
	if desc.Height then e:SetHeight(desc.Height) end
	if desc.MinSize then e:SetMinSize(desc.MinSize) end
	if desc.MinWidth then e:SetMinWidth(desc.MinWidth) end
	if desc.MinHeight then e:SetMinHeight(desc.MinHeight) end
	if desc.MaxSize then e:SetMaxSize(desc.MaxSize) end
	if desc.MaxWidth then e:SetMaxWidth(desc.MaxWidth) end
	if desc.MaxHeight then e:SetMaxHeight(desc.MaxHeight) end
	if desc.FixedSize then e:SetFixedSize(desc.FixedSize) end
	if desc.FixedWidth then e:SetFixedWidth(desc.FixedWidth) end
	if desc.FixedHeight then e:SetFixedHeight(desc.FixedHeight) end
	if desc.HorizontalAlignment then e:SetHorizontalAlignment(desc.HorizontalAlignment) end
	if desc.VerticalAlignment then e:SetVerticalAlignment(desc.VerticalAlignment) end
	if desc.ClipBorder then e:SetClipBorder(desc.ClipBorder) end
	if desc.Color then
		if desc.Color.Corners then
			local c
			for c=1,#desc.Color.Corners,1 do
				e:SetColor(desc.Color.Corners[c].Corner, desc.Color.Corners[c].Color)
			end
		else	
			e:SetColor(desc.Color)
		end
	end
	if desc.Priority then e:SetPriority(desc.Priority) end
	if desc.Opacity then e:SetOpacity(desc.Opacity) end
	e:SetBringToFront(desc.BringToFront)
	e:SetBringToBack(desc.BringToBack)
	e:SetClipChildren(desc.ClipChildren)
	e:SetSortChildren(desc.SortChildren)
	e:SetUseDerivedOpacity(desc.UseDerivedOpacity)
	if desc.Focus then e:SetFocus(desc.Focus) end
	if desc.FocusMode then e:SetFocusMode(desc.FocusMode) end
	if desc.DragDropMode then e:SetDragDropMode(desc.DragDropMode) end
	e:SetIndent(desc.Indent)
	if desc.IndentSpacing then e:SetIndentSpacing(desc.IndentSpacing) end
	
	
	
	-- Set Internal Elements
	if desc.Type=="Slider" and desc.Knob then
		--desc.Knob.Type="BorderImage"
		SetUIElementParameters(desc.Knob,e:GetKnob())
	elseif desc.Type=="ScrollBar" then
		if desc.BackButton then
			--desc.BackButton.Type="Button"
			SetUIElementParameters(desc.BackButton, e:GetBackButton())
		end
		if desc.ForwardButton then
			--desc.ForwardButton.Type="Button"
			SetUIElementParameters(desc.ForwardButton, e:GetForwardButton())
		end
		if desc.Slider then
			--desc.Slider.Type="Slider"
			SetUIElementParameters(desc.Slider, e:GetSlider())
		end
	elseif desc.Type=="ScrollView" then
		if desc.HorizontalScrollBar then
			--desc.HorizontalScrollBar.Type="ScrollBar"
			SetUIElementParameters(desc.HorizontalScrollBar, e:GetHorizontalScrollBar())
		end
		if desc.VerticalScrollBar then
			--desc.VerticalScrollBar.Type="ScrollBar"
			SetUIElementParameters(desc.VerticalScrollBar, e:GetVerticalScrollBar())
		end
		if desc.ScrollPanel then
			--desc.ScrollPanel.Type="BorderImage"
			SetUIElementParameters(desc.ScrollPanel, e:GetScrollPanel())
		end
		if desc.ContentElement then
			local ce=InstanceUI(desc.ContentElement, e)
			e:SetContentElement(ce)
		end
	end
end

function InstanceUIElement(desc, parent)
	if not parent then parent=ui.root end
	if desc.Name then
		if desc.Index then
			e=parent:CreateChild(desc.Type, desc.Name, desc.Index)
		else
			e=parent:CreateChild(desc.Type, desc.Name)
		end
	else
		e=parent:CreateChild(desc.Type)
	end
	if not e then return nil end
	
	SetUIElementParameters(desc,e)
	return e
end

function InstanceUI(desc, parent)
	local n=InstanceUIElement(desc,parent)
	if not n then return nil end
	local c
	
	if desc.Children then
		for _,c in pairs(desc.Children) do
			InstanceUI(c, n)
		end
	end
	
	return n
end