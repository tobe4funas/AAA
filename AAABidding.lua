local bidding_item_list = {}
local current_bid = 19
local current_bidders = {}
local freeloaders = {}
local MSbidding_has_started = false
local OSbidding_has_started = false
local bidding_sequence_has_started = false
local bidding_on_hold = false
local BiddingTimerTimeLeft = nil
local BiddingTimerTimeEnded = nil


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

-- function AcceptDKPChanges(winner, bid, reason)
-- 	local popup = StaticPopup_Show("ACCEPT_DKP_CHANGES", winner, bid)
-- 	popup.data = winner
-- 	popup.data2 = bid
-- end

-- StaticPopupDialogs["ACCEPT_DKP_CHANGES"] = {
--   text = "Do you accept %s winning for %d DKP?",
-- 	button1 = "Accept",
-- 	button2 = "Cancel",
-- 	OnAccept = function(self, winner, bid)
-- 	SendChatMessage("Congrats to " .. winner .. " for purchasing " .. bidding_item_list[1] .. " for " .. bid .. "DKP.", "RAID")
-- 	bid = -(bid)
-- 	AdjustPersonDKP(winner, bid, bidding_item_list[1])
-- 	ContinueBiddingSequence()
-- end,
-- 	OnCancel = function()
-- 	BiddingSequenceCanceled("been cancelled.")
-- end,
-- 	timeout = 0,
-- 	whileDead = true,
-- 	preferredIndex = 3,
-- }

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
		-- komanda 1
		if string.lower(keywords[1]) == "!dkp" then ReplyDKP(playerName, rosterDetails)
		-- komanda 2
		elseif string.lower(keywords[1]) == "!bid" and type(tonumber(keywords[2])) == "number" and keywords[3] == nil
		and bidding_on_hold == false and bidding_sequence_has_started == true then
			keywords[2] = tonumber(keywords[2]) 
			current_bid, current_bidders, freeloaders = BiddingResults(playerName, keywords[2], current_bid, current_bidders, freeloaders, MSbidding_has_started, OSbidding_has_started, bidding_on_hold)
		-- komanda 3
		elseif (string.lower(keywords[1]) == "!dkp" or string.lower(keywords[1]) == "!bid") and keywords[3] ~= nil 
		and bidding_on_hold == false and bidding_sequence_has_started == true then
			ReplyError(playerName, "maybe typos?")
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
		bidding_sequence_has_started = true
		for word in string.gmatch(message, "[^,]+") do
			table.insert(bidding_item_list, word)
		end
	end
	current_bid = 19
	current_bidders = {}
	freeloaders = {}
	-- OS, nes buvo MS
	if MSbidding_has_started == true then
		OSBidding(bidding_item_list[1])	
	-- MS, nes buvo OS	
	elseif OSbidding_has_started == true then
		table.remove(bidding_item_list, 1)
		if bidding_item_list[1] ~= nil then
			MSBidding(bidding_item_list[1])
		elseif bidding_item_list[1] == nil then
		BiddingSequenceCanceled("ended.")
		end
	-- MS, nes nebuvo nieko
	elseif bidding_item_list[1] ~= nil then
		MSBidding(bidding_item_list[1])
	elseif bidding_item_list[1] == nil then
		BiddingSequenceCanceled("ended.")
	end
end

function RefreshTimers()
	EndTimers()
	StartTimers()
end

function StartTimers()
	BiddingTimerTimeLeft = C_Timer.NewTimer(8, BiddingTimerIsLeft)
	BiddingTimerTimeEnded = C_Timer.NewTimer(12, BiddingTimerHasEnded)
end


function EndTimers()
	BiddingTimerTimeLeft:Cancel()
	BiddingTimerTimeEnded:Cancel()
end	

local ChatCommandsFrame=CreateFrame("frame");
ChatCommandsFrame:RegisterEvent("CHAT_MSG_WHISPER");
ChatCommandsFrame:HookScript("OnEvent", ReceiveWhisper)