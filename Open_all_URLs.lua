-- Get all players url and open it on web made by zinn#0001
local enableBox = ui.new_checkbox("Misc", "Miscellaneous", "URLs DUMP")
local ID_64
local URLs = {}
URLs.opened = {}
URLs.ID64 = {}
local js = panorama.open()

local function steamID64(steamid3)
    local y = 0
    local z = 0
      
    if ((steamid3 % 2) == 0) then
        y = 0
        z = (steamid3 / 2)
    else
        y = 1
        z = ((steamid3 - 1) / 2)
    end

    return '7656119' .. ((z * 2) + (7960265728 + y))
end


local button =  ui.new_button("Misc", "Miscellaneous", "Get all players URL", function()
	local should = true
	local steam_IDS = "\n"
	local counter = 0;
	local myID_64 = steamID64(entity.get_steam64(entity.get_local_player(client.userid_to_entindex(entity.get_local_player))))
	for i=1, 64 do
		if entity.get_steam64(i) ~= 0 and entity.get_local_player() ~= i and entity.get_player_name(i) ~= "GOTV" and entity.get_player_name(i) ~= "unknown" then 
			local ID_64 = js.GameStateAPI.GetPlayerXuidStringFromEntIndex(i)
			if ID_64 == "76561197960265728" or ID_64 == myID_64 then
			else
				for j=1, #URLs.ID64 do
					if ID_64 == URLs.ID64[j] then
						should = false
					end
				end
				if should then
					URLs.ID64[#URLs.ID64+1] = ID_64
					counter = counter + 1
					steam_IDS = steam_IDS .. "steamcommunity.com/profiles/" .. ID_64 .. "/\n"
				else
					should = true
				end
			end
		end
	end
	if counter == 0 then 
		client.log("No URL received, total amount: " .. tostring(#URLs.ID64))
	else
		client.log("This time got " .. tostring(counter) .. " different URLs:\n" .. steam_IDS)
		client.log("Total amount: " .. tostring(#URLs.ID64))
	end
end)

local open_button =  ui.new_button("Misc", "Miscellaneous", "Open all URLs", function()
	for k=1, #URLs.ID64 do
		if URLs.ID64[k] ~= nil and URLs.opened[k] ~= true then
			js.SteamOverlayAPI.OpenExternalBrowserURL("https://steamcommunity.com/profiles/" .. URLs.ID64[k])
			URLs.opened[k] = true
		end
	end
end)

local function menu_call()
	ui.set_visible(button, ui.get(enableBox))
	ui.set_visible(open_button, ui.get(enableBox))
end
menu_call()
ui.set_callback(enableBox, menu_call)