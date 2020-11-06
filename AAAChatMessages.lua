function AnnounceBid(new_bid, highest_bidders)
	local DKP = GetDKP(highest_bidders[1])
	local names = highest_bidders[1] .. "(" .. DKP .. ")"
	if highest_bidders[2] ~= nil then
		for i = 2, #highest_bidders do
			DKP = GetDKP(highest_bidders[i])
			local temp_name = highest_bidders[i] .. "(" .. DKP .. ")"
			names = names .. ", " .. temp_name 
		end
	end
	SendChatMessage("---- " .. new_bid .. " DKP NEW BID -----", "RAID")
	SendChatMessage("Highest bidder(s) are: " .. names, "RAID")
	RefreshTimers()
end

function AnnounceBidBimbo(new_bid, highest_bidders)
	local DKP = GetDKP(highest_bidders[1])
	local names = highest_bidders[1] .. "(" .. DKP .. ")"
	if highest_bidders[2] ~= nil then
		for i = 2, #highest_bidders do
			DKP = GetDKP(highest_bidders[i])
			local temp_name = highest_bidders[i] .. "(" .. DKP .. ")"
			names = names .. ", " .. temp_name 
		end
	end
	SendChatMessage("---- IF NOBODY WANTS THIS, BIMBOS WILL TAKE IT -----", "RAID")
	SendChatMessage("Current bimbo(s) are: " .. names, "RAID")
	RefreshTimers()
end

function ReplyError(playerName, reason)
	if reason ~= nil then 
		SendChatMessage("Automatic reply - " .. reason, "WHISPER", "Common", playerName)
	end
end

function ReplyDKP(playerName, database)
	local is_an_alt, main_character_name = IsAnAlt(playerName)
	if is_an_alt == false then
		local DKP = GetDKP(playerName)
		SendChatMessage(playerName .. ", you have " .. DKP .. " DKP.", "WHISPER", "Common", playerName)
	else local DKP = GetDKP(main_character_name)
		SendChatMessage(playerName .. ", you have " .. DKP .. " DKP.", "WHISPER", "Common", playerName)
	end
end

function BiddingTimerIsLeft()
	SendChatMessage("--------", "RAID")
	SendChatMessage("5 seconds left for bidding!", "RAID")
end

function PrintBidders(MSlist, OSlist, MSbimbos, OSbimbos, BidsList)
	local MSlisttext = ""
	local OSlisttext = ""
	local MSbimbostext = ""
	local OSbimbostext = ""
	SendChatMessage("Bidding is closed. Printing all the participants:", "RAID")

	if MSlist[1] ~= nil then
		MSlisttext = "MS bidders: " .. MSlist[1] .. "(" .. BidsList[MSlist[1]] .. "), "
		if MSlist[2] ~= nil then 
			for i = 2, #MSlist do
				MSlisttext = MSlisttext .. MSlist[i] .. "(" .. BidsList[MSlist[i]] .. "), "
			end
		end
	-- else MSlisttext = "MS bidders: none." 
		SendChatMessage(MSlisttext, "RAID")
	end

	if MSbimbos[1] ~= nil then
		MSbimbostext = "MS bimbos: " .. MSbimbos[1] .. "(" .. BidsList[MSbimbos[1]] .. "), "
		if MSlist[2] ~= nil then 
			for i = 2, #MSbimbos do
				MSbimbostext = MSbimbostext .. MSbimbos[i] .. "(" .. BidsList[MSbimbos[i]] .. "), "
			end
		end
	-- else MSbimbostext = "MS bimbos: none." 
		SendChatMessage(MSbimbostext, "RAID")
	end

	if OSlist[1] ~= nil then
		OSlisttext = "OS bidders: " .. OSlist[1] .. "(" .. BidsList[OSlist[1]] .. "), "
		if OSlist[2] ~= nil then 
			for i = 2, #OSlist do
				OSlisttext = OSlisttext .. OSlist[i] .. "(" .. BidsList[OSlist[i]] .. "), "
			end
		end
	-- else OSlisttext = "OS bidders: none."
		SendChatMessage(OSlisttext, "RAID") 
	end

	if OSbimbos[1] ~= nil then
		OSbimbostext = "OS bimbos: " .. OSbimbos[1] .. "(" .. BidsList[OSbimbos[1]] .. "), "
		if OSbimbos[2] ~= nil then 
			for i = 2, #OSbimbos do
				OSbimbostext = OSbimbostext .. OSbimbos[i] .. "(" .. BidsList[OSbimbos[i]] .. "), "
			end
		end
	-- else OSbimbostext = "OS bimbos: none." 
		SendChatMessage(OSbimbostext, "RAID")
	end
	
	
end
