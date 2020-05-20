--[[
Dungeon Quest Autolobby->Autofarm Run Check
  This file simply prevents the Autofarm script from running by ensuring it doesn't continue to it by checking the player's UserId.
  For example, if you are using the same PC to run 2 Roblox instances and host on one account and join it on the other. You would put the
  User Id of the account getting carried into this file so that it only runs the Autolobby code, and not the Autofarm code.
  You can get your User Id by visiting your Profile link on the Roblox account and then copying the number in the internet url.
  Example: https://www.roblox.com/users/USERIDNUMBER/profile
]]

--/ Replace the number here with the Account's ID number /--
local useridnum = 000000000
--/ Do not edit below this line /--

if game.Players.LocalPlayer.UserId == useridnum then
	print("AFCheck preventing any further script executions..")
	while game.Players.LocalPlayer.UserId == useridnum do
		wait()
	end
end
