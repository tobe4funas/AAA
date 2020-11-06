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
	playerInfo["attendance_starting"] = attendance_total
	playerInfo["attendance_total"] = 0
	playerInfo["attendance_percentage"] = 0
	playerInfo["guild_status"] = "Trial"
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

function ExportRoster(database, guildRoster)
	CalculateAttendance()
	local export_string_in_progress = guildRoster[1] .. " " .. database[guildRoster[1]]["DKP"] .. " " .. database[guildRoster[1]]["class"] .. " " .. database[guildRoster[1]]["guild_status"] .. " " .. database[guildRoster[1]]["attendance_percentage"] .. " " .. database[guildRoster[1]]["attendance_total"]
	for i = 2, #guildRoster do
		export_string_in_progress = export_string_in_progress .. "\n" .. guildRoster[i] .. " " .. database[guildRoster[i]]["DKP"] .. " " .. database[guildRoster[i]]["class"] .. " " .. database[guildRoster[i]]["guild_status"] .. " " .. database[guildRoster[i]]["attendance_percentage"] .. " " .. database[guildRoster[i]]["attendance_total"]
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
	if rosterDetails[playerName] ~= nil then
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
	else print("Incorrect name.")
	end
end

function UpdateAttendance()
	local is_an_alt = nil
	local main_character_name = nil
	attendance_total = attendance_total + 1
	for i = 1, #rosterRaidClone do
		is_an_alt, main_character_name = IsAnAlt(rosterRaidClone[i])
		if is_an_alt == false then
			rosterDetails[rosterRaidClone[i]]["attendance_total"] = rosterDetails[rosterRaidClone[i]]["attendance_total"] + 1
		else 
			rosterDetails[main_character_name]["attendance_total"] = rosterDetails[main_character_name]["attendance_total"] + 1
		end
	end
	for i = 1, #rosterGuild do
		local is_an_alt = IsAnAlt(rosterGuild[i])
		if is_an_alt == false then
			rosterDetails[rosterGuild[i]]["attendance_percentage"] = rosterDetails[rosterGuild[i]]["attendance_total"] / (attendance_total - rosterDetails[rosterGuild[i]]["attendance_starting"]) * 100
			local num = rosterDetails[rosterGuild[i]]["attendance_percentage"]
			rosterDetails[rosterGuild[i]]["attendance_percentage"] = RoundNumbers(num, 0)
		end
	end
end

function CalculateAttendance()
	for i = 1, #rosterGuild do
		local is_an_alt = IsAnAlt(rosterGuild[i])
		if is_an_alt == false then
			rosterDetails[rosterGuild[i]]["attendance_percentage"] = rosterDetails[rosterGuild[i]]["attendance_total"] / (attendance_total - rosterDetails[rosterGuild[i]]["attendance_starting"]) * 100
			local num = rosterDetails[rosterGuild[i]]["attendance_percentage"]
			rosterDetails[rosterGuild[i]]["attendance_percentage"] = RoundNumbers(num, 0)
		end
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
		local is_an_alt, main_character_name = IsAnAlt(rosterRaidClone[i])
		if is_an_alt == false then
			rosterDetails[rosterRaidClone[i]]["DKP"] = rosterDetails[rosterRaidClone[i]]["DKP"] + number
			changelog_dkp[#changelog_dkp + 1] = rosterRaidClone[i] .. " " .. number .. " " .. reason
		else 
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
	local is_in_raid = IsInRaidRoster(playerName)
	if is_in_raid == false then
		table.insert(rosterRaid, playerName)
		UpdateDisplay(true)
	end
end

function OpenAAAFrame()
	AAAUI:Show()
end

function RoundNumbers(number)
	number = math.floor(number)
	number = number / 10
	number = math.floor(number)
	number = number * 10
	return number
end

function ImportDKPFromSheet(list)
	if list ~= nil then 
	    local list_names = { }
	    local list_dkp = {}
	    for x in string.gmatch(list, "(%a+)") do
			table.insert(list_names, x)
		end
		for y in string.gmatch(list, "(%d+)") do
			table.insert (list_dkp, y)
	    end

	    for i = 1, #rosterGuild do
	    	for j = 1, #list_names do
	    		if rosterGuild[i] == list_names[j] then
	    			rosterDetails[rosterGuild[i]]["DKP"] = tonumber(list_dkp[j])
	    		end
	    	end
	    end
	    test_variable = list_names
    	UpdateDisplay()
    	print("Import complete.")
	else print("Nothing to import.")
	end
end

-- sitas visiskai dar neveikia
function CalculateHighestBid(list, bids)
	local winners = {}
	local winning_bid = 10
	local index = nil
	for i = 1, #list do
		if bids[list[i]] > winning_bid then
			winners = {}
			winners[1] = list[i]
			winning_bid = bids[list[i]]
			index = i
		elseif bids[list[i]] == winning_bid then
			table.insert(winners, list[i])
		end
	end
	-- jeigu yra tik 1 laimetojas, o dalyviu buvo daugiau nei 1, tai sumoket DKP maziau turi nei bidino
	if winners[2] == nil then
		local second_highest_bidder = nil
		local second_highest_bid = 10
		for i = 1, #list do
			if bids[list[i]] > second_highest_bid and index ~= i then
				second_highest_bid = bids[list[i]]
			end
		end
		winning_bid = second_highest_bid + 10
	end
	return winners, winning_bid
end

function CalculateWinner(MSbidders, OSbidders, MSfreeloaders, OSfreeloaders, bidders_bids)
	local winners = {}
	local winning_bid = 20
	if MSbidders[1] ~= nil then
		winners, winning_bid = CalculateHighestBid(MSbidders, bidders_bids)
	elseif MSfreeloaders[1] ~= nil then
	 	winners, winning_bid = CalculateHighestBid(MSfreeloaders, bidders_bids)
	elseif OSbidders[1] ~= nil then
	 	winners, winning_bid = CalculateHighestBid(OSbidders, bidders_bids)
	elseif OSfreeloaders[1] ~= nil then
	 	winners, winning_bid = CalculateHighestBid(OSfreeloaders, bidders_bids)
	end
	return winners, winning_bid
end

function IsBidEligible(playerName, bidding_round, new_bid, BiddingOnHold)
	local is_an_alt = IsAnAlt(playerName)
	local DKP = GetDKP(playerName)
	local playerName_rank = GetGuildRank(playerName)
	local is_all_in = false
	local reason = nil
	local is_bid_MSeligible = false
	local is_bid_OSeligible = false
	local is_bid_MSbimbo_eligible = false
	local is_bid_OSbimbo_eligible = false
	if new_bid < DKP then new_bid = RoundNumbers(new_bid)
	elseif new_bid == DKP then is_all_in = true end
	-- ar isvis priimu bid?
	if BiddingOnHold == false then
		if DKP >= new_bid and new_bid >= 20 and string.lower(bidding_round) == "!ms" and (playerName_rank == "Officer" or playerName_rank == "Guardian" or playerName_rank == "Member") then
			is_bid_MSeligible = true
			reason = "your " .. new_bid .. " DKP MS bid was taken in. You have a total of " .. DKP .. " DKP."
		elseif DKP >= new_bid and new_bid >= 20 and string.lower(bidding_round) == "!os" then
			is_bid_OSeligible = true
			reason = "your " .. new_bid .. " DKP OS bid was taken in. You have a total of " .. DKP .. " DKP."
		elseif DKP < 20 and string.lower(bidding_round) == "!ms" and (playerName_rank == "Officer" or playerName_rank == "Guardian" or playerName_rank == "Member") then
			is_bid_MSbimbo_eligible = true
			reason = "your 20 DKP MS bid was taken in. You have a total of " .. DKP .. " DKP."
		elseif DKP < 20 and string.lower(bidding_round) == "!os" then
			is_bid_OSbimbo_eligible = true
			reason = "your 20 DKP OS bid was taken in. You have a total of " .. DKP .. " DKP."
		elseif string.lower(bidding_round) == "!ms" and playerName_rank ~= "Officer" and playerName_rank ~= "Guardian" and playerName_rank ~= "Member" then
			reason = "alts & trials are only allowed to bid via !OS."
		elseif DKP < new_bid then
			reason = "insufficient DKP, you have a total of " .. DKP .. " DKP."
		else reason = "well, this is an error and I frankly have no idea what kind of. Ask in Discord for help I suppose..."
		end
	end
	return is_bid_MSeligible, is_bid_OSeligible, is_bid_MSbimbo_eligible, is_bid_OSbimbo_eligible, reason
end

function ChangeGuildStatus(playerName, new_status)
	rosterDetails[playerName]["guild_status"] = new_status
end

function IsInList(list, playerName)
	local is_in_list = false
	for i = 1, #list do
		if list[i] == playerName then
			is_in_list = true
			break
		end
	end
	return is_in_list
end

