-- Init Menu
Menu.Spacing()
Menu.Separator()
Menu.Spacing()
Menu.Text("Panorama")
Menu.Checkbox("Lobby | Invite All (Global)", "bPAutoInviteGlobal", false)
Menu.Checkbox("Lobby | Invite All (Friends)", "bPAutoInviteFriends", false)
Menu.Combo( "Lobby | Spam", "iPSpam", {"Disabled", "Spam Popups", "Spam Queue", "Spam to Chat" })
Menu.Checkbox("Lobby | Clear All Popups Messages", "bPClearPopups", false)
Menu.InputText("Lobby | Chat Text", "bPSpamChatText", "INTERIUM Cheat")


-- Custom
local Delay1 = 190 -- ms


function ClearPopups()
    if (not Menu.GetBool("bPClearPopups")) then 
		return
	end

    IPanorama.RunScript_Menu([[
        UiToolkitAPI.CloseAllVisiblePopups();
	]])
end


function SpamPopups()
    IPanorama.RunScript_Menu([[
	    PartyListAPI.SessionCommand("Game::HostEndGamePlayAgain", `run all xuid ${MyPersonaAPI.GetXuid()}`); 
	]])

	SpamPopupsTicks = 0
end


function SpamQueue()
    IPanorama.RunScript_Menu([[
		LobbyAPI.StartMatchmaking( '', '', '', '' );LobbyAPI.StopMatchmaking();
        LobbyChat.ScrollToBottom();
    ]])
end


function SpamChat()
    IPanorama.RunScript_Menu([[
        var LobbyChat = $('#MainMenu').FindChildInLayoutFile('PartyChat');
        var LobbyChatInput = LobbyChat.FindChildInLayoutFile('ChatInput');
		
        LobbyChatInput.text = "]] .. Menu.GetString("bPSpamChatText") .. [["
        LobbyChat.SubmitChatText();
        LobbyChatInput.text = ""
		
        LobbyChat.ScrollToBottom();
    ]])
end


function InviteGlobal()
    if (not Menu.GetBool("bPAutoInviteGlobal")) then return end

    IPanorama.RunScript_Menu([[
        PartyBrowserAPI.Refresh();
        var Players = PartyBrowserAPI.GetResultsCount();
        for (var i = 0; i < Players; i++) {
			FriendsListAPI.ActionInviteFriend(PartyBrowserAPI.GetXuidByIndex(i), "");
        }
	]])

	Menu.SetBool("bPAutoInviteGlobal", false)
end


function InviteFriends()
    if (not Menu.GetBool("bPAutoInviteFriends")) then return end

	IPanorama.RunScript_Menu([[
        var Friends = FriendsListAPI.GetCount();
        for (var i = 0; i < Friends; i++) {
            FriendsListAPI.ActionInviteFriend(FriendsListAPI.GetXuidByIndex(i), "");
        }
	]])
	
	Menu.SetBool("bPAutoInviteFriends", false)
end


local PanoramaSysTimer = 0
function PanoramaSys(stage)

	if (stage == 5) then
		InviteGlobal()
		InviteFriends()
		
		if (GetTickCount() > PanoramaSysTimer) then
			if (Menu.GetInt("iPSpam") == 1) then 
				SpamPopups()
			elseif (Menu.GetInt("iPSpam") == 2) then 
				SpamQueue()
			elseif (Menu.GetInt("iPSpam") == 3) then 
				SpamChat()
			end

			PanoramaSysTimer = GetTickCount() + Delay1
		end
	end
	
	ClearPopups();
end
Hack.RegisterCallback("FrameStageNotify", PanoramaSys)