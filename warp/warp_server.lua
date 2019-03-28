addEventHandler("onResourceStart", resourceRoot,
	function ()
		for i,player in pairs(getElementsByType("player")) do
			addEventHandler("onElementDataChange", player, dataChange)
		end
	end
)

addEventHandler("onPlayerJoin", root,
	function ()
		addEventHandler("onElementDataChange", source, dataChange)
	end
)

addEventHandler("onPlayerQuit", root,
	function ()
		removeEventHandler("onElementDataChange", source, dataChange)
	end
)

function dataChange(dataName, oldValue)
	local newValue = getElementData(source, dataName)
	if dataName == "interior" and newValue ~= getElementInterior(source) then
		setElementInterior(source, newValue)
	elseif dataName == "dimension" and newValue ~= getElementDimension(source) then
		setElementDimension(source, newValue)
	end
end
