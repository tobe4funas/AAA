function IsAnAlt(playerName)
	local is_an_alt = false
	local main_char_name = nil
	if rosterDetails[playerName]["is_an_alt"] == true then
		is_an_alt = true
		main_char_name = rosterDetails[playerName]["main"]
	end
	return is_an_alt, main_char_name
end

function IsGuildMember(playerName)
	local is_guild_member = false
	for i = 1, GetNumGuildMembers() do
		if playerName == string.gsub(GetGuildRosterInfo(i), "-Noggenfogger", "") then 
			is_guild_member = true
			break
		end
	end
	return is_guild_member
end

function IsInRaidRoster(playerName)
	local is_in_raid_roster = false
	if rosterRaid ~= nil then 
		for i = 1, #rosterRaid do
			if playerName == rosterRaid[i] then
				is_in_raid_roster = true
				break
			end
		end
	end
	return is_in_raid_roster
end

function IsInGuildRoster(playerName)
	local is_in_guild_roster = false
	if rosterGuild ~= nil then
		for i = 1, #rosterGuild do
			if playerName == rosterGuild[i] then
				is_in_guild_roster = true
				break
			end
		end
	if rosterDetails[playerName] ~= nil then is_in_guild_roster = true end
	end
	return is_in_guild_roster
end

function UpdateRoster(database, guildRoster, playerName, class, attendance_starting)
	local playerInfo = {}
	playerInfo["class"] = class
	playerInfo["DKP"] = 0
	playerInfo["alts"] = {}
	playerInfo["is_an_alt"] = false
	playerInfo["main"] = ""
	playerInfo["attendance_starting"] = attendance_starting
	playerInfo["attendance_total"] = 0
	playerInfo["attendance_percentage"] = 0
	if guildRoster == nil then guildRoster[1] = playerName
	else guildRoster[#guildRoster + 1] = playerName
	end
	database[playerName] = playerInfo
	return guildRoster, database[playerName]
end

function SortList(database, list)
	sorted_list = {}
	for i = 1, #list do
		if database[list[i]]["class"] == "Warrior" then
			sorted_list[#sorted_list + 1] = list[i]
		end
	end
	for i = 1, #list do
		if database[list[i]]["class"] == "Rogue" then
			sorted_list[#sorted_list + 1] = list[i]
		end
	end
	for i = 1, #list do
		if database[list[i]]["class"] == "Hunter" then
			sorted_list[#sorted_list + 1] = list[i]
		end
	end
	for i = 1, #list do
		if database[list[i]]["class"] == "Mage" then
			sorted_list[#sorted_list + 1] = list[i]
		end
	end
	for i = 1, #list do
		if database[list[i]]["class"] == "Warlock" then
			sorted_list[#sorted_list + 1] = list[i]
		end
	end
	for i = 1, #list do
		if database[list[i]]["class"] == "Priest" then
			sorted_list[#sorted_list + 1] = list[i]
		end
	end
	for i = 1, #list do
		if database[list[i]]["class"] == "Paladin" then
			sorted_list[#sorted_list + 1] = list[i]
		end
	end
	for i = 1, #list do
		if database[list[i]]["class"] == "Druid" then
			sorted_list[#sorted_list + 1] = list[i]
		end
	end
	return sorted_list
end

function CloneList(list)
	list = SortList(rosterDetails, list)
	local cloned_list = {}	
	for i = 1, #list do
		cloned_list[i] = list[i]
	end
	return cloned_list
end

function SaveRaid(database, guildRoster)
	local raidRoster = {}
	local raidRosterClone = {}
	for i = 1, 40 do
		-- jeigu raid roster maziau nei 40 zmoniu, tai breakinu
		if GetRaidRosterInfo(i) == nil then break end
		local playerName, _, _, _, class = GetRaidRosterInfo(i)
		-- patikrinu ar zmogus yra guilde
		local is_in_guild = IsGuildMember(playerName)
		-- jei taip, pridedu i raid rosteri
		if is_in_guild == true then
			raidRoster[#raidRoster + 1] = playerName
		-- patikrinu ar jau zmogus yra rosteryje
			local is_in_guild_roster = IsInGuildRoster(playerName)
		-- jei ne, pridedu i guild rosteri
			if is_in_guild_roster == false then
				guildRoster, database[playerName] = UpdateRoster(database, guildRoster, playerName, class, attendance_total)
			end
		end
	end
	raidRoster = SortList(database, raidRoster)
	guildRoster = SortList(database, guildRoster)
	raidRosterClone = CloneList(raidRoster)
	return raidRoster, guildRoster, raidRosterClone
end

function WeeklyDKPDecay(database, roster, changelog)
	for i = 1, #roster do
		database[roster[i]]["DKP"] = database[roster[i]]["DKP"] - 10
		changelog[#changelog + 1] = roster[i] .. " -10 Weekly decay"
	end
	UpdateDisplay(false)
end

function PopupWeeklyDKPDecay()
	StaticPopup_Show("CONFIRM_WEEKLY_DKP_DECAY")
end

StaticPopupDialogs["CONFIRM_WEEKLY_DKP_DECAY"] = {
text = "Apply weekly decay for everyone?",
button1 = "Accept",
button2 = "Cancel",
OnAccept = function()
WeeklyDKPDecay(rosterDetails, rosterGuild, changelog_dkp)
end,
timeout = 0,
whileDead = true,
hideOnEscape = true,
preferredIndex = 3,
}

function ExportChangelog(changelog)
	local export_string_in_progress = changelog[1]
	for i = 2, #changelog do
		export_string_in_progress = export_string_in_progress .. "\n" .. changelog[i]
	end
	export_string = tostring(export_string_in_progress)
	CreateExportString(export_string)
end

function MemberStatus(playerName)
	local playerName_rank = nil
	local member_status = nil
	for i = 1, GetNumGuildMembers() do
		local guild_name, guild_rank = GetGuildRosterInfo(i)
		if string.gsub(guild_name, "-Noggenfogger", "") == playerName then playerName_rank = guild_rank break end
	end
	if playerName_rank == "Trial" or playerName_rank == "Alt/Social" then member_status = "Trial"
	elseif rosterDetails[playerName]["attendance_percentage"] >= 75 then member_status = "Core"
	else member_status = "Casual"
	end
	return member_status
end

function ExportRoster(database, guildRoster)
	local member_status = MemberStatus(guildRoster[1])
	local export_string_in_progress = guildRoster[1] .. " " .. database[guildRoster[1]]["DKP"] .. " " .. database[guildRoster[1]]["class"] .. " " .. member_status .. " " .. database[guildRoster[1]]["attendance_percentage"] .. " " .. database[guildRoster[1]]["attendance_total"]
	for i = 2, #guildRoster do
		member_status = MemberStatus(guildRoster[i])
		export_string_in_progress = export_string_in_progress .. "\n" .. guildRoster[i] .. " " .. database[guildRoster[i]]["DKP"] .. " " .. database[guildRoster[i]]["class"] .. " " .. member_status .. " " .. database[guildRoster[i]]["attendance_percentage"] .. " " .. database[guildRoster[i]]["attendance_total"]
	end
	export_string = tostring(export_string_in_progress)
	CreateExportString(export_string)
end

--cia tas editbox template or smthing kur viska rodysiu
function CreateExportString(text)
	local Export = CreateFrame("ScrollFrame", nil, UIParent, "UIPanelScrollFrameTemplate")
	Export:SetSize(300,200)
	Export:SetPoint("CENTER")
	local ExportEditBox = CreateFrame("EditBox", nil, Export)
	ExportEditBox:SetMultiLine(true)
	ExportEditBox:SetFontObject(ChatFontNormal)
	ExportEditBox:SetWidth(300)
	Export:SetScrollChild(ExportEditBox)
	ExportEditBox:HighlightText()
	ExportEditBox:SetText(text)
	ExportEditBox:SetScript("OnEscapePressed", function()
	  Export:Hide()
	end)
end

function GetListIndex(list, name)
	local index = nil
	for i = 1, #list do
		if list[i] == name then
			index = i
			break
		end
	end
	return index
end

function GetDKP(playerName)
	local is_an_alt = IsAnAlt(playerName)
	local DKP = nil
	if is_an_alt == true then
		local main_character_name = rosterDetails[playerName]["main"]
		DKP = rosterDetails[main_character_name]["DKP"]
	else DKP = rosterDetails[playerName]["DKP"]
	end
	return tonumber(DKP)
end

function RemoveRaid(playerName)
	for i = 1, #rosterRaidClone do
		if playerName == rosterRaidClone[i] then
			table.remove(rosterRaidClone, i)
		end
	end
	UpdateDisplay(false)
end

function RemoveGuild(playerName)
	for i = 1, #rosterGuild do
		if playerName == rosterGuild[i] then
			rosterDetails[playerName] = nil
			table.remove(rosterGuild, i)
		end
	end
	UpdateDisplay()
end

function MakeAnAlt(playerName, main_character_name)
	local alt_count = #rosterDetails[main_character_name]["alts"] + 1
	rosterDetails[playerName]["is_an_alt"] = true
	rosterDetails[playerName]["main"] = main_character_name
	table.insert(rosterDetails[main_character_name]["alts"], alt_count, playerName)
	for i = 1, #rosterGuild do
		if rosterGuild[i] == playerName
			then index = i
			break
		end
	end
	table.remove(rosterGuild, index)
	UpdateDisplay(false)
end

function RoundNumbers(num, decimals)
	local mult = 10^(decimals)
	return math.floor(num * mult + 0.5) / mult
end

function UpdateAttendance()
	attendance_total = attendance_total + 1
	for i = 1, #rosterRaidClone do
		rosterDetails[rosterRaidClone[i]]["attendance_total"] = rosterDetails[rosterRaidClone[i]]["attendance_total"] + 1
	end
	for i = 1, #rosterGuild do
		rosterDetails[rosterGuild[i]]["attendance_percentage"] = rosterDetails[rosterGuild[i]]["attendance_total"] / (attendance_total - rosterDetails[rosterGuild[i]]["attendance_starting"]) * 100
		local num = rosterDetails[rosterGuild[i]]["attendance_percentage"]
		rosterDetails[rosterGuild[i]]["attendance_percentage"] = RoundNumbers(num, 0)
	end
end

function AdjustPersonDKP(playerName, number, reason)
	if reason == nil then reason = "Manual DKP adjust" end
	local is_an_alt, main_character_name = IsAnAlt(playerName)
	if is_an_alt == false then
		rosterDetails[playerName]["DKP"] = rosterDetails[playerName]["DKP"] + number	
	else rosterDetails[main_character_name]["DKP"] = rosterDetails[main_character_name]["DKP"] + number
	end
	changelog_items[#changelog_items + 1] = playerName .. " " .. number .. " " .. reason
	UpdateDisplay(false)
end

function AdjustRaidDKP(number, reason)
	for i = 1, #rosterRaidClone do
		local is_an_alt = IsAnAlt(rosterRaidClone[i])
		if is_an_alt == false then
			rosterDetails[rosterRaidClone[i]]["DKP"] = rosterDetails[rosterRaidClone[i]]["DKP"] + number
			changelog_dkp[#changelog_dkp + 1] = rosterRaidClone[i] .. " " .. number .. " " .. reason
		else 
			local main_character_name = rosterDetails[rosterRaidClone[i]]["main"]
			rosterDetails[main_character_name]["DKP"] = rosterDetails[main_character_name]["DKP"] + number
			changelog_dkp[#changelog_dkp + 1] = main_character_name .. " " .. number .. " " .. reason
		end
	end
	if reason == "attendance" then UpdateAttendance() end
	AAAUI.editBox1:SetText("")
	AAAUI.editBox2:SetText("")
	AAAUI.editBox1:ClearFocus()
	AAAUI.editBox2:ClearFocus()
	UpdateDisplay(true)
end

function IsInList(playerName, list)
	local is_in_list = false
	for i = 1, #list do
		if playerName == list[i] then
			is_in_list = true
			break
		end
	end
	return is_in_list
end

function RefreshChangelogs(changelog)
	local changelog_backup = {}
	for i = 1, #changelog do
		changelog_backup[i] = changelog[i]
	end
	changelog = {}
	return changelog, changelog_backup
end

function GetGuildRank(playerName)
	local rank = nil
	for i = 1, GetNumGuildMembers() do
		-- local guildName = GetGuildRosterInfo(i)
		if playerName == string.gsub(GetGuildRosterInfo(i), "-Noggenfogger", "") then
			_, rank = GetGuildRosterInfo(i)
			break
		end
	end
	return rank
end

function AddToRaid(playerName)
	print(playerName)
	local is_in_raid = IsInRaidRoster(playerName)
	print(is_in_raid)
	if is_in_raid == false then
		table.insert(rosterRaid, playerName)
		UpdateDisplay(true)
	end
end

function OpenAAAFrame()
	AAAUI:Show()
end




