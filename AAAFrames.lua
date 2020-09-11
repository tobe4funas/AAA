AAAUI = CreateFrame("Frame", "AAAFrame", UIParent, "BasicFrameTemplateWithInset")
AAAUI:SetSize(900, 720)
AAAUI:SetPoint("CENTER", UIParent, "CENTER")
AAAUI:SetMovable(true)
AAAUI:EnableMouse(true)
AAAUI:RegisterForDrag("LeftButton")
AAAUI:SetScript("OnDragStart", AAAUI.StartMoving)
AAAUI:SetScript("OnDragStop", AAAUI.StopMovingOrSizing)


AAAUI.scrollframe = CreateFrame("ScrollFrame", "AAAScrollFrame", AAAUI, "UIPanelScrollFrameTemplate");
AAAUI.scrollchild = CreateFrame("Frame");
AAAUI.scrollchild:SetPoint("BOTTOM", 0, 0)
local scrollbarName = AAAUI.scrollframe:GetName()
AAAUI.scrollbar = _G[scrollbarName.."ScrollBar"];
AAAUI.scrollupbutton = _G[scrollbarName.."ScrollBarScrollUpButton"];
AAAUI.scrolldownbutton = _G[scrollbarName.."ScrollBarScrollDownButton"];
 
AAAUI.scrollupbutton:ClearAllPoints();
AAAUI.scrollupbutton:SetPoint("TOPRIGHT", AAAUI.scrollframe, "TOPRIGHT", -2, -20);
 
AAAUI.scrolldownbutton:ClearAllPoints();
AAAUI.scrolldownbutton:SetPoint("BOTTOMRIGHT", AAAUI.scrollframe, "BOTTOMRIGHT", -2, 2);
 
AAAUI.scrollbar:ClearAllPoints();
AAAUI.scrollbar:SetPoint("TOP", AAAUI.scrollupbutton, "BOTTOM", 0, -2);
AAAUI.scrollbar:SetPoint("BOTTOM", AAAUI.scrolldownbutton, "TOP", 0, 2);
 
AAAUI.scrollframe:SetScrollChild(AAAUI.scrollchild);
 
AAAUI.scrollframe:SetAllPoints(AAAUI);
 
AAAUI.scrollchild:SetSize(AAAUI.scrollframe:GetWidth(), ( AAAUI.scrollframe:GetHeight() * 2 ));

local display_count_title = AAAUI:CreateFontString(AAAUI, "OVERLAY", "GameTooltipText")
local display_name_title = AAAUI:CreateFontString(AAAUI, "OVERLAY", "GameTooltipText")
local display_dkp_title = AAAUI:CreateFontString(AAAUI, "OVERLAY", "GameTooltipText")
local display_class_title = AAAUI:CreateFontString(AAAUI, "OVERLAY", "GameTooltipText")
local display_alt_title = AAAUI:CreateFontString(AAAUI, "OVERLAY", "GameTooltipText")
local display_attendance_title = AAAUI:CreateFontString(AAAUI, "OVERLAY", "GameTooltipText")
local display_lastname_title = AAAUI:CreateFontString(AAAUI, "OVERLAY", "GameTooltipText")
local display_lastclass_title = AAAUI:CreateFontString(AAAUI, "OVERLAY", "GameTooltipText")
local display_lastcount_title = AAAUI:CreateFontString(AAAUI, "OVERLAY", "GameTooltipText")


local display_raider = {}
local display_dkp = {}
local display_class = {}
local display_alts = {}
local display_count = {}
local display_attendance = {}
local display_lastraid = {}
local display_lastclass = {}
local display_lastcount = {}

local display_raider_fontstring = {}
local display_dkp_fontstring = {}
local display_class_fontstring = {}
local display_alts_fontstring = {}
local display_count_fontstring = {}
local display_attendance_fontstring = {}
local display_lastraid_fontstring = {}
local display_lastclass_fontstring = {}
local display_lastcount_fontstring = {}

local count_x = 15
local raider_x = 40
local dkp_x = 170
local class_x = 220
local alts_x = 280
local attendance_x = 400
local lastcount_x = 500
local lastraider_x = 525+ 20
local lastclass_x = 650+ 20

function AddRaidDKP()
	local DKP_adjust = AAAUI.editBox1:GetNumber()
	local DKP_adjust_reason = AAAUI.editBox2:GetText()
	if DKP_adjust_reason == "attendance" then attendance_total = attendance_total + 1 end
	for i = 1, #lastRaidRosterDKPAdjust do
		-- giving DKP to main char
		if rosterDetails[lastRaidRosterDKPAdjust[i]]["is_an_alt"] == false then
			rosterDetails[lastRaidRosterDKPAdjust[i]]["DKP"] = rosterDetails[lastRaidRosterDKPAdjust[i]]["DKP"] + DKP_adjust
			if changelog_dkp == nil then changelog_dkp = {}
				changelog_dkp[1] = date("%d/%m/%Y") .. " --- " .. lastRaidRosterDKPAdjust[i] .. " --- " .. DKP_adjust .. " --- " .. DKP_adjust_reason
			else changelog_dkp[#changelog_dkp + 1] = date("%d/%m/%Y") .. " --- " .. lastRaidRosterDKPAdjust[i] .. " --- " .. DKP_adjust .. " --- " .. DKP_adjust_reason
			end
		-- tracking attendance
			if DKP_adjust_reason == "attendance" then
				rosterDetails[lastRaidRosterDKPAdjust[i]]["attendance_total"] = rosterDetails[lastRaidRosterDKPAdjust[i]]["attendance_total"] + 1
			end
		-- giving DKP to main char		
		elseif rosterDetails[lastRaidRosterDKPAdjust[i]]["is_an_alt"] == true then
			local main_character = rosterDetails[lastRaidRosterDKPAdjust[i]]["main"]
			rosterDetails[main_character]["DKP"] = rosterDetails[main_character]["DKP"] + DKP_adjust
		-- tracking attendance for main char
			if changelog_dkp == nil then changelog_dkp = {}
				changelog_dkp[1] = date("%d/%m/%Y") .. " --- " .. main_character .. " --- " .. DKP_adjust .. " --- " .. DKP_adjust_reason
			else changelog_dkp[#changelog_dkp + 1] = date("%d/%m/%Y") .. " --- " .. main_character .. " --- " .. DKP_adjust .. " --- " .. DKP_adjust_reason
			end
			if DKP_adjust_reason == "attendance" then
				rosterDetails[main_character]["attendance_total"] = rosterDetails[main_character]["attendance_total"] + 1
			end

		end
	end
	AAAUI.editBox1:ClearFocus()
	AAAUI.editBox2:ClearFocus()
	RefreshRoster()
end

function PopupRemoveRoster()
	display_raider_fontstring[#rosterNames]:SetText("")
	display_dkp_fontstring[#rosterNames]:SetText("")
	display_class_fontstring[#rosterNames]:SetText("")
	display_alts_fontstring[#rosterNames]:SetText("")
	display_attendance_fontstring[#rosterNames]:SetText("")
	display_count_fontstring[#rosterNames]:SetText("")



	for i = 1, #rosterNames do
		if rosterNames[i] == shortName then
			for j = 1, #rosterDetails[rosterNames[i]]["alts"] do
				local alt_name = rosterDetails[rosterNames[i]]["alts"][j]
				print(alt_name)
				rosterDetails[alt_name] = nil
			end
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
	hideOnEscape = true,
	OnShow = function (self, data)
    	self.editBox:SetText("Main character's name")   
	end,

	OnAccept = function (self, data)
		local main_character_name = self.editBox:GetText()
		if rosterDetails[main_character_name] ~= nil then
			rosterDetails[shortName]["is_an_alt"] = true
			rosterDetails[shortName]["main"] = main_character_name
			local alt_count = #rosterDetails[main_character_name]["alts"] + 1
			table.insert(rosterDetails[rosterDetails[shortName]["main"]]["alts"], alt_count, shortName)
			display_raider_fontstring[#rosterNames]:SetText("")
					display_dkp_fontstring[#rosterNames]:SetText("")
					display_class_fontstring[#rosterNames]:SetText("")
					display_alts_fontstring[#rosterNames]:SetText("")
					display_attendance_fontstring[#rosterNames]:SetText("")
					display_count_fontstring[#rosterNames]:SetText("")
			for i = 1, #rosterNames do
				if shortName == rosterNames[i] then
					
					table.remove(rosterNames, i)
					RefreshRoster()
					break
				end
			end
		end
	end,
	hasEditBox = true,
	whileDead = true,

	preferredIndex = 3,
	hideOnEscape = true,
}

StaticPopupDialogs["CHANGE_ROSTER_NAMES"] = {
  text = "What to do with %s?",
	button1 = "Remove",
	button2 = "Make an alt",
	OnAccept = PopupRemoveRoster,
	OnCancel = PopupMakeAnAlt,
	timeout = 0,
	whileDead = true,
	hideOnEscape = true,
	preferredIndex = 3,

}

function PopupWipeDKP()
	StaticPopup_Show("WIPE_DKP", shortName)
end

StaticPopupDialogs["WIPE_DKP"] = {
  text = "You sure you want to wipe shit?",
	button1 = "Yes",
	button2 = "No",
	OnAccept = function()
		changelog_dkp_backup = {}
		changelog_items_backup = {}
		for i = 1, #rosterNames do
			rosterDetails[rosterNames[i]]["DKP"] = 0
			rosterDetails[rosterNames[i]]["attendance_total"] = 0
			rosterDetails[rosterNames[i]]["attendance_starting"] = 0
		end
		for i = 1, #changelog_dkp do
			changelog_dkp_backup[i] = changelog_dkp[i]
		end
		for i = 1, #changelog_items do
			changelog_items_backup[i] = changelog_items[i]
		end
		changelog_dkp = {}
		changelog_items = {}
		attendance_total = 0
		RefreshRoster()
	end,
	timeout = 0,
	whileDead = true,
	hideOnEscape = true,
	preferredIndex = 3,

}

function PopupWipeRoster()
	StaticPopup_Show("WIPE_ROSTER", shortName)
end

StaticPopupDialogs["WIPE_ROSTER"] = {
  text = "You sure you want to wipe shit?",
	button1 = "Yes",
	button2 = "No",
	OnAccept = function()
	rosterNames = {}
	rosterDetails = {}
	changelog_dkp_backup = {}
	changelog_items_backup = {}
	for i = 1, #changelog_dkp do
		changelog_dkp_backup[i] = changelog_dkp[i]
	end
	for i = 1, #changelog_items do
		changelog_items_backup[i] = changelog_items[i]
	end
	changelog_dkp = {}
	changelog_items = {}
	attendance_total = 0
	RefreshRoster()
end,
	timeout = 0,
	whileDead = true,
	hideOnEscape = true,
	preferredIndex = 3,
}


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
	changelog_items[#changelog_items + 1] = date("%m/%d/%Y") .. " " .. shortName .. " " ..  tonumber(self.editBox:GetText()) .. " " .. "Manual_DKP_adjust"
	RefreshRoster()
end,
	timeout = 0,
	whileDead = true,
	hideOnEscape = true,
	preferredIndex = 3,
}

function PopupRaiders()
	StaticPopup_Show("CHANGE_ROSTER_NAMES", shortName)
end

function PopupDKP()
	StaticPopup_Show("CHANGE_ROSTER_NAMES_DKP", shortName, shortName_DKP)
end

function RemoveLastRaid()
	display_lastcount_title:SetText(#lastRaidRosterDKPAdjust .. "/" .. #lastRaidRoster)
	for i = 1, #lastRaidRosterDKPAdjust do
		display_lastraid_fontstring[i]:SetText(lastRaidRosterDKPAdjust[i])
		display_lastclass_fontstring[i]:SetText(lastRaidRosterClassesDKPAdjust[i])
		-- class colors
		if lastRaidRosterClassesDKPAdjust[i] == "Rogue" then
			display_lastclass_fontstring[i]:SetTextColor(1, 1, 0, 1)
		elseif lastRaidRosterClassesDKPAdjust[i] == "Warrior" then
			display_lastclass_fontstring[i]:SetTextColor(153/255, 76/255, 0, 1)
		elseif lastRaidRosterClassesDKPAdjust[i] == "Mage" then
			display_lastclass_fontstring[i]:SetTextColor(0/255, 128/255, 255, 1)
		elseif lastRaidRosterClassesDKPAdjust[i] == "Warlock" then
			display_lastclass_fontstring[i]:SetTextColor(178/255, 102/255, 1, 1)
		elseif lastRaidRosterClassesDKPAdjust[i] == "Priest" then
			display_lastclass_fontstring[i]:SetTextColor(1, 1, 1, 1)
		elseif lastRaidRosterClassesDKPAdjust[i] == "Hunter" then
			display_lastclass_fontstring[i]:SetTextColor(0, 1, 0, 1)
		elseif lastRaidRosterClassesDKPAdjust[i] == "Druid" then
			display_lastclass_fontstring[i]:SetTextColor(1, 153/255, 51/255, 1)
		elseif lastRaidRosterClassesDKPAdjust[i] == "Paladin" then
			display_lastclass_fontstring[i]:SetTextColor(1, 0, 1, 1)
		end
	end
end

function lastRaidRosterCloning()
	lastRaidRosterDKPAdjust = {}
	lastRaidRosterClassesDKPAdjust = {}
	for i = 1, #lastRaidRoster do
		lastRaidRosterDKPAdjust[i] = lastRaidRoster[i]
		lastRaidRosterClassesDKPAdjust[i] = lastRaidRosterClasses[i]
	end
end


function RefreshRoster()
	display_count_title:SetText(#rosterNames)
	SortRosterNames()
	lastRaidRosterCloning()
	display_lastcount_title:SetText(#lastRaidRosterDKPAdjust .. "/" .. #lastRaidRoster)
	-- calculate attendance
	if attendance_total == nil then attendance_total = 0 end
	for i = 1, #rosterNames do
		rosterDetails[rosterNames[i]]["attendance_percentage"] = rosterDetails[rosterNames[i]]["attendance_total"] / (attendance_total - rosterDetails[rosterNames[i]]["attendance_starting"]) * 100
	end

	if display_raider[1] == nil then
		j = -30
		-- creating raider frames
		for i = 1, #rosterNames do
			display_raider[i] = CreateFrame("Button", nill, AAAUI.scrollchild)
			display_dkp[i] = CreateFrame("Button", nill, AAAUI.scrollchild)
			display_class[i] = CreateFrame("Button", nill, AAAUI.scrollchild)
			display_alts[i] = CreateFrame("Button", nill, AAAUI.scrollchild)
			display_attendance[i] = CreateFrame("Button", nill, AAAUI.scrollchild)
			display_count[i] = CreateFrame("Button", nill, AAAUI.scrollchild)
			
			display_raider[i]:SetHeight(20)
			display_dkp[i]:SetHeight(20)
			display_class[i]:SetHeight(20)
			display_alts[i]:SetHeight(20)
			display_attendance[i]:SetHeight(20)
			display_count[i]:SetHeight(20)		

			display_raider[i]:SetWidth(120)
			display_dkp[i]:SetWidth(50)
			display_class[i]:SetWidth(60)
			display_alts[i]:SetWidth(120)
			display_attendance[i]:SetWidth(80)
			display_count[i]:SetWidth(20)
			
			display_raider[i]:SetPoint("TOPLEFT", raider_x, j)
			display_dkp[i]:SetPoint("TOPLEFT", dkp_x, j)
			display_class[i]:SetPoint("TOPLEFT", class_x, j)
			display_alts[i]:SetPoint("TOPLEFT", alts_x, j)
			display_attendance[i]:SetPoint("TOPLEFT", attendance_x, j)
			display_count[i]:SetPoint("TOPLEFT", count_x, j)


			display_raider[i]:SetHighlightTexture("Interface/Buttons/UI-Panel-Button-Highlight", "ADD")
			display_dkp[i]:SetHighlightTexture("Interface/Buttons/UI-Panel-Button-Highlight", "ADD")
			display_class[i]:SetHighlightTexture("Interface/Buttons/UI-Panel-Button-Highlight", "ADD")
			display_alts[i]:SetHighlightTexture("Interface/Buttons/UI-Panel-Button-Highlight", "ADD")
			display_attendance[i]:SetHighlightTexture("Interface/Buttons/UI-Panel-Button-Highlight", "ADD")
			display_count[i]:SetHighlightTexture("Interface/Buttons/UI-Panel-Button-Highlight", "ADD")
			
			display_raider_fontstring[i] = display_raider[i]:CreateFontString(AAAUI, "OVERLAY", "GameTooltipText")
			display_dkp_fontstring[i] = display_dkp[i]:CreateFontString(AAAUI, "OVERLAY", "GameTooltipText")
			display_class_fontstring[i] = display_class[i]:CreateFontString(AAAUI, "OVERLAY", "GameTooltipText")
			display_alts_fontstring[i] = display_alts[i]:CreateFontString(AAAUI, "OVERLAY", "GameTooltipText")
			display_attendance_fontstring[i] = display_attendance[i]:CreateFontString(AAAUI, "OVERLAY", "GameTooltipText")
			display_count_fontstring[i] = display_count[i]:CreateFontString(AAAUI, "OVERLAY", "GameTooltipText")

			display_raider_fontstring[i]:SetPoint("LEFT", 0, 3)
			display_dkp_fontstring[i]:SetPoint("LEFT", 0, 3)
			display_class_fontstring[i]:SetPoint("LEFT", 0, 3)
			display_alts_fontstring[i]:SetPoint("LEFT", 0, 3)
			display_attendance_fontstring[i]:SetPoint("LEFT", 0, 3)
			
			display_count_fontstring[i]:SetAllPoints(true)
			display_count_fontstring[i]:SetJustifyV("TOP")
			display_count_fontstring[i]:SetJustifyH("CENTER")

			-- display_count_fontstring[i]:SetJustifyH("RIGHT")
			-- if i < 10 then display_count_fontstring[i]:SetJustifyH("RIGHT")
			-- elseif i >= 10 then display_count_fontstring[i]:SetJustifyH("LEFT") end

			display_raider_fontstring[i]:SetText(rosterNames[i])
			display_dkp_fontstring[i]:SetText(rosterDetails[rosterNames[i]]["DKP"])
			display_class_fontstring[i]:SetText(rosterDetails[rosterNames[i]]["class"])
			display_attendance_fontstring[i]:SetText(string.format("%.2f %%", rosterDetails[rosterNames[i]]["attendance_percentage"]))
			display_count_fontstring[i]:SetText(i)

			if rosterDetails[rosterNames[i]]["class"] == "Rogue" then
				display_class_fontstring[i]:SetTextColor(1, 1, 0, 1)
			elseif rosterDetails[rosterNames[i]]["class"] == "Warrior" then
				display_class_fontstring[i]:SetTextColor(153/255, 76/255, 0, 1)
			elseif rosterDetails[rosterNames[i]]["class"] == "Mage" then
				display_class_fontstring[i]:SetTextColor(0/255, 128/255, 255, 1)
			elseif rosterDetails[rosterNames[i]]["class"] == "Warlock" then
				display_class_fontstring[i]:SetTextColor(178/255, 102/255, 1, 1)
			elseif rosterDetails[rosterNames[i]]["class"] == "Priest" then
				display_class_fontstring[i]:SetTextColor(1, 1, 1, 1)
			elseif rosterDetails[rosterNames[i]]["class"] == "Hunter" then
				display_class_fontstring[i]:SetTextColor(0, 1, 0, 1)
			elseif rosterDetails[rosterNames[i]]["class"] == "Druid" then
				display_class_fontstring[i]:SetTextColor(1, 153/255, 51/255, 1)
			elseif rosterDetails[rosterNames[i]]["class"] == "Paladin" then
				display_class_fontstring[i]:SetTextColor(1, 0, 1, 1)
			end


			if #rosterDetails[rosterNames[i]]["alts"] == 0 then
				display_alts_fontstring[i]:SetText("---")
			elseif #rosterDetails[rosterNames[i]]["alts"] == 1 then
				display_alts_fontstring[i]:SetText(rosterDetails[rosterNames[i]]["alts"][1])
			elseif #rosterDetails[rosterNames[i]]["alts"] == 2 then
				display_alts_fontstring[i]:SetText(rosterDetails[rosterNames[i]]["alts"][1] .. " etc...")
			end
			
			function OnClickDoRaiders()
				if display_raider_fontstring[i]:GetText() ~= nil then
					shortName = rosterNames[i]
					PopupRaiders()
				end
			end

			function OnClickDoDKP()
				if display_dkp_fontstring[i]:GetText() ~= nil then
					shortName = rosterNames[i]
					shortName_DKP = rosterDetails[rosterNames[i]]["DKP"]
					PopupDKP()
				end
			end

			display_raider[i]:SetScript("OnClick", OnClickDoRaiders)
			display_dkp[i]:SetScript("OnClick", OnClickDoDKP)

			j = j - 15
		end
		j = -30
		-- creating last raid frames
		for i = 1, #lastRaidRosterDKPAdjust do
			display_lastraid[i] = CreateFrame("Button", nill, AAAUI.scrollchild)
			display_lastclass[i] = CreateFrame("Button", nill, AAAUI.scrollchild)
			display_lastcount[i] = CreateFrame("Button", nill, AAAUI.scrollchild)

			display_lastraid[i]:SetHeight(20)
			display_lastclass[i]:SetHeight(20)
			display_lastcount[i]:SetHeight(20)

			display_lastraid[i]:SetWidth(120)
			display_lastclass[i]:SetWidth(60)
			display_lastcount[i]:SetWidth(60)

			display_lastraid[i]:SetPoint("TOPLEFT", lastraider_x, j)
			display_lastclass[i]:SetPoint("TOPLEFT", lastclass_x, j)
			display_lastcount[i]:SetPoint("TOPLEFT", lastcount_x, j)

			display_lastraid[i]:SetHighlightTexture("Interface/Buttons/UI-Panel-Button-Highlight", "ADD")
			display_lastclass[i]:SetHighlightTexture("Interface/Buttons/UI-Panel-Button-Highlight", "ADD")
			display_lastcount[i]:SetHighlightTexture("Interface/Buttons/UI-Panel-Button-Highlight", "ADD")

			display_lastraid_fontstring[i] = display_lastraid[i]:CreateFontString(AAAUI, "OVERLAY", "GameTooltipText")
			display_lastclass_fontstring[i] = display_lastclass[i]:CreateFontString(AAAUI, "OVERLAY", "GameTooltipText")
			display_lastcount_fontstring[i] = display_lastcount[i]:CreateFontString(AAAUI, "OVERLAY", "GameTooltipText")

			display_lastraid_fontstring[i]:SetPoint("LEFT", 0, 3)
			display_lastclass_fontstring[i]:SetPoint("LEFT", 0, 3)

			display_lastcount_fontstring[i]:SetAllPoints(true)
			display_lastcount_fontstring[i]:SetJustifyV("TOP")
			display_lastcount_fontstring[i]:SetJustifyH("CENTER") 

			display_lastraid_fontstring[i]:SetText(lastRaidRosterDKPAdjust[i])
			display_lastclass_fontstring[i]:SetText(lastRaidRosterClassesDKPAdjust[i])
			display_lastcount_fontstring[i]:SetText(i)

			if lastRaidRosterClassesDKPAdjust[i] == "Rogue" then
				display_lastclass_fontstring[i]:SetTextColor(1, 1, 0, 1)
			elseif lastRaidRosterClassesDKPAdjust[i] == "Warrior" then
				display_lastclass_fontstring[i]:SetTextColor(153/255, 76/255, 0, 1)
			elseif lastRaidRosterClassesDKPAdjust[i] == "Mage" then
				display_lastclass_fontstring[i]:SetTextColor(0/255, 128/255, 255, 1)
			elseif lastRaidRosterClassesDKPAdjust[i] == "Warlock" then
				display_lastclass_fontstring[i]:SetTextColor(178/255, 102/255, 1, 1)
			elseif lastRaidRosterClassesDKPAdjust[i] == "Priest" then
				display_lastclass_fontstring[i]:SetTextColor(1, 1, 1, 1)
			elseif lastRaidRosterClassesDKPAdjust[i] == "Hunter" then
				display_lastclass_fontstring[i]:SetTextColor(0, 1, 0, 1)
			elseif lastRaidRosterClassesDKPAdjust[i] == "Druid" then
				display_lastclass_fontstring[i]:SetTextColor(1, 153/255, 51/255, 1)
			elseif lastRaidRosterClassesDKPAdjust[i] == "Paladin" then
				display_lastclass_fontstring[i]:SetTextColor(1, 0, 1, 1)
			end

			function OnClickDoLastraid()
				shortName_lastraid = lastRaidRosterDKPAdjust[i]
				display_lastraid_fontstring[#lastRaidRosterDKPAdjust]:SetText("")
				display_lastclass_fontstring[#lastRaidRosterDKPAdjust]:SetText("")
				display_lastcount_fontstring[#lastRaidRosterDKPAdjust]:SetText("")

				table.remove(lastRaidRosterDKPAdjust, i)
				table.remove(lastRaidRosterClassesDKPAdjust, i)
				RemoveLastRaid()
			end

			j = j - 15

			
			display_lastraid[i]:SetScript("OnClick", OnClickDoLastraid)

		end
	end
	-- only updating the list
	if display_raider[1] ~= nil then
		-- last raid frames
		for i = 1, #lastRaidRosterDKPAdjust do
			if display_lastraid[i] == nil then ReloadUI() end
			display_lastraid_fontstring[i]:SetText(lastRaidRosterDKPAdjust[i])
			display_lastclass_fontstring[i]:SetText(lastRaidRosterClassesDKPAdjust[i])
			display_lastcount_fontstring[i]:SetText(i)

			-- class colors
			if lastRaidRosterClassesDKPAdjust[i] == "Rogue" then
				display_lastclass_fontstring[i]:SetTextColor(1, 1, 0, 1)
			elseif lastRaidRosterClassesDKPAdjust[i] == "Warrior" then
				display_lastclass_fontstring[i]:SetTextColor(153/255, 76/255, 0, 1)
			elseif lastRaidRosterClassesDKPAdjust[i] == "Mage" then
				display_lastclass_fontstring[i]:SetTextColor(0/255, 128/255, 255, 1)
			elseif lastRaidRosterClassesDKPAdjust[i] == "Warlock" then
				display_lastclass_fontstring[i]:SetTextColor(178/255, 102/255, 1, 1)
			elseif lastRaidRosterClassesDKPAdjust[i] == "Priest" then
				display_lastclass_fontstring[i]:SetTextColor(1, 1, 1, 1)
			elseif lastRaidRosterClassesDKPAdjust[i] == "Hunter" then
				display_lastclass_fontstring[i]:SetTextColor(0, 1, 0, 1)
			elseif lastRaidRosterClassesDKPAdjust[i] == "Druid" then
				display_lastclass_fontstring[i]:SetTextColor(1, 153/255, 51/255, 1)
			elseif lastRaidRosterClassesDKPAdjust[i] == "Paladin" then
				display_lastclass_fontstring[i]:SetTextColor(1, 0, 1, 1)
			end

		end
		-- the entire roster
		for i = 1, #rosterNames do
			if display_raider[i] == nil then ReloadUI() end
			display_raider_fontstring[i]:SetText(rosterNames[i])
			display_dkp_fontstring[i]:SetText(rosterDetails[rosterNames[i]]["DKP"])
			display_class_fontstring[i]:SetText(rosterDetails[rosterNames[i]]["class"])
			display_attendance_fontstring[i]:SetText(string.format("%.2f %%", rosterDetails[rosterNames[i]]["attendance_percentage"]))			
			display_count_fontstring[i]:SetText(i)

			if #rosterDetails[rosterNames[i]]["alts"] == 0 then
				display_alts_fontstring[i]:SetText("---")
			elseif #rosterDetails[rosterNames[i]]["alts"] == 1 then
				display_alts_fontstring[i]:SetText(rosterDetails[rosterNames[i]]["alts"][1])
			elseif #rosterDetails[rosterNames[i]]["alts"] >= 2 then
				display_alts_fontstring[i]:SetText(rosterDetails[rosterNames[i]]["alts"][1] .. " etc.")
			end
			-- class colors
			if rosterDetails[rosterNames[i]]["class"] == "Rogue" then
				display_class_fontstring[i]:SetTextColor(1, 1, 0, 1)
			elseif rosterDetails[rosterNames[i]]["class"] == "Warrior" then
				display_class_fontstring[i]:SetTextColor(153/255, 76/255, 0, 1)
			elseif rosterDetails[rosterNames[i]]["class"] == "Mage" then
				display_class_fontstring[i]:SetTextColor(0/255, 128/255, 255, 1)
			elseif rosterDetails[rosterNames[i]]["class"] == "Warlock" then
				display_class_fontstring[i]:SetTextColor(178/255, 102/255, 1, 1)
			elseif rosterDetails[rosterNames[i]]["class"] == "Priest" then
				display_class_fontstring[i]:SetTextColor(1, 1, 1, 1)
			elseif rosterDetails[rosterNames[i]]["class"] == "Hunter" then
				display_class_fontstring[i]:SetTextColor(0, 1, 0, 1)
			elseif rosterDetails[rosterNames[i]]["class"] == "Druid" then
				display_class_fontstring[i]:SetTextColor(1, 153/255, 51/255, 1)
			elseif rosterDetails[rosterNames[i]]["class"] == "Paladin" then
				display_class_fontstring[i]:SetTextColor(1, 0, 1, 1)
			end

		end
		if rosterNames[1] == nil then
			for i = 1, #display_raider do
				display_raider_fontstring[i]:SetText("")
				display_dkp_fontstring[i]:SetText("")
				display_class_fontstring[i]:SetText("")	
				display_alts_fontstring[i]:SetText("")
				display_attendance_fontstring[i]:SetText("")
				display_count_fontstring[i]:SetText("")

			end
		end

	end
end

function CreateTitles()
	display_count_title:SetPoint("LEFT", AAAUI.TitleBg, "LEFT", count_x, 0)
	display_count_title:SetText(#rosterNames)
	display_name_title:SetPoint("LEFT", AAAUI.TitleBg, "LEFT", raider_x, 0)
	display_name_title:SetText("Raider")
	display_dkp_title:SetPoint("LEFT", AAAUI.TitleBg, "LEFT", dkp_x, 0)
	display_dkp_title:SetText("DKP")
	display_class_title:SetPoint("LEFT", AAAUI.TitleBg, "LEFT", class_x, 0)
	display_class_title:SetText("Class")
	display_alt_title:SetPoint("LEFT", AAAUI.TitleBg, "LEFT", alts_x, 0)
	display_alt_title:SetText("Alts")
	display_attendance_title:SetPoint("LEFT", AAAUI.TitleBg, "LEFT", attendance_x, 0)
	display_attendance_title:SetText("Attendance, %")
	display_lastname_title:SetPoint("LEFT", AAAUI.TitleBg, "LEFT", lastraider_x, 0)
	display_lastname_title:SetText("Last raid roster")
	display_lastclass_title:SetPoint("LEFT", AAAUI.TitleBg, "LEFT", lastclass_x, 0)
	display_lastclass_title:SetText("Class")
	display_lastcount_title:SetPoint("LEFT", AAAUI.TitleBg, "LEFT", lastcount_x, 0)
	display_lastcount_title:SetText(#lastRaidRosterDKPAdjust .. "/" .. #lastRaidRoster)
end

function Initialize()
	if changelog_DKP == nil then changelog_DKP = {} end
	if changelog_items == nil then changelog_items = {} end
	if rosterNames == nil then rosterNames = {} end
	print("initialize done")
end

AAAUI:RegisterEvent("PLAYER_ENTERING_WORLD")
AAAUI:HookScript("OnEvent", CreateTitles)
AAAUI:HookScript("OnEvent", RefreshRoster)
AAAUI:HookScript("OnEvent", Initialize)