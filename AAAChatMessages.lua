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