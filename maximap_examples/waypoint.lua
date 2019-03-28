-- Script to make the player capable of placing a marker on the map, just like in singleplayer

local blip															-- Initialise local vars (I just like local vars)

function printLocation(button,state,aX,aY)
	if button=="right" and state=="down" then						-- Only trigger this if it's due to a right-click and the state is "down", we don't want too many triggers now do we? :P
		if blip then												-- If we already have a blip...
			destroyElement(blip)									-- Destroy it, you couldn't create 2 blips in SP either
			blip=nil												-- Leave no traces, or the script would (still) think we have a blip next time
			
			playSoundFrontEnd(2)									-- We want a BEEP like in SP
			
			return													-- And let's not bother the rest of the function, we just destroyed a blip, and we don't want another until the next click
		end
		
		local x,y=exports.maximap:getWorldFromMapPosition(aX,aY)	-- We want to get the world position in comparison with the map, so we get fetch that and give the cursor position for it to calculate
		blip=createBlip(x,y,0,41,2)									-- With our newly calculated position we'll create a blip. Maximap resource will automatically draw this blip on the maximap
		
		playSoundFrontEnd(1)										-- We want it to be like in SP, so we give a BEEP
	end
end
addEventHandler("onClientClick",getRootElement(),printLocation)