IGameEventListener.AddEvent("vote_options", false)

-- Init Menu
Menu.Spacing()
Menu.Separator()
Menu.Spacing()
Menu.Checkbox("Vote Loger", "bVoteLoger", true)

local Options = {}

function VoteOptions(Event)
    Options = {}

    local count = Event:GetInt("count", 0)

    for i = 0, count do
        Options[i] = Event:GetString("option" .. tostring(i + 1), "")
    end
end

function VoteCast(Event)
    local entityid = Event:GetInt("entityid", 0)
    local vote_option = Event:GetInt("vote_option", 0)

    local Option = Options[vote_option]

    local Player = IEntityList.GetPlayer(entityid)
    if (not Player) then return end

    local PlayerInfo = CPlayerInfo.new()
    if (not Player:GetPlayerInfo(PlayerInfo)) then return end

    local color = "\x06"
    if (Option == "No") then
        color = "\x07"
    end

    --local Name = "\x01Player \x0B" .. PlayerInfo.szName
    local Name = "\x0B" .. PlayerInfo.szName
    if (IEngine.GetLocalPlayer() == entityid) then
        Name = "\x05You"
    end

    local Message = "\x01[".. color .."INTERIUM\x01] " .. Name .. " \x08voted for " .. color .. Option

    IChatElement.ChatPrintf(0, 0, Message)
end

function FireEventClientSideThink(Event)
    if (not Menu.GetInt("bVoteLoger")) then return end
    if (not Utils.IsLocal()) then return end

    if (Event:GetName() == "vote_options") then
        VoteOptions(Event)
    end

    if (Event:GetName() == "vote_cast") then
        VoteCast(Event)
    end
end
Hack.RegisterCallback("FireEventClientSideThink", FireEventClientSideThink)