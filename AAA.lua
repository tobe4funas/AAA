print("You suck ass")

function SortRosterNames()
	local sortedRoster = {}
	if #rosterNames >= 1 then
		for i = 1, #rosterNames do
			if rosterDetails[rosterNames[i]]["class"] == "Warrior" then
				if #sortedRoster == nil then 
					sortedRoster[1] = rosterNames[i]
				else sortedRoster[#sortedRoster + 1] = rosterNames[i]
				end
			end
		end
		for i = 1, #rosterNames do
			if rosterDetails[rosterNames[i]]["class"] == "Rogue" then
				if #sortedRoster == nil then 
					sortedRoster[1] = rosterNames[i] 
				else sortedRoster[#sortedRoster + 1] = rosterNames[i] 
				end
			end
		end
		for i = 1, #rosterNames do
			if rosterDetails[rosterNames[i]]["class"] == "Hunter" then
				if #sortedRoster == nil then 
					sortedRoster[1] = rosterNames[i] 
				else sortedRoster[#sortedRoster + 1] = rosterNames[i] 
				end
			end
		end	
		for i = 1, #rosterNames do
			if rosterDetails[rosterNames[i]]["class"] == "Mage" then
				if #sortedRoster == nil then 
					sortedRoster[1] = rosterNames[i] 
				else sortedRoster[#sortedRoster + 1] = rosterNames[i] 
				end
			end
		end	
		for i = 1, #rosterNames do
			if rosterDetails[rosterNames[i]]["class"] == "Warlock" then
				if #sortedRoster == nil then 
					sortedRoster[1] = rosterNames[i] 
				else sortedRoster[#sortedRoster + 1] = rosterNames[i] 
				end
			end
		end	
		for i = 1, #rosterNames do
			if rosterDetails[rosterNames[i]]["class"] == "Priest" then
				if #sortedRoster == nil then 
					sortedRoster[1] = rosterNames[i] 
				else sortedRoster[#sortedRoster + 1] = rosterNames[i] 
				end
			end
		end	
		for i = 1, #rosterNames do
			if rosterDetails[rosterNames[i]]["class"] == "Paladin" then
				if #sortedRoster == nil then 
					sortedRoster[1] = rosterNames[i] 
				else sortedRoster[#sortedRoster + 1] = rosterNames[i] 
				end
			end
		end	
		for i = 1, #rosterNames do
			if rosterDetails[rosterNames[i]]["class"] == "Druid" then
				if #sortedRoster == nil then 
					sortedRoster[1] = rosterNames[i] 
				else sortedRoster[#sortedRoster + 1] = rosterNames[i] 
				end
			end
		end	
		rosterNames = sortedRoster
	end
end

function SortLastRaidRoster()
	local sortedRoster = {}
	local sortedRosterClasses = {}
	if #lastRaidRoster >= 1 then
		for i = 1, #lastRaidRoster do
			if lastRaidRosterClasses[i] == "Warrior" then
				if #sortedRoster == nil then 
					sortedRoster[1] = lastRaidRoster[i]
					sortedRosterClasses[1] = "Warrior"
				else sortedRoster[#sortedRoster + 1] = lastRaidRoster[i]
				sortedRosterClasses[#sortedRosterClasses + 1] = "Warrior"
				end
			end
		end
		for i = 1, #lastRaidRoster do
			if lastRaidRosterClasses[i] == "Rogue" then
				if #sortedRoster == nil then 
					sortedRoster[1] = lastRaidRoster[i]
					sortedRosterClasses[1] = "Rogue"
				else sortedRoster[#sortedRoster + 1] = lastRaidRoster[i]
				sortedRosterClasses[#sortedRosterClasses + 1] = "Rogue"
				end
			end
		end
		for i = 1, #lastRaidRoster do
			if lastRaidRosterClasses[i] == "Hunter" then
				if #sortedRoster == nil then 
					sortedRoster[1] = lastRaidRoster[i]
					sortedRosterClasses[1] = "Hunter"
				else sortedRoster[#sortedRoster + 1] = lastRaidRoster[i]
				sortedRosterClasses[#sortedRosterClasses + 1] = "Hunter"
				end
			end
		end
		for i = 1, #lastRaidRoster do
			if lastRaidRosterClasses[i] == "Mage" then
				if #sortedRoster == nil then 
					sortedRoster[1] = lastRaidRoster[i]
					sortedRosterClasses[1] = "Mage"
				else sortedRoster[#sortedRoster + 1] = lastRaidRoster[i]
				sortedRosterClasses[#sortedRosterClasses + 1] = "Mage"
				end
			end
		end
		for i = 1, #lastRaidRoster do
			if lastRaidRosterClasses[i] == "Warlock" then
				if #sortedRoster == nil then 
					sortedRoster[1] = lastRaidRoster[i]
					sortedRosterClasses[1] = "Warlock"
				else sortedRoster[#sortedRoster + 1] = lastRaidRoster[i]
				sortedRosterClasses[#sortedRosterClasses + 1] = "Warlock"
				end
			end
		end
		for i = 1, #lastRaidRoster do
			if lastRaidRosterClasses[i] == "Priest" then
				if #sortedRoster == nil then 
					sortedRoster[1] = lastRaidRoster[i]
					sortedRosterClasses[1] = "Priest"
				else sortedRoster[#sortedRoster + 1] = lastRaidRoster[i]
				sortedRosterClasses[#sortedRosterClasses + 1] = "Priest"
				end
			end
		end
		for i = 1, #lastRaidRoster do
			if lastRaidRosterClasses[i] == "Paladin" then
				if #sortedRoster == nil then 
					sortedRoster[1] = lastRaidRoster[i]
					sortedRosterClasses[1] = "Paladin"
				else sortedRoster[#sortedRoster + 1] = lastRaidRoster[i]
				sortedRosterClasses[#sortedRosterClasses + 1] = "Paladin"
				end
			end
		end
		for i = 1, #lastRaidRoster do
			if lastRaidRosterClasses[i] == "Druid" then
				if #sortedRoster == nil then 
					sortedRoster[1] = lastRaidRoster[i]
					sortedRosterClasses[1] = "Druid"
				else sortedRoster[#sortedRoster + 1] = lastRaidRoster[i]
				sortedRosterClasses[#sortedRosterClasses + 1] = "Druid"
				end
			end
		end
		
	end
	lastRaidRoster = sortedRoster
	lastRaidRosterClasses = sortedRosterClasses
end



function OpenAddonFrame()
	AAAUI:Show()
end

function SaveRaidRoster()
	lastRaidRoster = {}
	lastRaidRosterClasses = {}
	lastRaidRosterDKPAdjust = {}
	lastRaidRosterClassesDKPAdjust = {}
	for i = 1, 40 do
		if GetRaidRosterInfo(i) == nil then
			break
		end
		local name, rank, subgroup, level, class = GetRaidRosterInfo(i)
			for j = 1, GetNumGuildMembers() do
				fullName = GetGuildRosterInfo(j)
				shortName = string.gsub(fullName, "-Noggenfogger", "")
				if shortName == name then
					lastRaidRoster[i] = name
					lastRaidRosterClasses[i] = class
				end
			end
	end
	SortLastRaidRoster()
	RosterUpdate()
	lastRaidRosterDKPAdjust = lastRaidRoster
	lastRaidRosterClassesDKPAdjust = lastRaidRosterClasses
end

function RosterUpdate()
	if rosterNames == nil then rosterNames = {}
	end
	-- check if the person is still in the guild
	for i = 1, #rosterNames do
		local name_is_in_roster = false
		for j = 1, GetNumGuildMembers() do
			local fullName = GetGuildRosterInfo(j)
			 local shortName = string.gsub(fullName, "-Noggenfogger", "")
			if rosterNames[i] == shortName then
				name_is_in_roster = true
			end
		end
		if name_is_in_roster == false then
			print(rosterNames[i] .. " has left the guild.")
			table.remove(rosterDetails[rosterNames[i]])
			table.remove(rosterNames, i)
		end
	end
	-- actually update the roster
	for i = 1, #lastRaidRoster do
		if rosterDetails[lastRaidRoster[i]] == nil then
			local duplicate = false
			for j=1, #rosterNames do
				if lastRaidRoster[i] == rosterNames[j] 
					then
					duplicate = true
				end
			end
			if duplicate == false then
				playerInfo = {lastRaidRoster[i]}
				playerInfo["class"] = lastRaidRosterClasses[i]
				playerInfo["DKP"] = 0
				playerInfo["alts"] = {}
				playerInfo["is_an_alt"] = false
				playerInfo["main"] = ""
				playerInfo["attendance_starting"] = attendance_total
				playerInfo["attendance_total"] = 0
				playerInfo["attendance_percentage"] = 0
				rosterNames[#rosterNames + 1] = lastRaidRoster[i]
				if rosterDetails == nil then
					rosterDetails = {}
				end
				rosterDetails[lastRaidRoster[i]] = playerInfo
			end
		end
	end
	SortRosterNames()
	RefreshRoster()
end

local export_string = ""

function DisplayChangelogItems()
	local export_string_in_progress = changelog_items[1]
	for i = 2, #changelog_items do
		export_string_in_progress = export_string_in_progress .. "\n" .. changelog_items[i]
	end
	export_string = tostring(export_string_in_progress)
	CreateExportShit()
end

function DisplayChangelogDKP()
	local export_string_in_progress = changelog_dkp[1]
	for i = 2, #changelog_dkp do
		export_string_in_progress = export_string_in_progress .. "\n" .. changelog_dkp[i]
	end
	export_string = tostring(export_string_in_progress)
	CreateExportShit()
end



--cia tas editbox template or smthing kur viska rodysiu
function CreateExportShit()
	-- this part works for sure, just lacking some background
	local Export = CreateFrame("ScrollFrame", nil, UIParent, "UIPanelScrollFrameTemplate") -- or you actual parent instead
	Export:SetSize(300,200)
	Export:SetPoint("CENTER")
	local ExportEditBox = CreateFrame("EditBox", nil, Export)
	ExportEditBox:SetMultiLine(true)
	ExportEditBox:SetFontObject(ChatFontNormal)
	ExportEditBox:SetWidth(300)
	Export:SetScrollChild(ExportEditBox)
	ExportEditBox:HighlightText() -- select all (if to be used for copy paste)
	ExportEditBox:SetText(export_string)
	ExportEditBox:SetScript("OnEscapePressed", function()
	  Export:Hide()
	end)
end





