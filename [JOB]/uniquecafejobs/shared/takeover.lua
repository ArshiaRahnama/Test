--[[
	Holding Takeover War.

	Every Config.Takeover.IntervalDays (real days), the weakest business
	(lowest tracked revenue since the last cycle) of each business Type that
	has 2+ businesses goes up for a timed auction between the OTHER 3
	holdings - see server/takeover_sv.lua. Carwash (Type='carwash') only has
	1 business (Suds) so it's automatically excluded from every cycle - a
	lone business would otherwise be "weakest of its type" by definition
	every single time, which isn't a real contest.

	"Revenue" here is the same crafting-tax credit that already funds
	society_<job> in server/crafting_sv.lua - every successful craft adds a
	small amount to that business's tracked total. This is a reuse of an
	existing mechanic, not a new one.

	Ownership itself (cafes.lua's `Holding` field) is a compile-time
	default - once a takeover happens, the new owner is stored as a runtime
	OVERRIDE (business_holding_override table) that every ownership check
	in server/corp_server.lua and client/corp_client.lua reads through
	GetBusinessHolding()/the client-side holding-override cache, instead of
	the static Cafes table directly.
]]

Config.Takeover = {
	IntervalDays     = 30,    -- real days between auction cycles
	BidWindowMinutes = 60,    -- how long a single auction stays open once opened
	MinBid           = 20000,
	MinBidIncrement  = 2000,  -- each new bid must beat the current highest by at least this
}
