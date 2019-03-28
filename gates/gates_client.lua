local dbg = false
local blips = {}
local markers = {}
local text3Ds = {}

addCommandHandler("dbg",
--addEventHandler("onClientResourceStart", resourceRoot,
	function ()
		setTimer(function ()
		if not dbg then
			dbg = true
			for i, gate in pairs(getElementsByType("gate", root)) do
				local id = getElementID(gate)
				local interior = getElementData(gate, "interior")
				local dimension = getElementData(gate, "dimension")
				local center = getElementData(gate, "center")
				local class = getElementData(gate, "class")
				local subclass = getElementData(gate, "subclass")
				local x,y,z = getElementPosition(center)
				blips[#blips+1] = createBlip(x,y,z, 0, 2, 0,255,0,255, 0,512)
				setElementAlpha(center, 255)
				
				for j, trigger in pairs(getElementsByType("colshape", gate)) do
					local x,y,z = getElementPosition(trigger)
					local size = getElementData(trigger, "size")
					
					markers[#markers+1] = createMarker(x,y,z-(size/2), "cylinder", 2*size, 0,255,0,32)
					
					if class then
						id = id.."\n".."class: "..class
					elseif subclass then
						id = id.."\n".."subclass: "..subclass
					end
					
					local text3D = createElement("text3D")
					setElementData(text3D, "posX", x)
					setElementData(text3D, "posY", y)
					setElementData(text3D, "posZ", z)
					setElementData(text3D, "interior", interior)
					setElementData(text3D, "dimension", dimension)
					setElementData(text3D, "force", true)
					setElementData(text3D, "text", id)
					setElementData(text3D, "r", 0)
					setElementData(text3D, "g", 255)
					setElementData(text3D, "b", 0)
					setElementData(text3D, "size", 2)
					setElementData(text3D, "font", "bankgothic")
					text3Ds[#text3Ds+1] = text3D
				end
			end
		else
			dbg = false
			for i, gate in pairs(getElementsByType("gate", root)) do
				local center = getElementData(gate, "center")
				setElementAlpha(center, 0)
			end
			for i, blip in pairs(blips) do
				destroyElement(blip)
			end
			for i, marker in pairs(markers) do
				destroyElement(marker)
			end
			for i, text3D in pairs(text3Ds) do
				destroyElement(text3D)
			end
		end
		end, 500, 1)
	end
)
