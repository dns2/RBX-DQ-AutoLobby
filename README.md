# RBX-DQ-AutoLobby

Auto-Lobby Script for the game "Dungeon Quest" on Roblox

## Introduction

   This script was designed to give you the additional capability of **Auto-hosting** a game lobby, or **Auto-joining** another player's game lobby. It was made to work with Blake's Autofarm on the game Dungeon Quest. It is useful for auto-hosting/joining friends and alt accounts.

## Usage

   To use this script you must **download `AutolobbyDQ.lua`** and then **edit the settings** in the config section at the top of the file. What each setting means and how to use it is explained below in Settings section.

   ~~There's two ways you can configure the script to work with the Autofarm script.~~ Autoexec method has been removed due to unreliability.

   **Loadfile Method**: After configuring the file, you **place it in the autoexec folder of your exploit program** (*like Synapse X*), **and place Blake's Autofarm file in the exploit 'workspace' folder**. They should be individual/separate files. You can name the autofarm whatever you wish, just be sure to update the exact name of it in the Misc area of the autolobby file's settings.

   The settings in the Autolobby script do not affect the settings of the Autofarm script nor do they change how it performs. The Autofarm script will detect where it is once a dungeon or boss raid dungeon has loaded, and will do what it is supposed to do from there. *This script only handles lobby creation, whitelisting, and joining.*

   The Autolobby script is now also capable of handling multiple accounts at once on the same PC, using the Multiple_Roblox exploit. Using this tactic, you can host and carry the accounts of your choosing simultaneously. This means on one PC you can have a host auto-creating lobbies as well as one or more alt/carry accounts auto-joining it. I will be writing a separate info file to explain how to do this, and will add the link to it in this file shortly.

## Settings

Important: **Usernames**, **Map name**, & **Difficulty** are all **case-sensitive**. *Example: "player1" is not the same as "Player1")

### Script

* Enabled

  `true` : *Enables Autolobby script. Script will attempt to run with configured settings.*

  `false` : *Disables Autolobby. Script will exit immediately.*

* VIPONLY

  **Note**: *This script cannot teleport you to VIP servers. This setting is only for usage with the AutoRestart program. It simply detects whether you have loaded into a VIP server or not and then pauses further script execution based on whether you have enabled it or not.*

  `true` : *Will pause any further execution of script detects you are in a public server. Will prevent the script from continuing.*

  `false` : *Will not suspend the script if it detects you're in a public server when loaded.*

___

### Hosting

* LobbyHost

   The username of the player that will be creating and hosting the game lobby. If you will be the one hosting, then you can either put your own username or simply leave it empty (such as `""`). *If you will be using the Multiple_Roblox method then the exact username is required.*

  **Examples**:

   `"MyUserName"` : *Your username or another player you want to automatically join*

   `""` : *A shortcut for you to host without inputting your username in the script*

* WLParty

   The username(s) to whitelist. Whatever players you put here will be whitelisted for the game you create. This option does nothing if you are not the host. When you are the host and have players listed here, the script will not start the game until all players have been whitelisted and joined the game party.

  **Examples**:

  `{"Player1","Player2","Player3"}` : *Whitelist multiple players*

  `{"Player1"}` : *Whitelist single player*

  `{}` : *Do not whitelist or wait for other players*

* LobbyType

   The type of lobby to create. This option is only used if you will be the one hosting.

  **Examples**:

  `"Dungeon"` : *Create a dungeon lobby*

  `"BossRaid"` : *Create a boss raid lobby*

___

### Dungeon

* MapName

   The name of the Dungeon map. *This option only matters if you are hosting.*

  **Example**:

  `"Desert Temple"` : *To host a dungeon on the Desert Temple map*

* Difficulty

   The difficulty setting for the Dungeon. *This option only matters if you are hosting.*

  **Example**:

  `"Nightmare"` : *To set difficulty to Nightmare*

* Hardcore

   Whether the hardcore setting will be enabled or not for the Dungeon map. *This option only matters if you are hosting.*

  **Example**:

  `true` or `false` : *Enable or disable Hardcore mode*

* WaveDefense

   This option should be kept `false`. (Wave defence doesn't currently work on Blake's Autofarm).

___

### BossRaid

* BRTier

   The tier number of the boss raid lobby you wish to create. *This option only matters if you are hosting.*

  **Example**:

  `10` : *To set the Boss Raid Tier to level 10*

* BRTierReq

   The tier requirement for players joining your boss raid lobby. *This option should remain at `0`. Reserved for a possible future update.*

___

### Misc

* Private

   **(Unused)** Whether or not to make your lobby private or public when creating it. *Keep this set to `false`. Reserved for a possible future.* update.

* DisableMusic

   If `true` this will disable the game music that plays once you have spawned into the game. If `false`, does nothing.

* DisableTrade

   If `true` this will disable your trade requests after spawning into the game. If `false`, leaves trading enabled.

* DebugOutput

   `true` or `false` : Enables or Disables the script output to Roblox Developer Console. *On PC you can quickly open the console using the F9 button.*

* NameOfAutofarmFile

   `"AutofarmFileName.lua"` : The **exact** filename you have for Blake's Autofarm file. *The file must be located in your exploit workspace folder*.

* RunAfOnlyAsHost

   `true` Autofarm file will only be run after the dungeon is loaded **if it's the account hosting the game lobby**

   `false` Autofarm file **will always be allowed to run after a dungeon is loaded**, even if you are just auto-joining another account

