function createText3D(id, text, font, size, r,g,b, x,y,z, interior, dimension, force, class, subclass)
	triggerClientEvent("createText3D", root, id, text, font, size, r,g,b, x,y,z, interior, dimension, force, class, subclass)
end

function destroyText3D(id)
	triggerClientEvent("destroyText3D", root, id)
end
