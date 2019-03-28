local localPlayer = getLocalPlayer()
local screenWidth, screenHeight = guiGetScreenSize()
local spawnClassRoot = getElementByID("spawn.xml")
local spawnMoney = 500

addEventHandler("onClientResourceStart", resourceRoot,
	function ()
	
		spawnClassGridList = guiCreateGridList(0.705, 0.277, 0.276, 0.45, true)
		guiGridListSetSortingEnabled(spawnClassGridList, false)
		guiSetAlpha(spawnClassGridList, 0.8)
		guiSetVisible(spawnClassGridList, false)
		guiGridListAddColumn(spawnClassGridList, "", 0.8)
		
		local font = exports["fonts"]:getGuiFont("UNCON___.ttf", 9)
		guiSetFont(guiCreateLabel(0.075,0.01,1,0.08, "Class", true, spawnClassGridList), font)
		guiSetFont(spawnClassGridList, font)
		
		treeCollapseAll(spawnClassRoot)
--		treeExpandAll(spawnClassRoot)

		guiGridListClear(spawnClassGridList)
		treeDraw(spawnClassRoot, spawnClassGridList, 1)
		addEventHandler("onClientGUIClick", spawnClassGridList, spawnClassHandler)
		toggleSpawnGui()
	end
)

addEventHandler("onClientPlayerSpawn", localPlayer,
	function ()
		setCameraTarget(source)
		setTimer(setCameraTarget, 100, 1, source)
	end
)

function spawnClassHandler()
	if guiGridListGetSelectedCount(spawnClassGridList) > 0 then
		local row, column = guiGridListGetSelectedItem(spawnClassGridList)
		local id = guiGridListGetItemData(spawnClassGridList, row, column)
		local element = getElementByID(id)
		
		playSoundFrontEnd(38)
		if getElementType(element) ~= "spawnpoint" then
			local password = getElementData(element, "password")
			local ACL = getElementData(element, "ACL")
			
			treeCollapseAll(spawnClassRoot)
			guiGridListClear(spawnClassGridList)
			setElementExpanded(getElementParent(element), true)
			
			if ACL then
				local found = false
				local ACLGroup = getElementID(element)
				local ACLGroups = getElementData(localPlayer, "ACLGroups") or ""
				ACLGroups = split(ACLGroups, 44)
				
				for i, group in pairs(ACLGroups) do
					if ACLGroup == group or group == "PublicAccess" then
						found = true
						break
					end
				end
				
				if found then
					setElementExpanded(element, true)
				else
					outputChatBox("You don't have access to " .. ACLGroup .. ". See westcoastgaming.net for more information.", 255, 64, 0)
				end
			else
				setElementExpanded(element, true)
				toggleAllControls(true, false, true)
			end
			treeDraw(spawnClassRoot, spawnClassGridList, column)
		else
			for i, spawnpoint in ipairs(getElementsByType("spawnpoint")) do
				if getElementData(spawnpoint, "row") == row then
					element = spawnpoint
				end
			end
			
			triggerEvent("colfix", localPlayer)
			triggerEvent("hideLogo", localPlayer)
			triggerServerEvent("spawnPlayer", localPlayer, element, spawnMoney)
			setCameraInterior(getElementData(element, "interior"))
			showPlayerHudComponent("radar", not (tonumber(getElementData(element, "interior")) > 0))
			setTimer(setCameraTarget, 50, 2, localPlayer)
			setInteriorSoundsEnabled(false)
			setAmbientSoundEnabled("general", false)
			setAmbientSoundEnabled("gunfire", false)
			resetSkyGradient()
			fadeCamera(true)
			toggleSpawnGui()
		end
	end
end

function toggleSpawnGui()
	if not guiGetVisible(spawnClassGridList) then
		triggerEvent("showLogo", localPlayer)
		playSoundFrontEnd(41)
		guiSetVisible(spawnClassGridList, true)
		showCursor(true)
	else
		triggerEvent("hideLogo", localPlayer)
		playSoundFrontEnd(42)
		guiSetVisible(spawnClassGridList, false)
		guiSetInputEnabled(false)
		--if not guiGetVisible(scoreTabPanel) then
			--showCursor(false)
		--end
		showCursor(false)
	end
end

addEvent("toggleSpawnGui", true)
addEventHandler("toggleSpawnGui", root, toggleSpawnGui)
addCommandHandler("spawn", toggleSpawnGui)

--hack: why does setElementData propagate to all children?
function setElementExpanded(element, state)
	setElementData(element, "expanded", state, false)
	for i, child in ipairs(getElementChildren(element)) do
		setElementData(child, "expanded", false, false)
	end
end
