function BiddingUpdate(new_bid, highest_bidders)
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

function BiddingUpdateBimbo(new_bid, highest_bidders)
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

function BiddingResults(playerName, new_bid, highest_bid, highest_bidders, bimbos, MSbidding, OSbidding, BiddingOnHold)
	local is_an_alt = IsAnAlt(playerName)
	local DKP = GetDKP(playerName)
	local playerName_rank = GetGuildRank(playerName)
	local is_all_in = false
	local outbidding_yourself = IsInList(playerName, highest_bidders)
	local outbidding_yourself_bimbo = IsInList(playerName, bimbos)
	if new_bid < DKP then new_bid = RoundNumbers(new_bid)
	elseif new_bid == DKP then is_all_in = true end
	
	-- ar isvis priimu bid?
	if BiddingOnHold == false and (OSbidding == true or (MSbidding == true and (playerName_rank == "Officer" or playerName_rank == "Guardian" or playerName_rank == "Member"))) then
		-- kur dabar tas bid nueina?

		-- simple outbid
		if (new_bid >= (highest_bid + 10) or (new_bid > highest_bid and is_all_in == true)) and DKP >= new_bid and outbidding_yourself == false then
			highest_bid = new_bid
			highest_bidders = {}
			table.insert(highest_bidders, playerName)
			BiddingUpdate(new_bid, highest_bidders)
		-- simple matching bid
		elseif new_bid == highest_bid and highest_bid > 10 and DKP >= new_bid and outbidding_yourself == false then
			table.insert(highest_bidders, playerName)
			BiddingUpdate(new_bid, highest_bidders)
		-- outbidding yourself
		elseif new_bid >= highest_bid and DKP >= new_bid and highest_bidders[2] == nil and outbidding_yourself == true then
			ReplyError(playerName, "outbidding yourself.")
		-- outbidding yourself but it's ok because there's more than 1 bidder
		elseif (new_bid >= (highest_bid + 10) or (new_bid > highest_bid and is_all_in == true)) and highest_bidders[2] ~= nil then
			highest_bid = new_bid
			highest_bidders = {}
			table.insert(highest_bidders, playerName)
			BiddingUpdate(new_bid, highest_bidders)
		elseif DKP < 20 and highest_bidders[1] == nil and outbidding_yourself_bimbo == false then
			ReplyError(playerName, "you're only allowed to win if nobody with actual DKP will want this.")
			table.insert(bimbos, playerName)
			BiddingUpdateBimbo(20, bimbos)
		elseif new_bid < (highest_bid + 10) and DKP >= new_bid then
			ReplyError(playerName, "bid is too low.")
		elseif new_bid > highest_bid and DKP < new_bid then
			ReplyError(playerName, "insufficient DKP.")
		end
	else ReplyError(playerName, "your guild status is too low.")
	end
	return highest_bid, highest_bidders, bimbos
end

function ReplyError(playerName, reason)
	SendChatMessage("Invalid command, reason - " .. reason, "WHISPER", "Common", playerName)
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