local indentString = "  "
local indent = ""

--hack: why does setElementData propagate to all children? worse here, have to go deeper in tree
function setElementRow(element, row)
	setElementData(element, "row", row, false)
	for i, child in ipairs(getElementChildren(element)) do
		setElementData(child, "row", "", false)
		for j, gchild in ipairs(getElementChildren(child)) do
			setElementData(gchild, "row", "", false)
		end
	end
end

function treeCollapseAll(treeRoot)
	if treeRoot then
		local children = getElementChildren(treeRoot)
		for i, child in ipairs(children) do
			setElementData(child, "expanded", false, false)
			setElementRow(child, "")
--			setElementData(child, "row", nil, false)
		end
	end
end

function treeExpandAll(treeRoot)
	if treeRoot then
		local children = getElementChildren(treeRoot)
		for i, child in ipairs(children) do
			setElementData(child, "expanded", true, false)
			setElementRow(child, "")
--			setElementData(child, "row", nil, false)
		end
	end
end

function treeDraw(treeRoot, gridList, column)
	if treeRoot then
		for i, child in ipairs(getElementChildren(treeRoot)) do
			if getElementType(child) == "player" then return end						--bugFix due to setting players as children of spawnpoints
			local row = guiGridListAddRow(gridList)
			local id = getElementID(child)
			local r = getElementData(child, "r") or 255
			local g = getElementData(child, "g") or 255
			local b = getElementData(child, "b") or 255
			
--			setElementData(child, "row", row, false)
			setElementRow(child, row)
			guiGridListSetItemText(gridList, row, column, indent..id, false, false)
			guiGridListSetItemColor(gridList, row, column, r, g, b)
			guiGridListSetItemData(gridList, row, column, id)
			if getElementData(child, "expanded") then									--only check/draw children if expanded
				local tmp = indent
				indent = indent..indentString
				treeDraw(child, gridList, column)
				indent = tmp
			end
		end
	end
end