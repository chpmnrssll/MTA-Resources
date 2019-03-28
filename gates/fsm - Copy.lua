-- states --
function opened()
	return "door is opened"
end

function closed()
	return "door is closed"
end


-- transition table --
local stateTable = {
{ opened, "onColShapeLeave", closed },
{ closed, "onColShapeHit", opened },
}

local state = closed


addEventHandler("onResourceStart", resourceRoot,
	function ()
		local fsm = createFSM(stateTable)
		
		outputDebugString(state())
		for i,event in ipairs({ "onColShapeHit", "onColShapeLeave", "onColShapeHit", "onColShapeLeave" }) do
			if fsm[state] and fsm[state][event] then
				state = fsm[state][event]					-- set the state to the new state for this event
				--state()									-- run the function the new state
				outputDebugString(event)
				outputDebugString(state())
			else
				outputDebugString(event)
				outputDebugString(state().." still")
			end
		end
	end
)


function createFSM(stateTable)
	local fsm = {}
	for k,v in ipairs(stateTable) do
		local state, event, transition = v[1], v[2], v[3]
		if fsm[state] == nil then fsm[state] = {} end
		fsm[state][event] = transition
	end
	
	return fsm
end
