-----------------------------------------------------------------------------
-- [[ Dungeon Quest AutoLobby Addon v1.1 - by dns (dns#3420 on discord) ]] --
-----------------------------------------------------------------------------
-- This adds Carrying (Auto-hosting/Auto-joining) functionality to Blake's Autofarm.
-- TO USE: Paste Blake's Autofarm code below this one (or paste this one above Blake's)
-- SUPPORT: If you need help with using/configuring this, then message me (dns#3420) on discord.
-- NOTE: This will not teleport you to VIP servers. The VIPONLY option is only for usage with the AutoRestart program.

-- [[ CONFIG ]] -- (NOTES: Usernames, Map name, & Difficulty are all case-sensitive. *Example: "player1" is not the same as "Player1")
---> Hosting options
_G.DQAL_LobbyHost = "HostName" -- Put your username here if you'll be hosting/carrying other players, or the host's name if you'll be joining someone else's game
_G.DQAL_WLParty = {"Player1"} -- Username(s) to whitelist. Example: {"Player1","Player2","Player3"} | Or for solo farming just use {}
_G.DQAL_LobbyType = "Dungeon" -- "Dungeon" or "BossRaid"
---> Dungeon options
_G.DQAL_MapName = "Orbital Outpost"
_G.DQAL_Difficulty = "Nightmare"
_G.DQAL_Hardcore = true
_G.DQAL_WaveDefense = false -- Wave defence doesn't currently work on Blake's Autofarm. Leave this false, for now.
---> BossRaid options
_G.DQAL_BRTier = 30 -- I'll add an Auto feature for this in a future update.
_G.DQAL_BRTierReq = 0 -- Leave at 0. This option is for a future update.
---> Universal options
_G.DQAL_Enabled = true -- Change to false to disable/skip the Autolobby code. (Will make it skip this and go straight to Blake's Autofarm)
_G.DQAL_Private = true -- Keep this true, will be used in a future update. (False allows open lobbies which anyone can join)
_G.DQAL_VIPONLY = false -- true = Suspend everything unless on a VIP Server (Only used for autofarming with autorestart program) | false = Continue working on public servers (risky)
_G.DQAL_DisableMusic = true -- true = Music disabled | false = Music enabled
_G.DQAL_DisableTrade = true -- true = Trading disabled | false = Trading enabled
_G.DQAL_VerboseDebug = true -- Enable or Disable information/error output to Roblox Developer Console

function Prnt(_msg)
	if _G.DQAL_VerboseDebug then print("[DQAL]: "..tostring(_msg)) end
end
Prnt("Dungeon Quest AutoLobby has loaded, Waiting for game to load..")
repeat wait() until game:IsLoaded()
Prnt("Game is loaded.")
local MyName = game.Players.LocalPlayer.Name
local Proceed = false
-- [[ FUNCTIONS ]]
function findInTable(tbl, thing)
    for _, x in ipairs(tbl) do
        if x == thing then
            return true
		end
    end
	return false
end
function whitelist()
	if #_G.DQAL_WLParty <= 0 then return false end
	local myLobby = {}
	local plyrsAdded = {}
	local plyrsOnline = {}
	local partyReady = false
	Prnt("Waiting to whitelist ["..#_G.DQAL_WLParty.."] players..")
	repeat
		wait()
		if _G.DQAL_LobbyType == "Dungeon" then
			myLobby = game.Workspace.games.inLobby[MyName]:GetChildren()
			if #_G.DQAL_WLParty == #myLobby-2 then partyReady = true end
		elseif _G.DQAL_LobbyType == "BossRaid" then
			myLobby = game.Workspace.bossLobbies[MyName].players:GetChildren()
			if #_G.DQAL_WLParty == #myLobby-1 then partyReady = true end
		end
		plyrsOnline = game.Players:GetChildren()
		for i, v in ipairs(plyrsOnline) do
			if findInTable(_G.DQAL_WLParty, v.Name) and not findInTable(myLobby, v.Name) and not findInTable(plyrsAdded, v.Name) then
				if _G.DQAL_LobbyType == "Dungeon" then
					game.ReplicatedStorage.remotes.addPlayerToWhitelist:FireServer(v.Name)
				elseif _G.DQAL_LobbyType == "BossRaid" then
					game.ReplicatedStorage.remotes.addPlayerToBossWhitelist:FireServer(v.Name)
				end
				table.insert(plyrsAdded, v.Name)
				Prnt(v.Name.." whitelisted. ["..#plyrsAdded.."/"..#_G.DQAL_WLParty.."]")
			end
		end
	until(partyReady and (#_G.DQAL_WLParty == #plyrsAdded))
	return true
end

if _G.DQAL_Enabled and game.PlaceId == 2414851778 then
	game.ReplicatedStorage.remotes.loadPlayerCharacter:FireServer(true)
	Prnt("Waiting for character to load..")
	game.Players.LocalPlayer.CharacterAdded:Wait()
	Prnt("Character loaded.")
	MyName = game.Players.LocalPlayer.Name
	Prnt("Hello, "..MyName..". Dungeon Quest Lobby found, continuing..")

	--disable music/trading
	if _G.DQAL_DisableMusic then game.ReplicatedStorage.remotes.changeMute:FireServer() end
	if _G.DQAL_DisableTrade then game.ReplicatedStorage.remotes.changeDnD:FireServer() end

	if _G.DQAL_VIPONLY and not game.Workspace.vipServer.Value then
		Prnt("VIPONLY is enabled, and this is a Public server. Stopping here.")
		repeat wait() until not _G.DQAL_VIPONLY
	end

	if _G.DQAL_LobbyHost == MyName then
		--create the lobby
		if _G.DQAL_LobbyType == "Dungeon" then
			Prnt("Creating your Dungeon Lobby..")
			game.ReplicatedStorage.remotes.createLobby:InvokeServer(_G.DQAL_MapName, _G.DQAL_Difficulty, 0, _G.DQAL_Hardcore, _G.DQAL_Private, _G.DQAL_WaveDefense)
		elseif _G.DQAL_LobbyType == "BossRaid" then
			Prnt("Creating your Boss Raid Lobby..")
			game.ReplicatedStorage.remotes.createBossLobby:InvokeServer(_G.DQAL_BRTier, _G.DQAL_Private, _G.DQAL_BRTierReq)
		end

		--whitelist players
		whitelist()

		--start the dungeon
		Prnt("All players have joined. Starting game..")
		if _G.DQAL_LobbyType == "Dungeon" then
			game.ReplicatedStorage.remotes.startDungeon:FireServer()
		elseif _G.DQAL_LobbyType == "BossRaid" then
			game.ReplicatedStorage.remotes.startBossRaid:FireServer()
		end

		--wait for teleport
		Prnt("Waiting to teleport out..")
		while game.PlaceId == 2414851778 do
			wait()
		end

	else -- if joining another host

		--get lobby
		local lobbies = {}
		Proceed = false
		Prnt("Searching for ".._G.DQAL_LobbyHost.."'s Lobby..")
		repeat
			wait()
			if _G.DQAL_LobbyType == "Dungeon" then
				lobbies = game.Workspace.games.inLobby:GetChildren()
			elseif _G.DQAL_LobbyType == "BossRaid" then
				lobbies = game.Workspace.bossLobbies:GetChildren()
			end
			for i,v in next, lobbies do
				if tostring(v) == _G.DQAL_LobbyHost then
					Proceed = true
					Prnt("Lobby found.")
					break
				end
			end
		until(Proceed)

		--join lobby
		Prnt("Joining ".._G.DQAL_LobbyHost.."'s Lobby..")
		Proceed = false
		if _G.DQAL_LobbyType == "Dungeon" then
			game.ReplicatedStorage.remotes.joinDungeon:InvokeServer(_G.DQAL_LobbyHost)
		elseif _G.DQAL_LobbyType == "BossRaid" then
			local raidHost = game.Workspace.bossLobbies[_G.DQAL_LobbyHost]
			game.ReplicatedStorage.remotes.playerJoinBossLobby:InvokeServer(raidHost)
		end
		repeat
			wait()
			local inlobby = {}
			if _G.DQAL_LobbyType == "Dungeon" then
				inlobby = game.Workspace.games.inLobby[_G.DQAL_LobbyHost]:GetChildren()
			elseif _G.DQAL_LobbyType == "BossRaid" then
				inlobby = game.Workspace.bossLobbies[_G.DQAL_LobbyHost].players:GetChildren()
			end
			for i,v in next, inlobby do
				if tostring(v) == game.Players.LocalPlayer.Name then
					Proceed = true
					Prnt("Lobby joined.")
					break
				end
			end
		until(Proceed)

		--wait for teleport
		Prnt("Waiting to teleport out..")
		while game.PlaceId == 2414851778 do
			wait()
		end
	end
else
	Prnt("Not a Dungeon Quest Lobby, or Autolobby is disabled. Exiting.")
end

-- // End of Dungeon Quest AutoLobby. Paste Blake's Autofarm code (ALL of it, including Settings) below this line // --
