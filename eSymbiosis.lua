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
-- declare local variables
-- -----------------------------------------------------------------------------
local players = {}
local playerCounter = 0
local playerName
local playerClass
local playerSpec
local inspectTimer = 0
local calledIt = false


-- -----------------------------------------------------------------------------
-- Create addon frame
-- -----------------------------------------------------------------------------
local eSymbiosis = CreateFrame("Frame")


-- -----------------------------------------------------------------------------
-- Event handler
-- -----------------------------------------------------------------------------
eSymbiosis:SetScript("OnEvent", function(self, event, ...)

	if event == "INSPECT_READY" and calledIt then

		calledIt = false

		eSymbiosis:SetScript("OnUpdate", nil)

		-- save the playername and class in a table
		table.insert(players, {
			name = playerName,
			class = playerClass,
			spec = GetInspectSpecialization(playerName)
		} )

		ClearInspectPlayer(playerName)

		eSymbiosis_DataGathering()

	end

end) -- eSymbiosis_OnEvent(self, event, ...)


-- -----------------------------------------------------------------------------
-- Register slash commands
-- -----------------------------------------------------------------------------
function eSymbiosis_DataGathering()

	-- check if player is alone
	if playerCounter < GetNumGroupMembers() then

		-- get player name and class from the raidroster
		playerName = select(1, GetRaidRosterInfo(playerCounter+1))
		playerClass = select(6, GetRaidRosterInfo(playerCounter+1))

		-- check if we can inspect the unit
		if CanInspect(playerName) then

			NotifyInspect(playerName)
			calledIt = true

			playerCounter = playerCounter + 1

			inspectTimer = 0

			eSymbiosis:SetScript("OnUpdate", function(self, elapsed)

				inspectTimer = inspectTimer + elapsed

				if inspectTimer >= 5 then

					eSymbiosis_StopDataGathering()

				end

			end)

		else

			playerCounter = playerCounter + 1

		end -- if CanInspect(playerName) then

	else

		eSymbiosis_StopDataGathering()

	end -- if playerCounter <= GetNumGroupMembers() then

end -- function eSymbiosis_DataGathering()


-- -----------------------------------------------------------------------------
-- Register slash commands
-- -----------------------------------------------------------------------------
function eSymbiosis_StopDataGathering()

	eSymbiosis:SetScript("OnUpdate", nil)

	if playerCounter == GetNumGroupMembers() then

		-- Print gatheres data
		eSymbiosis_PrintResults()

	else

		-- print error because we didn't finish scanning
		print("There was an error durig inspection. Data gathering has been stopped.")

	end

	for k in pairs(players) do
	    players[k].name = nil
	    players[k].class = nil
	    players[k].spec = nil
	    players[k] = nil
	end

end -- function eSymbiosis_StopDataGathering()


-- -----------------------------------------------------------------------------
-- print results
-- -----------------------------------------------------------------------------
function eSymbiosis_PrintResults()

	DEFAULT_CHAT_FRAME:AddMessage("[|cFFAAAAAAeSymbiosis|r] ==============================================================")

	for k in pairs(players) do

		DEFAULT_CHAT_FRAME:AddMessage("[|cFFAAAAAAeSymbiosis|r] "..k..
			". [|c"..eSymbiosis_ClassColor(players[k].class)..players[k].name..
			"|r]("..eSymbiosis_SpecName(players[k].spec)..") would get "
			..eSymbiosis_DruidGives(players[k].class, players[k].spec).." and give "
			..eSymbiosis_DruidGets(players[k].class, GetSpecializationInfo(GetSpecialization()))..".")

	end

	DEFAULT_CHAT_FRAME:AddMessage("[|cFFAAAAAAeSymbiosis|r] ==============================================================")

end -- function eSymbiosis_PrintResults()


-- -----------------------------------------------------------------------------
-- function to get class color codes
-- -----------------------------------------------------------------------------
function eSymbiosis_ClassColor(class)

	if     class == "DEATHKNIGHT" 	then return "FFC41F3B"
	elseif class == "DRUID" 		then return "FFFF7D0A"
	elseif class == "HUNTER" 		then return "FFABD473"
	elseif class == "MAGE" 			then return "FF69CCF0"
	elseif class == "MONK" 			then return "FF558A84"
	elseif class == "PALADIN" 		then return "FFF58CBA"
	elseif class == "PRIEST" 		then return "FFFFFFFF"
	elseif class == "ROGUE" 		then return "FFFFF569"
	elseif class == "SHAMAN" 		then return "FF0070DE"
	elseif class == "WARLOCK" 		then return "FF9482C9"
	elseif class == "WARRIOR" 		then return "FFC79C6E"
	else 								 return "FFAAAAAA"
	end

end -- function eSymbiosis_ClassColor(class)


-- -----------------------------------------------------------------------------
-- function to fint out what spell the druid gets
-- -----------------------------------------------------------------------------
function eSymbiosis_DruidGets(class, druidspec)

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

end -- eSymbiosis_DruidGets(class, druidspec)


-- -----------------------------------------------------------------------------
-- function to fint out what spell the druid gives
-- -----------------------------------------------------------------------------
function eSymbiosis_DruidGives(class, spec)

	if class == "DEATHKNIGHT" then

		if 		spec == 250 then return "\124cff71d5ff\124Hspell:113072\124h[Might of Ursoc]\124h\124r"
		elseif 	spec == 251 then return "\124cff71d5ff\124Hspell:113516\124h[Wild Mushroom: Plague]\124h\124r"
		elseif 	spec == 252 then return "\124cff71d5ff\124Hspell:113516\124h[Wild Mushroom: Plague]\124h\124r"
		else 					 return "Unknown"
		end

	elseif class == "DRUID" then

		return "nothing"

	elseif class == "HUNTER" then

		return "\124cff71d5ff\124Hspell:113073\124h[Dash]\124h\124r"

	elseif class == "MAGE" then

		return "\124cff71d5ff\124Hspell:113074\124h[Healing Touch]\124h\124r"

	elseif class == "MONK" then

		if 		spec == 268 then return "\124cff71d5ff\124Hspell:113306\124h[Survival Instincts]\124h\124r"
		elseif 	spec == 269 then return "\124cff71d5ff\124Hspell:122286\124h[Savage Defense]\124h\124r"
		elseif 	spec == 270 then return "\124cff71d5ff\124Hspell:113275\124h[Entangling Roots]\124h\124r"
		else 					 return "Unknown"
		end

	elseif class == "PALADIN" then

		if 		spec == 65  then return "\124cff71d5ff\124Hspell:113269\124h[Rebirth]\124h\124r"
		elseif 	spec == 66  then return "\124cff71d5ff\124Hspell:113075\124h[Barkskin]\124h\124r"
		elseif 	spec == 70  then return "\124cff71d5ff\124Hspell:122287\124h[Wrath]\124h\124r"
		else 					 return "Unknown"
		end

	elseif class == "PRIEST" then

		if 		spec == 256 then return "\124cff71d5ff\124Hspell:113275\124h[Entangling Roots]\124h\124r"
		elseif 	spec == 257 then return "\124cff71d5ff\124Hspell:113275\124h[Entangling Roots]\124h\124r"
		elseif 	spec == 258 then return "\124cff71d5ff\124Hspell:113277\124h[Tranquility]\124h\124r"
		else 					 return "Unknown"
		end

	elseif class == "ROGUE" then

		return "\124cff71d5ff\124Hspell:113613\124h[Growl]\124h\124r"

	elseif class == "SHAMAN" then

		if 		spec == 262 then return "\124cff71d5ff\124Hspell:113287\124h[Solar Beam]\124h\124r"
		elseif 	spec == 263 then return "\124cff71d5ff\124Hspell:113287\124h[Solar Beam]\124h\124r"
		elseif 	spec == 264 then return "\124cff71d5ff\124Hspell:113289\124h[Prowl]\124h\124r"
		else 				  	 return "Unknown"
		end

	elseif class == "WARLOCK" then

		return "\124cff71d5ff\124Hspell:113295\124h[Rejuvenation]\124h\124r"

	elseif class == "WARRIOR" then

		if 		spec == 71  then return "\124cff71d5ff\124Hspell:122294\124h[Stampeding Shout]\124h\124r"
		elseif 	spec == 72  then return "\124cff71d5ff\124Hspell:122294\124h[Stampeding Shout]\124h\124r"
		elseif 	spec == 73  then return "Savage Defense"
		else 				     return "Unknown"
		end

	else

		return "Unknown"

	end

end -- eSymbiosis_DruidGives(class, spec)


-- -----------------------------------------------------------------------------
-- function to get class specialisation names
-- -----------------------------------------------------------------------------
function eSymbiosis_SpecName(SpecID)

    if     SpecID == 62  then return "Arcane"
    elseif SpecID == 63  then return "Fire"
    elseif SpecID == 64  then return "Frost"
    elseif SpecID == 65  then return "Holy"
    elseif SpecID == 66  then return "Protection"
    elseif SpecID == 70  then return "Retribution"
    elseif SpecID == 71  then return "Arms"
    elseif SpecID == 72  then return "Fury"
    elseif SpecID == 73  then return "Protection"
    elseif SpecID == 102 then return "Balance"
    elseif SpecID == 103 then return "Feral"
    elseif SpecID == 104 then return "Guardian"
    elseif SpecID == 105 then return "Restoration"
    elseif SpecID == 250 then return "Blood"
    elseif SpecID == 251 then return "Frost"
    elseif SpecID == 252 then return "Unholy"
    elseif SpecID == 253 then return "Beast Mastery"
    elseif SpecID == 254 then return "Marksmanship"
    elseif SpecID == 255 then return "Survival"
    elseif SpecID == 256 then return "Discipline"
    elseif SpecID == 257 then return "Holy"
    elseif SpecID == 258 then return "Shadow"
    elseif SpecID == 259 then return "Assassination"
    elseif SpecID == 260 then return "Combat"
    elseif SpecID == 261 then return "Subtlety"
    elseif SpecID == 262 then return "Elemental"
    elseif SpecID == 263 then return "Enhancement"
    elseif SpecID == 264 then return "Restoration"
    elseif SpecID == 265 then return "Affliction"
    elseif SpecID == 266 then return "Demonology"
    elseif SpecID == 269 then return "Destruction"
    elseif SpecID == 268 then return "Brewmaster"
    elseif SpecID == 269 then return "Windwalker"
    elseif SpecID == 270 then return "Mistweaver"
    else 					   return "Unknown"
    end

end -- eSymbiosis_SpecName(SpecID)


-- -----------------------------------------------------------------------------
-- Register slash commands
-- -----------------------------------------------------------------------------
SLASH_ESYMBIOSIS1 = "/esb"

function SlashCmdList.ESYMBIOSIS(msg, editbox)

	eSymbiosis:RegisterEvent("INSPECT_READY")

	-- declare variables needed for data gathering
	playerCounter = 0

	-- start the data gathering
	eSymbiosis_DataGathering()

end -- function SlashCmdList.ESYMBIOSIS(msg, editbox)

