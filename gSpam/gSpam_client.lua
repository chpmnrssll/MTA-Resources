local width, height = guiGetScreenSize()
local timeout = 4000

addEventHandler("onClientPlayerWeaponSwitch", getLocalPlayer(),
	function (prevSlot, newSlot)
		if newSlot == 8 and disabled then
			toggleControl("fire", false)
		else
			toggleControl("fire", true)
		end
	end
)

addEventHandler("onClientPlayerWeaponFire", getLocalPlayer(),
	function (weapon)
		if getPedWeaponSlot(source) == 8 then
			disabled = true
			toggleControl("fire", false)
			x,y = width*0.784, height*0.063
			w,h = width*0.059, height*0.094
			d = (h/timeout)*h
			setTimer(
				function ()
					disabled = false
					toggleControl("fire", true)
				end,
			timeout, 1)
		end
	end
)

addEventHandler("onClientRender", getRootElement(),
	function ()
		if getPedWeaponSlot(getLocalPlayer()) == 8 and disabled then
			dxDrawRectangle(x,y, w,h, tocolor(0,0,0,4*h))
			if h > 0 then h = h-d end
		end
	end
)