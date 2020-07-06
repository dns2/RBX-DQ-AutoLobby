-----------------------------------------------------------------------------
-- [[ Dungeon Quest AutoLobby Addon v1.3 - by dns (dns#3420 on discord) ]] --
--               https://github.com/dns2/RBX-DQ-AutoLobby                  --
-----------------------------------------------------------------------------
--[[ 	FOR: Adds Carrying (Auto-hosting and/or Auto-joining) functionality to Blake's Autofarm.
		TO USE:
			Configure the settings below, put autolobby file in exploit's autoexec folder, put autofarm file in exploit's 'workspace' folder.
		SUPPORT: If you need help with using/configuring this, then message me (dns#3420) on discord, or use link below.
			* Full Configuration and Usage info is available at https://github.com/dns2/RBX-DQ-AutoLobby/blob/master/README.md
		NOTES:
			This will not teleport you to VIP servers. The VIPONLY option is only for usage with the 'AutoRestart' program.
			Usernames, Map name, & Difficulty are all case-sensitive. *Example: "player1" is not the same as "Player1")		]]

-- [ CONFIG ]
Settings = {
	--> [ Script ]
		Enabled = true,						-- false = disable/skip Autolobby
		VIPONLY = false,					-- true = Suspend everything unless on a VIP Server
	--> [ Hosting ]
		LobbyHost = "HostName",				-- Username of player that will be creating/hosting the game lobby. Will also accept "" to be host
		WLParty  = {"Player1"},				-- Username(s) to whitelist. Example: {"Player1","Player2","Player3"} | Will also accept {} for solo
		LobbyType = "Dungeon",				-- "Dungeon" or "BossRaid"
	--> [ Dungeon ]
		MapName = "Volcanic Chambers",
		Difficulty = "Nightmare",
		Hardcore = true,
		WaveDefense = false,				-- Keep this false. (Wave defence doesn't currently work on Blake's Autofarm)
	--> [ BossRaid ]
		BRTier = 30,						-- I'll add an Auto feature for this in a future update
		BRTierReq = 0,						-- Leave at 0. Reserved for future update
	--> [ Misc ]
		Private = true,						-- Keep this true. Reserved for future update
		DisableMusic = true,				-- true = Music disabled | false = Music enabled
		DisableTrade = true,				-- true = Trading disabled | false = Trading enabled
		DebugOutput = true,					-- Enable or Disable script output to Roblox Developer Console
		NameOfAutofarmFile = "Blakes_P_DQ_Autofarm_V5.2C.lua",	-- EXACT name of the autofarm lua file
		RunAfOnlyAsHost = true				-- true = Will only run Autofarm when you're the host | false = Will always run Autofarm when Dungeon loads
	} -- [ END CONFIG ] --> (Do not edit below this line)

	DQAL = {}
	SRemote = {
		rFile = nil,
		invoke = {"createLobby","createBossLobby","joinDungeon","playerJoinBossLobby"},
		fire = {"loadPlayerCharacter","changeMute","changeDnD","addPlayerToWhitelist","addPlayerToBossWhitelist","startDungeon","startBossRaid"}}
	setmetatable(SRemote, {__call =
	function(tbl, rScript, ...)
		if not tbl.rFile then tbl.rFile = game:GetService("ReplicatedStorage"):FindFirstChild("remotes") end
		if table.find(tbl.invoke, rScript) then tbl.rFile:FindFirstChild(rScript):InvokeServer(...) return end
		if table.find(tbl.fire, rScript) then tbl.rFile:FindFirstChild(rScript):FireServer(...) return end
	end})

	function DQAL.Prnt(...)
		if Settings.DebugOutput then print("[DQAL]:",...) end
	end

	function DQAL.Die(p, ...)
		if p then DQAL.Prnt(...) end
		Settings = nil
		DQAL = nil
		script:Destroy()
		script.Disabled = true
		error("'I refused to die, but alas, my creator willed it so. Therefore, it shall be done.' [Coderonians:187]", 0)
	end

	function DQAL.PreRun()
		DQAL.Prnt("Dungeon Quest AutoLobby initialized. Waiting for game..")
		repeat wait() until game:IsLoaded()
		local place = game.PlaceId
		if place ~= 2414851778 then
			if not DQAL.CheckPlaceID(place) then
				DQAL.Die(true, "Not a known Dungeon Quest Lobby/Dungeon. Exiting..")
			elseif DQAL.CheckPlaceID(place) then
				return 2 -- Determine whether to load Autofarm
			end
		end
		DQAL.Prnt("Game is loaded. Waiting for character..")
		SRemote("loadPlayerCharacter", true)
		MyChar = game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:wait()
		DQAL.Prnt("Character loaded. Continuing..")
		MyName = game.Players.LocalPlayer.Name
		if Settings.LobbyHost == "" then Settings.LobbyHost = MyName end
		if Settings.DisableMusic then SRemote("changeMute") end
		if Settings.DisableTrade then SRemote("changeDnD") end
		if Settings.VIPONLY and not game.Workspace.vipServer.Value then
			warn("VIPONLY setting is enabled, and this is a Public server. Pausing..")
			repeat wait(1) until not game.Workspace.vipServer.Value
		end
		return 1 -- Allow Autolobby to continue
	end

	function DQAL.CreateLobby()
		DQAL.Prnt("Creating a "..Settings.LobbyType.." Lobby..")
		if Settings.LobbyType == "Dungeon" then
			SRemote("createLobby", Settings.MapName, Settings.Difficulty, 0, Settings.Hardcore, Settings.Private, Settings.WaveDefense)
			LobbyFolder = game.Workspace.games.inLobby:WaitForChild(MyName, 60)
		elseif Settings.LobbyType == "BossRaid" then
			SRemote("createBossLobby", Settings.BRTier, Settings.Private, Settings.BRTierReq)
			LobbyFolder = game.Workspace.bossLobbies:WaitForChild(MyName, 60)
		end
		DQAL.Prnt(Settings.LobbyType.." Lobby created.")
	end

	function DQAL.JoinLobby()
		DQAL.Prnt("Looking for "..Settings.LobbyHost.."'s Lobby..")
		if Settings.LobbyType == "Dungeon" then
			LobbyFolder = game.Workspace.games.inLobby:WaitForChild(Settings.LobbyHost, 1200)
		elseif Settings.LobbyType == "BossRaid" then
			LobbyFolder = game.Workspace.bossLobbies:WaitForChild(Settings.LobbyHost, 1200)
		end
		DQAL.Prnt(Settings.LobbyHost.."'s "..Settings.LobbyType.." Lobby found.")
		wait()
			function sendJoin()
				DQAL.Prnt("Joining "..Settings.LobbyHost.."'s Lobby..")
				if Settings.LobbyType == "Dungeon" then
					SRemote("joinDungeon", Settings.LobbyHost)
					game.Workspace.games.inLobby[Settings.LobbyHost]:WaitForChild(MyName, 10)
				elseif Settings.LobbyType == "BossRaid" then
					local raidHost = game.Workspace.bossLobbies[Settings.LobbyHost]
					SRemote("playerJoinBossLobby", raidHost)
					game.Workspace.bossLobbies[Settings.LobbyHost]:WaitForChild(MyName, 10)
				end
			end
			function confirmJoin()
				if Settings.LobbyType == "Dungeon" then
					if not game.Workspace.games.inLobby[Settings.LobbyHost]:FindFirstChild(MyName) then sendJoin() end
				elseif Settings.LobbyType == "BossRaid" then
					if not game.Workspace.bossLobbies[Settings.LobbyHost]:FindFirstChild(MyName) then sendJoin() end
				end
			end
		sendJoin()
		DQAL.Prnt("Lobby joined. Waiting for "..Settings.LobbyHost.." to start game..")
		while game.PlaceId == 2414851778 do
			wait(5)
			confirmJoin()
		end
	end

	function DQAL.Whitelist()
		if #Settings.WLParty <= 0 then return end
		local lobbyPlyrs, plyrsAdded, plyrsOnline, partyReady = {},{},{},false
		DQAL.Prnt("Waiting to whitelist ["..#Settings.WLParty.."] players..")
		repeat
			wait()
			plyrsOnline = game:GetService("Players"):GetPlayers()
			for _,p in pairs(plyrsOnline) do
				if table.find(Settings.WLParty, p.Name) and not table.find(lobbyPlyrs, p.Name) and not table.find(plyrsAdded, p.Name) then
					if Settings.LobbyType == "Dungeon" then
						SRemote("addPlayerToWhitelist", p.Name)
					elseif Settings.LobbyType == "BossRaid" then
						SRemote("addPlayerToBossWhitelist", p.Name)
					end
					table.insert(plyrsAdded, p.Name)
					DQAL.Prnt(p.Name.." whitelisted. ["..#plyrsAdded.."/"..#Settings.WLParty.."]")
				end
			end
			lobbyPlyrs = LobbyFolder:GetChildren()
			if Settings.LobbyType == "Dungeon" then
				if #Settings.WLParty == #lobbyPlyrs-2 then partyReady = true end
			elseif Settings.LobbyType == "BossRaid" then
				if #Settings.WLParty == #lobbyPlyrs-1 then partyReady = true end
			end
		until(partyReady and (#Settings.WLParty == #plyrsAdded))
		DQAL.Prnt("All players whitelisted and ready.")
	end

	function DQAL.StartDungeon()
		DQAL.Prnt("Starting game..")
		if Settings.LobbyType == "Dungeon" then
			SRemote("startDungeon")
		elseif Settings.LobbyType == "BossRaid" then
			SRemote("startBossRaid")
		end
		DQAL.Prnt("Waiting to teleport out..")
		while game.PlaceId == 2414851778 do	wait(.5) end
	end

	function DQAL.CheckPlaceID(_id)
		local Dungeons = {
			2606294912, -- Desert Temple
			2743806150, -- Winter Outpost
			2988891534, -- Pirate Island
			3041739550, -- King's Castle
			3119903031, -- The Underworld
			3277965370, -- Samurai Palace
			3488584454, -- The Canals
			3737465474, -- Ghastly Harbor
			4113459044, -- Steampunk Sewers
			4628698373, -- Orbital Outpost
			4865331948, -- Egg Island
			5281215714, -- Volcanic Chambers
		}
		if table.find(Dungeons, _id) then
			return true
		else
			return false
		end
	end

	if Settings.Enabled then
		local task = DQAL.PreRun()
		if task == 1 then
			if Settings.LobbyHost == MyName then
				DQAL.CreateLobby()
				DQAL.Whitelist()
				DQAL.StartDungeon()
			elseif Settings.LobbyHost ~= MyName then
				DQAL.JoinLobby()
			end
		elseif task == 2 then
			MyName = game.Players.LocalPlayer.Name
			if Settings.LobbyHost == MyName then
				DQAL.Prnt("Joined Dungeon as Host! Loading '"..Settings.NameOfAutofarmFile.."'..")
				do loadfile(Settings.NameOfAutofarmFile)() end
			elseif Settings.LobbyHost ~= MyName then
				if not Settings.RunAfOnlyAsHost then
					DQAL.Prnt("Joined Dungeon as Alt/Carry! Loading '"..Settings.NameOfAutofarmFile.."'..")
					do loadfile(Settings.NameOfAutofarmFile)() end
				elseif Settings.RunAfOnlyAsHost then
					DQAL.Prnt("Joined Dungeon as Alt/Carry!")
					return
				end
			end
		end
	end

	-- // End of Dungeon Quest AutoLobby // --
