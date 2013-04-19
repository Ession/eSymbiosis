-- =============================================================================
--
--       Filename:  eSymbiosis.lua
--
--    Description:  Tells you what you can get and give with symbiosis.
--
--        Version:  5.2.1
--
--         Author:  Mathias Jost (mail@mathiasjost.com)
--
-- =============================================================================


-- -----------------------------------------------------------------------------
-- Create addon table
-- -----------------------------------------------------------------------------
local eSymbiosis = {
	players = {}
}


-- -----------------------------------------------------------------------------
-- Someone changed their talents
-- -----------------------------------------------------------------------------
function eSymbiosis:OnInspectUpdate(event, guid, unit, info)

	-- check if we have all the data needed
	if unit ~= nil or info.class ~= nil or info.global_spec_id ~= nil then

		-- dreate table for the players data
		if not eSymbiosis.players[guid] then
			eSymbiosis.players[guid] = {}
		end

		-- save the players data to his table
		eSymbiosis.players[guid].name = UnitName(unit)
		eSymbiosis.players[guid].class = info.class
		eSymbiosis.players[guid].global_spec_id = info.global_spec_id

	end

end -- function eSymbiosis:OnInspectUpdate(event, guid, unit, info)


-- -----------------------------------------------------------------------------
-- Someone left the group
-- -----------------------------------------------------------------------------
function eSymbiosis:OnInspectRemove(event, guid)

	-- remove the players data from the table
	eSymbiosis.players[guid] = nil
	
end -- function eSymbiosis:OnInspectRemove(event, guid)


-- -----------------------------------------------------------------------------
-- function to get class color codes
-- -----------------------------------------------------------------------------
local function eSymbiosis_ClassColor(class)

	-- return FF000000 (white) if we don't know the class
  	if not RAID_CLASS_COLORS[class] then 
  		return "|cFF000000" -- unknown class
  	end

  	-- return blizzards class color when we DO know the class
  	return string.format("FF%02x%02x%02x", RAID_CLASS_COLORS[class].r * 255, RAID_CLASS_COLORS[class].g * 255, RAID_CLASS_COLORS[class].b * 255)

end -- function eSymbiosis_ClassColor(class)


-- -----------------------------------------------------------------------------
-- function to fint out what spell the druid gets
-- -----------------------------------------------------------------------------
function eSymbiosis:DruidGets(class, druidspec)

	-- the Druids spec is Balance
	if druidspec == 102 then

		if     class == "DEATHKNIGHT" 	then return "\124cff71d5ff\124Hspell:110570\124h[Anti-Magic Shell]\124h\124r"
		elseif class == "DRUID" 		then return "nothing"
		elseif class == "HUNTER" 		then return "\124cff71d5ff\124Hspell:110588\124h[Misdirection]\124h\124r"
		elseif class == "MAGE" 			then return "\124cff71d5ff\124Hspell:110621\124h[Mirror Image]\124h\124r"
		elseif class == "MONK" 			then return "Grapple Weapon"
		elseif class == "PALADIN" 		then return "\124cff71d5ff\124Hspell:110698\124h[Hammer of Justice]\124h\124r"
		elseif class == "PRIEST" 		then return "\124cff71d5ff\124Hspell:110709\124h[Mass Dispel]\124h\124r"
		elseif class == "ROGUE" 		then return "\124cff71d5ff\124Hspell:110788\124h[Cloak of Shadows]\124h\124r"
		elseif class == "SHAMAN" 		then return "\124cff71d5ff\124Hspell:110802\124h[Purge]\124h\124r"
		elseif class == "WARLOCK" 		then return "\124cff71d5ff\124Hspell:122291\124h[Unending Resolve]\124h\124r"
		elseif class == "WARRIOR" 		then return "\124cff71d5ff\124Hspell:122292\124h[Intervene]\124h\124r"
		else 								 return "Unknown"
		end

	-- the Druids spec is Feral
	elseif druidspec == 103 then

		if     class == "DEATHKNIGHT" 	then return "\124cff71d5ff\124Hspell:122283\124h[Death Coil]\124h\124r"
		elseif class == "DRUID" 		then return "nothing"
		elseif class == "HUNTER" 		then return "\124cff71d5ff\124Hspell:110597\124h[Play Dead]\124h\124r"
		elseif class == "MAGE" 			then return "\124cff71d5ff\124Hspell:110693\124h[Frost Nova]\124h\124r"
		elseif class == "MONK" 			then return "Clash"
		elseif class == "PALADIN" 		then return "\124cff71d5ff\124Hspell:110700\124h[Divine Shield]\124h\124r"
		elseif class == "PRIEST" 		then return "\124cff71d5ff\124Hspell:110715\124h[Dispersion]\124h\124r"
		elseif class == "ROGUE" 		then return "\124cff71d5ff\124Hspell:110730\124h[Redirect]\124h\124r"
		elseif class == "SHAMAN" 		then return "\124cff71d5ff\124Hspell:110807\124h[Feral Spirit]\124h\124r"
		elseif class == "WARLOCK" 		then return "\124cff71d5ff\124Hspell:110810\124h[Soul Swap]\124h\124r"
		elseif class == "WARRIOR" 		then return "\124cff71d5ff\124Hspell:112997\124h[Shattering Blow]\124h\124r"
		else 								 return "Unknown"
		end

	-- the Druids spec is Guardian
	elseif druidspec == 104 then

		if     class == "DEATHKNIGHT" 	then return "\124cff71d5ff\124Hspell:122285\124h[Bone Shield]\124h\124r"
		elseif class == "DRUID" 		then return "nothing"
		elseif class == "HUNTER" 		then return "\124cff71d5ff\124Hspell:110600\124h[Ice Trap]\124h\124r"
		elseif class == "MAGE" 			then return "\124cff71d5ff\124Hspell:110694\124h[Frost Armor]\124h\124r"
		elseif class == "MONK" 			then return "Elusive Brew"
		elseif class == "PALADIN" 		then return "\124cff71d5ff\124Hspell:110701\124h[Consecration]\124h\124r"
		elseif class == "PRIEST" 		then return "\124cff71d5ff\124Hspell:110717\124h[Fear Ward]\124h\124r"
		elseif class == "ROGUE" 		then return "\124cff71d5ff\124Hspell:122289\124h[Feint]\124h\124r"
		elseif class == "SHAMAN" 		then return "\124cff71d5ff\124Hspell:110803\124h[Lightning Shield]\124h\124r"
		elseif class == "WARLOCK" 		then return "\124cff71d5ff\124Hspell:122290\124h[Life Tap]\124h\124r"
		elseif class == "WARRIOR" 		then return "\124cff71d5ff\124Hspell:113002\124h[Spell Reflection]\124h\124r"
		else 							   	 return "Unknown"
		end

	-- the Druids spec is Restoration
	elseif druidspec == 105 then

		if     class == "DEATHKNIGHT" 	then return "\124cff71d5ff\124Hspell:110575\124h[Icebound Fortitude]\124h\124r"
		elseif class == "DRUID" 		then return "nothing"
		elseif class == "HUNTER" 		then return "\124cff71d5ff\124Hspell:110617\124h[Deterrence]\124h\124r"
		elseif class == "MAGE" 			then return "\124cff71d5ff\124Hspell:110696\124h[Ice Block]\124h\124r"
		elseif class == "MONK" 			then return "Fortifying Brew"
		elseif class == "PALADIN" 		then return "\124cff71d5ff\124Hspell:122288\124h[Cleanse]\124h\124r"
		elseif class == "PRIEST" 		then return "\124cff71d5ff\124Hspell:110718\124h[Leap of Faith]\124h\124r"
		elseif class == "ROGUE" 		then return "\124cff71d5ff\124Hspell:110791\124h[Evasion]\124h\124r"
		elseif class == "SHAMAN" 		then return "\124cff71d5ff\124Hspell:110806\124h[Spiritwalker's Grace]\124h\124r"
		elseif class == "WARLOCK" 		then return "\124cff71d5ff\124Hspell:112970\124h[Demonic Circle: Teleport]\124h\124r"
		elseif class == "WARRIOR" 		then return "\124cff71d5ff\124Hspell:113004\124h[Intimidating Roar]\124h\124r"
		else 								 return "Unknown"
		end

	else

		return "Unknown"

	end

end -- eSymbiosis:DruidGets(class, druidspec)


-- -----------------------------------------------------------------------------
-- function to find out what spell the druid gives
-- -----------------------------------------------------------------------------
function eSymbiosis:DruidGives(spec)

	if 		spec == 62  then return "\124cff71d5ff\124Hspell:113074\124h[Healing Touch]\124h\124r" -- Arcane
	elseif 	spec == 63  then return "\124cff71d5ff\124Hspell:113074\124h[Healing Touch]\124h\124r" -- Fire
	elseif 	spec == 64  then return "\124cff71d5ff\124Hspell:113074\124h[Healing Touch]\124h\124r" -- Frost
	elseif 	spec == 65  then return "\124cff71d5ff\124Hspell:113269\124h[Rebirth]\124h\124r" -- Holy
	elseif 	spec == 66  then return "\124cff71d5ff\124Hspell:113075\124h[Barkskin]\124h\124r" -- Protection
	elseif 	spec == 70  then return "\124cff71d5ff\124Hspell:122287\124h[Wrath]\124h\124r" -- Retribution
	elseif 	spec == 71  then return "\124cff71d5ff\124Hspell:122294\124h[Stampeding Shout]\124h\124r" -- Arms
	elseif 	spec == 72  then return "\124cff71d5ff\124Hspell:122294\124h[Stampeding Shout]\124h\124r" -- Fury
	elseif 	spec == 73  then return "Savage Defense" -- Protection
	elseif 	spec == 102 then return "nothing" -- Balance
	elseif 	spec == 103 then return "nothing" -- Feral
	elseif 	spec == 104 then return "nothing" -- Guardian
	elseif 	spec == 105 then return "nothing" -- Restoration
	elseif	spec == 250 then return "\124cff71d5ff\124Hspell:113072\124h[Might of Ursoc]\124h\124r" -- Blood
	elseif 	spec == 251 then return "\124cff71d5ff\124Hspell:113516\124h[Wild Mushroom: Plague]\124h\124r" -- Frost
	elseif 	spec == 252 then return "\124cff71d5ff\124Hspell:113516\124h[Wild Mushroom: Plague]\124h\124r" -- Unholy
	elseif 	spec == 253 then return "\124cff71d5ff\124Hspell:113073\124h[Dash]\124h\124r" -- Beast Mastery
	elseif 	spec == 254 then return "\124cff71d5ff\124Hspell:113073\124h[Dash]\124h\124r" -- Marksmanship
	elseif 	spec == 255 then return "\124cff71d5ff\124Hspell:113073\124h[Dash]\124h\124r" -- Survival
	elseif 	spec == 256 then return "\124cff71d5ff\124Hspell:113275\124h[Entangling Roots]\124h\124r" -- Discipline
	elseif 	spec == 257 then return "\124cff71d5ff\124Hspell:113275\124h[Entangling Roots]\124h\124r" -- Holy
	elseif 	spec == 258 then return "\124cff71d5ff\124Hspell:113277\124h[Tranquility]\124h\124r" -- Shadow
	elseif 	spec == 259 then return "\124cff71d5ff\124Hspell:113613\124h[Growl]\124h\124r" -- Assassination
	elseif 	spec == 260 then return "\124cff71d5ff\124Hspell:113613\124h[Growl]\124h\124r" -- Combat
	elseif 	spec == 261 then return "\124cff71d5ff\124Hspell:113613\124h[Growl]\124h\124r" -- Subtlety
	elseif 	spec == 262 then return "\124cff71d5ff\124Hspell:113287\124h[Solar Beam]\124h\124r" -- Elemental
	elseif 	spec == 263 then return "\124cff71d5ff\124Hspell:113287\124h[Solar Beam]\124h\124r" -- Enhancement
	elseif 	spec == 264 then return "\124cff71d5ff\124Hspell:113289\124h[Prowl]\124h\124r" -- Restoration
	elseif 	spec == 265 then return "\124cff71d5ff\124Hspell:113295\124h[Rejuvenation]\124h\124r" -- Affliction
	elseif 	spec == 266 then return "\124cff71d5ff\124Hspell:113295\124h[Rejuvenation]\124h\124r" -- Demonology
	elseif 	spec == 267 then return "\124cff71d5ff\124Hspell:113295\124h[Rejuvenation]\124h\124r" -- Destruction
	elseif 	spec == 268 then return "\124cff71d5ff\124Hspell:113306\124h[Survival Instincts]\124h\124r" -- Brewmaster
	elseif 	spec == 269 then return "\124cff71d5ff\124Hspell:122286\124h[Savage Defense]\124h\124r" -- Windwalker
	elseif 	spec == 270 then return "\124cff71d5ff\124Hspell:113275\124h[Entangling Roots]\124h\124r" -- Mistweaver
	else 					 return "Unknown"
	end

end -- eSymbiosis:DruidGives(spec)


-- -----------------------------------------------------------------------------
-- Register slash commands
-- -----------------------------------------------------------------------------
SLASH_ESYMBIOSIS1 = "/esb"

function SlashCmdList.ESYMBIOSIS(msg, editbox)

	-- get the spec of the druid
	local druidspec = GetSpecializationInfo(GetSpecialization())

	DEFAULT_CHAT_FRAME:AddMessage("[|cFFAAAAAAeSymbiosis|r] ==============================================================")

	-- print a string for every player whos data we know
	for k, v in pairs(eSymbiosis.players) do

		DEFAULT_CHAT_FRAME:AddMessage("[|cFFAAAAAAeSymbiosis|r] [|c"..eSymbiosis_ClassColor(v.class)..v.name.."|r]("
		..select(2,GetSpecializationInfoByID(v.global_spec_id))..") would get "..eSymbiosis.DruidGives(v.class, v.global_spec_id).." and give "
		..eSymbiosis.DruidGets(v.class, druidspec)..".")

	end

	DEFAULT_CHAT_FRAME:AddMessage("[|cFFAAAAAAeSymbiosis|r] ==============================================================")

end -- function SlashCmdList.ESYMBIOSIS(msg, editbox)


-- -----------------------------------------------------------------------------
-- register callbacks
-- -----------------------------------------------------------------------------
LibStub ("LibGroupInSpecT-1.0").RegisterCallback (eSymbiosis, "GroupInSpecT_Remove", "OnInspectRemove")
LibStub ("LibGroupInSpecT-1.0").RegisterCallback (eSymbiosis, "GroupInSpecT_Update", "OnInspectUpdate")