-- Goblinson Crusoe
-- UI Styles

uistyles=
{
	RightScrollButton=
	{
		Type="Button",
		Texture="Textures/buttons.png",
		ImageRect=IntRect(322,2,338,18),
		Size=IntVector2(16,16),
		HoverOffset=IntVector2(19,0),
		PressedOffset=IntVector2(19,0),
		Border=IntRect(4,4,4,4),
	},
	
	LeftScrollButton=
	{
		Type="Button",
		Texture="Textures/buttons.png",
		ImageRect=IntRect(322,21,338,37),
		Size=IntVector2(16,16),
		HoverOffset=IntVector2(19,0),
		PressedOffset=IntVector2(19,0),
		Border=IntRect(4,4,4,4),
	},
	
	DownScrollButton=
	{
		Type="Button",
		Texture="Textures/buttons.png",
		ImageRect=IntRect(379,2,395,18),
		Size=IntVector2(16,16),
		HoverOffset=IntVector2(19,0),
		PressedOffset=IntVector2(19,0),
		Border=IntRect(4,4,4,4),
	},
	
	UpScrollButton=
	{
		Type="Button",
		Texture="Textures/buttons.png",
		ImageRect=IntRect(379,21,395,37),
		Size=IntVector2(16,16),
		HoverOffset=IntVector2(19,0),
		PressedOffset=IntVector2(19,0),
		Border=IntRect(4,4,4,4),
	},
	
	LeftRightSliderKnob=
	{
		Type="BorderImage",
		Texture="Textures/buttons.png",
		ImageRect=IntRect(437,21,453,37),
		Size=IntVector2(16,16),
		Border=IntRect(4,4,4,4),
	},
	
	UpDownSliderKnob=
	{
		Type="BorderImage",
		Texture="Textures/buttons.png",
		ImageRect=IntRect(437,2,453,18),
		Size=IntVector2(16,16),
		Border=IntRect(4,4,4,4),
	},
	
	RightScrollButtonLarge=
	{
		Type="Button",
		Texture="Textures/buttons.png",
		ImageRect=IntRect(458,4,490,36),
		Size=IntVector2(32,32),
		HoverOffset=IntVector2(33,0),
		PressedOffset=IntVector2(33,0),
		Border=IntRect(4,4,4,4),
	},
	
	LeftScrollButtonLarge=
	{
		Type="Button",
		Texture="Textures/buttons.png",
		ImageRect=IntRect(458,36,490,68),
		Size=IntVector2(32,32),
		HoverOffset=IntVector2(33,0),
		PressedOffset=IntVector2(33,0),
		Border=IntRect(4,4,4,4),
	},
	
	DownScrollButtonLarge=
	{
		Type="Button",
		Texture="Textures/buttons.png",
		ImageRect=IntRect(555,4,587,36),
		Size=IntVector2(32,32),
		HoverOffset=IntVector2(32,0),
		PressedOffset=IntVector2(32,0),
		Border=IntRect(4,4,4,4),
	},
	
	UpScrollButtonLarge=
	{
		Type="Button",
		Texture="Textures/buttons.png",
		ImageRect=IntRect(555,36,587,68),
		Size=IntVector2(32,32),
		HoverOffset=IntVector2(32,0),
		PressedOffset=IntVector2(32,0),
		Border=IntRect(4,4,4,4),
	},
	
	LeftRightSliderKnobLarge=
	{
		Type="BorderImage",
		Texture="Textures/buttons.png",
		ImageRect=IntRect(650,36,682,68),
		Size=IntVector2(32,32),
		Border=IntRect(8,8,8,8),
	},
	
	UpDownSliderKnobLarge=
	{
		Type="BorderImage",
		Texture="Textures/buttons.png",
		ImageRect=IntRect(651,4,685,36),
		Size=IntVector2(32,32),
		Border=IntRect(8,8,8,8),
	},
	
	HotKeyText=
	{
		Type="Text",
		FontName="Fonts/minya nouvelle bd.otf",
		FontSize=12,
		TextAlignment=HA_CENTER,
		HorizontalAlignment=HA_LEFT,
		VerticalAlignment=HA_TOP,
		TextEffect=TE_STROKE,
		EffectColor=Color(0,0,0),
		Color=Color(1,1,1),
	},
	
	SpellbookTitleText=
	{
		Type="Text",
		FontName="Fonts/minya nouvelle bd.otf",
		FontSize=14,
		TextAlignment=HA_LEFT,
		TextEffect=TE_SHADOW,
		EffectColor=Color(0,0,0),
		Color=Color(1,1,1),
	},
	
	CombatActionButton=
	{
		Type="Button",
		FixedSize=IntVector2(64, 64),
		Texture="Textures/buttons.png",
		HoverOffset=IntVector2(64, 0),
		PressedOffset=IntVector2(64, 0),
		HorizontalAlignment=HA_LEFT,
		VerticalAlignment=VA_TOP,
	},
	
	MovementPointsTextDisplay=
	{
		Type="Text",
		FontName="Fonts/minya nouvelle bd.otf",
		FontSize=20,
		TextAlignment=TA_CENTER,
		HorizontalAlignment=HA_CENTER,
		VerticalAlignment=VA_CENTER,
		TextEffect=TE_SHADOW,
		EffectColor=Color(0,0,0),
		Color=Color(1,0.75,0.125),
	}
}

spellbookstyles=
{
	SpellbookCloseButton=
	{
		Type="Button",
		Texture="Textures/buttons.png",
		ImageRect=IntRect(458,68,490,100),
		Size=IntVector2(32,32),
		HoverOffset=IntVector2(32,0),
		PressedOffset=IntVector2(32,0),
		Border=IntRect(4,4,4,4),
	},
	
	SpellbookDescriptionText=
	{
		Type="Text",
		FontName="Fonts/minya nouvelle bd.otf",
		FontSize=12,
		TextAlignment=HA_LEFT,
		HorizontalAlignment=HA_LEFT,
		VerticalAlignment=HA_CENTER,
		TextEffect=TE_SHADOW,
		EffectColor=Color(0,0,0),
		Color=Color(1,1,1),
	},
	
	SpellbookBookView=
	{
		Type="ScrollView",
		AutoVisible=true,
		--VerticalVisible=true,
		
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
	}
}


-- Color table
colortable=
{
	Color(1,1,1),
	Color(0,0,0),
	Color(1,0,0),
	Color(0,1,0),
	Color(0,0,1),
	Color(1,1,0),
	Color(1,0,1),
	Color(0,1,1),
	Color(0.5,0,0),
	Color(0,0.5,0),
	Color(0,0,0.5),
	Color(0.5,0.5,0),
	Color(0.5,0,0.5),
	Color(0,0.5,0.5),
	Color(0.5,0.5,0.5),
	Color(1,0.5,0),
	Color(1,0,0.5),
	Color(1,0.5,0.5),
	Color(0.5,1,0),
	Color(0,1,0.5),
	Color(0.5,1,0.5),
	Color(0.5,0,1),
	Color(0,0.5,1),
	Color(0.5,0.5,1),
	Color(1,1,0.5),
	Color(1,0.5,1),
	Color(0.5,1,1)
}

