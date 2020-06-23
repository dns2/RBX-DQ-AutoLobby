## Using Dungeon Quest AutoLobby with the Multiple_Roblox exploit

The Multiple Roblox exploit allows you to have multiple instances of the roblox player running at the same time on one PC. It's free, small, has a portable version, and is available at https://wearedevs.net/dinfo/Multiple%20RBX%20Games with usage instructions on the download page. You have most likely heard of this exploit tool, it has been around for quite a long time.

Using that, along with the AutoLobby script, you have the capability of auto-hosting on one account while auto-joining it with one *or more* other accounts. Or, you could have multiple accounts auto-joining someone else that is hosting/carrying them for you. The possibilities and usages are numerous. Along with the new 'RunAfOnlyAsHost' option in the AutoLobby script, you now have a much more versatile set of options than before.

### Setup Info

Ensure you have the newest version of the AutoLobby script.

Configure your settings in the script depending on what you want to do. I will explain the settings and how to get it started in an example below..

You have 2 accounts, Account1 and Account2. You want to host with Account1, and join with Account2.

* You would configure these applicable settings like so:
 * VIPONLY = false,             -- Must be false (Cannot use autorestart program while using Multiple Roblox exploit.)
 * LobbyHost = "Account1",      -- Must be the exact username of the host account
 * WLParty  = {"Account2"},     -- Must have the exact username of the account that will be joining the host
 * RunAfOnlyAsHost = true,      -- Must be true if you want Account1 to run the autofarm and Account2 to sit and wait in dungeon until it's completed *(If you set this to false then both accounts would attempt to load the autofarm file.)*

The rest of the options in the settings have the typical expected affect on the script. But this allows you to have a **single instance of the AutoLobby script in the autoexec folder** and allow it to handle different accounts, in different ways, *depending on where the account is located in the script settings*.

*If the account is listed as LobbyHost, then the applicable Hosting options will apply to it. Such as the game it creates (map/difficulty/etc), and who it whitelists.*
*If the account is listed in WLParty then it will ignore those Hosting options and then attempt to wait to join the listed LobbyHost.*

Ensure the above settings are configured, and edit the rest of the AutoLobby settings how you need them. Don't forget to save your changes to the script file.

Ensure the AutoLobby script is inside your Roblox exploit's "autoexec" folder.

*If you are using Synapse X, I have tested and this does work with auto-launch enabled, but is not required. You can just have Synapse X open and minimized if you want, as long as auto-attach is enabled. It will automatically inject each game and run the AutoLobby script from autoexec as each Roblox window opens.*

Close any open Roblox player/game windows.

Download and run the Multiple Roblox exploit.

In your browser, log into either Account1 or Account2 (the order doesn't matter) and then load a Dungeon Quest game. Leave it running and focus back on your browser.

Log out of the first Roblox account on the browser. Log into the other account. Load another Dungeon Quest game.

You should now have 2 Dungeon Quest game windows open, 1 each for both accounts. (Make sure you put both accounts in the same game server.)

The AutoLobby script should then begin having Account1 create a game, and Account2 will join it when it finds it.

Once the Dungeon loads, Account1 will load the Autofarm script and complete the Dungeon while Account2 waits/idles.

After the Dungeon is complete, both accounts should teleport together to the same public lobby and continue the process.

*If you have issues with it not working properly, viewing the script's debug output in the Roblox in-game developer console is usually pretty insightful.*

#### Notes

Using the setup listed above, you can carry even more accounts simultaneously by simply adding more accounts to the WLParty option and loading the game windows for them. The limit will be the limits of your PC and/or Network Connection capabilites. But be aware that **teleport errors are bound to happen with Dungeon Quest**, regardless of doing this or not, and there is currently no way to script a recovery for that error if it occurs. So you would have to manually restart/reload whichever account happens to get errored out and have it join the other account(s) again to continue the process.

As usual, if you have any questions about how to do any of this, feel free to message me on Discord at **dns#3420**. Enjoy!