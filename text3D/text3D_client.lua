local text3Ds = {}

addEventHandler("onClientResourceStart", resourceRoot,
	function ()
		for i, warp in ipairs(getElementsByType("warp")) do
			if getElementData(warp, "name") then
				createText3D("warp"..i,
					getElementData(warp, "name"),
					"bankgothic",
					6,
					128,
					255,
					0,
					getElementData(warp, "posX"),
					getElementData(warp, "posY"),
					getElementData(warp, "posZ")+1.25,
					getElementData(warp, "interior"),
					getElementData(warp, "dimension"),
					false,
					getElementData(warp, "class"),
					getElementData(warp, "subclass"))
			end
		end
		
		for i, vehicle in ipairs(getElementsByType("vehicle")) do
			if getElementData(vehicle, "owner") == "Dealership" then
				local x,y,z = getElementPosition(vehicle)
				createText3D(
					getElementID(vehicle),
					"$"..getElementData(vehicle, "price").."\n"..getVehicleName(vehicle),
					"bankgothic",
					5,
					48,
					96,
					48,
					x,
					y,
					z,
					getElementInterior(vehicle),
					getElementDimension(vehicle),
					true,
					false,
					false
				)
			end
		end
		
		for i, t3D in ipairs(getElementsByType("text3D")) do
			createText3D(i,
				getElementData(t3D, "text"),
				getElementData(t3D, "font"),
				getElementData(t3D, "size"),
				getElementData(t3D, "r"),
				getElementData(t3D, "g"),
				getElementData(t3D, "b"),
				getElementData(t3D, "posX"),
				getElementData(t3D, "posY"),
				getElementData(t3D, "posZ"),
				getElementData(t3D, "interior"),
				getElementData(t3D, "dimension"),
				getElementData(t3D, "force"),
				getElementData(t3D, "class"),
				getElementData(t3D, "subclass"))
		end
		
		addEvent("createText3D", true)
		addEvent("destroyText3D", true)
		addEventHandler("createText3D", root, createText3D)
		addEventHandler("destroyText3D", root, destroyText3D)
	end
)

addEventHandler("onClientRender", root,
	function ()
		local cx,cy,cz = getCameraMatrix()
		local int = getElementInterior(localPlayer)
		local dim = getElementDimension(localPlayer)
		local classPlr = getElementData(localPlayer, "class")
		local subclassPlr = getElementData(localPlayer, "subclass")
		
		for i, t3D in pairs(text3Ds) do
			if t3D.interior == int and t3D.dimension == dim then
				local dist = getDistanceBetweenPoints3D(cx,cy,cz, t3D.x,t3D.y,t3D.z)
				if dist < 64 then
					if t3D.class and t3D.class ~= classPlr or t3D.subclass and t3D.subclass ~= subclassPlr then
--						outputConsole(classPlr)
					else
						if t3D.force or isLineOfSightClear(cx,cy,cz, t3D.x,t3D.y,t3D.z, true, true, false, true, true, false, false) then
							local tx,ty = getScreenFromWorldPosition(t3D.x,t3D.y,t3D.z, 10)
							if tx and ty then
								local size = t3D.size/dist
								dxDrawTextOutlined(t3D.text, tx,ty, tx,ty, t3D.r,t3D.g,t3D.b, 255-(dist*4), size, t3D.font, "center", "center", false, false)
							end
						end
					end
				end
			end
		end
		
		--dxDrawText("#text3D: "..#text3Ds, 600,150)
	end
)

function dxDrawTextOutlined(text, posX,posY, sizeX,sizeY, r,g,b,a, scale, font, alignX, alignY, clip, postGUI)
	local color = tocolor(0,0,0, a/3)
	dxDrawText(text, posX-scale,posY-scale, sizeX-scale,sizeY-scale, color, scale, font, alignX, alignY, clip, postGUI)
	dxDrawText(text, posX+scale,posY-scale, sizeX+scale,sizeY-scale, color, scale, font, alignX, alignY, clip, postGUI)
	dxDrawText(text, posX-scale,posY+scale, sizeX-scale,sizeY+scale, color, scale, font, alignX, alignY, clip, postGUI)
	dxDrawText(text, posX+scale,posY+scale, sizeX+scale,sizeY+scale, color, scale, font, alignX, alignY, clip, postGUI)
	dxDrawText(text, posX,posY, sizeX,sizeY, tocolor(r,g,b,a), scale, font, alignX, alignY, clip, postGUI)
end

function createText3D(id, text, font, size, r,g,b, x,y,z, interior, dimension, force, class, subclass)
	local t3D = {}
	t3D.id = id
	t3D.text = text
	t3D.font = font
	t3D.size = tonumber(size)
	t3D.r = tonumber(r)
	t3D.g = tonumber(g)
	t3D.b = tonumber(b)
	t3D.x = tonumber(x)
	t3D.y = tonumber(y)
	t3D.z = tonumber(z)
	t3D.interior = tonumber(interior) or 0
	t3D.dimension = tonumber(dimension) or 0
	t3D.force = force or false
	t3D.class = class or false
	t3D.subclass = subclass or false
	
	table.insert(text3Ds, t3D)
	return t3D
end

function destroyText3D(id)
	for i, t3D in ipairs(text3Ds) do
		if t3D.id == id then
			table.remove(text3Ds, i)
		end
	end
end
