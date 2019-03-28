---
-- Manages the adding of scoreboard columns.
-- 
-- @author driver2
-- @copyright 2010 driver2
--
-- Recent changes:
-- 2010-02-08: Only sync scoreboard columns if necessary


addEventHandler("onResourceStart",getRootElement(),
function(startedResource)
	setTimer(resourceStarted,2000,1,startedResource)
end
)

---
-- Checks which resource was started and adds the scoreboard
-- columns if it was this one or a scoreboard.
--
-- @param   resource   startedResource: The resource that was started
function resourceStarted(startedResource)
	local scoreboard = getResourceFromName("scoreboard")
	local dxscoreboard = getResourceFromName("dxscoreboard")
	if startedResource == getThisResource() then
		if scoreboard then
			addScoreboardColumns(exports.scoreboard)
		end
		if dxscoreboard then
			addScoreboardColumns(exports.dxscoreboard)
		end
	elseif startedResource == scoreboard then
		addScoreboardColumns(exports.scoreboard)
	elseif startedResource == dxscoreboard then
		addScoreboardColumns(exports.dxscoreboard)
	end
end
--[[
function checkForScoreboard()
	local scoreboard = getResourceFromName("scoreboard")
	local dxscoreboard = getResourceFromName("dxscoreboard")
	if scoreboard then
		addScoreboardColumns(exports.scoreboard)
	end
	if dxscoreboard then
		addScoreboardColumns(exports.dxscoreboard)
	end
end
]]

---
-- Adds the enabled columns to the given scoreboard resource.
--
-- @param   table   scoreboard: The table with the exported functions of the scoreboard
function addScoreboardColumns(scoreboard)
	if toboolean(get("addFpsToScoreboard")) then
		scoreboard:addScoreboardColumn("fps")
		setElementData(getResourceRootElement(),"addFpsToScoreboard",true)
	else
		-- Apparently removing is not really necessary since scoreboard does that when the resource that added it is stopped,
		-- however it might come in handy if this function is not only called onResourceStart
		--scoreboard:removeScoreboardColumn("fps")
		setElementData(getResourceRootElement(),"addFpsToScoreboard",false)
	end
	if toboolean(get("addAvgFpsToScoreboard")) then
		scoreboard:addScoreboardColumn("avg fps")
		setElementData(getResourceRootElement(),"addAvgFpsToScoreboard",true)
	else
		--scoreboard:removeScoreboardColumn("avg fps")
		setElementData(getResourceRootElement(),"addAvgFpsToScoreboard",false)
	end
end

---
-- Converts a string boolean value to a boolean.
--
-- @param   string   string: The string to convert to a boolean
-- @return  mixed    false if the string is "false", the string itself otherwise
--                     (which will itself be evaluated to true if it is a valid string)
function toboolean(string)
	if string == "false" then
		return false
	end
	return string
end
