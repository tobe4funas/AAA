function ReceiveWhisper(playerName, text)
	-- ar addon turi reaguoti i ji?
	-- as raide, jis rosteryje, whisperina komanda
	-- if komanda X, then
	-- if komanda Y, then
	-- end
end

function BiddingNew(playerName, bid)
	-- susirenku info
	-- ar eligible biddint?
	-- sutvarkau bids
	-- siunciu i BiddingSequence
	-- returninu naujus values, nes sitas neturi buti susijes su local variables jokiais
end

function BiddingEnd()
	-- imu viso failo variables
	-- paskelbiu laimetojus
	-- atiduodu i global funkcijas paupdatinti database
	-- siunciu i BiddingSequence
end

function BiddingSequence(message)

function BiddingSequence(message)
	bidding_on_hold = false
	-- naujas sequence
	if bidding_sequence_has_started == false then 
		bidding_item_list = {}
		for word in string.gmatch(message, "[^,]+") do
			table.insert(bidding_item_list, word)
		end
		bidding_sequence_has_started = true
	end
	bidding_item = bidding_item_list[1]
	current_bid = 19
	current_bidders = {}

	-- sekantis item in the sequence ARBA baigiam sequence
	if OSbidding_has_started == true then
		table.remove(bidding_item_list, 1)
		if bidding_item_list ~= nil then
			MSbidding_has_started = true
			OSbidding_has_started = false
			MSBidding(bidding_item, current_bid, current_bidders)
		else EndBiddingSequence(bidding_sequence_has_started)
		end

	-- einam i OS
	elseif MSbidding_has_started == true then
		MSbidding_has_started = false
		OSbidding_has_started = true
		OSBidding(bidding_item, current_bid, current_bidders)

	-- pradedam su MS
	else
		MSbidding_has_started = true
		OSbidding_has_started = false 
		MSBidding(bidding_item, current_bid, current_bidders)
	end
end	







