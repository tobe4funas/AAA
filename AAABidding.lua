local bidding_item_list = {}
local MSbidders = {}
local OSbidders = {}
local MSfreeloaders = {}
local OSfreeloaders = {}
local bidders_bids = {}
local all_bidders = {}
local bidders_priority = {}
local bidding_sequence_has_started = false
local bidding_on_hold = false
local BiddingTimerTimeLeft = nil
local BiddingTimerTimeEnded = nil

local bidding_item_list_backup = {}

function BiddingSequenceCanceled(action)
	MSbidders = {}
	OSbidders = {}
	MSfreeloaders = {}
	OSfreeloaders = {}
	all_bidders = {}
	bidders_priority = {}
	bidders_bids = {}
	UpdateBiddingControlBidders(all_bidders, bidders_bids, bidders_priority)
	bidding_sequence_has_started = false
	bidding_item_list = {}
	EndTimers()
	if action ~= nil then 
		SendChatMessage("Bidding has " .. action, "RAID")
	end
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
        AdjustPersonDKP(winner, bid * -1, reason)
        PrintBidders(MSbidders, OSbidders, MSfreeloaders, OSfreeloaders, bidders_bids)
        SendChatMessage("Congrats to " .. winner .. " for " .. bidders_priority[winner] .. " purchasing " .. reason .. " for " .. bid .. "DKP.", "RAID")
        ContinueBiddingSequence()
    end,
    OnCancel = function()
        BiddingSequenceCanceled("been cancelled.")
    end,  
}

function BiddingTimerHasEnded()
	if bidding_sequence_has_started == true then
		bidding_on_hold = true
		local highest_bidder, highest_bid = CalculateWinner(MSbidders, OSbidders, MSfreeloaders, OSfreeloaders, bidders_bids)
		if highest_bidder[1] == nil then 
			SendChatMessage("Bidding has ended, " .. bidding_item_list[1] .. " will be disenchanted.", "RAID")
			ContinueBiddingSequence()
		elseif #highest_bidder > 1 then
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
			SendChatMessage("Winner is - " .. winner, "RAID")
			AcceptDKPChanges(winner, highest_bid, bidding_item_list[1])
		elseif highest_bidder[1] ~=nil and highest_bidder[2] == nil then
			AcceptDKPChanges(highest_bidder[1], highest_bid, bidding_item_list[1])
		end
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
		elseif (string.lower(keywords[1]) == "!ms" or string.lower(keywords[1]) == "!os" or string.lower(keywords[1]) == "!bid") and keywords[3] ~= nil 
		and bidding_on_hold == false and bidding_sequence_has_started == true then
			ReplyError(playerName, "you made a typo. The syntax is '!ms X' or 'os X', where X is the amount you want to bid.")		
		elseif (string.lower(keywords[1]) == "!ms" or string.lower(keywords[1]) == "!os") and type(tonumber(keywords[2])) == "number" and keywords[3] == nil
		and bidding_on_hold == false and bidding_sequence_has_started == true then
			keywords[2] = tonumber(keywords[2])
			local playerName_DKP = GetDKP(playerName)
			if keywords[2] > playerName_DKP and keywords[2] > 20 then keywords[2] = playerName_DKP end
			local is_MSbid_eligible, is_OSbid_eligible, is_bid_MSbimbo_eligible, is_bid_OSbimbo_eligible, reason = IsBidEligible(playerName, keywords[1], keywords[2], bidding_on_hold)
			if is_MSbid_eligible == true or is_OSbid_eligible == true or is_bid_MSbimbo_eligible == true or is_bid_OSbimbo_eligible == true then
				MSbidders, OSbidders, MSfreeloaders, OSfreeloaders, bidders_bids, all_bidders, bidders_priority = UpdateCurrentBidders(playerName, keywords[2], is_MSbid_eligible, is_OSbid_eligible, is_bid_MSbimbo_eligible, is_bid_OSbimbo_eligible, MSbidders, OSbidders, MSfreeloaders, OSfreeloaders, bidders_bids, all_bidders, bidders_priority)
				ReplyError(playerName, reason)
				UpdateBiddingControlBidders(all_bidders, bidders_bids, bidders_priority)
			else ReplyError(playerName, reason)
			end
		end
	end
end

function UpdateCurrentBidders(playerName, playerName_bid, MSbid_eligible, OSbid_eligible, bid_MSbimbo_eligible, bid_OSbimbo_eligible, MSlist, OSlist, MSFlist, OSFlist, bids_list, bidders_list, priority)
	RemoveBidder(playerName)
	local is_in_MS_list = IsInList(MSbidders, playerName)
	local is_in_OS_list = IsInList(OSbidders, playerName)
	local is_in_MSfreeloaders_list = IsInList(MSfreeloaders, playerName)
	local is_in_OSfreeloaders_list = IsInList(OSfreeloaders, playerName)
	if MSbid_eligible == true and is_in_MS_list == false then
		MSlist[#MSlist + 1] = playerName
		bidders_list[#bidders_list + 1] = playerName
		priority[playerName] = "MS"
	elseif OSbid_eligible == true and is_in_OS_list == false then
		OSlist[#OSlist + 1] = playerName
		bidders_list[#bidders_list + 1] = playerName
		priority[playerName] = "OS"
	elseif bid_MSbimbo_eligible == true and is_in_MSfreeloaders_list == false then
		MSFlist[#MSFlist + 1] = playerName
		bidders_list[#bidders_list + 1] = playerName
		priority[playerName] = "MS bimbo"
	elseif bid_OSbimbo_eligible == true and is_in_OSfreeloaders_list == false then
		OSfreeloaders[#OSfreeloaders + 1] = playerName
		bidders_list[#bidders_list + 1] = playerName
		priority[playerName] = "OS bimbo"
	end
	if playerName_bid < 20 then playerName_bid = 20 end
	bids_list[playerName] = playerName_bid
	return MSlist, OSlist, MSFlist, OSFlist, bids_list, bidders_list, priority
end

function ContinueBiddingSequence()
	table.remove(bidding_item_list, 1)
	BiddingSequence()
end

function ResetBidding()
	bidding_on_hold = false
	bidding_sequence_has_started = true
	for i = 1, #bidding_item_list_backup do
		bidding_item_list[i] = bidding_item_list_backup[i]
	end
	BiddingSequence()
end

function BiddingSequenceSpecificItem(index)
	if bidding_sequence_has_started == true then 
		BiddingSequenceCanceled("been canceled.")
	end
	bidding_on_hold = false
	bidding_sequence_has_started = true
	bidding_item_list[1] = bidding_item_list_backup[index]
	BiddingSingleItem(bidding_item_list[1])
end

function BiddingSingleItem(item)
	MSbidders = {}
	OSbidders = {}
	MSfreeloaders = {}
	OSfreeloaders = {}
	all_bidders = {}
	bidders_priority = {}
	bidders_bids = {}
	UpdateBiddingControlCurrentItem(item)
	UpdateBiddingControlAllItems(bidding_item_list_backup)
	UpdateBiddingControlBidders(all_bidders, bidders_bids, bidders_priority)
	SendChatMessage("-------------------", "RAID")
	SendChatMessage("Bid for " .. item .. ". Whisper me '!ms X' or '!os X' where X is the amount you want to bid.", "RAID_WARNING")
	StartTimers()
end

function BiddingSequence(message)
	bidding_on_hold = false
	highest_bid = 20
	MSbidders = {}
	OSbidders = {}
	MSfreeloaders = {}
	OSfreeloaders = {}
	all_bidders = {}
	bidders_priority = {}
	bidders_bids = {}	
	--pirmakart ateina cia
	if bidding_sequence_has_started == false then 
		bidding_item_list = {}
		bidding_item_list_backup = {}
		bidding_sequence_has_started = true
		for word in string.gmatch(message, "[^,]+") do
			table.insert(bidding_item_list, word)
			table.insert(bidding_item_list_backup, word)
		end
		CreateBiddingControlBidders(MSbidders, OSbidders, MSfreeloaders, OSfreeloaders, bidders_bids, all_bidders)
		UpdateBiddingControlCurrentItem(bidding_item_list[1])
		UpdateBiddingControlAllItems(bidding_item_list_backup)
		UpdateBiddingControlBidders(all_bidders, bidders_bids, bidders_priority)
		SendChatMessage("-------------------", "RAID")
		SendChatMessage("Bid for " .. bidding_item_list[1] .. ". Whisper me '!ms X' or '!os X' where X is the amount you want to bid.", "RAID_WARNING")
		StartTimers()
	else 
		if bidding_item_list[1] ~= nil then
			UpdateBiddingControlCurrentItem(bidding_item_list[1])
			UpdateBiddingControlBidders(all_bidders, bidders_bids, bidders_priority)
			SendChatMessage("-------------------", "RAID")
			SendChatMessage("Bid for " .. bidding_item_list[1] .. ". Whisper me '!ms X' or '!os X' where X is the amount you want to bid.", "RAID_WARNING")
			StartTimers()
		elseif bidding_item_list[1] == nil then
			UpdateBiddingControlBidders(all_bidders, bidders_bids, bidders_priority)
			BiddingSequenceCanceled("ended.")
		end
	end
end

function RefreshTimers()
	bidding_on_hold = false
	StaticPopup_Hide("ACCEPT_DKP_CHANGES")
	EndTimers()
	StartTimers()
end

function StartTimers()
	BiddingTimerTimeLeft = C_Timer.NewTimer(25, BiddingTimerIsLeft)
	BiddingTimerTimeEnded = C_Timer.NewTimer(30, BiddingTimerHasEnded)
end

function EndTimers()
	BiddingTimerTimeLeft:Cancel()
	BiddingTimerTimeEnded:Cancel()
end	

local ChatCommandsFrame=CreateFrame("frame");
ChatCommandsFrame:RegisterEvent("CHAT_MSG_WHISPER");
ChatCommandsFrame:HookScript("OnEvent", ReceiveWhisper)

function RemoveBidder(playerName)
	for i = 1, #all_bidders do
		if all_bidders[i] == playerName then
			bidders_bids[all_bidders[i]] = nil
			table.remove(all_bidders, i)
			break
		end
	end
	for i = 1, #MSbidders do
		if MSbidders[i] == playerName then
			table.remove(MSbidders, i)
			break
		end
	end
	for i = 1, #OSbidders do
		if OSbidders[i] == playerName then
			table.remove(OSbidders, i)
			break
		end
	end
	for i = 1, #MSfreeloaders do
		if MSfreeloaders[i] == playerName then
			table.remove(MSfreeloaders, i)
			break
		end
	end
	for i = 1, #OSfreeloaders do
		if OSfreeloaders[i] == playerName then
			table.remove(OSfreeloaders, i)
			break
		end
	end
	UpdateBiddingControlBidders(all_bidders, bidders_bids, bidders_priority)		
end

function TestFunction()
	print(MSbidders[1])
	print(OSbidders[1])
	print(MSfreeloaders[1])
	print(OSfreeloaders[1])
end


