local localPlayer = getLocalPlayer()
local helpItem = {}
local helpLabel = nil
local helpKey = "F9"
local helpCommand = "gamehelp"
local tabPanel = guiCreateTabPanel(0.25, 0.25, 0.50, 0.50, true)

addEventHandler("onClientResourceStart", resourceRoot,
	function ()
		guiSetAlpha(tabPanel, 0.80)
		helpTab = guiCreateTab("Help", tabPanel)
		guiSetSelectedTab(tabPanel, helpTab)
		guiSetVisible(tabPanel, false)
		
		helpGridList = guiCreateGridList(0.015, 0.02, 0.35, 0.96, true, helpTab)
		guiGridListSetSortingEnabled(helpGridList, false)
		guiGridListSetScrollBars(helpGridList, false, false)
		guiSetEnabled(helpGridList, true)
		guiSetAlpha(helpGridList, 0.75)
		helpColumn = guiGridListAddColumn(helpGridList, "Topic", 0.75)
		
		helpBG = guiCreateGridList(0.375, 0.02, 0.61, 0.96, true, helpTab)
		guiGridListSetSortingEnabled(helpBG, false)
		guiGridListSetScrollBars(helpBG, false, false)
		guiSetAlpha(helpBG, 0.75)
		guiGridListAddColumn(helpBG, "Help", 0.9)
		
		helpLabel = guiCreateLabel(.4, .06, .52, .96, "", true, helpTab)
		guiSetAlpha(helpLabel, 0.75)
		guiLabelSetColor(helpLabel, 192,255,128)
		guiLabelSetHorizontalAlign(helpLabel, "center", true)
		
		addHelpItem(getResourceFromName(getElementID(resourceRoot)))
		for i, resourceRoot in ipairs(getElementsByType("resource")) do
			local resource = getResourceFromName(getElementID(resourceRoot))
			if resource then
				addHelpItem(resource)
			end
		end
		
		addEventHandler("onClientGUIClick", helpGridList, updateHelp)
--		guiGridListSetSelectedItem(helpGridList, 0, helpColumn)
		guiGridListSetSelectedItem(helpGridList, helpItem["Help"].row, helpColumn)
		updateHelp()
		
		addCommandHandler(helpCommand, toggleHelpGui)
		bindKey(helpKey, "down", toggleHelpGui)
	end
)

function addHelpItem(resource)
	local resourceName = getResourceName(resource)
	if helpItem[resourceName] then
		return false
	end
	
	local helpNode = getResourceConfig(":"..resourceName.."/help.xml")
	local topics = 0
	if helpNode then
		topics = xmlNodeGetChildren(helpNode)
	end
	
	if helpNode and #topics == 0 then					--regular help file
		helpItem[resourceName] = {}
		helpItem[resourceName].name = xmlNodeGetAttribute(helpNode, "name") or resourceName
		helpItem[resourceName].text = xmlNodeGetValue(helpNode)
		helpItem[resourceName].row = guiGridListAddRow(helpGridList)
		guiGridListSetItemText(helpGridList, helpItem[resourceName].row, helpColumn, helpItem[resourceName].name, false, false)
		guiGridListSetItemColor(helpGridList, helpItem[resourceName].row, helpColumn, 192,255,128)
		guiGridListSetItemData(helpGridList, helpItem[resourceName].row, helpColumn, resourceName)
	elseif helpNode then								--extended help file with multiple topics
		for i, topic in ipairs(topics) do
			local name = xmlNodeGetAttribute(topic, "name")
			if helpItem[name] then
				return false
			end
			helpItem[name] = {}
			helpItem[name].name = name
			helpItem[name].text = xmlNodeGetValue(topic)
			helpItem[name].row = guiGridListAddRow(helpGridList)
			guiGridListSetItemText(helpGridList, helpItem[name].row, helpColumn, helpItem[name].name, false, false)
			guiGridListSetItemColor(helpGridList, helpItem[name].row, helpColumn, 192,255,128)
			guiGridListSetItemData(helpGridList, helpItem[name].row, helpColumn, name)
		end
	end
end

function updateHelp()
	if guiGridListGetSelectedCount(helpGridList) > 0 then
		local row, column = guiGridListGetSelectedItem(helpGridList)
		local resourceName = guiGridListGetItemData(helpGridList, row, column)
		guiSetText(helpLabel, helpItem[resourceName].text)
	end
end

function toggleHelpGui()
	if not guiGetVisible(tabPanel) then
		guiSetVisible(tabPanel, true)
		setTimer(showCursor, 50, 1, true)
	else
		guiSetVisible(tabPanel, false)
		setTimer(guiSetInputEnabled, 50, 1, false)
		setTimer(showCursor, 50, 1, false)
	end
end