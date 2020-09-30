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

local menuFrame = CreateFrame("Frame", "ExampleMenuFrame", UIParent, "UIDropDownMenuTemplate")

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
local lastraider_x = 545
local lastclass_x = 670




function GetClassColorText(playerName, database)
	local r, g, b, t = 0
	if database[playerName]["class"] == "Rogue" then
		r = 1; g = 1; b = 0; t = 1
	elseif database[playerName]["class"] == "Warrior" then
		r = 153/255; g = 76/255; b = 0; t = 1
	elseif database[playerName]["class"] == "Mage" then
		r = 0; g = 128/255; b = 255; t = 1
	elseif database[playerName]["class"] == "Warlock" then
		r = 178/255; g = 102/255; b = 1; t = 1
	elseif database[playerName]["class"] == "Priest" then
		r = 1; g = 1; b = 1; t = 1
	elseif database[playerName]["class"] == "Druid" then
		r = 1; g = 153/255; b = 51/255; t = 1
	elseif database[playerName]["class"] == "Paladin" then
		r = 1; g = 0; b = 1; t = 1
	elseif database[playerName]["class"] == "Hunter" then
		r = 0; g = 1; b = 0; t = 1
	end
	return r, g, b, t
end

function PopupWipeDKP()
	StaticPopup_Show("WIPE_DKP")
end

function WipeShit()
	changelog_dkp = {}
	changelog_items = {}
	for i = 1, #rosterGuild do
		rosterDetails[rosterGuild[i]]["DKP"] = 0
	end
	UpdateDisplay(false)
end

StaticPopupDialogs["WIPE_DKP"] = {
  text = "You sure you want to wipe DKP & roster?",
	button1 = "Accept",
	button2 = "Cancel",
	timeout = 0,
	hideOnEscape = true,
	OnAccept = WipeShit,
	whileDead = true,
	preferredIndex = 3,
}



function PopupRemoveGuild(playerName)
	local popup = StaticPopup_Show("CHANGE_ROSTER_GUILD", playerName)
	popup.data = playerName
end

function PopupMakeAnAlt(playerName)
	local popup = StaticPopup_Show("MAKE_AN_ALT", playerName)
	popup.data = playerName
end

function PopupDKP(playerName)
	local popup = StaticPopup_Show("ADJUST_DKP", playerName)
	popup.data = playerName
end

StaticPopupDialogs["ADJUST_DKP"] = {
  text = "What to do with %s's DKP?",
	button1 = "Accept",
	button2 = "Cancel",
	timeout = 0,
	hideOnEscape = true,
	OnShow = function (self, playerName)
    	self.editBox:SetText("")   
	end,
	OnAccept = function(self, playerName)
	local number = self.editBox:GetText()
		AdjustPersonDKP(playerName, number)
	end,
	hasEditBox = true,
	whileDead = true,
	preferredIndex = 3,
}

StaticPopupDialogs["MAKE_AN_ALT"] = {
  text = "Whose alt should %s be?",
	button1 = "Accept",
	button2 = "Cancel",
	timeout = 0,
	hideOnEscape = true,
	OnShow = function (self, data)
    	self.editBox:SetText("Main character's name")
    	self.editBox:SetScript("OnEscapePressed", function(self)
 self:GetParent():Hide()
end)  
	end,
	OnAccept = function(self, playerName)
		local main_character_name = self.editBox:GetText()
		MakeAnAlt(playerName, main_character_name)
	end,
	hasEditBox = true,
	whileDead = true,
	preferredIndex = 3,
}

StaticPopupDialogs["CHANGE_ROSTER_GUILD"] = {
  text = "Are you sure you want to remove %s?",
  	playerName = "%s",
	button1 = "Fuck yes",
	button2 = "Nope",
	OnAccept = function(self, playerName)
		RemoveGuild(playerName)
	end,
	timeout = 0,
	whileDead = true,
	hideOnEscape = true,
	preferredIndex = 3,
}

function ResetDisplay(guildRoster, raidRosterClone)
	for i = 1, #display_raider do
		display_raider_fontstring[i]:SetText("")
		display_dkp_fontstring[i]:SetText("")
		display_class_fontstring[i]:SetText("")
		display_alts_fontstring[i]:SetText("")
		display_attendance_fontstring[i]:SetText("")
		display_count_fontstring[i]:SetText("")
	end	
	for i = 1, #display_lastraid do
		display_lastraid_fontstring[i]:SetText("")
		display_lastclass_fontstring[i]:SetText("")
		display_lastcount_fontstring[i]:SetText("")	
	end
end

function UpdateDisplay(should_be_cloned)
	local guild_starting_height = -30
	local raid_starting_height = -30

	if should_be_cloned == true then rosterRaidClone = CloneList(rosterRaid) end
	if #rosterGuild > #display_raider or #rosterRaidClone > #display_lastraid then
		guild_starting_height = guild_starting_height - (#display_raider * 15)
		raid_starting_height = raid_starting_height - (#display_lastraid * 15)
		CreateDisplay(rosterDetails, rosterGuild, rosterRaid, rosterRaidClone, changelog_dkp, guild_starting_height, raid_starting_height)
	end
	ResetDisplay(rosterGuild, rosterRaidClone)
	RenderDisplay(rosterDetails, rosterGuild, rosterRaid, rosterRaidClone, guild_starting_height, raid_starting_height)
end


function RenderDisplay(database, guildRoster, raidRoster, raidRosterClone, guild_height, raid_height)
	for i = 1, #guildRoster do
		display_raider_fontstring[i]:SetText(guildRoster[i])
		display_dkp_fontstring[i]:SetText(database[guildRoster[i]]["DKP"])
		display_class_fontstring[i]:SetText(database[guildRoster[i]]["class"])
		display_attendance_fontstring[i]:SetText(database[guildRoster[i]]["attendance_percentage"] .. "%")
		display_count_fontstring[i]:SetText(i)

		local r, g, b, t = GetClassColorText(guildRoster[i], database)
		display_class_fontstring[i]:SetTextColor(r, g, b, t)

		if #database[guildRoster[i]]["alts"] == 0 then
			display_alts_fontstring[i]:SetText("---")
		elseif #database[guildRoster[i]]["alts"] == 1 then
			display_alts_fontstring[i]:SetText(database[guildRoster[i]]["alts"][1])
		elseif #database[guildRoster[i]]["alts"] >= 2 then
			display_alts_fontstring[i]:SetText(database[guildRoster[i]]["alts"][1] .. " etc...")
		end

	end
	for i = 1, #raidRosterClone do
		display_lastraid_fontstring[i]:SetText(raidRosterClone[i])
		display_lastclass_fontstring[i]:SetText(database[raidRosterClone[i]]["class"])
		display_lastcount_fontstring[i]:SetText(i)

		local r, g, b, t = GetClassColorText(raidRosterClone[i], database)
		display_lastclass_fontstring[i]:SetTextColor(r, g, b, t)
	end

	if raidRosterClone == nil then display_lastcount_title:SetText("0/0")
	else display_lastcount_title:SetText(#raidRosterClone .. "/" .. #raidRoster) end

end

function CreateDisplay(database, guildRoster, raidRoster, raidRosterClone, changelog, guild_height, raid_height)
	for i = 1, #guildRoster do
		-- pracheckinu ar reikia dar toki papildoma kurti
		if display_raider[i] == nil then
			display_raider[i] = CreateFrame("Button", nil, AAAUI.scrollchild)
			display_dkp[i] = CreateFrame("Button", nil, AAAUI.scrollchild)
			display_class[i] = CreateFrame("Button", nil, AAAUI.scrollchild)
			display_alts[i] = CreateFrame("Button", nil, AAAUI.scrollchild)
			display_attendance[i] = CreateFrame("Button", nill, AAAUI.scrollchild)
			display_count[i] = CreateFrame("Button", nil, AAAUI.scrollchild)
			
			display_raider[i]:SetHeight(13)
			display_dkp[i]:SetHeight(13)
			display_class[i]:SetHeight(13)
			display_alts[i]:SetHeight(13)
			display_attendance[i]:SetHeight(13)
			display_count[i]:SetHeight(13)		

			display_raider[i]:SetWidth(400)
			display_dkp[i]:SetWidth(50)
			display_class[i]:SetWidth(60)
			display_alts[i]:SetWidth(120)
			display_attendance[i]:SetWidth(80)
			display_count[i]:SetWidth(20)
			
			display_raider[i]:SetPoint("TOPLEFT", raider_x, guild_height)
			display_dkp[i]:SetPoint("TOPLEFT", dkp_x, guild_height)
			display_class[i]:SetPoint("TOPLEFT", class_x, guild_height)
			display_alts[i]:SetPoint("TOPLEFT", alts_x, guild_height)
			display_attendance[i]:SetPoint("TOPLEFT", attendance_x, guild_height)
			display_count[i]:SetPoint("TOPLEFT", count_x, guild_height)


			display_raider[i]:SetHighlightTexture("Interface/FriendsFrame/UI-FriendsFrame-HighlightBar", "ADD")
			
			display_raider_fontstring[i] = display_raider[i]:CreateFontString(AAAUI, "OVERLAY", "GameTooltipText")
			display_dkp_fontstring[i] = display_dkp[i]:CreateFontString(AAAUI, "OVERLAY", "GameTooltipText")
			display_class_fontstring[i] = display_class[i]:CreateFontString(AAAUI, "OVERLAY", "GameTooltipText")
			display_alts_fontstring[i] = display_alts[i]:CreateFontString(AAAUI, "OVERLAY", "GameTooltipText")
			display_attendance_fontstring[i] = display_attendance[i]:CreateFontString(AAAUI, "OVERLAY", "GameTooltipText")
			display_count_fontstring[i] = display_count[i]:CreateFontString(AAAUI, "OVERLAY", "GameTooltipText")

			display_raider_fontstring[i]:SetPoint("LEFT", 0, 0)
			display_dkp_fontstring[i]:SetPoint("LEFT", 0, 0)
			display_class_fontstring[i]:SetPoint("LEFT", 0, 0)
			display_alts_fontstring[i]:SetPoint("LEFT", 0, 0)
			display_attendance_fontstring[i]:SetPoint("LEFT", 0, 0)
			
			display_count_fontstring[i]:SetAllPoints(true)
			display_count_fontstring[i]:SetJustifyV("TOP")
			display_count_fontstring[i]:SetJustifyH("CENTER")

			display_raider_fontstring[i]:SetText(guildRoster[i])
			display_dkp_fontstring[i]:SetText(database[guildRoster[i]]["DKP"])
			display_class_fontstring[i]:SetText(database[guildRoster[i]]["class"])
			display_attendance_fontstring[i]:SetText(database[guildRoster[i]]["attendance_percentage"] .. "%")
			display_count_fontstring[i]:SetText(i)

			local r, g, b, t = GetClassColorText(guildRoster[i], database)
			display_class_fontstring[i]:SetTextColor(r, g, b, t)

			if #database[guildRoster[i]]["alts"] == 0 then
				display_alts_fontstring[i]:SetText("---")
			elseif #database[guildRoster[i]]["alts"] == 1 then
				display_alts_fontstring[i]:SetText(database[guildRoster[i]]["alts"][1])
			elseif #database[guildRoster[i]]["alts"] >= 2 then
				display_alts_fontstring[i]:SetText(database[guildRoster[i]]["alts"][1] .. " etc...")
			end

			guild_height = guild_height - 15

			function OnClickDoRemoveGuild()
				if display_raider_fontstring[i]:GetText() ~= nil then
				local playerName = display_raider_fontstring[i]:GetText()
				PopupRemoveGuild(playerName)
				end
			end

			function OnClickDoMakeAnAlt(i)
				if display_raider_fontstring[i]:GetText() ~= nil then
					local playerName = display_raider_fontstring[i]:GetText()
					PopupMakeAnAlt(playerName)
				end
			end

			function OnClickDoDKP(i)
				if display_dkp_fontstring[i]:GetText() ~= nil then
				local playerName = display_raider_fontstring[i]:GetText()
				PopupDKP(playerName)
				end
			end

			function OnClickDoAddRaid(i)
				if display_raider_fontstring[i]:GetText() ~= nil then
					local playerName = display_raider_fontstring[i]:GetText()
					AddToRaid(playerName)
				end
			end

			local menu = {
			    { text = guildRoster[i], isTitle = true},
			    { text = "Adjust DKP", func = function() OnClickDoDKP(i); end },
			    { text = "Make an Alt", func = function() OnClickDoMakeAnAlt(i); end },
			    { text = "Remove from roster", func = function() OnClickDoRemoveGuild(i); end },
			    { text = "Add to raid", func = function() OnClickDoAddRaid(i); end },
			}

			display_raider[i]:SetScript("OnClick", function()
				EasyMenu(menu, menuFrame, "cursor", 0 , 0, "MENU")
			end)
			

		end
	end

	for i = 1, #raidRosterClone do
		if display_lastraid[i] == nil then
			display_lastraid[i] = CreateFrame("Button", nill, AAAUI.scrollchild)
			display_lastclass[i] = CreateFrame("Button", nill, AAAUI.scrollchild)
			display_lastcount[i] = CreateFrame("Button", nill, AAAUI.scrollchild)

			display_lastraid[i]:SetHeight(13)
			display_lastclass[i]:SetHeight(13)
			display_lastcount[i]:SetHeight(13)

			display_lastraid[i]:SetWidth(180)
			display_lastclass[i]:SetWidth(60)
			display_lastcount[i]:SetWidth(60)

			display_lastraid[i]:SetPoint("TOPLEFT", lastraider_x, raid_height)
			display_lastclass[i]:SetPoint("TOPLEFT", lastclass_x, raid_height)
			display_lastcount[i]:SetPoint("TOPLEFT", lastcount_x, raid_height)

			display_lastraid[i]:SetHighlightTexture("Interface/FriendsFrame/UI-FriendsFrame-HighlightBar", "ADD")

			display_lastraid_fontstring[i] = display_lastraid[i]:CreateFontString(AAAUI, "OVERLAY", "GameTooltipText")
			display_lastclass_fontstring[i] = display_lastclass[i]:CreateFontString(AAAUI, "OVERLAY", "GameTooltipText")
			display_lastcount_fontstring[i] = display_lastcount[i]:CreateFontString(AAAUI, "OVERLAY", "GameTooltipText")

			display_lastraid_fontstring[i]:SetPoint("LEFT", 0, 0)
			display_lastclass_fontstring[i]:SetPoint("LEFT", 0, 0)

			display_lastcount_fontstring[i]:SetAllPoints(true)
			display_lastcount_fontstring[i]:SetJustifyV("TOP")
			display_lastcount_fontstring[i]:SetJustifyH("CENTER") 

			display_lastraid_fontstring[i]:SetText(raidRosterClone[i])
			display_lastclass_fontstring[i]:SetText(database[raidRosterClone[i]]["class"])
			display_lastcount_fontstring[i]:SetText(i)

			local r, g, b, t = GetClassColorText(raidRosterClone[i], database)
			display_lastclass_fontstring[i]:SetTextColor(r, g, b, t)

			raid_height = raid_height - 15

			function OnClickDoLastraid()
				if display_lastraid_fontstring[i]:GetText() ~= nil then
					local playerName = display_lastraid_fontstring[i]:GetText()
					RemoveRaid(playerName)
				end
			end
			display_lastraid[i]:SetScript("OnClick", OnClickDoLastraid)
		end
	end
end

function CreateTitles(guildRoster, raidRoster, raidRosterClone)
	display_count_title:SetPoint("LEFT", AAAUI.TitleBg, "LEFT", count_x, 0)
	if guildRoster == nil then display_count_title:SetText(0)
	else display_count_title:SetText(#guildRoster) end
	display_name_title:SetPoint("LEFT", AAAUI.TitleBg, "LEFT", raider_x, 0)
	display_name_title:SetText("Raider")
	display_dkp_title:SetPoint("LEFT", AAAUI.TitleBg, "LEFT", dkp_x, 0)
	display_dkp_title:SetText("DKP")
	display_class_title:SetPoint("LEFT", AAAUI.TitleBg, "LEFT", class_x, 0)
	display_class_title:SetText("Class")
	display_alt_title:SetPoint("LEFT", AAAUI.TitleBg, "LEFT", alts_x, 0)
	display_alt_title:SetText("Alts")
	display_attendance_title:SetPoint("LEFT", AAAUI.TitleBg, "LEFT", attendance_x, 0)
	display_attendance_title:SetText("Attendance")
	display_lastname_title:SetPoint("LEFT", AAAUI.TitleBg, "LEFT", lastraider_x, 0)
	display_lastname_title:SetText("Last raid roster")
	display_lastclass_title:SetPoint("LEFT", AAAUI.TitleBg, "LEFT", lastclass_x, 0)
	display_lastclass_title:SetText("Class")
	display_lastcount_title:SetPoint("LEFT", AAAUI.TitleBg, "LEFT", lastcount_x, 0)
	if raidRoster == nil then display_lastcount_title:SetText("0/0")
	else display_lastcount_title:SetText(#raidRosterClone .. "/" .. #raidRoster) end
end

function Initialize()
	if rosterDetails == nil then rosterDetails = {} end
	if rosterGuild == nil then rosterGuild = {} end
	if attendance_total == nil then attendance_total = 0 end
	if changelog_dkp == nil then changelog_dkp = {} end
	if changelog_items == nil then changelog_items = {} end
	if rosterRaid == nil then rosterRaidClone = {} 
	else rosterRaidClone = CloneList(rosterRaid) end
	print("AAA initialized.")
end

AAAUI:RegisterEvent("PLAYER_ENTERING_WORLD")
AAAUI:HookScript("OnEvent", Initialize)
AAAUI:HookScript("OnEvent", function()
	CreateTitles(rosterGuild, rosterRaid, rosterRaidClone)
end)
AAAUI:HookScript("OnEvent", function()
	CreateDisplay(rosterDetails, rosterGuild, rosterRaid, rosterRaidClone, changelog_dkp, -30, -30)
end)





