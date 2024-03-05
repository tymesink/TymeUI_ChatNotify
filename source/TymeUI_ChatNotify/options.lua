local addon, ns = ...

local options = function()
	return {
		name = 'ChatNotify',
		handler = ChatNotify,
		type = 'group',
		args = {
			profiles = {},
			general = {
				name = 'Settings',
				type = 'group',
				order = 1,
				args = {
					optGuild = {
						type = 'group',
						name = 'Guild',
						inline = true,
						order = 0,
						args = {
							opt1 = {
								type = 'toggle',
								name = 'Enable',
								order = 0,
								get = function() return ChatNotify.db.profile.GuildEnabled end,
								set = function (self, val) ChatNotify.db.profile.GuildEnabled = not ChatNotify.db.profile.GuildEnabled end,
							},
							opt2 = {
								type = 'select',
								style = 'dropdown',
								name = 'Sound',
								order = 1,
								values = ns.getSoundTable(),
								get = function() return ChatNotify.db.profile.GuildSound end,
								set = function (self, value)
									ns.playMediaSound(value);
									ChatNotify.db.profile.GuildSound = value 
								end,
							},
						},
					},
					optOfficer = 
					{
						type = 'group',
						name = 'Officer',
						inline = true,
						order = 1,
						args = {
							opt1 = {
								type = 'toggle',
								name = 'Enable',
								order = 0,
								get = function() return ChatNotify.db.profile.OfficerEnabled end,
								set = function (self, val) ChatNotify.db.profile.OfficerEnabled = not ChatNotify.db.profile.OfficerEnabled end,
							},
							opt2 = {
								type = 'select',
								style = 'dropdown',
								name = 'Sound',
								order = 1,
								values = ns.getSoundTable(),
								get = function() return ChatNotify.db.profile.OfficerSound end,
								set = function (self, value)
									ns.playMediaSound(value);
									ChatNotify.db.profile.OfficerSound = value 
								end,
							},
						},
					},
					optParty = {
						type = 'group',
						name = 'Party',
						inline = true,
						order = 2,
						args = {
							opt1 = {
								type = 'toggle',
								name = 'Enable',
								order = 0,
								get = function() return ChatNotify.db.profile.PartyEnabled end,
								set = function (self, val) ChatNotify.db.profile.PartyEnabled = not ChatNotify.db.profile.PartyEnabled end,
							},
							opt2 = {
								type = 'select',
								style = 'dropdown',
								name = 'Sound',
								order = 1,
								values = ns.getSoundTable(),
								get = function() return ChatNotify.db.profile.PartySound end,
								set = function (self, value)
									ns.playMediaSound(value);
									ChatNotify.db.profile.PartySound = value 
								end,
							},
						},
					},
					optPartyL = {
						type = 'group',
						name = 'Party Leader',
						inline = true,
						order = 3,
						args = {
							opt1 = {
								type = 'toggle',
								name = 'Enable',
								order = 0,
								get = function() return ChatNotify.db.profile.PartyLeaderEnabled end,
								set = function (self, val) ChatNotify.db.profile.PartyLeaderEnabled = not ChatNotify.db.profile.PartyLeaderEnabled end,
							},
							opt2 = {
								type = 'select',
								style = 'dropdown',
								name = 'Sound',
								order = 1,
								values = ns.getSoundTable(),
								get = function() return ChatNotify.db.profile.PartyLeaderSound end,
								set = function (self, value)
									ns.playMediaSound(value);
									ChatNotify.db.profile.PartyLeaderSound = value 
								end,
							},
						},
					},
					optRaid = {
						type = 'group',
						name = 'Raid',
						inline = true,
						order = 4,
						args = {
							opt1 = {
								type = 'toggle',
								name = 'Enable',
								order = 0,
								get = function() return ChatNotify.db.profile.RaidEnabled end,
								set = function (self, val) ChatNotify.db.profile.RaidEnabled = not ChatNotify.db.profile.RaidEnabled end,
							},
							opt2 = {
								type = 'select',
								style = 'dropdown',
								name = 'Sound',
								order = 1,
								values = ns.getSoundTable(),
								get = function() return ChatNotify.db.profile.RaidSound end,
								set = function (self, value)
									ns.playMediaSound(value);
									ChatNotify.db.profile.RaidSound = value 
								end,
							},
						},
					},
					optRaidL = {
						type = 'group',
						name = 'Raid Leader',
						inline = true,
						order = 5,
						args = {
							opt1 = {
								type = 'toggle',
								name = 'Enable',
								order = 0,
								get = function() return ChatNotify.db.profile.RaidLeaderEnabled end,
								set = function (self, val) ChatNotify.db.profile.RaidLeaderEnabled = not ChatNotify.db.profile.RaidLeaderEnabled end,
							},
							opt2 = {
								type = 'select',
								style = 'dropdown',
								name = 'Sound',
								order = 1,
								values = ns.getSoundTable(),
								get = function() return ChatNotify.db.profile.RaidLeaderSound end,
								set = function (self, value)
									ns.playMediaSound(value);
									ChatNotify.db.profile.RaidLeaderSound = value 
								end,
							},
						},
					},
					optInstG = {
						type = 'group',
						name = 'Instance Group',
						inline = true,
						order = 6,
						args = {
							opt1 = {
								type = 'toggle',
								name = 'Enable',
								order = 0,
								get = function() return ChatNotify.db.profile.InstanceGroupEnabled end,
								set = function (self, val) ChatNotify.db.profile.InstanceGroupEnabled = not ChatNotify.db.profile.InstanceGroupEnabled end,
							},
							opt2 = {
								type = 'select',
								style = 'dropdown',
								name = 'Sound',
								order = 1,
								values = ns.getSoundTable(),
								get = function() return ChatNotify.db.profile.InstanceGroupSound end,
								set = function (self, value)
									ns.playMediaSound(value);
									ChatNotify.db.profile.InstanceGroupSound = value 
								end,
							},
						},
					},
					optInstGL = {
						type = 'group',
						name = 'Instance Group Leader',
						inline = true,
						order = 7,
						args = {
							opt1 = {
								type = 'toggle',
								name = 'Enable',
								order = 0,
								get = function() return ChatNotify.db.profile.InstanceLeaderEnabled end,
								set = function (self, val) ChatNotify.db.profile.InstanceLeaderEnabled = not ChatNotify.db.profile.InstanceLeaderEnabled end,
							},
							opt2 = {
								type = 'select',
								style = 'dropdown',
								name = 'Sound',
								order = 1,
								values = ns.getSoundTable(),
								get = function() return ChatNotify.db.profile.InstanceLeaderSound end,
								set = function (self, value)
									ns.playMediaSound(value);
									ChatNotify.db.profile.InstanceLeaderSound = value 
								end,
							},
						},
					},
				},
			},
		},
	}
end
ns.configOptions = options;