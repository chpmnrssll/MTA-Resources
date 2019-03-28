local localPlayer = getLocalPlayer()
local width,height = guiGetScreenSize()

local r = 96
local g = 64
local b = 32
local a = 0
local d = 16
local counter = 0
local timeout = 128			--num frames to show

local successText = { "Thanks! Now bring us some more!",
					  "Heh, now we got em. Good job.",
					  "Everybody's got secrets, we want theirs!" }

local badCorp
local briefcase
local marker
local owner
local successMsg = ""

addEvent("espionageStart", true)
addEventHandler("espionageStart", getRootElement(),
	function ()
		if not isPlayerDead(localPlayer) then
			briefcase = getElementData(source, "briefcase")
			owner = getElementData(briefcase, "owner")
			setElementData(localPlayer, "briefcase", briefcase)
			
			for i, company in pairs(getElementsByType("company")) do
				if getElementData(company, "name") ~= owner then
					badCorp = company
				end
			end
			
			successMsg = tostring(successText[math.random(#successText)])
			marker = createMarker(getElementData(badCorp, "posX"), getElementData(badCorp, "posY"), getElementData(badCorp, "posZ")-1, "cylinder", 2, r,g,b,192)
			setElementInterior(marker, getElementData(badCorp, "interior"))
			setElementDimension(marker, getElementData(badCorp, "dimension"))
			addEventHandler("onClientMarkerHit", marker, checkMission)
			addEventHandler("onClientElementDataChange", localPlayer, checkBriefcase)
			addEventHandler("onClientRender", getRootElement(), showMissionText)
		end
	end
)

function checkMission(hitPlayer, matchingDimension)
	if hitPlayer == localPlayer and matchingDimension then
		if getElementData(localPlayer, "hasBriefcase") then
			a = 0
			counter = 0
			removeEventHandler("onClientMarkerHit", marker, checkMission)
			removeEventHandler("onClientElementDataChange", localPlayer, checkBriefcase)
			removeEventHandler("onClientRender", getRootElement(), showMissionText)
			addEventHandler("onClientRender", getRootElement(), showMissionSuccess)
			
			local respect = getPedStat(localPlayer, 68)
			setElementData(localPlayer, "respect", respect+1)
			setElementData(localPlayer, "hasBriefcase", false)
			destroyElement(marker)
			triggerServerEvent("stoleBriefcase", localPlayer, briefcase)
		end
	end
end

function failMission()
	a = 0
	counter = 0
	removeEventHandler("onClientMarkerHit", marker, checkMission)
	removeEventHandler("onClientElementDataChange", localPlayer, checkBriefcase)
	removeEventHandler("onClientRender", getRootElement(), showMissionText)
	addEventHandler("onClientRender", getRootElement(), showMissionFailure)
	destroyElement(marker)
end

function checkBriefcase(dataName, oldValue)
	if dataName == "hasBriefcase" and oldValue == true then
		failMission()
	end
end

function showMissionText()
	drawText("Espionage", (width/2), (height/3.5), 2, "pricedown")
	drawText("Bring these documents to "..getElementData(badCorp, "name")..".", (width/2), (height/3.5)+(height/18), 1, "default-bold")
	
	counter = counter+1
	if counter > timeout then
		if a > 0 then
			a = a-d
		else
			a = 0
			counter = 0
			removeEventHandler("onClientRender", getRootElement(), showMissionText)
		end
	else
		if a < 240 then
			a = a+d
		end
	end
end

function showMissionSuccess()
	drawText("Espionage", (width/2), (height/3.5), 2, "pricedown")
	drawText(successMsg, (width/2), (height/3.5)+(height/18), 1, "default-bold")
	
	counter = counter+1
	if counter > timeout then
		if a > 1 then
			a = a-d
		else
			a = 0
			counter = 0
			removeEventHandler("onClientRender", getRootElement(), showMissionSuccess)
		end
	else
		if a < 240 then
			a = a+d
		end
	end
end

function showMissionFailure()
	drawText("Espionage", (width/2), (height/3.5), 2, "pricedown")
	drawText("You lost the briefcase.", (width/2), (height/3.5)+(height/18), 1, "default-bold")
	
	counter = counter+1
	if counter > timeout then
		if a > 1 then
			a = a-d
		else
			a = 0
			counter = 0
			removeEventHandler("onClientRender", getRootElement(), showMissionFailure)
		end
	else
		if a < 240 then
			a = a+d
		end
	end
end

function drawText(string, x,y, size, font)
	local s = size*1.1
	dxDrawText(string, x-s,y-s, x-s,y-s, tocolor(0,0,0,a), size, font, "center", "center")
	dxDrawText(string, x+s,y-s, x+s,y-s, tocolor(0,0,0,a), size, font, "center", "center")
	dxDrawText(string, x-s,y+s, x-s,y+s, tocolor(0,0,0,a), size, font, "center", "center")
	dxDrawText(string, x+s,y+s, x+s,y+s, tocolor(0,0,0,a), size, font, "center", "center")
	dxDrawText(string, x,y, x,y, tocolor(r,g,b,a), size, font, "center", "center")
end
