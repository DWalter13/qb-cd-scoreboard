local CD = CD or {}

CD.Scoreboard = {}
local forceDraw = false
local shouldDraw = false
local shouldOpenMenu = false

--shouldDraw = true


function CD.Scoreboard.GetPlayerCount(self)
    local count = NetworkGetNumConnectedPlayers()
    return count
end

Citizen.CreateThread(function()
	local currentItemIndex = 1
	local selectedItemIndex = 1

	WarMenu.CreateMenu('scoreboard', 'Online Players')

	WarMenu.SetSubTitle("scoreboard", "Players")
	WarMenu.SetTitleColor("scoreboard", 135, 206, 250, 255)
    WarMenu.SetTitleBackgroundColor("scoreboard", 0 , 0, 0, 150)
    WarMenu.SetMenuBackgroundColor("scoreboard", 0, 0, 0, 100)
    WarMenu.SetMenuSubTextColor("scoreboard", 255, 255, 255, 255)

    WarMenu.CreateSubMenu('playeroptions', 'scoreboard', 'Player Info')

	while true do
		if WarMenu.IsMenuOpened('scoreboard') then
			if WarMenu.Button("Total:", tostring(CD.Scoreboard:GetPlayerCount()), {r = 135, g = 206, b = 250, a = 150}) then
				else
				local playerlist = GetActivePlayers()
				--print(''..identifierSteam..'')
                for i = 1, #playerlist do
                    local currPlayer = playerlist[i]
                    if WarMenu.MenuButton("ID: ~y~[" .. GetPlayerServerId(currPlayer) .. "] ~s~" .. GetPlayerName(currPlayer), 'playeroptions') then
                        selectedPlayer = currPlayer end
                end
			end

			WarMenu.Display()
		elseif WarMenu.IsMenuOpened('playeroptions') then
			if WarMenu.Button("~p~Selected: " .. "~y~[" .. GetPlayerServerId(selectedPlayer) .. "] ~s~" .. GetPlayerName(selectedPlayer)) then
			elseif WarMenu.Button("ID: ~y~[" .. GetPlayerServerId(selectedPlayer) .. "] ~s~") then
			elseif WarMenu.Button("Name: ~y~[" .. GetPlayerName(selectedPlayer) .. "] ~s~") then
			end

			WarMenu.Display()
		elseif IsControlJustReleased(0, Config.Button) then -- U by default
			WarMenu.OpenMenu('scoreboard')
			shouldDraw = true
		else
			shouldDraw =false
		end

		Citizen.Wait(0)
	end
end)

AddEventHandler('playerSpawned', function(spawn)
    return count
end)


--Draw Things
Citizen.CreateThread(function()
    local animationState = false
    while true do
        Citizen.Wait(0)

        if shouldDraw or forceDraw then
            local nearbyPlayers = GetNeareastPlayers()
            for k, v in pairs(nearbyPlayers) do
                local x, y, z = table.unpack(v.coords)
                Draw3DText(x, y, z + 1.1, v.playerId)
            end
        end
    end
end)

function Draw3DText(x, y, z, text)
    -- Check if coords are visible and get 2D screen coords
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    if onScreen then
        -- Calculate text scale to use
        local dist = GetDistanceBetweenCoords(GetGameplayCamCoords(), x, y, z, 1)
        local scale = 1.8 * (1 / dist) * (1 / GetGameplayCamFov()) * 100

        -- Draw text on screen
        SetTextScale(scale, scale)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 255)
        SetTextDropShadow(0, 0, 0, 0, 255)
        SetTextDropShadow()
        SetTextEdge(4, 0, 0, 0, 255)
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x, _y)
    end
end


function GetNeareastPlayers()
	local playerPed = PlayerPedId()
	local playerlist = GetActivePlayers()
   --local players, _ = ESX.Game.GetPlayersInArea(GetEntityCoords(playerPed), Config.DrawDistance)

    local players_clean = {}
    local found_players = false

    for i = 1, #playerlist, 1 do
        found_players = true
        table.insert(players_clean, { playerName = GetPlayerName(playerlist[i]), playerId = GetPlayerServerId(playerlist[i]), coords = GetEntityCoords(GetPlayerPed(playerlist[i])) })
    end
    return players_clean
end
