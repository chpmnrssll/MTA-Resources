local NUM = 40

addEventHandler("onResourceStart", resourceRoot,
	function ()
		for i, object in ipairs(getElementsByType("object", resourceRoot)) do
			local id = getElementData(object, "id")
			local doublesided = getElementData(object, "doublesided")
			local model = getElementData(object, "model")
			local interior = getElementData(object, "interior")
			local dimension = getElementData(object, "dimension")
			local posX = getElementData(object, "posX")
			local posY = getElementData(object, "posY")
			local posZ = getElementData(object, "posZ")
			local rotX = getElementData(object, "rotX")
			local rotY = getElementData(object, "rotY")
			local rotZ = getElementData(object, "rotZ")
			
			for j=1, NUM do
				local clone = createObject(model, posX, posY, posZ, rotX, rotY, rotZ)
				setElementID(clone, id)
				setElementInterior(clone, interior)
				setElementDimension(clone, j)
				setElementDoubleSided(clone, true)
			end
		end
	end
)