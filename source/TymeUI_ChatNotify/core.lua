local addon, ns = ...
local frame = CreateFrame('Frame');
ChatNotify = LibStub('AceAddon-3.0'):NewAddon('ChatNotify', 'AceConsole-3.0', 'AceEvent-3.0', 'AceHook-3.0');

local defaults = {
    profile = {
        GuildEnabled = false,
        GuildSound = '',
        OfficerEnabled = false,
        OfficerSound = '',
        PartyEnabled = false,
        PartySound = '',
        PartyLeaderEnabled = false,
        PartyLeaderSound = '',
        RaidEnabled = false,
        RaidSound = '',
        RaidLeaderEnabled = false,
        RaidLeaderSound = '',
        InstanceGroupEnabled = false,
        InstanceGroupSound = '',
        InstanceLeaderEnabled = false,
        InstanceLeaderSound = '',
        WhispersEnabled = false,
        WhispersSound = '',
        BNETWhispersEnabled = false,
        BNETWhispersSound = '',
    },
}

local ChatNotifyPlaySound = function(msgtype)
    --ns.chat('chat', '*** ChatNotifyPlaySound *** =>  msgtype: '..msgtype);
    --ns.chat('chat', '*** ChatNotifyPlaySound *** =>  GuildEnabled: '..tostring(ChatNotify.db.profile.GuildEnabled));
    if msgtype == 'GUILD' and ChatNotify.db.profile.GuildEnabled == true then
        ns.playMediaSound(ChatNotify.db.profile.GuildSound);
    elseif msgtype == 'OFFICER' and ChatNotify.db.profile.OfficerEnabled == true then
        ns.playMediaSound(ChatNotify.db.profile.OfficerSound);
    elseif msgtype == 'PARTY' and ChatNotify.db.profile.PartyEnabled == true then
        ns.playMediaSound(ChatNotify.db.profile.PartySound);
    elseif msgtype == 'PARTY_LEADER' and ChatNotify.db.profile.PartyLeaderEnabled == true then
        ns.playMediaSound(ChatNotify.db.profile.PartyLeaderSound);
    elseif msgtype == 'RAID' and ChatNotify.db.profile.RaidEnabled == true then
        ns.playMediaSound(ChatNotify.db.profile.RaidSound);
    elseif msgtype == 'RAID_LEADER' and ChatNotify.db.profile.RaidLeaderEnabled == true then
        ns.playMediaSound(ChatNotify.db.profile.RaidLeaderSound);
    elseif msgtype == 'INSTANCE_CHAT' and ChatNotify.db.profile.InstanceGroupEnabled == true then
        ns.playMediaSound(ChatNotify.db.profile.InstanceGroupSound);
    elseif msgtype == 'INSTANCE_CHAT_LEADER' and ChatNotify.db.profile.InstanceLeaderEnabled == true then
        ns.playMediaSound(ChatNotify.db.profile.InstanceLeaderSound);       
    end
end

local ChatNotifyOnEvent = function(self, event, ...)
    local arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9 = ...;
	if (strsub (event, 1, 8) == 'CHAT_MSG') then
		local msgtype = strsub (event, 10)
		if msgtype == 'CHANNEL' then -- exclude afk/dnd, global channel and blacklisted custom channels messages.
			if arg6 == 'AFK' or arg6 == 'DND' or arg6 == 'COM' or arg7 > 0 then return end
            --if arg9 and ChatSounds_Config[ChatSounds_Player].Blacklist[strlower(arg9)] then return end
            ns.chat('chat', '*** ChatNotifyOnEvent *** => arg9: '..strlower(arg9));
            return
        end
       
		if (arg2 ~= ns.getDBCharName(false)) then
            ChatNotifyPlaySound(msgtype);
            return
        end
        --ChatNotifyPlaySound(msgtype);
	end
end

local ChatFrameOnEvent = function (self, event, ...)
    local arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9 = ...;

    if not (strsub(event, 1, 8) == 'CHAT_MSG') then
        return
    end

    if (event == 'CHAT_MSG_WHISPER') then
        if not ((strsub(arg1, 1, 4) == 'LVPN') or (strsub(arg1, 1, 4) == 'LVBM')) then --- Deadly Boss Mod filter
            if (self.tellTimer and (GetTime ( ) > self.tellTimer)) then
                if arg6 == 'GM' or arg6 == 'DEV' then 
                    ChatNotifyPlaySound('GMWHISPER')
                 else
                    ChatNotifyPlaySound('WHISPER')
                end
            end

             self.tellTimer = GetTime ( ) + CHAT_TELL_ALERT_TIME
        end
    elseif (event == 'CHAT_MSG_WHISPER_INFORM') then
        if not ((strsub(arg1, 1, 4) == 'LVPN') or (strsub(arg1, 1, 4) == 'LVBM')) then --- Deadly Boss Mod filter
            if (arg2) then 
                ChatEdit_SetLastTellTarget(arg2,'WHISPER')
            end
            ChatNotifyPlaySound('WHISPER')
        end
    elseif (event == 'CHAT_MSG_BN_WHISPER') then
        if (self.tellTimer and (GetTime ( ) > self.tellTimer)) then
            ChatNotifyPlaySound('BNWHISPER')
        end

        self.tellTimer = GetTime ( ) + CHAT_TELL_ALERT_TIME
    elseif (event == 'CHAT_MSG_BN_WHISPER_INFORM') then
        if (arg2) then 
            ChatEdit_SetLastTellTarget(arg2,'BN_WHISPER')
        end
        ChatNotifyPlaySound('BNWHISPER')
    end
end

function ChatNotify:OnInitialize()
    -- Called when the addon is loaded
    self.db = LibStub('AceDB-3.0'):New('ChatNotifyDB', defaults)
    ns.loadSounds();
    local options = ns.configOptions();

	options.args.profiles = LibStub('AceDBOptions-3.0'):GetOptionsTable(self.db)
	LibStub('AceConfig-3.0'):RegisterOptionsTable('ChatNotify', options)
	self.optionsFrame = LibStub('AceConfigDialog-3.0'):AddToBlizOptions('ChatNotify', 'ChatNotify')
    self:RegisterChatCommand('cn', 'ChatCommand')
    self:RegisterChatCommand('chatNotify', 'ChatCommand')

	self.db.RegisterCallback(self, 'OnProfileChanged', 'ChangeProfile')
	self.db.RegisterCallback(self, 'OnProfileCopied', 'ChangeProfile')
    self.db.RegisterCallback(self, 'OnProfileReset', 'ResetProfile')
end

function ChatNotify:OnEnable()
     -- Called when the addon is enabled
     --DEFAULT_CHAT_FRAME:AddMessage(ChatSounds_label..' '.. ChatSounds_Version .. ' are loaded.');
     --hooksecurefunc('ChatFrame_OnEvent', ChatFrameOnEvent);
    frame:SetScript('OnEvent', ChatNotifyOnEvent);
    frame:RegisterEvent('CHAT_MSG_GUILD')
    frame:RegisterEvent('CHAT_MSG_OFFICER')
    frame:RegisterEvent('CHAT_MSG_PARTY')
    frame:RegisterEvent('CHAT_MSG_PARTY_LEADER')
    frame:RegisterEvent('CHAT_MSG_RAID')
    frame:RegisterEvent('CHAT_MSG_RAID_LEADER')
    frame:RegisterEvent('CHAT_MSG_INSTANCE_CHAT')
    frame:RegisterEvent('CHAT_MSG_INSTANCE_CHAT_LEADER')
    frame:RegisterEvent('CHAT_MSG_CHANNEL')

    ns.chat('chat', 'Addon Loaded');
end

function ChatNotify:OnDisable()
    -- Called when the addon is disabled
end

function ChatNotify:ChatCommand(input)
    if not input or input:trim() == '' then
        InterfaceOptionsFrame_OpenToCategory('ChatNotify')
    else
        LibStub('AceConfigCmd-3.0'):HandleCommand('cn', 'chatNotify', input)
    end
end

function ChatNotify:ResetProfile()
	wipe(self.db.profile)
  	for id, value in pairs(defaults.profile) do
  		self.db.profile[id] = value
	end
end

function ChatNotify:ChangeProfile()
	--GlobalPrefs = self.db.profile.GlobalPrefs or {}
end