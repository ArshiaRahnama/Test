--[[
	Holding IPO. A holding's Boss can list part of its future franchise-fee
	collections for public sale (see 'uniquecafejobs:corp:collectFranchiseFee'
	in server/corp_server.lua, unchanged trigger point) - ANY player, not
	just employees, can then buy shares. TotalShares is fixed at 100 so a
	share is simply "1% of the offered percent" - e.g. offerPercent=20,
	someone holding 50 shares owns 50% of that 20%, i.e. 10% of the holding's
	total collection revenue, paid out automatically every time the holding's
	boss collects (same CollectCooldownMins cadence already in shared/corp.lua).

	Unsold shares just mean that portion of the dividend pool stays with the
	holding's own society account instead of being paid out to anyone.
]]

Config.IPO = {
	MaxOfferPercent = 50,   -- a holding can offer at most 50% of its collections
	MinSharePrice   = 100,  -- boss must price shares at $100+ each
	TotalShares     = 100,  -- fixed - a share is always 1% of offerPercent
}
