-----------------------------------------------------------------------------
-- [[ Dungeon Quest AutoLobby Addon v1.2 - by dns (dns#3420 on discord) ]] --
--               https://github.com/dns2/RBX-DQ-AutoLobby                  --
-----------------------------------------------------------------------------
--[[ 	FOR: Adds Carrying (Auto-hosting or Auto-joining) functionality to Blake's Autofarm.
		TO USE: Configure the settings below and place in autoexec folder along with Blake's Autofarm (separately).
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
	LobbyType = "BossRaid",				-- "Dungeon" or "BossRaid"
--> [ Dungeon ]
	MapName = "Orbital Outpost",
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
	DebugOutput = true					-- Enable or Disable script output to Roblox Developer Console
} -- [ END CONFIG ] --> (Do not edit below this line)

DQAL = {}
SRemote = {
	rFile = nil,
	invoke = {"createLobby","createBossLobby","joinDungeon","playerJoinBossLobby"},
	fire = {"loadPlayerCharacter","changeMute","changeDnD","addPlayerToWhitelist","addPlayerToBossWhitelist","startDungeon","startBossRaid"}	}
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
	while script do script:Destroy() end
end

function DQAL.PreRun()
	DQAL.Prnt("Dungeon Quest AutoLobby initialized. Waiting for game..")
	repeat wait() until game:IsLoaded()
	if game.PlaceId ~= 2414851778 then DQAL.Die(true, "Not a Dungeon Quest Lobby. Exiting..") end
	DQAL.Prnt("Game is loaded. Waiting for character..")
	SRemote("loadPlayerCharacter", true)
	pChar = game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:wait()
	DQAL.Prnt("Character loaded. Continuing..")
	MyName = game.Players.LocalPlayer.Name
	if Settings.LobbyHost == "" then Settings.LobbyHost = MyName end
	if Settings.DisableMusic then SRemote("changeMute") end
	if Settings.DisableTrade then SRemote("changeDnD") end
	if Settings.VIPONLY and not game.Workspace.vipServer.Value then
		warn("VIPONLY setting is enabled, and this is a Public server. Pausing..")
		repeat wait(1) until not game.Workspace.vipServer.Value
	end
end

function DQAL.CreateLobby()
	DQAL.Prnt("Creating a "..Settings.LobbyType.." Lobby..")
	if Settings.LobbyType == "Dungeon" then
		SRemote("createLobby", Settings.MapName, Settings.Difficulty, 0, Settings.Hardcore, Settings.Private, Settings.WaveDefense)
		LobbyFolder = game.Workspace.games.inLobby:WaitForChild(MyName, 30)
	elseif Settings.LobbyType == "BossRaid" then
		SRemote("createBossLobby", Settings.BRTier, Settings.Private, Settings.BRTierReq)
		LobbyFolder = game.Workspace.bossLobbies:WaitForChild(MyName, 30)
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
	DQAL.Prnt("Joining "..Settings.LobbyHost.."'s Lobby..")

	if Settings.LobbyType == "Dungeon" then
		SRemote("joinDungeon", Settings.LobbyHost)
		game.Workspace.games.inLobby[Settings.LobbyHost]:WaitForChild(MyName, 30)
	elseif Settings.LobbyType == "BossRaid" then
		local raidHost = game.Workspace.bossLobbies[Settings.LobbyHost]
		SRemote("playerJoinBossLobby", raidHost)
		game.Workspace.bossLobbies[Settings.LobbyHost]:WaitForChild(MyName, 30)
	end

	DQAL.Prnt("Lobby joined. Waiting for "..Settings.LobbyHost.." to start game..")
	while game.PlaceId == 2414851778 do	wait(.5) end
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

if Settings.Enabled then
	DQAL.PreRun()
	if Settings.LobbyHost == MyName then
		DQAL.CreateLobby()
		DQAL.Whitelist()
		DQAL.StartDungeon()
	else
		DQAL.JoinLobby()
	end
end

-- // End of Dungeon Quest AutoLobby // --
