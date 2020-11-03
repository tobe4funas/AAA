local bidding_item_list = {}
local highest_bid = 10
local highest_bidder = {}
local bidders = {}
local bidders_bids = {}
local freeloaders = {}
local MSbidding_has_started = false
local OSbidding_has_started = false
local bidding_sequence_has_started = false
local bidding_on_hold = false
local BiddingTimerTimeLeft = nil
local BiddingTimerTimeEnded = nil

local bidding_item_list_backup = {}

function BiddingSequenceCanceled(action)
	bidding_sequence_has_started = false
	MSbidding_has_started = false
	OSbidding_has_started = false
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
	if highest_bidder[1] == nil and OSbidding_has_started == true and freeloaders[1] == nil then 
		SendChatMessage("Bidding has ended, " .. bidding_item_list[1] .. " will be disenchanted.", "RAID")
		BiddingSequence()
	elseif highest_bidder[1] == nil and MSbidding_has_started == true and freeloaders[1] == nil then 
		BiddingSequence()
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
	elseif freeloaders[1] ~= nil and freeloaders[2] == nil then
		AcceptDKPChanges(freeloaders[1], 20, bidding_item_list[1])	
	elseif freeloaders[1] ~= nil and freeloaders[2] ~= nil then
		SendChatMessage("Bidding has ended! Freeloaders rejoice, it's yours!", "RAID")
		local highest_value = 0
		local highest_bidder_roll = {}
		local winner = ""
		for i = 1, #freeloaders do
			highest_bidder_roll[i] = math.random(1, 100)
			SendChatMessage(freeloaders[i] .. " rolls for " .. highest_bidder_roll[i], "RAID")
			if highest_bidder_roll[i] > highest_value then
				highest_value = highest_bidder_roll[i]
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
			local is_bid_eligible, is_bid_bimbo_eligible, reason, new_bid = IsBidEligible(playerName, keywords[2], highest_bidder, highest_bid, bidding_on_hold, MSbidding_has_started, OSbidding_has_started)
			if is_bid_eligible == true then
				bidders, bidders_bids = UpdateCurrentBidders(playerName, new_bid, bidders, bidders_bids)
				highest_bidder, highest_bid = CalculateHighestBidder(bidders, bidders_bids, highest_bid)
				AnnounceBid(highest_bid, highest_bidder)
			-- cia yra nonsense
			elseif is_bid_bimbo_eligible == true then
				freeloaders = UpdateCurrentBidders(playerName, 20, freeloaders, bidders_bids)
				AnnounceBidBimbo(20, freeloaders)
			else ReplyError(playerName, reason)
			end
		end
	end
end

function UndoLastBid()
	if bidders[1] ~= nil then 
		bidders[#bidders] = nil
	elseif freeloaders[1] ~= nil then
		freeloaders[#freeloaders] = nil
	end
	if bidders[1] ~= nil then
		highest_bidder, highest_bid = CalculateHighestBidder(bidders, bidders_bids, highest_bid)
		AnnounceBid(highest_bid, highest_bidder)
		RefreshTimers()
	elseif freeloaders[1] ~= nil then
		highest_bid = 10
		highest_bidder, highest_bid = CalculateHighestBidder(bidders, bidders_bids, highest_bid)
		AnnounceBidBimbo(20, freeloaders)
		RefreshTimers()
	else
		highest_bid = 10
		highest_bidder, highest_bid = CalculateHighestBidder(bidders, bidders_bids, highest_bid)
		SendChatMessage("---- NO BIDDERS -----", "RAID")
		RefreshTimers()
	end
end


function MSBidding(item)
	highest_bid = 10
	bidders = {}
	bidders_bids = {}
	highest_bidder = {}
	freeloaders = {}
	MSbidding_has_started = true
	OSbidding_has_started = false
	SendChatMessage("-------------------", "RAID")
	SendChatMessage("MS bidding - MEMBERS ONLY for " .. item .. ". Whisper me !bid X.", "RAID_WARNING")
	StartTimers()
end

function OSBidding(item)
	highest_bid = 10
	bidders = {}
	bidders_bids = {}
	highest_bidder = {}
	freeloaders = {}
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

function ResetBidding()
	bidding_on_hold = false
	bidding_sequence_has_started = true
	for i = 1, #bidding_item_list_backup do
		bidding_item_list[i] = bidding_item_list_backup[i]
	end
	MSBidding(bidding_item_list[1])
end

function BiddingSequenceSpecificItem(index)
	BiddingSequenceCanceled("been canceled.")
	bidding_on_hold = false
	bidding_sequence_has_started = true
	bidding_item_list[1] = bidding_item_list_backup[index]
	MSBidding(bidding_item_list[1])
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
		UpdateBiddingControlAllItems(bidding_item_list_backup)
	end
	-- OS, nes buvo MS
	if MSbidding_has_started == true then
		OSBidding(bidding_item_list[1])	
	-- MS, nes buvo OS	
	elseif OSbidding_has_started == true then
		table.remove(bidding_item_list, 1)
		if bidding_item_list[1] ~= nil then
			UpdateBiddingControlCurrentItem(bidding_item_list[1])
			MSBidding(bidding_item_list[1])
		elseif bidding_item_list[1] == nil then
		BiddingSequenceCanceled("ended.")
		end
	-- MS, nes nebuvo nieko
	elseif bidding_item_list[1] ~= nil then
		UpdateBiddingControlCurrentItem(bidding_item_list[1])
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



function TestFunction()
	if bidders[1] ~= nil then
		for i = 1, #bidders do
			print(bidders[i])
		end
	end
end




