---
-- This file contains some useful functions.
--
-- @author	driver2
-- @copyright	2009-2010 driver2
--
-- Recent changes:
-- 2010-02-08: Cleaned up


---------------
-- GUI Stuff --
---------------

-- Help

guiHelp = {}
guiHelpDefaultText = "Move your mouse over a GUI Element to get help (if available)."
guiHelpMemo = nil
function addHelp(text,...)
	for k,v in ipairs(arg) do
		guiHelp[v] = text
	end
end
function handleHelp()
	if guiHelpMemo == nil then
		return
	end
	--var_dump(source)
	local text = guiHelp[source]
	--var_dump(text)
	if text ~= nil then
		guiSetText(guiHelpMemo,text)
	else
		guiSetText(guiHelpMemo,guiHelpDefaultText)
	end
end

-- Edit Buttons

editButtons = {}
function addEditButton(x,y,w,h,text,relative,parent,...)
	local button = guiCreateButton(x,y,w,h,text,relative,parent)
	editButtons[button] = arg
	return button
end
function handleEditButtonClick()
	for button,doThis in pairs(editButtons) do
		if source == button then
			for k,v in ipairs(doThis) do
				local edit = v.edit
				if v.mode == "add" then
					addToEdit(edit,v.add)
				elseif v.mode == "cycle" then
					cycleEdit(edit,v.values)
				elseif v.mode == "set" then
					guiSetText(edit,v.value)
				elseif v.mode == "cyclebackwards" then
					cycleEditBackwards(edit,v.values)
				end
			end
		end
	end
end
addEventHandler("onClientGUIClick",root,handleEditButtonClick)

function addToEdit(edit,amount)
	guiSetText(edit,guiGetText(edit) + amount)
end

function cycleEdit(edit,values)
	local currentValue = guiGetText(edit)
	local first = nil
	local found = false
	for k,v in pairs(values) do
		if found then
			-- set the next value after the one which was found
			guiSetText(edit,tostring(v))
			return
		end
		if currentValue == tostring(v) then
			found = true
		end
		if first == nil then
			first = tostring(v)
		end
	end
	if first == nil then
		first = ""
	end
	-- if no values in table or last value was currently set
	guiSetText(edit,first)
end
function cycleEditBackwards(edit,values)
	local currentValue = guiGetText(edit)
	local previous = nil
	local previousIsLast = false
	for k,v in pairs(values) do
		if currentValue == tostring(v) then
			if previous == nil then
				previousIsLast = true
			else
				guiSetText(edit,previous)
				return
			end
		end
		previous = tostring(v)

	end
	if previous == nil then
		previous = ""
	end
	guiSetText(edit,previous)
end

----------
-- Misc --
----------

function duration(seconds)
	if seconds == nil then
		return ""
	end
	seconds = tonumber(seconds)

	local minute = 60
	local hour = minute * 60
	local day = hour * 24
	local week = day * 7
	local year = day * 365

	
	local result = {}
	table.insert(result,{ "years", math.floor(seconds / year) })
	seconds = seconds % year

	table.insert(result,{ "weeks", math.floor(seconds / week) })
	seconds = seconds % week

	table.insert(result,{ "days", math.floor(seconds / day) })
	seconds = seconds % day

	table.insert(result,{ "hours", math.floor(seconds / hour) })
	seconds = seconds % hour

	table.insert(result,{ "minutes", math.floor(seconds / minute) })
	seconds = seconds % minute

	table.insert(result,{ "seconds", seconds })


	local resultText = ""
	for k,v in ipairs(result) do
		local value = v[2]
		if value ~= 0 then
			local label = v[1]
			if value == 1 then
				label = label:sub(1,-2)
			end
			resultText = resultText..value.." "..label.." "
		end
	end
	return resultText
end

function toboolean(bool)
	if bool == "true" or bool == 1 or bool == "1" or bool == true then
		return true
	end
	return false
end




---------------
-- Debugging --
---------------


-- modifiers: v - verbose (all subtables), n - normal, s - silent (no output), dx - up to depth x, u - unnamed
function var_dump(...)
	-- default options
	local verbose = false
	local firstLevel = true
	local outputDirectly = true
	local noNames = false
	local indentation = "\t\t\t\t\t\t"
	local depth = nil

	local name = nil
	local output = {}
	for k,v in ipairs(arg) do
		-- check for modifiers
		if type(v) == "string" and k < #arg and v:sub(1,1) == "-" then
			local modifiers = v:sub(2)
			if modifiers:find("v") ~= nil then
				verbose = true
			end
			if modifiers:find("s") ~= nil then
				outputDirectly = false
			end
			if modifiers:find("n") ~= nil then
				verbose = false
			end
			if modifiers:find("u") ~= nil then
				noNames = true
			end
			local s,e = modifiers:find("d%d+")
			if s ~= nil then
				depth = tonumber(string.sub(modifiers,s+1,e))
			end
		-- set name if appropriate
		elseif type(v) == "string" and k < #arg and name == nil and not noNames then
			name = v
		else
			if name ~= nil then
				name = ""..name..": "
			else
				name = ""
			end

			local o = ""
			if type(v) == "string" then
				table.insert(output,name..type(v).."("..v:len()..") \""..v.."\"")
			elseif type(v) == "userdata" then
				local elementType = "no valid MTA element"
				if isElement(v) then
					elementType = getElementType(v)
				end
				table.insert(output,name..type(v).."("..elementType..") \""..tostring(v).."\"")
			elseif type(v) == "table" then
				local count = 0
				for key,value in pairs(v) do
					count = count + 1
				end
				table.insert(output,name..type(v).."("..count..") \""..tostring(v).."\"")
				if verbose and count > 0 and (depth == nil or depth > 0) then
					table.insert(output,"\t{")
					for key,value in pairs(v) do
						-- calls itself, so be careful when you change anything
						local newModifiers = "-s"
						if depth == nil then
							newModifiers = "-sv"
						elseif  depth > 1 then
							local newDepth = depth - 1
							newModifiers = "-svd"..newDepth
						end
						local keyString, keyTable = var_dump(newModifiers,key)
						local valueString, valueTable = var_dump(newModifiers,value)
						
						if #keyTable == 1 and #valueTable == 1 then
							table.insert(output,indentation.."["..keyString.."]\t=>\t"..valueString)
						elseif #keyTable == 1 then
							table.insert(output,indentation.."["..keyString.."]\t=>")
							for k,v in ipairs(valueTable) do
								table.insert(output,indentation..v)
							end
						elseif #valueTable == 1 then
							for k,v in ipairs(keyTable) do
								if k == 1 then
									table.insert(output,indentation.."["..v)
								elseif k == #keyTable then
									table.insert(output,indentation..v.."]")
								else
									table.insert(output,indentation..v)
								end
							end
							table.insert(output,indentation.."\t=>\t"..valueString)
						else
							for k,v in ipairs(keyTable) do
								if k == 1 then
									table.insert(output,indentation.."["..v)
								elseif k == #keyTable then
									table.insert(output,indentation..v.."]")
								else
									table.insert(output,indentation..v)
								end
							end
							for k,v in ipairs(valueTable) do
								if k == 1 then
									table.insert(output,indentation.." => "..v)
								else
									table.insert(output,indentation..v)
								end
							end
						end
					end
					table.insert(output,"\t}")
				end
			else
				table.insert(output,name..type(v).." \""..tostring(v).."\"")
			end
			name = nil
		end
	end
	local string = ""
	for k,v in ipairs(output) do
		if outputDirectly then
			outputConsole(v)
		end
		string = string..v
	end
	return string, output
end

