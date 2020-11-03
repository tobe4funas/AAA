local bidding_item_list = {}
local current_bid = 10
local current_bidders = {}
local current_bids = {}
local freeloaders = {}
local MSbidding_has_started = false
local OSbidding_has_started = false
local bidding_sequence_has_started = false
local bidding_on_hold = false
local BiddingTimerTimeLeft = nil
local BiddingTimerTimeEnded = nil

local bidding_item_list_backup = {}
local current_bid_backup = 10
local current_bidders_backup = {}
local freeloaders_backup = {}

function UndoBidding()
end



function BiddingSequenceCanceled(action)
	bidding_sequence_has_started = false
	MSbidding_has_started = false
	OSbidding_has_started = false
	bidding_item_list = {}
	SendChatMessage("Bidding has " .. action, "RAID")
	EndTimers()
end

function AcceptDKPChanges(winner, bid, reason)
	StaticPopup_Show("ACCEPT_DKP_CHANGES", winner .. "*" .. bid .. "*" .. reason)
end

StaticPopupDialogs["ACCEPT_DKP_CHANGES"] = {
    timeout = 0,
    whileDead = true,
    hideOnEscape = true,
    preferredIndex = 3,
    button1 = "Accept",
    button2 = "Cancel",
    text = "%s",
    OnHide = function(self)
        self.data = nil
    end,
    OnShow = function(self)
        self.data = { strsplit("*",self.text:GetText(),3) }
        self.text:SetText( format("Do you accept %s winning for %s DKP?", unpack(self.data)))
    end,
    OnAccept = function(self)
        local winner, bid, reason = unpack(self.data)
        SendChatMessage("Congrats to " .. winner .. " for purchasing " .. reason .. " for " .. bid .. "DKP.", "RAID")
        AdjustPersonDKP(winner, bid * -1, reason)
        ContinueBiddingSequence()
    end,
    OnCancel = function()
        BiddingSequenceCanceled("been cancelled.")
    end,  
}

function BiddingTimerHasEnded()
	bidding_on_hold = true
	if current_bidders[1] == nil and OSbidding_has_started == true and freeloaders[1] == nil then 
		SendChatMessage("Bidding has ended, " .. bidding_item_list[1] .. " will be disenchanted.", "RAID")
		BiddingSequence()
	elseif current_bidders[1] == nil and MSbidding_has_started == true and freeloaders[1] == nil then 
		BiddingSequence()
	elseif #current_bidders > 1 then
		SendChatMessage("Bidding has ended! Rolling out for the highest bidders.", "RAID")
		local highest_value = 0
		local current_bidders_roll = {}
		local winner = ""
		for i = 1, #current_bidders do
			current_bidders_roll[i] = math.random(1, 100)
			SendChatMessage(current_bidders[i] .. " rolls for " .. current_bidders_roll[i], "RAID")
			if current_bidders_roll[i] > highest_value then
				highest_value = current_bidders_roll[i]
				winner = current_bidders[i]
			end
		end
		SendChatMessage("Winner is - " .. winner, "RAID")
		AcceptDKPChanges(winner, current_bid, bidding_item_list[1])
	elseif current_bidders[1] ~=nil and current_bidders[2] == nil then
		AcceptDKPChanges(current_bidders[1], current_bid, bidding_item_list[1])
	elseif freeloaders[1] ~= nil and freeloaders[2] == nil then
		AcceptDKPChanges(freeloaders[1], 20, bidding_item_list[1])	
	elseif freeloaders[1] ~= nil and freeloaders[2] ~= nil then
		SendChatMessage("Bidding has ended! Freeloaders rejoice, it's yours!", "RAID")
		local highest_value = 0
		local current_bidders_roll = {}
		local winner = ""
		for i = 1, #freeloaders do
			current_bidders_roll[i] = math.random(1, 100)
			SendChatMessage(freeloaders[i] .. " rolls for " .. current_bidders_roll[i], "RAID")
			if current_bidders_roll[i] > highest_value then
				highest_value = current_bidders_roll[i]
				winner = freeloaders[i]
			end
		end
		SendChatMessage("Winner is - " .. winner, "RAID")
		AcceptDKPChanges(winner, 20, bidding_item_list[1])
	end
end



function ReceiveWhisper(self, event, text, playerName)
	--susirenku informacija
	playerName = string.gsub(playerName, "-Noggenfogger", "")
	if IsInRaid() and IsInGuildRoster(playerName) and IsInRaidRoster(playerName) then
		local keywords = {}
		local j = 1
		for words in text:gmatch("%S+") do
			keywords[j] = words
			j = j + 1	
		end
		
		if string.lower(keywords[1]) == "!dkp" then ReplyDKP(playerName, rosterDetails)
		elseif (string.lower(keywords[1]) == "!dkp" or string.lower(keywords[1]) == "!bid") and keywords[3] ~= nil 
		and bidding_on_hold == false and bidding_sequence_has_started == true then
			ReplyError(playerName, "maybe typos?")		
		elseif string.lower(keywords[1]) == "!bid" and type(tonumber(keywords[2])) == "number" and keywords[3] == nil
		and bidding_on_hold == false and bidding_sequence_has_started == true then
			keywords[2] = tonumber(keywords[2]) 
			current_bid, current_bidders, freeloaders = BiddingResults(playerName, keywords[2], current_bid, current_bidders, freeloaders, MSbidding_has_started, OSbidding_has_started, bidding_on_hold)
		end
	end
end

function MSBidding(item)
	MSbidding_has_started = true
	OSbidding_has_started = false
	SendChatMessage("MS bidding - MEMBERS ONLY for " .. item .. ". Whisper me !bid X.", "RAID_WARNING")
	StartTimers()
end

function OSBidding(item)
	MSbidding_has_started = false
	OSbidding_has_started = true
	SendChatMessage("Bidding has ended, " .. item .. " goes to OS next.", "RAID")
	SendChatMessage("OS bidding - trials & alts go nuts for " .. item .. ". Whisper me !bid X.", "RAID_WARNING")
	StartTimers()
end

function ContinueBiddingSequence()
	table.remove(bidding_item_list, 1)
	MSbidding_has_started = false
	OSbidding_has_started = false
	BiddingSequence()
end

function BiddingSequence(message)
	bidding_on_hold = false
	--pirmakart ateina cia
	if bidding_sequence_has_started == false then 
		bidding_item_list = {}
		bidding_item_list_backup = {}
		bidding_sequence_has_started = true
		for word in string.gmatch(message, "[^,]+") do
			table.insert(bidding_item_list, word)
			table.insert(bidding_item_list_backup, word)
		end
		CreateBiddingControlFrames()
		UpdateBiddingControlFrames(bidding_item_list)
	end
	current_bid = 10
	current_bidders = {}
	freeloaders = {}
	-- OS, nes buvo MS
	if MSbidding_has_started == true then
		OSBidding(bidding_item_list[1])	
	-- MS, nes buvo OS	
	elseif OSbidding_has_started == true then
		table.remove(bidding_item_list, 1)
		if bidding_item_list[1] ~= nil then
			BiddingControl(bidding_item_list[1])
			MSBidding(bidding_item_list[1])
		elseif bidding_item_list[1] == nil then
		BiddingSequenceCanceled("ended.")
		end
	-- MS, nes nebuvo nieko
	elseif bidding_item_list[1] ~= nil then
		BiddingControl(bidding_item_list[1])
		MSBidding(bidding_item_list[1])
	elseif bidding_item_list[1] == nil then
		BiddingSequenceCanceled("ended.")
	end
end

function RefreshTimers()
	bidding_on_hold = false
	StaticPopup_Hide("ACCEPT_DKP_CHANGES")
	EndTimers()
	StartTimers()
end

function StartTimers()
	BiddingTimerTimeLeft = C_Timer.NewTimer(15, BiddingTimerIsLeft)
	BiddingTimerTimeEnded = C_Timer.NewTimer(20, BiddingTimerHasEnded)
end


function EndTimers()
	BiddingTimerTimeLeft:Cancel()
	BiddingTimerTimeEnded:Cancel()
end	

local ChatCommandsFrame=CreateFrame("frame");
ChatCommandsFrame:RegisterEvent("CHAT_MSG_WHISPER");
ChatCommandsFrame:HookScript("OnEvent", ReceiveWhisper)

function BiddingControl(item_name)
	CurrentBiddingItem:Show()
	local bidding_item_ID, _, _, _, bidding_item_icon = GetItemInfoInstant(item_name)
	local bidding_item_link = GetItemInfo(bidding_item_ID)
	CurrentBiddingItemTexture:SetTexture(bidding_item_icon)
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
			UpdateCurrentBidders(playerName, new_bid, )
			AnnounceBid(new_bid, highest_bidders)
		-- simple matching bid
		elseif new_bid == highest_bid and highest_bid > 10 and DKP >= new_bid and outbidding_yourself == false then
			table.insert(highest_bidders, playerName)
			AnnounceBid(new_bid, highest_bidders)
		-- outbidding yourself
		elseif new_bid >= highest_bid and DKP >= new_bid and highest_bidders[2] == nil and outbidding_yourself == true then
			ReplyError(playerName, "outbidding yourself.")
		-- outbidding yourself but it's ok because there's more than 1 bidder
		elseif (new_bid >= (highest_bid + 10) or (new_bid > highest_bid and is_all_in == true)) and highest_bidders[2] ~= nil then
			highest_bid = new_bid
			highest_bidders = {}
			table.insert(highest_bidders, playerName)
			AnnounceBid(new_bid, highest_bidders)
		elseif DKP < 20 and highest_bidders[1] == nil and outbidding_yourself_bimbo == false then
			ReplyError(playerName, "you're only allowed to win if nobody with actual DKP will want this.")
			table.insert(bimbos, playerName)
			AnnounceBidBimbo(20, bimbos)
		elseif new_bid < (highest_bid + 10) and DKP >= new_bid then
			ReplyError(playerName, "bid is too low.")
		elseif new_bid > highest_bid and DKP < new_bid then
			ReplyError(playerName, "insufficient DKP.")
		end
	else ReplyError(playerName, "your guild status is too low.")
	end
	return highest_bid, highest_bidders, bimbos
end
