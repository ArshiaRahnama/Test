-- ============================================================
-- Server time sync
-- FiveM's client Lua runtime does NOT expose the `os` library
-- (os.time/os.date are nil there) -- only the server does. Every
-- new /doj + /law menu that needs to show "X daghighe pish" or
-- similar relative-time text asks here once and derives the rest
-- locally (see client/server_time.lua). No permission check needed,
-- this leaks nothing but the current unix timestamp.
-- ============================================================

ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback('esx_uniquejobs:getServerTime', function(source, cb)
	cb(os.time())
end)
