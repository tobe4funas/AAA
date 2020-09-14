local bidding_item = ""
local bidding_item_list = {}
local current_bid = 0
local highest_bidder = {}
local MSbidding_has_started = false
local OSbidding_has_started = false
local bidding_sequence_has_started = false


function RemoveDKP()
	if current_bid ~= 0 and rosterDetails[highest_bidder[1]]["is_an_alt"] == false then
		rosterDetails[highest_bidder[1]]["DKP"] = rosterDetails[highest_bidder[1]]["DKP"] - current_bid
		changelog_items[#changelog_items + 1] = highest_bidder[1] .. " " .. current_bid .. " " .. bidding_item
		SendChatMessage(highest_bidder[1] .. " has bought " .. bidding_item .. " for " .. current_bid .. " DKP.", "RAID")
	elseif current_bid ~= 0 and rosterDetails[highest_bidder[1]]["is_an_alt"] == true then
		local main_character_name = rosterDetails[highest_bidder[1]]["main"]
		rosterDetails[main_character_name]["DKP"] = rosterDetails[main_character_name]["DKP"] - current_bid
		changelog_items[#changelog_items + 1] = highest_bidder[1] .. "(" .. main_character_name .. ") " .. current_bid .. " " .. bidding_item
		SendChatMessage(rosterDetails[highest_bidder[1]]["main"] .. "(" .. highest_bidder[1] .. ")" .. " has bought " .. bidding_item .. " for " .. current_bid .. " DKP.", "RAID")
	end
	ContinueSequence2()
	RefreshRoster()
end

function BiddingCanceled()
	SendChatMessage("Bidding has been canceled.", "RAID")
end

StaticPopupDialogs["ACCEPT_DKP_CHANGES"] = {
  text = "Do you accept %s winning for %d DKP?",
	button1 = "Accept",
	button2 = "Cancel",
	OnAccept = RemoveDKP,
	OnCancel = BiddingCanceled,
	timeout = 0,
	whileDead = true,
	hideOnEscape = true,
	preferredIndex = 3,
}

function BiddingTimerHasEnded()
	if highest_bidder[1] ~= nil and highest_bidder[2] ~= nil then
		SendChatMessage("Bidding has ended! Rolling out for the highest bidders.", "RAID")
		local highest_value = 0
		local highest_bidder_roll = {}
		local winner = ""
		for i = 1, #highest_bidder do
			highest_bidder_roll[i] = math.random(1, 100)
			SendChatMessage(highest_bidder[i] .. " rolls for " .. highest_bidder_roll[i], "RAID")
			if highest_bidder_roll[i] > highest_value then
				highest_value = highest_bidder_roll[i]
				winner = highest_bidder[i]
			end
		end
		highest_bidder[1] = winner
		SendChatMessage("Winner is - " .. highest_bidder[1], "RAID")
		MSbidding_has_started = false
		OSbidding_has_started = false
		StaticPopup_Show("ACCEPT_DKP_CHANGES", highest_bidder[1], current_bid)
	elseif highest_bidder[1] ~=nil and highest_bidder[2] == nil then
		MSbidding_has_started = false
		OSbidding_has_started = false
		StaticPopup_Show("ACCEPT_DKP_CHANGES", highest_bidder[1], current_bid)
	elseif highest_bidder[1] == nil then
		if MSbidding_has_started == true then 
			SendChatMessage("Bidding has ended, " .. bidding_item .. " goes to OS next.", "RAID")
			MSbidding_has_started = false
			ContinueSequenceOS() 
		elseif OSbidding_has_started == true then 
			SendChatMessage("Bidding has ended, " .. bidding_item .. " will be disenchanted.", "RAID")
			ContinueSequence2() 
		end
		-- MSbidding_has_started = false
		-- OSbidding_has_started = false
	end
end

function BiddingTimerIsLeft()
	SendChatMessage("5 seconds left for bidding!", "RAID")
end

function YourDKP(self, event, text, playerName)
	local shortName_YourDKP = string.gsub(playerName, "-Noggenfogger", "")
	local text_command = text
	for i = 1, #rosterNames do
		if shortName_YourDKP == rosterNames[i] and text_command == "!dkp" then
			if rosterDetails[rosterNames[i]]["is_an_alt"] == false then
				SendChatMessage(shortName_YourDKP .. ", you have " .. rosterDetails[rosterNames[i]]["DKP"] .. " DKP.", "WHISPER", "Common", shortName_YourDKP)
			elseif rosterDetails[rosterNames[i]]["is_an_alt"] == true then
				local main_character_name = rosterDetails[rosterNames[i]]["main"]
				SendChatMessage(shortName_YourDKP .. ", you have " .. rosterDetails[rosterNames[i]["main"]]["DKP"] .. " DKP.", "WHISPER", "Common", shortName_YourDKP)
			end
		end
	end
end

function Bidding(self, event, text, playerName)
	local keywords = {}
	local j = 1
	if MSbidding_has_started == true or OSbidding_has_started == true then
		for words in text:gmatch("%S+") do
						keywords[j] = words
						j = j + 1	
		end
		if string.lower(keywords[1]) == "!bid" then
			if type(tonumber(keywords[2])) ~= "number" or keywords[3] ~= nil then
				SendChatMessage("Stop breaking my addon you dum dum, you're supposed to whisper me '!bid amount', where amount is DKP number", "WHISPER", "Common", playerName)
			elseif type(tonumber(keywords[2])) == "number" and keywords[3] == nil then
				local new_bid = tonumber(keywords[2])
				local new_bidder = string.gsub(playerName, "-Noggenfogger", "")
				local new_bidder_rank = ""
				for i = 1, GetNumGuildMembers() do
					local guild_name, guild_rank = GetGuildRosterInfo(i)
					if string.gsub(guild_name, "-Noggenfogger", "") == new_bidder then new_bidder_rank = guild_rank break end
				end
				if (MSbidding_has_started == true and (new_bidder_rank == "Guardian" or new_bidder_rank == "Officer" or new_bidder_rank == "Member")) or OSbidding_has_started == true then
					if rosterDetails[new_bidder]["is_an_alt"] == true then 
						local main_character_name = rosterDetails[new_bidder]["main"]
						rosterDetails[new_bidder]["DKP"] = rosterDetails[main_character_name]["DKP"]
					end

					-- outbid, uztenka dkp, ne tas pats asmuo
					if new_bid > current_bid and rosterDetails[new_bidder]["DKP"] >= new_bid and highest_bidder[1] ~= new_bidder then
						highest_bidder = {}
						highest_bidder[1] = new_bidder
						current_bid = new_bid
						SendChatMessage(new_bidder .. "(" .. rosterDetails[new_bidder]["DKP"] .. " DKP) is the highest bidder with " .. keywords[2] .. " DKP. 20 seconds to outbid!", "RAID")
						BiddingTimerTimeLeft:Cancel()
 						BiddingTimerTimeEnded:Cancel()
						BiddingTimerTimeLeft = C_Timer.NewTimer(15, BiddingTimerIsLeft)
						BiddingTimerTimeEnded = C_Timer.NewTimer(20, BiddingTimerHasEnded)

					-- matching bid, kai jau yra numerous bids
					elseif new_bid > current_bid and rosterDetails[new_bidder]["DKP"] >= new_bid and highest_bidder[2] ~= nil then
						highest_bidder = {}
						highest_bidder[1] = new_bidder
						current_bid = new_bid
						SendChatMessage(new_bidder .. "(" .. rosterDetails[new_bidder]["DKP"] .. " DKP) is the highest bidder with " .. keywords[2] .. " DKP. 20 seconds to outbid!", "RAID")
						BiddingTimerTimeLeft:Cancel()
 						BiddingTimerTimeEnded:Cancel()
						BiddingTimerTimeLeft = C_Timer.NewTimer(15, BiddingTimerIsLeft)
						BiddingTimerTimeEnded = C_Timer.NewTimer(20, BiddingTimerHasEnded)

					-- matching bid, uztenka dkp
					elseif new_bid == current_bid and rosterDetails[new_bidder]["DKP"] >= new_bid then
						local outbiding_yourself = false

						-- ne tas pats asmuo
						for i = 1, #highest_bidder do
							if new_bidder == highest_bidder[i] then outbiding_yourself = true end
						end
						if outbiding_yourself == false then
							highest_bidder[#highest_bidder + 1] = new_bidder
							current_bid = new_bid
							for i = 1, #highest_bidder do SendChatMessage(highest_bidder[i] .. "(" .. rosterDetails[new_bidder]["DKP"] .. " DKP) is one of the highest bidders with " .. keywords[2] .. " DKP. 20 seconds to outbid!", "RAID") end
							BiddingTimerTimeLeft:Cancel()
	 						BiddingTimerTimeEnded:Cancel()
							BiddingTimerTimeLeft = C_Timer.NewTimer(15, BiddingTimerIsLeft)
							BiddingTimerTimeEnded = C_Timer.NewTimer(20, BiddingTimerHasEnded)
						elseif outbiding_yourself == true then SendChatMessage("While we all fight with ourselves daily, wasting your DKP trying to outbid yourself is for sure not the right way to go.", "WHISPER", "Common", playerName)
						end
					else SendChatMessage("You might not have enough DKP or you may be bidding too little. I don't know, if I were a proper dev I'd make this addon tell you the exact reason but I'm but a random fucker on the internet.", "WHISPER", "Common", playerName)
					end
				elseif MSbidding_has_started == true and (new_bidder_rank ~= "Guardian" or new_bidder_rank ~= "Officer" or new_bidder_rank ~= "Member") then
					SendChatMessage("You probably don't have member status in the guild but fuck knows, I suck at addons so might be a random error.", "WHISPER", "Common", playerName)
				end
			end
		end
	end
end

function StartMSBidding(message)
	current_bid = 0
	highest_bidder = {}
	bidding_item = (message)
	SendChatMessage("MS bidding - MEMBERS ONLY for " .. bidding_item .. ". Whisper me !bid X.", "RAID_WARNING")
	BiddingTimerTimeLeft = C_Timer.NewTimer(15, BiddingTimerIsLeft)
	BiddingTimerTimeEnded = C_Timer.NewTimer(20, BiddingTimerHasEnded)
	MSbidding_has_started = true
end

function StartOSBidding(message)
	current_bid = 0
	highest_bidder = {}
	bidding_item = (message)
	SendChatMessage("OS bidding - alts, trials, OS bids for " .. bidding_item .. ".", "RAID_WARNING")
	BiddingTimerTimeLeft = C_Timer.NewTimer(15, BiddingTimerIsLeft)
	BiddingTimerTimeEnded = C_Timer.NewTimer(20, BiddingTimerHasEnded)
	OSbidding_has_started = true
end

local ChatCommandsFrame=CreateFrame("frame");
ChatCommandsFrame:RegisterEvent("CHAT_MSG_WHISPER");
ChatCommandsFrame:HookScript("OnEvent", Bidding)
ChatCommandsFrame:HookScript("OnEvent", YourDKP)

function StartSequenceBidding(message)
	bidding_item_list = {}
	for word in string.gmatch(message, "[^,]+") do
		table.insert(bidding_item_list, word)
	end

	bidding_sequence_has_started = true
	bidding_item = bidding_item_list[1]
	current_bid = 0
	highest_bidder = {}
	MSbidding_has_started = true
	BiddingTimerTimeLeft = C_Timer.NewTimer(20, BiddingTimerIsLeft)
	BiddingTimerTimeEnded = C_Timer.NewTimer(25, BiddingTimerHasEnded)
	SendChatMessage("MS bidding - MEMBERS ONLY for " .. bidding_item .. ". Whisper me !bid X.", "RAID_WARNING")
end

function ContinueSequence2()
	table.remove(bidding_item_list, 1)
	
	if bidding_item_list[1] ~= nil then
		bidding_item = bidding_item_list[1]
		current_bid = 0
		highest_bidder = {}
		BiddingTimerTimeLeft = C_Timer.NewTimer(20, BiddingTimerIsLeft)
		BiddingTimerTimeEnded = C_Timer.NewTimer(25, BiddingTimerHasEnded)
		SendChatMessage("------------", "RAID")
		SendChatMessage("MS bidding - MEMBERS ONLY for " .. bidding_item .. ". Whisper me !bid X.", "RAID_WARNING")
		MSbidding_has_started = true
	else bidding_sequence_has_started = false
	end
end

function ContinueSequenceOS()
	BiddingTimerTimeLeft = C_Timer.NewTimer(20, BiddingTimerIsLeft)
	BiddingTimerTimeEnded = C_Timer.NewTimer(25, BiddingTimerHasEnded)
	SendChatMessage("------------", "RAID")
	SendChatMessage("OS bidding - alts, trials, OS bids for " .. bidding_item .. ".", "RAID_WARNING")
	OSbidding_has_started = true
end