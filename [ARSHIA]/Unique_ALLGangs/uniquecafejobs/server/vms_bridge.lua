--[[
	uniquecafejobs <-> vms_barber / vms_tattooshop payment bridge.

	Every payment at a barber or tattoo shop (self service and bills) goes through
	VmsSplitPayment():
	  - VmsConfig.HoldingSharePercent (40%) -> society of the holding that owns
	    that type of shop (society_meridian for barbers, society_turfco for tattoos)
	  - the rest (60%) -> the shared shop society (society_barber / society_tattoo)
	The full amount is also counted for the Takeover War sales board.
]]

CreateThread(function()
	Wait(1000)
	TriggerEvent('esx_society:registerSociety', 'barber', 'Barber Shop', 'society_barber', 'society_barber', 'society_barber', { type = 'public' })
	TriggerEvent('esx_society:registerSociety', 'tattoo', 'Tattoo Shop', 'society_tattoo', 'society_tattoo', 'society_tattoo', { type = 'public' })
end)

local function addToSociety(societyName, amount)
	if amount <= 0 then return end
	TriggerEvent('esx_addonaccount:getSharedAccount', societyName, function(account)
		if account then
			account.addMoney(amount)
		else
			print(('^1[uniquecafejobs] missing society account %s - run vms_businesses_jobs.sql^0'):format(societyName))
		end
	end)
end

function VmsSplitPayment(shopJob, amount)
	amount = math.floor(tonumber(amount) or 0)
	if amount <= 0 or not shopJob then return end

	local biz = GetBusinessForJob(shopJob)
	local holdingPart = 0
	if biz then
		holdingPart = math.floor(amount * VmsConfig.HoldingSharePercent / 100)
		addToSociety('society_' .. GetBusinessHolding(biz), holdingPart)
	end
	addToSociety('society_' .. shopJob, amount - holdingPart)

	RecordSale(shopJob, amount)
end
