local UIConfig = CreateFrame("Frame", "AAAFrame", UIParent, "BasicFrameTemplateWithInset")
UIConfig:SetSize(900, 720)
UIConfig:SetPoint("CENTER", UIParent, "CENTER")
UIConfig:SetMovable(true)
UIConfig:EnableMouse(true)
UIConfig:RegisterForDrag("LeftButton")
UIConfig:SetScript("OnDragStart", UIConfig.StartMoving)
UIConfig:SetScript("OnDragStop", UIConfig.StopMovingOrSizing)


UIConfig.scrollframe = CreateFrame("ScrollFrame", "AAAScrollFrame", UIConfig, "UIPanelScrollFrameTemplate");
UIConfig.scrollchild = CreateFrame("Frame");
UIConfig.scrollchild:SetPoint("BOTTOM", 0, 0)
local scrollbarName = UIConfig.scrollframe:GetName()
UIConfig.scrollbar = _G[scrollbarName.."ScrollBar"];
UIConfig.scrollupbutton = _G[scrollbarName.."ScrollBarScrollUpButton"];
UIConfig.scrolldownbutton = _G[scrollbarName.."ScrollBarScrollDownButton"];
 
UIConfig.scrollupbutton:ClearAllPoints();
UIConfig.scrollupbutton:SetPoint("TOPRIGHT", UIConfig.scrollframe, "TOPRIGHT", -2, -20);
 
UIConfig.scrolldownbutton:ClearAllPoints();
UIConfig.scrolldownbutton:SetPoint("BOTTOMRIGHT", UIConfig.scrollframe, "BOTTOMRIGHT", -2, 2);
 
UIConfig.scrollbar:ClearAllPoints();
UIConfig.scrollbar:SetPoint("TOP", UIConfig.scrollupbutton, "BOTTOM", 0, -2);
UIConfig.scrollbar:SetPoint("BOTTOM", UIConfig.scrolldownbutton, "TOP", 0, 2);
 
UIConfig.scrollframe:SetScrollChild(UIConfig.scrollchild);
 
UIConfig.scrollframe:SetAllPoints(UIConfig);
 
UIConfig.scrollchild:SetSize(UIConfig.scrollframe:GetWidth(), ( UIConfig.scrollframe:GetHeight() * 2 ));

-- REMOVED just for testing
-- function PopulateRosterList()
-- 	local j = -30
-- 	for i = 1, #rosterNames do
-- 		roster_list_names[i] = RosterFrame:CreateFontString(RosterFrame, "OVERLAY", "GameTooltipText")
-- 		roster_list_names[i]:SetPoint("TOPLEFT", 15, j)
-- 		roster_list_DKP[i] = RosterFrame:CreateFontString(RosterFrame, "OVERLAY", "GameTooltipText")
-- 		roster_list_DKP[i]:SetPoint("TOPLEFT", 150, j)
-- 		roster_list_class[i] = RosterFrame:CreateFontString(RosterFrame, "OVERLAY", "GameTooltipText")
-- 		roster_list_class[i]:SetPoint("TOPLEFT", 200, j)
-- 		j = j - 15
-- 	end
-- 	j = -30
-- 	for i = 1, #lastRaidRoster do
-- 		lastRaidRoster_list_names[i] = RosterFrame:CreateFontString(RosterFrame, "OVERLAY", "GameTooltipText")
-- 		lastRaidRoster_list_names[i]:SetPoint("TOPLEFT", 350, j)
-- 		lastRaidRoster_list_class[i] = RosterFrame:CreateFontString(RosterFrame, "OVERLAY", "GameTooltipText")
-- 		lastRaidRoster_list_class[i]:SetPoint("TOPLEFT", 485, j)
-- 		j = j - 15
-- 	end
-- 	RosterFrame:UnregisterEvent("PLAYER_ENTERING_WORLD")
-- 	RefreshRoster()
-- end

-- REMOVED just for testing
-- function RefreshRoster()
-- 	for i = 1, #roster_list_names do
-- 		if rosterNames[i] == nil then
-- 			roster_list_names[i]:SetText("")
-- 			roster_list_DKP[i]:SetText("")
-- 			roster_list_class[i]:SetText("")
-- 		else
-- 			roster_list_names[i]:SetText(rosterNames[i])
-- 			roster_list_DKP[i]:SetText(rosterDetails[rosterNames[i]]["DKP"])
-- 			roster_list_class[i]:SetText(rosterDetails[rosterNames[i]]["class"])
-- 		end
-- 	end
-- 	for i = 1, #lastRaidRoster_list_names do
-- 		if lastRaidRoster[i] == nil then
-- 			lastRaidRoster_list_names[i]:SetText("")
-- 			lastRaidRoster_list_class[i]:SetText("")
-- 		else
-- 			lastRaidRoster_list_names[i]:SetText(lastRaidRoster[i])
-- 			lastRaidRoster_list_class[i]:SetText(lastRaidRosterClasses[i])
-- 		end
-- 	end
-- end




function RosterNamesRemove()
	for i = 1, #rosterNames do
		if rosterNames[i] == shortName then
			rosterDetails[rosterNames[i]] = nil
			table.remove(rosterNames, i)
			RefreshRoster()
			break	
		end
	end
end

function PopupMakeAnAlt()
	StaticPopup_Show("MAKE_AN_ALT", shortName)
end

StaticPopupDialogs["MAKE_AN_ALT"] = {
  text = "Whose alt should %s be?",
	button1 = "Accept",
	button2 = "Cancel",
	timeout = 0,
	OnShow = function (self, data)
    self.editBox:SetText("Main character's name")
end,
	OnAccept = function (self, data)
	rosterDetails[shortName]["alt"] = true
	rosterDetails[shortName]["main"] = self.editBox:GetText()
	rosterDetails[rosterDetails[shortName]["main"]]["alts"[#"alts" + 1]] = shortName
	for i = 1, #rosterNames do
		if shortName == rosterNames[i] then
			table.remove(rosterNames, i)
			RefreshRoster()
			break
		end
	end
end,
	hasEditBox = true,
	whileDead = true,
	hideOnEscape = true,
	preferredIndex = 3,
	hideOnEscape = true,
}

StaticPopupDialogs["CHANGE_ROSTER_NAMES"] = {
  text = "What to do with %s?",
	button1 = "Remove",
	button2 = "Make an alt",
	OnAccept = RosterNamesRemove,
	OnCancel = PopupMakeAnAlt,
	timeout = 0,
	whileDead = true,
	hideOnEscape = true,
	preferredIndex = 3,

}
function RefreshRoster()
	for i = 1, #name_frames_font_string do
		if rosterNames[i] == nil then
			name_frames_font_string[i]:SetText("")
			name_frames_DKP_font_string[i]:SetText("")
			name_frames_Class_font_string[i]:SetText("")
		elseif rosterNames[i] ~= nil then
			name_frames_font_string[i]:SetText(rosterNames[i])
			name_frames_DKP_font_string[i]:SetText(rosterDetails[rosterNames[i]]["DKP"])
			name_frames_Class_font_string[i]:SetText(rosterDetails[rosterNames[i]]["class"])
		end
	end
end

StaticPopupDialogs["CHANGE_ROSTER_NAMES_DKP"] = {
  text = "What to do with %s's %s DKP?",
	button1 = "Adjust DKP",
	button2 = "Cancel",
	OnShow = function (self, data)
    self.editBox:SetText("")
end,
hasEditBox = true,
	OnAccept = function(self, data)
	rosterDetails[shortName]["DKP"] = rosterDetails[shortName]["DKP"] + tonumber(self.editBox:GetText())
	RefreshRoster()
end,
	timeout = 0,
	whileDead = true,
	hideOnEscape = true,
	preferredIndex = 3,
}

function PopupRosterNamesOnClickNames()
	StaticPopup_Show("CHANGE_ROSTER_NAMES", shortName)
end

function PopupRosterNamesDKPOnClickDKP()
	StaticPopup_Show("CHANGE_ROSTER_NAMES_DKP", shortName, shortName_DKP)
end

function DisplayRosterNames()
	-- sukuria naujus name_frames
	if roster_frames_names_created == false then
		local j = - 25
		for i = 1, #rosterNames do
			if name_frames[i] == nil then
				name_frames[i] = CreateFrame("Button", nil, UIConfig.scrollchild)
				name_frames[i]:SetHeight(20)
				name_frames[i]:SetWidth(140)
				name_frames[i]:SetPoint("TOPLEFT", 15, j)
				name_frames[i]:SetHighlightTexture("Interface/Buttons/UI-Panel-Button-Highlight", "ADD")
				name_frames_font_string[i] = name_frames[i]:CreateFontString(name_frames[i], "OVERLAY", "GameTooltipText")
				name_frames_font_string[i]:SetPoint("LEFT", 0, 3)
				name_frames_font_string[i]:SetText(rosterNames[i])
				j = j - 15
				function RosterNamesOnClickNamesDo()
					shortName = rosterNames[i]
					RosterNamesOnClickNames()
				end
			end
			name_frames[i]:SetScript("OnClick", RosterNamesOnClickNamesDo)
		end
		roster_frames_names_created = true
	-- yra per daug name_frames
	elseif roster_frames_names_created == true and #name_frames > #rosterNames then
		for i = 1, #name_frames do
			name_frames_font_string[i]:SetText("")
		end
		for i = 1, #rosterNames do
			name_frames_font_string[i]:SetText(rosterNames[i])
		end
	-- yra per mazai name_frames
	elseif roster_frames_names_created == true and #name_frames < #rosterNames then
		local point, relativeTo, relativePoint, xOfs, j = name_frames[#name_frames]:GetPoint()
		j = j - 15
		for i = (#name_frames + 1), #rosterNames do
			name_frames[i] = CreateFrame("Button", nil, UIConfig.scrollchild)
			name_frames[i]:SetHeight(20)
			name_frames[i]:SetWidth(160)
			name_frames[i]:SetPoint("TOPLEFT", 15, j)
			name_frames_font_string[i] = name_frames[i]:CreateFontString(name_frames[i], "OVERLAY", "GameTooltipText")
			name_frames_font_string[i]:SetPoint("LEFT", 0, 3)
			name_frames_font_string[i]:SetText(rosterNames[i])
			name_frames[i]:SetHighlightTexture("Interface/Buttons/UI-Panel-Button-Highlight", "ADD")
			j = j - 15
			function RosterNamesOnClickNamesDo()
				shortName = rosterNames[i]
				RosterNamesOnClickNames()
			end
			name_frames[i]:SetScript("OnClick", RosterNamesOnClickNamesDo)
		end
	end	
end

function DisplayRosterDKP()
	-- sukuria naujus name_frames
	if roster_frames_DKP_created == false then
		local j = - 25
		for i = 1, #rosterNames do
			if name_frames_DKP[i] == nil then
				name_frames_DKP[i] = CreateFrame("Button", nil, UIConfig.scrollchild)
				name_frames_DKP[i]:SetHeight(20)
				name_frames_DKP[i]:SetWidth(50)
				name_frames_DKP[i]:SetPoint("TOPLEFT", 150, j)
				name_frames_DKP[i]:SetHighlightTexture("Interface/Buttons/UI-Panel-Button-Highlight", "ADD")
				name_frames_DKP_font_string[i] = name_frames_DKP[i]:CreateFontString(name_frames_DKP[i], "OVERLAY", "GameTooltipText")
				name_frames_DKP_font_string[i]:SetPoint("LEFT", 0, 3)
				name_frames_DKP_font_string[i]:SetText(rosterDetails[rosterNames[i]]["DKP"])
				j = j - 15
				function RosterNamesOnClickDKPDo()
					shortName = rosterNames[i]
					shortName_DKP = rosterDetails[rosterNames[i]]["DKP"]
					RosterNamesDKPOnClickDKP()
				end
			end
			name_frames_DKP[i]:SetScript("OnClick", RosterNamesOnClickDKPDo)
		end
		roster_frames_DKP_created = true
	-- yra per daug name_frames
	elseif roster_frames_DKP_created == true and #name_frames > #rosterNames then
		for i = 1, #name_frames do
			name_frames_font_string[i]:SetText("")
		end
		for i = 1, #rosterNames do
			name_frames_font_string[i]:SetText(rosterNames[i])
		end
	-- yra per mazai name_frames
	elseif roster_frames_DKP_created == true and #name_frames < #rosterNames then
		local point, relativeTo, relativePoint, xOfs, j = name_frames[#name_frames]:GetPoint()
		j = j - 15
		for i = (#name_frames + 1), #rosterNames do
			name_frames[i] = CreateFrame("Button", nil, UIConfig.scrollchild)
			name_frames[i]:SetHeight(20)
			name_frames[i]:SetWidth(160)
			name_frames[i]:SetPoint("TOPLEFT", 15, j)
			name_frames_font_string[i] = name_frames[i]:CreateFontString(name_frames[i], "OVERLAY", "GameTooltipText")
			name_frames_font_string[i]:SetPoint("LEFT", 0, 3)
			name_frames_font_string[i]:SetText(rosterNames[i])
			name_frames[i]:SetHighlightTexture("Interface/Buttons/UI-Panel-Button-Highlight", "ADD")
			j = j - 15
			function RosterNamesOnClickDKPDo()
					shortName = rosterNames[i]
					shortName_DKP = rosterDetails[rosterNames[i]]["DKP"]
					RosterNamesDKPOnClickDKP()
			end
			name_frames_DKP[i]:SetScript("OnClick", RosterNamesOnClickDKPDo)
		end
	end	
end

function DisplayRosterClass()
	-- sukuria naujus name_frames
	if roster_frames_Class_created == false then
		local j = - 25
		for i = 1, #rosterNames do
			if name_frames_Class[i] == nil then
				name_frames_Class[i] = CreateFrame("Button", nil, UIConfig.scrollchild)
				name_frames_Class[i]:SetHeight(20)
				name_frames_Class[i]:SetWidth(60)
				name_frames_Class[i]:SetPoint("TOPLEFT", 200, j)
				name_frames_Class[i]:SetHighlightTexture("Interface/Buttons/UI-Panel-Button-Highlight", "ADD")
				name_frames_Class_font_string[i] = name_frames_Class[i]:CreateFontString(name_frames_Class[i], "OVERLAY", "GameTooltipText")
				name_frames_Class_font_string[i]:SetPoint("LEFT", 0, 3)
				name_frames_Class_font_string[i]:SetText(rosterDetails[rosterNames[i]]["class"])
				j = j - 15
			end
		end
		roster_frames_Class_created = true
	-- yra per daug name_frames
	elseif roster_frames_Class_created == true and #name_frames > #rosterNames then
		for i = 1, #name_frames do
			name_frames_font_string[i]:SetText("")
		end
		for i = 1, #rosterNames do
			name_frames_font_string[i]:SetText(rosterNames[i])
		end
	-- yra per mazai name_frames
	elseif roster_frames_Class_created == true and #name_frames < #rosterNames then
		local point, relativeTo, relativePoint, xOfs, j = name_frames[#name_frames]:GetPoint()
		j = j - 15
		for i = (#name_frames + 1), #rosterNames do
			name_frames_Class[i] = CreateFrame("Button", nil, UIConfig.scrollchild)
			name_frames_Class[i]:SetHeight(20)
			name_frames_Class[i]:SetWidth(60)
			name_frames_Class[i]:SetPoint("TOPLEFT", 200, j)
			name_frames_Class_font_string[i] = name_frames[i]:CreateFontString(name_frames[i], "OVERLAY", "GameTooltipText")
			name_frames_Class_font_string[i]:SetPoint("LEFT", 0, 3)
			name_frames_Class_font_string[i]:SetText(rosterDetails[rosterNames[i]]["class"])
			name_frames_Class[i]:SetHighlightTexture("Interface/Buttons/UI-Panel-Button-Highlight", "ADD")
			j = j - 15
		end
	end	
end

function DisplayRosterLastRaidDKPAdjust()
	-- sukuria naujus name_frames
	if roster_frames_LastRaid_created == false then
		local j = - 25
		for i = 1, #lastRaidRoster do
			if name_frames_lastRaidDKPAdjust[i] == nil then
				name_frames_lastRaidDKPAdjust[i] = CreateFrame("Button", nil, UIConfig.scrollchild)
				name_frames_lastRaidDKPAdjust[i]:SetHeight(20)
				name_frames_lastRaidDKPAdjust[i]:SetWidth(150)
				name_frames_lastRaidDKPAdjust[i]:SetPoint("TOPLEFT", 485, j)
				name_frames_lastRaidDKPAdjust[i]:SetHighlightTexture("Interface/Buttons/UI-Panel-Button-Highlight", "ADD")
				name_frames_lastRaidDKPAdjust_font_string[i] = name_frames_lastRaidDKPAdjust[i]:CreateFontString(name_frames_lastRaidDKPAdjust[i], "OVERLAY", "GameTooltipText")
				name_frames_lastRaidDKPAdjust_font_string[i]:SetPoint("LEFT", 0, 3)
				name_frames_lastRaidDKPAdjust_font_string[i]:SetText(lastRaidDKPAdjust[i])
				j = j - 15
			end
		end
		roster_frames_lastRaidDKPAdjust_created = true
	-- yra per daug name_frames
	elseif roster_frames_lastRaidDKPAdjust_created == true and #name_frames_lastRaidDKPAdjust > #lastRaidDKPAdjust then
		for i = 1, #name_frames_lastRaidDKPAdjust do
			name_frames_lastRaidDKPAdjust_font_string[i]:SetText("")
		end
		for i = 1, #lastRaidRoster do
			name_frames_lastRaidDKPAdjust_font_string[i]:SetText(lastRaidDKPAdjustroster[i])
		end
	-- yra per mazai name_frames
	elseif roster_frames_lastRaidDKPAdjust_created == true and #name_frames_lastRaidDKPAdjust < #lastRaidDKPAdjust then
		local point, relativeTo, relativePoint, xOfs, j = name_frames_lastRaidDKPAdjust[#name_frames_lastRaidDKPAdjust]:GetPoint()
		j = j - 15
		for i = (#name_frames_lastRaidDKPAdjust + 1), #lastRaidRoster do
			name_frames_lastRaidDKPAdjust[i] = CreateFrame("Button", nil, UIConfig.scrollchild)
			name_frames_lastRaidDKPAdjust[i]:SetHeight(20)
			name_frames_lastRaidDKPAdjust[i]:SetWidth(150)
			name_frames_lastRaidDKPAdjust[i]:SetPoint("TOPLEFT", 485, j)
			name_frames_lastRaidDKPAdjust_font_string[i] = name_frames[i]:CreateFontString(name_frames[i], "OVERLAY", "GameTooltipText")
			name_frames_lastRaidDKPAdjust_font_string[i]:SetPoint("LEFT", 0, 3)
			name_frames_lastRaidDKPAdjust_font_string[i]:SetText(lastRaidRoster[i])
			name_frames_lastRaidDKPAdjust_font_string[i]:SetHighlightTexture("Interface/Buttons/UI-Panel-Button-Highlight", "ADD")
			j = j - 15
		end
	end	
end




-- function DisplayRoster()
-- 	local j = -15
-- 	for i = 1, #rosterNames do
-- 		local display_name = RosterFrame:CreateFontString(RosterFrame, "OVERLAY", "GameTooltipText")
-- 		display_name:SetPoint("TOPLEFT", 15, j)
-- 		local display_dkp = RosterFrame:CreateFontString(RosterFrame, "OVERLAY", "GameTooltipText")
-- 		display_dkp:SetPoint("TOPLEFT", 225, j)
-- 		if rosterDetails[rosterNames[i]]["alt"] == true then
-- 			display_name:SetText(rosterNames[i] .. " (" .. rosterDetails[rosterNames[i]]["main_character_name"] .. ")")
-- 			display_dkp:SetText(0)
-- 		else 
-- 		display_name:SetText(rosterNames[i])	
-- 		display_dkp:SetText(rosterDetails[rosterNames[i]]["DKP"])
-- 		end
-- 		local display_class = RosterFrame:CreateFontString(RosterFrame, "OVERLAY", "GameTooltipText")
-- 		display_class:SetPoint("TOPLEFT", 150, j)
-- 		display_class:SetText(rosterDetails[rosterNames[i]]["class"])
-- 		j = j - 15
-- 	end
-- 	local j = -45
-- 	for i = 1, #lastRaidRoster do
-- 		local display_name = RosterFrame2:CreateFontString(RosterFrame, "OVERLAY", "GameTooltipText")
-- 		display_name:SetPoint("TOPLEFT", 400, j)
-- 		display_name:SetText(lastRaidRoster[i])
-- 		j = j - 15
-- 	end
-- end




local RosterFrame = CreateFrame("Frame", "RosterFrame", UIConfig.scrollchild)
	RosterFrame:SetWidth(1) 
	RosterFrame:SetHeight(1)
	RosterFrame:SetAllPoints(UIConfig.scrollchild)
local LastRaidFrame = CreateFrame("Frame", nil, UIConfig.scrollchild)
	LastRaidFrame:SetWidth(1) 
	LastRaidFrame:SetHeight(1)
	LastRaidFrame:SetAllPoints(UIConfig.scrollchild)

local display_name_title = RosterFrame:CreateFontString(RosterFrame, "OVERLAY", "GameTooltipText")
	display_name_title:SetPoint("LEFT", UIConfig.TitleBg, "LEFT", 15, 0)
	display_name_title:SetText("Raider")
local display_dkp_title = RosterFrame:CreateFontString(RosterFrame, "OVERLAY", "GameTooltipText")
	display_dkp_title:SetPoint("LEFT", UIConfig.TitleBg, "LEFT", 150, 0)
	display_dkp_title:SetText("DKP")
local display_class_title = RosterFrame:CreateFontString(RosterFrame, "OVERLAY", "GameTooltipText")
	display_class_title:SetPoint("LEFT", UIConfig.TitleBg, "LEFT", 200, 0)
	display_class_title:SetText("Class")
local display_alt_title = RosterFrame:CreateFontString(RosterFrame, "OVERLAY", "GameTooltipText")
	display_alt_title:SetPoint("LEFT", UIConfig.TitleBg, "LEFT", 300, 0)
	display_alt_title:SetText("Alts")
local display_name_title = LastRaidFrame:CreateFontString(LastRaidFrame, "OVERLAY", "GameTooltipText")
	display_name_title:SetPoint("LEFT", UIConfig.TitleBg, "LEFT", 485, 0)
	display_name_title:SetText("Last raid roster")
local display_class_title = RosterFrame:CreateFontString(RosterFrame, "OVERLAY", "GameTooltipText")
	display_class_title:SetPoint("LEFT", UIConfig.TitleBg, "LEFT", 600, 0)
	display_class_title:SetText("Class")

UIConfig:RegisterEvent("PLAYER_ENTERING_WORLD")
UIConfig:HookScript("OnEvent", DisplayRosterNames)
UIConfig:HookScript("OnEvent", DisplayRosterDKP)
UIConfig:HookScript("OnEvent", DisplayRosterClass)
UIConfig:HookScript("OnEvent", DisplayRosterLastRaid)



