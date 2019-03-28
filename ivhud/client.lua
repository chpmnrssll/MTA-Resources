local minVel = 0.3 --velocity, from witch on radar zoom will go bigger
local minDist = 180 --minimum radius of radar in meters, with zoom 1.
local maxVel = 1 --at witch point maxDist will take effect
local maxDist = 360 --[[maximum radius of map in meters, shown with 1 zoom,
,if velocity of car is maxVel or higher.You can change it, bot dont make it any bigger.]]
local minZoom = 1.3 --minimum changebale zoom
local maxZoom = 3 --maximum changeable zoom
local zoom=1.3 --default zoom
local zoomPlus="=" --key to zoom in the radar
local zoomMinus="-" --key to zoom out the radar
local toogleHUDKey="num_mul" --key to toogle Hud
local showAllKey="num_add" --key that shows all data
local mapSize=3000 --dimensions of radar map included in res, change it if you change the map
local sx,sy=guiGetScreenSize() --ovibious, dont change it.
local size=(0.240*sy)/2 --[[radius of hud, do this*1.3 to get actual radius of radar in pixels.
Is affected by resolution.]]
local size2=size*2 --used so much that its inefficent to use size*2 each time
local x,y=size*1.7,sy-size*1.5 --position of center of radar on screen
local radioX,radioY=sx/2,20 --radio display position, in pixels
local radioSize=100/1080*sy --radio icon size, in pixels
local radioFadeTime=5000 --how long it takes to fade radio hud out
local radioSideIcons=2 --how much radio icons should be drawn on each side of the current radio icon
local radioSlideSpeed=500 --speed, how fast radio icons slide forwards/backwards
local radioGapSize=radioSize*0.2 --how big will be the gap between radio icons, in pixels
local dxSize=1 --size of blip texts, currently cant find optimal solution for all resolutions
local dxFont="arial" --font of blip texts
local screenSizeCompensate=sy/500 --how much will blip size be affected by your resolution
local blipDimension=16*screenSizeCompensate --default size blip width,height
local txtx,txty=sx-200,sy-200 --text position
local textColor=tocolor(200,200,200,255) --default color of blip texts
local backgroundCol=tocolor(0,0,0,200) --color of blip text background
local hpCol=tocolor(20,90,20,255) --color of HP bar
local armorCol=tocolor(10,50,100,255) --color of armor bar
local ringCol=tocolor(30,30,30,255) --color of hud ring
local inRingCol=tocolor(0,0,0,255) --color of armour & HP bar bakground
local airCol=tocolor(10,10,180,255) --color of breath gauge
local airBackCol=tocolor(0,0,0,130) --color of breath/height gauge background
local mapBorderCol={0,255,120,255} --color of radar map border
local moneyGreenCol=tocolor(0,150,0,255)
local moneyRedCol=tocolor(230,0,0,255)
local clipCol=tocolor(0,50,120,255)
local ammoCol=tocolor(200,200,200,255)
local black=tocolor(0,0,0,255)
local waterCol=tocolor(67,86,88,255)
local finalCol=tocolor(255,255,255,255) --color used in final hud componet drawings
local white2=tocolor(255,255,255,200)
local finalAlpha=210 --final radar alpha
local createBlipsForVehicles=true
local createBlipsForPickups=true 
local renderPickups=true --should blips attached to pickups be transformed into a legit pickup blip
local hudX,hudY=60,20 --x and y in pixels from right top corner to right top edge of weapon/money/time/wanted level hud area
local doDrawRadio=true
local doDrawRadar=true
local doDrawInfo=true
local doDrawHUD=true
--end of settings
local wtexture
local lastOffX,lastrid=0,0
local radioStartAt=0
local startsetnewr
local newWep
local moneydiff
local moneydiffchangetime=0
local hudrendertarg
local weptarg
local moneychangestr=""
local moneychangecol=moneyGreenCol
local lastmoney=0
local moneychangetime
local wslot=0
local doflash, overrideflash
local lastwanchange=getTickCount()
local lastwanlvl=0
local weapon=0
local wepswitchtime
local airmode
local roundAreas={}
local texture
local mask
local shader
local renderImage
local newtarg
local entering
local radioFadeGap=radioSize/2+radioSideIcons*radioSize
local worthDrawingRadio
local radioGoRight
local oldRadio=0
local newRadio=0
local radioSwitchTime=0
local normCol=tocolor(255,255,255,255)
local black=tocolor(0,0,0,255)
local x2,y2,l2,h2=size*1.5-size*1.3,size*1.5-size*1.3,size*2.6,size*2.6
local localP = getLocalPlayer()
local root = getRootElement()
local resRoot = getResourceRootElement()
local doRender=true
local ratio = (maxDist-minDist)/(maxVel-minVel)
local blipTimer
--local airTimer
local moneydiff
local areas={}
local blips
local lastcurr=0
local hp=100
local armor=0
local areaTimer
local hpTimer
local dmgTab={}
local elemData={}
local textH=dxGetFontHeight(dxSize,dxFont)
local players={}
local border=110/128*size*1.20
local blipimages={}
local zoomticks=getTickCount()
--local currAir=1 --float of air
local raceMode
local vehicle
local parachute
local vehSwitchTime=0
local showTime=0
local fps=0
local frames,lastsec=0,0
local showTime=0
local madeByHUD={}
local occupiedvehicles={}
local gui={}
local settingsOn=false
local posGUI
local settingtimer

radioGapSize=1+radioGapSize/radioSize

function showSettings()
	doRender=true
	settingsOn=not settingsOn
	posGUI=settingsOn
	showCursor(settingsOn,false)
	for _,widget in pairs(gui) do
		guiSetVisible(widget,settingsOn)
	end
	if settingsOn then
		entering=true
		worthDrawingRadio=true
		radioSwitchTime=getTickCount()
		showAll()
		settingtimer=setTimer(function()
			entering=true
			worthDrawingRadio=true
			radioSwitchTime=getTickCount()
			showAll()
		end,3000,0)
	else
		killTimer(settingtimer)
	end
end

--[[function generateRectanglesInRing(radius,accuracy) --the old way of making it round, before shaders were released.
	local n=2
	local rT={}
	rT[1] = {}
	local smallRadius=radius-accuracy
	local xOff=smallRadius
	local yOff=(radius^2-xOff^2)^0.5
	rT[1][1],rT[1][2],rT[1][3],rT[1][4]=-xOff,-yOff,xOff*2,yOff*2
	while true do
		rT[n]={}
		rT[n+1]={}
		xOff=(smallRadius^2-yOff^2)^0.5
		yOff=(radius^2-xOff^2)^0.5
		rT[n][1],rT[n][2],rT[n][3],rT[n][4]=-xOff,-yOff,xOff*2,yOff-math.abs(rT[n-1][2])
		rT[n+1][1],rT[n+1][2],rT[n+1][3],rT[n+1][4]=-xOff,math.abs(rT[n-1][2]),rT[n][3],rT[n][4]
		if yOff>=smallRadius then
			rT[n][2],rT[n][4]=-smallRadius,rT[n][4]-(yOff-smallRadius)
			rT[n+1][4]=rT[n][4]
			break
		end
		n=n+2
	end
	for n=2,#rT do
		for k=1,4 do
			rT[n][k]=math.ceil(rT[n][k])
		end
		if rT[n-1][2]==rT[n][2] then
			table.remove(rT,n)
		end
	end
	return rT
end]]

function onStart()
	gui={
		radar=guiCreateWindow(x-size*1.1+1,y-size*1.1-17,size*2.2,size*2.2+17,"Radar - Move and resize",false);
		radio=guiCreateWindow(radioX-radioSize*1.2*(radioSideIcons+1),radioY-20,radioSize*1.2*(radioSideIcons*2+2),radioSize+22,"Radio - Move and resize",false);
		hud=guiCreateWindow(sx-hudX-256,hudY,256,266,"HUD - Drag to move",false);
		text=guiCreateWindow(txtx,txty-17,150,160,"Text Info - Drag to move",false)
	}
	for key,widget in pairs(gui) do
		guiSetVisible(widget,false)
		guiSetAlpha(widget,0.3)
		if key=="hud" or key=="text" then
			guiWindowSetSizable(widget,false)
		end
	end
	addEventHandler("onClientGUIMove",gui.radar,function()
		local posx,posy=guiGetPosition(source,false)
		local sizex,sizey=guiGetSize(source,false)
		if posx<0 or posx+sizex>sx or posy<0 or posy+sizey>sy then
			posx=math.clip(0,posx,sx-sizex)
			posy=math.clip(0,posy,sy-sizey)
			guiSetPosition(source,posx,posy,false)
		end
		x,y=posx-1+size*1.1,posy+17+size*1.1
	end)
	addEventHandler("onClientGUIMove",gui.radio,function()
		local posx,posy=guiGetPosition(source,false)
		local sizex,sizey=guiGetSize(source,false)
		if posx<0 or posx+sizex>sx or posy<0 or posy+sizey>sy then
			posx=math.clip(0,posx,sx-sizex)
			posy=math.clip(0,posy,sy-sizey)
			guiSetPosition(source,posx,posy,false)
		end
		radioX,radioY=posx+radioSize*1.2*(radioSideIcons+1),posy+20
	end)
	addEventHandler("onClientGUIMove",gui.hud,function()
		local posx,posy=guiGetPosition(source,false)
		local sizex,sizey=guiGetSize(source,false)
		if posx<0 or posx+sizex>sx or posy<0 or posy+sizey>sy then
			posx=math.clip(0,posx,sx-sizex)
			posy=math.clip(0,posy,sy-sizey)
			guiSetPosition(source,posx,posy,false)
		end
		hudX,hudY=sx-(posx+sizex),posy
	end)
	addEventHandler("onClientGUIMove",gui.text,function()
		local posx,posy=guiGetPosition(source,false)
		local sizex,sizey=guiGetSize(source,false)
		if posx<0 or posx+sizex>sx or posy<0 or posy+sizey>sy then
			posx=math.clip(0,posx,sx-sizex)
			posy=math.clip(0,posy,sy-sizey)
			guiSetPosition(source,posx,posy,false)
		end
		txtx,txty=posx,posy+17
	end)
	addEventHandler("onClientGUISize",gui.radar,function()
		local posx,posy=guiGetPosition(source,false)
		local sizex,sizey=guiGetSize(source,false)
		local setsize=math.clip(150,(sizex+sizey-17)/2,500)
		if posx<0 or posx+setsize>sx or posy<0 or posy+setsize+17>sy then
			posx=math.clip(0,posx,sx-setsize)
			posy=math.clip(0,posy,sy-setsize-17)
			guiSetPosition(source,posx,posy,false)
		end
		guiSetSize(source,setsize,setsize+17,false)
		size,size2=setsize/2.2,setsize/1.1
		x,y=posx-1+size*1.1,posy+17+size*1.1
		x2,y2,l2,h2=size*1.5-size*1.3,size*1.5-size*1.3,size*2.6,size*2.6
		border=110/128*size*1.20
		destroyElement(renderImage)
		destroyElement(newtarg)
		renderImage=dxCreateRenderTarget(size2,size2,false)
		newtarg=dxCreateRenderTarget(size*3,size*3,false)
	end)
	addEventHandler("onClientGUISize",gui.radio,function()
		local posx,posy=guiGetPosition(source,false)
		local sizex,sizey=guiGetSize(source,false)
		sizey=math.clip(20,sizey,200)
		sizex=math.clip(200,sizex,1000)
		if posx<0 or posx+sizex>sx or posy<0 or posy+sizey+22>sy then
			posx=math.clip(0,posx,sx-sizex)
			posy=math.clip(0,posy,sy-sizey-22)
			guiSetPosition(source,posx,posy,false)
		end
		guiSetSize(source,sizex,sizey,false)
		radioX,radioY=posx+sizex/2,posy+20
		radioSize=sizey-22
		radioSideIcons=math.floor((sizex-(sizex%(radioSize*1.2)))/1.2/radioSize/2)
		radioGapSize=1.2
		radioFadeGap=radioSideIcons*radioSize
	end)
	roundAreas=getElementData(root,"roundareadata") or {}
	setElementData(root,"roundareadata",nil)
	wslot=getPedWeaponSlot(localP)
	weapon=getPedWeapon(localP,wslot)
	moneychangetime=getTickCount()
	wepswitchtime=getTickCount()
	if createBlipsForVehicles then
		for k,v in pairs(getElementsByType("vehicle")) do
			local blip=createBlipAttachedTo(v,2,1.4,255,255,255,255)
			madeByHUD[blip]=true
			occupiedvehicles[v]=true
			setElementData(blip,"customBlipPath","images/blips/pedvehicle.png")
			setBlipVisibleDistance(blip,400)
			setElementParent(blip,v)
		end
	end
	if createBlipsForPickups then
		for k,v in pairs(getElementsByType("pickup")) do
			local blip=createBlipAttachedTo(v,1,1.3,255,255,255,255,-65000)
			madeByHUD[blip]=true
			setBlipVisibleDistance(blip,400)
			setElementParent(blip,v)
		end
	end
	getBlips()
	for _,v in ipairs(blips) do
		if not elemData[v] then
			elemData[v]={}
		end
		elemData[v][1]=getElementData(v,"blipText")
		elemData[v][2]=getElementData(v,"customBlipPath")
	end
	areaTimer=setTimer(getRadarAreas,1000,0)
	blipTimer=setTimer(getBlips,1000,0)
	hpTimer=setTimer(refreshHP,100,0)
	bindKey(toogleHUDKey,"down",toogleHUD)
	bindKey("radio_next","down",radioSwitch,true)
	bindKey("F3","down",showSettings)
	bindKey("radio_previous","down",radioSwitch,false)
	bindKey("fire","down",weaponFire) --melee and rpg/greande trigger
	bindKey(showAllKey,"down",showAll)
	local dxinfo=dxGetStatus()
	if dxinfo["VideoMemoryFreeForMTA"]<=10 then
		outputChatBox("Sorry, your video memory is [almost] full.",false,255,0,0)
		outputChatBox("IVhud can't draw weapon icons and radar with no video memory aviable.",false,255,0,0)
		outputChatBox("Change your MTA settings or visit MTA forums for more help.",false,255,0,0)
		doDrawRadar,doDrawHUD=false,false
	elseif not dxinfo then
		outputChatBox( "IVhud is not fully compatible with this MTA version.",false,255,0,0)
		outputChatBox( "Download MTA 1.1 or higher.",false,255,0,0)
		doDrawRadar,doDrawHUD=false,false
	else
		hudrendertarg=dxCreateRenderTarget(256,300,true)
		weptarg=dxCreateRenderTarget(256,256,true)
		texture=dxCreateTexture("images/radar.jpg")
		mask=dxCreateTexture("images/mask2.png")
		shader=dxCreateShader("shader.fx")
		renderImage=dxCreateRenderTarget(size2,size2,false)
		newtarg=dxCreateRenderTarget(size*3,size*3,false)
		dxSetShaderValue(shader,"finalAlpha",finalAlpha/255)
		dxSetShaderValue(shader,"maskTex0",mask)
	end
	if doDrawHUD then
		showPlayerHudComponent("money",false)
		showPlayerHudComponent("ammo",false)
		showPlayerHudComponent("weapon",false)
		showPlayerHudComponent("clock",false)
		showPlayerHudComponent("health",false)
		showPlayerHudComponent("armour",false)
		showPlayerHudComponent("breath",false)
	end
	if doDrawRadar then
		showPlayerHudComponent("radar",false)
		showPlayerHudComponent("health",false)
		showPlayerHudComponent("armour",false)
	end
	if doDrawRadio then
		showPlayerHudComponent("radio",false)
	end
	if doDrawInfo then
		showPlayerHudComponent("vehicle_name",false)
		showPlayerHudComponent("area_name",false)
	end
	--posTab=generateRectanglesInRing(size,0.1*size)
	addEventHandler("onClientRender",root,renderFrame)
	outputChatBox("IVhud #909090by #00DD00Karlis#909090 loaded! Press F3 for settings.",10,30,140,true)
end

function onStop()
	setElementData(root,"roundareadata",roundAreas)
	for _,v in ipairs(blips) do
		if madeByHUD[v] then
			destroyElement(v)
		end
	end
	killTimer(blipTimer)
	killTimer(hpTimer)
	killTimer(areaTimer)
	showPlayerHudComponent("money",true)
	showPlayerHudComponent("ammo",true)
	showPlayerHudComponent("weapon",true)
	showPlayerHudComponent("clock",true)
	showPlayerHudComponent("radar",true)
	showPlayerHudComponent("armour",true)
	showPlayerHudComponent("health",true)
	showPlayerHudComponent("radio",true)
	showPlayerHudComponent("vehicle_name",true)
	showPlayerHudComponent("area_name",true)
	showPlayerHudComponent("breath",true)
end

function onRaceStart()
	reDelDefaultHUD()
	if not raceMode then
		raceMode=true
		killTimer(hpTimer)
	end
end

function onRaceStop()
	if raceMode then
		raceMode=false
		hpTimer=setTimer(refreshHP,100,0)
	end
end

function reDelDefaultHUD()
	if doDrawHUD then
		showPlayerHudComponent("money",false)
		showPlayerHudComponent("ammo",false)
		showPlayerHudComponent("weapon",false)
		showPlayerHudComponent("clock",false)
		showPlayerHudComponent("health",false)
		showPlayerHudComponent("armour",false)
		showPlayerHudComponent("breath",false)
	end
	if doDrawRadar then
		showPlayerHudComponent("radar",false)
		showPlayerHudComponent("health",false)
		showPlayerHudComponent("armour",false)
	end
	if doDrawRadio then
		showPlayerHudComponent("radio",false)
	end
	if doDrawInfo then
		showPlayerHudComponent("vehicle_name",false)
		showPlayerHudComponent("area_name",false)
	end
end

function vehEnter(veh,seat)
	entering=true
	worthDrawingRadio=true
	newRadio=getRadioChannel()
	oldRadio=newRadio
	radioSwitchTime=getTickCount()
	vehSwitchTime=getTickCount()
	setElementData(source,"vehicleSeat",seat,true)
end

function vehExit()
	newRadio=getRadioChannel()
	oldRadio=getRadioChannel()
	radioSwitchTime=0
	setElementData(source,"vehicleSeat",false,true)
end

function getRadarRadius () --function from customblips resource
	if not vehicle then
		return minDist
	else
		if getVehicleType(vehicle) == "Plane" then
			return maxDist
		end
		local speed = ( getDistanceBetweenPoints3D(0,0,0,getElementVelocity(vehicle)) )
		if speed <= minVel then
			return minDist
		elseif speed >= maxVel then
			return maxDist
		end
		local streamDistance = speed - minVel
		streamDistance = streamDistance * ratio
		streamDistance = streamDistance + minDist
		return math.ceil(streamDistance)
	end
end

function doesCollide(x1,y1,v1,h1,x2,y2,v2,h2)
	local horizontal=(x1<x2)~=(x1+v1<x2) or (x1>x2)~=(x1>x2+v2)
	local vertical=(y1<y2)~=(y1+h1<y2) or (y1>y2)~=(y1>y2+h2)
	return (horizontal and vertical)
end

function isRingInRing(x1,y1,r1,x2,y2,r2)
	return r1+r2>=getDistanceBetweenPoints2D(x1,y1,x2,y2)
end

function getRot() --function extracted from customblips resource
	local camRot
	local cameraTarget = getCameraTarget()
	if not cameraTarget then
		local px,py,_,lx,ly = getCameraMatrix()
		camRot = getVectorRotation(px,py,lx,ly)
	else
		if vehicle then
			if getControlState"vehicle_look_behind" or ( getControlState"vehicle_look_left" and getControlState"vehicle_look_right" ) or ( getVehicleType(vehicle)~="Plane" and getVehicleType(vehicle)~="Helicopter" and ( getControlState"vehicle_look_left" or getControlState"vehicle_look_right" ) ) then
				camRot = -math.rad(getPedRotation(localP))
			else
				local px,py,_,lx,ly = getCameraMatrix()
				camRot = getVectorRotation(px,py,lx,ly)
			end
		elseif getControlState("look_behind") then
			camRot = -math.rad(getPedRotation(localP))
		else
			local px,py,_,lx,ly = getCameraMatrix()
			camRot = getVectorRotation(px,py,lx,ly)
		end
	end
	return camRot
end

function refreshElementData(name)
	local etype=getElementType(source)
	if etype=="blip" and elemData[source] then
		if name=="blipText" then
			elemData[source][1]=getElementData(source,name)
		elseif name=="customBlipPath" then
			elemData[source][2]=getElementData(source,name)
		end
	elseif etype=="player" and name=="vehicleSeat" then
		if not players[source] then
			players[source]=getElementData(source,name)
		end
	end
end

function getRadarAreas()
	areas=getElementsByType("radararea")
end

function getVectorRotation(px,py,lx,ly)
	local rotz=6.2831853071796-math.atan2(lx-px,ly-py)%6.2831853071796
	return -rotz
end

function ultilizeDamageScreen(attacker,weapon,_,loss)
	refreshHP()
	local slot=getPedWeaponSlot(attacker) and getPedWeaponSlot(attacker) or false
	if attacker and attacker~=source and not (slot==8 or (slot==7 and weapon~=38)) then --if we can find rotation of attacker, and its not using explosive weapon
		local px1,py1=getElementPosition(source)
		local px2,py2=getElementPosition(attacker)
		dmgTab[#dmgTab+1]={getTickCount(),math.deg(getVectorRotation(px1,py1,px2,py2)),math.min(25.5*loss,255)} --1st:attack time 2nd: rotation 3rd: how opaque it should be, reaches max on 10hp hit
	else --in case its just dmg, not one with direction
		local len=#dmgTab
		for n=1,12 do
			dmgTab[len+n]={getTickCount(),30*n,math.min(25.5*loss,255)}
		end
	end
	if #dmgTab>18 then --we dont want dx overloading
		repeat
			table.remove(dmgTab,1)
		until #dmgTab<18
	end
end

function drawRadarAreas(mx,my,mw,mh)
	for _,area in ipairs(areas) do
		local rax,ray=getElementPosition(area)
		local raw,rah=getRadarAreaSize(area)
		local ramx,ramy,ramw,ramh=(3000+rax)/6000*mapSize,(3000-ray)/6000*mapSize,raw/6000*mapSize,-(rah/6000*mapSize)
		if doesCollide(mx,my,mw,mh,ramx,ramy,ramw,ramh) then --should it even be on screen?
			local r,g,b,a=getRadarAreaColor(area)
			if isRadarAreaFlashing(area) then
				a=a*math.abs(getTickCount()%1000-500)/500
			end
			local sRatio=size2/mw
			local dx,dy,dw,dh=(ramx-mx)*sRatio,(ramy-my)*sRatio,ramw*sRatio,ramh*sRatio
			dxDrawRectangle(dx,dy,dw,dh,tocolor(r,g,b,a),false)
		end
	end
end

function drawRoundAreas(nx,ny,maprad)
	for _,content in pairs(roundAreas) do
		local ax,ay,arad=(3000+content[10])/6000*mapSize,(3000-content[11])/6000*mapSize,content[12]/6000*mapSize
		if isRingInRing(nx,ny,maprad,ax,ay,arad) then
			local sRatio=size/maprad
			local sax,say=(ax-(nx-maprad))*sRatio,(ay-(ny-maprad))*sRatio
			local sradius=arad*sRatio
			local r,g,b,a=content[1],content[2],content[3],content[4]
			if content[6] and content[13] then
				local prog=math.abs(getTickCount()%(content[5]*2)-content[5])/content[5]
				if content[13]=="Binary" then
					prog=math.floor(prog+0.5)
				end
				r,g,b=interpolateBetween(r,g,b,content[6],content[7],content[8],prog,content[13]~="Binary" and content[13] or "Linear",content[14],content[15],content[16])
				a=a+(getEasingValue(prog,content[13]~="Binary" and content[13] or "Linear",content[14],content[15],content[16])*(content[9]-a))
			end
			dxDrawImage(sax-sradius,say-sradius,sradius*2,sradius*2,"images/roundArea.png",0,0,0,tocolor(r,g,b,a),false)
		end
	end
end

function drawHudItems()
	if not doDrawHUD then return end
	dxSetRenderTarget(hudrendertarg,true)
	local currBufferOff=40
	local wantedlvl=getPlayerWantedLevel(localP)
	local ticks=getTickCount()
	if wantedlvl>0 then
		local flashide=true
		if wantedlvl~=lastwanlvl then
			if wantedlvl>lastwanlvl then
				doflash=true
				setTimer(function() doflash=false end,5000,1)
			end
			lastwanlvl=wantedlvl
		end
		if doflash or overrideFlash then
			flashhide=250>(ticks%500)
		end
		for i=1,6 do
			dxDrawImage(256-21*i,hudY,32,32,(i<=wantedlvl and flashhide) and "images/wanted.png" or "images/wanted_a.png",0,0,0,finalCol)
		end
	end
	local money=getPlayerMoney(localP)
	if lastmoney~=money then
		moneydiff=money-lastmoney
		moneychangetime=ticks
		moneychangestr=(moneydiff>0 and "+" or "")..tostring(moneydiff).."$ "
		moneychangecol=moneydiff>0 and moneyGreenCol or moneyRedCol
		moneydiffchangetime=ticks
		lastmoney=money
	end
	if ticks-moneychangetime<15000 then
		local moneystr=tostring(money).."$ "
		local moneycol=money>=0 and moneyGreenCol or moneyRedCol
		local moneyw=dxGetTextWidth(moneystr,1.2,"pricedown")
		dxDrawTextBordered(moneystr,math.min(221-moneyw,191),currBufferOff,256,currBufferOff+32,moneycol,2,1.2,"pricedown","center","top",false,false,false)
		if ticks-moneydiffchangetime<15000 then
			currBufferOff=currBufferOff+30
			local moneychangew=dxGetTextWidth(moneychangestr,1,"pricedown")
			dxDrawTextBordered(moneychangestr,math.min(221-moneychangew,191),currBufferOff,256,currBufferOff+32,moneychangecol,2,1,"pricedown","center","top",false,false,false)
		end
		currBufferOff=currBufferOff+30
	end
	if ticks-wepswitchtime<10000 then --weapon icons and ammo count
		local weapon=getPedWeapon(localP)
		if weapon==13 then weapon=12 end
		if weapon==45 then weapon=44 end
		dxSetRenderTarget(weptarg,true)
		local alpha=1
		if ticks-wepswitchtime>8000 then
			alpha=1-(ticks-wepswitchtime-8000)/2000
		end
		if wslot>1 and wslot<10 then
			local ammo=" "..tostring(getPedTotalAmmo(localP))
			local clip=0
			local ammow=dxGetTextWidth(ammo,1.2,"pricedown")
			if not (weapon==25 or (weapon>32 and weapon<37) or wslot==8) then
				clip=getPedAmmoInClip(localP)
				local clipw=dxGetTextWidth(clip,1.2,"pricedown")+5
				dxDrawTextBordered(clip,236-ammow-clipw,0,256,currBufferOff+32,clipCol,2,1.2,"pricedown","left","top",false,false,false)
			end
			dxDrawTextBordered(ammo-clip,236-ammow,0,256,currBufferOff+32,ammoCol,2,1.2,"pricedown","left","top",false,false,false)
			currBufferOff=currBufferOff+32
		else
			currBufferOff=currBufferOff+16
		end
		dxDrawImage(0,32,256,128,"images/"..weapon..".png",0,0,0,normCol)
		dxSetRenderTarget(hudrendertarg)
		dxDrawImage(0,currBufferOff-32,256,256,weptarg,0,0,0,tocolor(255,255,255,255*alpha))
	end
	dxSetRenderTarget()
	dxDrawImage(sx-hudX-256,hudY,256,300,hudrendertarg,0,0,0,finalCol,posGUI)
end

function renderFrame()
	if doRender and not isPlayerMapVisible() then
		local px,py,pz=getElementPosition(localP)
		vehicle=getPedOccupiedVehicle(localP)  --events can't handle it propertly, sorry.
		if doDrawRadar then
			local drawonborder
			local prz=getPedRotation(localP)
			local nx,ny=(3000+px)/6000*mapSize,(3000-py)/6000*mapSize
			local radius=getRadarRadius()
			local maprad=radius/6000*mapSize*zoom
			local preRot=-getRot()
			local rot=math.deg(preRot)
			local mx,my,mw,mh=nx-maprad,ny-maprad,maprad*2,maprad*2
			local scx,scy,scw,sch=0,0,size2,size2
			local absx,absy=math.abs(px),math.abs(py)
			local dontDrawSc
			if absx+radius*zoom>3000 then
				if absx-radius*zoom>3000 then
					dontDrawSc=true
				elseif px<0 then
					mw=mx+mw
					mx=0
					scw=scw*(mw/(maprad*2))
					scx=size2-scw
				else
					mw=mw-(mx+mw-mapSize)
					scw=scw*(mw/(maprad*2))
				end
			end
			if absy+radius*zoom>3000 then
				if absy-radius*zoom>3000 then
					dontDrawSc=true
				elseif py>0 then
					mh=my+mh
					my=0
					sch=sch*(mh/(maprad*2))
					scy=size2-sch
				else
					mh=mh-(my+mh-mapSize)
					sch=sch*(mh/(maprad*2))
				end
			end
			dxSetRenderTarget(renderImage,true)
			dxDrawRectangle(0,0,size2,size2,waterCol,false)
			if not dontDrawSc then
				dxDrawImageSection(scx,scy,scw,sch,mx,my,mw,mh,texture,0,0,0,normCol,false)
			end
			drawRadarAreas(nx-maprad,ny-maprad,maprad*2,maprad*2)
			drawRoundAreas(nx,ny,maprad)
			dxSetRenderTarget(newtarg,true)
			dxDrawImage(size/2,size/2,size2,size2,renderImage,rot,0,0,normCol,false)
			--[[for _,v in ipairs(posTab) do
				dxDrawImageSection(x+v[1],y+v[2],v[3],v[4],nx+v[1]*mapRad,ny+v[2]*mapRad,v[3]*mapRad,v[4]*mapRad,texture,rot,0,-(v[2]+v[4]/2),normCol,false)
			end]]
			for k,v in ipairs(dmgTab) do --handling damage showing
				v[3]=v[3]-(getTickCount()-v[1])/800 --counting current alpha using time elapsed since damage and damage power
				if v[3]<=0 then
					table.remove(dmgTab,k)
				else
					dxDrawImage(size/2,size/2,size2,size2,"images/dmg.png",rot+v[2],0,0,tocolor(255,255,255,v[3]))
				end
			end
			prepareBlips(px,py,pz,preRot,radius*zoom)
			dxDrawImage(x2,y2,l2,h2,"images/ring.png",0,0,0,ringCol,false)
			drawAir(pz)
			drawHP()
			dxDrawImage(x2,y2,l2,h2,"images/mask.png",0,0,0,ringCol,false)
			for _,v in ipairs(blipimages) do --makes sure blips are drawn over the hud frame, but text-under
				dxDrawImage(size*1.5+v[1]-x,size*1.5+v[2]-y,v[3],v[4],v[5],v[6],0,0,v[7],false)
			end
			if not (airmode or parachute) then
				dxDrawImage(size*1.5-blipDimension/2,size*1.5-blipDimension/2,blipDimension,blipDimension,"images/blips/2.png",rot-prz,0,0,normCol,false) --player blip
			end
			local Nx,Ny=getPointFromDistanceRotation(size*1.5,size*1.5,size*0.9,-rot-180)
			dxDrawImage(Nx-blipDimension/2,Ny-blipDimension/2,blipDimension,blipDimension,"images/blips/4.png",0,0,0,normCol,false) --north blip
			blipimages={}
			dxSetRenderTarget()
			dxSetShaderValue(shader,"tex0",newtarg)
			dxDrawImage(x-size*1.5,y-size*1.5,size*3,size*3,shader,0,0,0,finalCol,posGUI)
			local keyIn=getKeyState(zoomPlus)
			local keyOut=getKeyState(zoomMinus)
			if keyIn or keyOut then
				local progress=(getTickCount()-zoomticks)/1000
				zoom=math.max(minZoom,math.min(maxZoom,zoom+((keyIn and -1 or 1)*progress)))
			end
		end
		drawRadio()
		drawHudItems()
		drawTexts(px,py,pz)
	end
	zoomticks=getTickCount()
	frames=frames+1
	if zoomticks-1000>lastsec then
		local prog=(zoomticks-lastsec)
		lastsec=zoomticks
		fps=frames/(prog/1000)
		frames=fps*((prog-1000)/1000)
	end
end

function prepareBlips(px,py,pz,rot,radiusR)
	for _,blip in ipairs(blips) do
		if isElement(blip) then
			local target=elemData[blip][4]
			local targetType=isElement(target) and getElementType(target) or false
			local bx,by,bz=getElementPosition(blip)
			local occupant,doSkip
			if targetType=="vehicle" then
				occupant=getVehicleOccupant(target,0)
				doSkip=isVehicleBlown(target)
			end
			local a=elemData[blip][3][4]
			if not (localP==occupant and airMode)   --no self-attached blips cross altitude bar
			and not (madeByHUD[blip] and (doSkip or occupant)) --no vehicle blips when somebody in veh, or if it exploded
			and (localP~=target and a~=0 and ((madeByHUD[blip] and radiusR*0.9 or getBlipVisibleDistance(blip))>getDistanceBetweenPoints3D(px,py,pz,bx,by,bz) )) then --alpha above 0 and distance is close enough
				local r,g,b=elemData[blip][3][1],elemData[blip][3][2],elemData[blip][3][3]
				local dist=getDistanceBetweenPoints2D(bx,by,px,py)
				local blipPointRot=0
				local id=elemData[blip][5]
				local bSize=elemData[blip][6]
				local path=elemData[blip][7]
				local blipRot=math.deg(-getVectorRotation(px,py,bx,by)-rot)-180
				local customBlipPath=elemData[blip][2]
				local text=elemData[blip][1]
				local textcolor
				if renderPickups and targetType=="pickup" then
					local pType=getPickupType(target)
					path="images/blips/pickup"..pType..".png"
					text=pType==2 and getWeaponNameFromID(getPickupWeapon(target))
				end
				if id==0 then --handling normal blip showing up or down
					if pz<bz-3 then
						path="images/blips/"..id.."-up.png"
					elseif pz>bz+3 then
						path="images/blips/"..id.."-up.png"
						blipPointRot=180
					end
					bSize=bSize/2
				end
				if type(customBlipPath)=="string" then
					path=customBlipPath
				end
				if (id==2 or id==3) and target then --handling blip rotation for special blips
					if targetType=="vehicle" then
						_,_,zRot=getElementRotation(target)
						blipPointRot=(360-zRot)+math.deg(rot)+45
					elseif targetType=="ped" or targetType=="player" then
						zRot=getPedRotation(target)
						blipPointRot=zRot-math.deg(rot)
					end
				end
				if text~=true then --getting text for blips, true is off, false is default
					if type(text)=="string" then
						if targetType=="player" and (not (players[target]==0 or players[target]==nil)) then
							text=false
						elseif targetType=="player" then
							local pr,pg,pb=getPlayerNametagColor(target)
							textcolor=tocolor(pr,pg,pb,200)
						end
					else
						if targetType=="vehicle" then
							text=getVehicleName(target)
							setElementData(blip,"blipText",text,true)
						elseif targetType=="player" then
							if target==localP then
								text=true
							else
								text=getPlayerName(target)
							end
							setElementData(blip,"blipText",text,false)
							if type(text)=="string" then
								elemData[blip][9]=text:find("#%x%x%x%x%x%x")
							end
						end
					end
				end
				local maxSize=size*0.9
				local sRad=math.min((dist/radiusR)*size,maxSize)
				local dx,dy=getPointFromDistanceRotation(x,y,sRad,blipRot)
				blipimages[#blipimages+1]={dx-bSize/2,dy-bSize/2,bSize,bSize,path,blipPointRot,tocolor(r,g,b,a)}
				if type(text)=="string" then --drawing text for blips
					local drawColored=elemData[blip][9]
					textcolor=textcolor or elemData[blip][8] or white2
					local textL=dxGetTextWidth(text:gsub("#%x%x%x%x%x%x",""),dxSize,dxFont)
					local dx,dy=getPointFromDistanceRotation(size*1.5,size*1.5,sRad,blipRot)
					local tbx,tby=dx+(textL/2),dy+(bSize/2+textH-1)
					if math.ceil(sRad)<maxSize then --detects should the text be drawn, or its too far from you
						local textx,texty=math.ceil(dx-textL/2),math.ceil(dy+bSize/2)
						dxDrawRectangle(textx-1,texty+2,textL+2,textH-3,backgroundCol,false)
						if drawColored then
							dxDrawColorText(text,textx,texty,textx+textL,texty+textH,textcolor,dxSize,dxFont,"left","top",true,false,false)
						else
							dxDrawText(text,textx,texty,textx+textL,texty+textH,textcolor,dxSize,dxFont,"left","top",true,false,false)
						end
					end
				end
			end
		end
	end
end

function getBlips()
	if createBlipsForVehicles then
		for k,v in pairs(getElementsByType("vehicle")) do
			if not occupiedvehicles[v] then
				local blip=createBlipAttachedTo(v,2,1.4,255,255,255,255)
				madeByHUD[blip]=true
				occupiedvehicles[v]=true
				setElementData(blip,"customBlipPath","images/blips/pedvehicle.png")
				setBlipVisibleDistance(blip,400)
			end
		end
	end
	blips=getElementsByType("blip")
	table.sort(blips,function(b1,b2)
		return getBlipOrdering(b1)<getBlipOrdering(b2)
	end)
	for _,v in pairs(blips) do
		if not elemData[v] then
			elemData[v]={}
		end
		elemData[v][3]={getBlipColor(v)}
		elemData[v][4]=getElementAttachedTo(v)
		elemData[v][5]=getBlipIcon(v)
		elemData[v][6]=math.min(getBlipSize(v),4)/2*blipDimension --we don't need blips showing all over the screen, do we?
		elemData[v][7]="images/blips/"..elemData[v][5]..".png"
	end
end

function refreshHP()
	hp=getElementHealth(localP)*1.8/(1+math.max(getPedStat(localP,24)-569,0)/431) --hp conversion to 180 to be max
	armor=getPedArmor(localP)*1.8 --todo stat dependance on armor
end

function drawHP()
	if raceMode and vehicle then
		hp=getElementHealth(veh)*0.18
		armor=0
	end
	local degr=360
	local hpTempCol
	if hp<=18 then
		local ticks=getTickCount()%600
		local red=ticks<=300 and 0 or 200
		hpTempCol=tocolor(red,0,0,255)
	end
	hpTempCol=hpTempCol or hpCol
	dxDrawImage(x2,y2,l2,h2,"images/ring360.png",0,0,0,hpTempCol,false)
	if armor~=0 then
		degr=degr-hp
		dxDrawImage(x2,y2,l2,h2,"images/ring180.png",math.max(0,degr-1.8),0,0,armorCol,false)
		degr=degr-armor
	else
		degr=degr-hp*2
	end
	--if dmgcount~=0 then
	local currprog=0
	for n=0,6 do
		local val=180/2^n
		if math.ceil(val)<=degr then
			degr=degr-val
			dxDrawImage(x2,y2,l2,h2,"images/ring"..math.ceil(val)..".png",val+currprog,0,0,black,false)
			currprog=currprog+val
			if degr>=360 then
				break
			end
		end
	end
end

function drawAir(pz)
	if (vehicle and (getVehicleType(vehicle)=="Plane" or getVehicleType(vehicle)=="Helicopter")) or parachute then
		airmode=true
		if pz>200 then
			pz=pz/5
		end
		local prog=math.max(0,math.min(1,pz/200))
		dxDrawRectangle(size*1.5,size/2,2,size2,airBackCol,false)
		dxDrawLine(size*1.5-28,math.floor(size*2.45-(size2*prog)),size*1.5+28,math.floor(size*2.45-(size2*prog)),normCol,1.5,false)
	else
		airmode=false
	end
end

 function getPointFromDistanceRotation(x,y,dist,angle)
	local a=math.rad(90-angle)
	local dx=math.cos(a)*dist
	local dy=math.sin(a)*dist
	return x+dx,y+dy
end

function toogleHUD()
	doRender=not doRender
end

function weaponSwitch(_,slot)
	wslot=slot
	wepswitchtime=getTickCount()
	parachute=getPedWeapon(localP)==46
end

function weaponFire()
	wepswitchtime=getTickCount()
end

function drawRadio()
	if doDrawRadio and worthDrawingRadio and (vehicle or settingsOn) then
		local baseAlpha=math.min(255,700-(getTickCount()-radioSwitchTime)/radioFadeTime*700)
		if baseAlpha>0 then
			if startsetnewr then
				radioStartAt=lastOffX
				oldRadio=(oldRadio-lastrid)%13
				startsetnewr=false
				entering=false
			end
			local right=radioGoRight and -1 or 1
			local diff=0
			for n=1,13 do --sry for this, couldnt find formula
				diff=diff+right
				if (oldRadio-n*right)%13==newRadio then break end
			end
			local prog=math.min((getTickCount()-radioSwitchTime)/radioSlideSpeed,1)
			local rid,offX=math.modf(radioStartAt*(1-prog)+diff*prog)
			if entering then
				rid,offX=0,0
			end
			for id=-radioSideIcons-1,radioSideIcons+1 do
				local xOff=(offX+id)*radioSize
				local alpha=(1-math.abs(xOff)/radioFadeGap)*255
				local radioID=(oldRadio-rid+id)%13
				if alpha>0 and radioID~=0 then
					dxDrawImage(radioX+(xOff*radioGapSize)-radioSize/2,radioY,radioSize,radioSize,"images/radios/"..radioID..".png",0,0,0,tocolor(255,255,255,alpha*baseAlpha/255),posGUI)
				end
			end
			if prog==1 and setnewr then
				radioStartAt=0
				oldRadio=newRadio
				setnewr=false
			end
			lastOffX,lastrid=offX,rid
		else
			entering=false
			worthDrawingRadio=false
		end
	end
end

function drawTexts(px,py,pz)
	if not doDrawInfo then return end
	local ticks=getTickCount()
	if vehicle and (ticks-5000<vehSwitchTime or ticks-10000<showTime) then
		dxDrawTextBordered(getVehicleName(vehicle),txtx,txty,txtx+150,txty+30,hpCol,2,1.3,"pricedown","center","top",false,false,posGUI)
	end
	if ticks-10000<showTime then
		dxDrawTextBordered(getZoneName(px,py,pz,false),txtx,txty+43,txtx+150,txty+70,normCol,1,1.1,"default-bold","center","top",false,false,posGUI)
		dxDrawTextBordered(getZoneName(px,py,pz,true),txtx,txty+55,txtx+150,txty+110,armorCol,1,1,"diploma","center","top",false,false,posGUI)
		dxDrawTextBordered("FPS:"..math.ceil(fps-0.5),txtx,txty+85,txtx+150,txty+150,normCol,1,1.1,"clear","center","top",false,false,posGUI)
		local hrs,mins=getTime()
		local hrs,mins=tostring(hrs),tostring(mins)
		if #hrs==1 then hrs="0"..hrs end
		if #mins==1 then mins="0"..mins end
		dxDrawTextBordered(hrs..":"..mins,txtx,txty+100,txtx+150,txty+160,normCol,2,3,"default-bold","center","top",false,false,posGUI)
	end
end

function dxDrawTextBordered(text,x1,y1,x2,y2,color,thickness,scale,font,alignX,alignY,textclip,wordbreak,postgui)
	for w=-thickness,thickness,thickness do
		for h=-thickness,thickness,thickness do
			if not(w==0 and h==0) then
				dxDrawText(text,x1+w,y1+h,x2+w,y2+h,black,scale,font,alignX,alignY,textclip,wordbreak,postgui)
			end
		end
	end
	dxDrawText(text,x1,y1,x2,y2,color,scale,font,alignX,alignY,textclip,wordbreak,postgui)
end

function radioSwitch(_,_,forward)
	startsetnewr=true
	setnewr=true
	worthDrawingRadio=true
	radioGoRight=forward
	radioSwitchTime=getTickCount()
	newRadio=getRadioChannel()
end

function showAll()
	showTime=getTickCount()
	moneychangetime=showTime
	wepswitchtime=showTime
end

function math.clip(min,val,max)
	return math.max(min,math.min(max,val))
end

addCommandHandler("getInfo",function()
	local info=dxGetStatus()
	for k,v in pairs(info) do
		outputConsole(k.." : "..tostring(v))
	end
end)

function dxDrawColorText(str, ax, ay, bx, by, color, scale, font, alignX, alignY,clip,wordbreak,postgui)
	if alignX then
		if alignX == "center" then
			local w = dxGetTextWidth(str:gsub("#%x%x%x%x%x%x",""), scale, font)
			ax = ax + (bx-ax)/2 - w/2
		elseif alignX == "right" then
			local w = dxGetTextWidth(str:gsub("#%x%x%x%x%x%x",""), scale, font)
			ax = bx - w
		end
	end
	if alignY then
		if alignY == "center" then
			local h = dxGetFontHeight(scale, font)
			ay = ay + (by-ay)/2 - h/2
		elseif alignY == "bottom" then
			local h = dxGetFontHeight(scale, font)
			ay = by - h
		end
	end
	local pat = "(.-)#(%x%x%x%x%x%x)"
	local s, e, cap, col = str:find(pat, 1)
	local last = 1
	while s do
		if cap == "" and col then color = tocolor(tonumber("0x"..col:sub(1, 2)), tonumber("0x"..col:sub(3, 4)), tonumber("0x"..col:sub(5, 6)), 255) end
		if s ~= 1 or cap ~= "" then
			local w = dxGetTextWidth(cap, scale, font)
			dxDrawText(cap, ax, ay, ax + w, by, color, scale, font,"left","top",clip,wordbreak,postgui)
			ax = ax + w
			color = tocolor(tonumber("0x"..col:sub(1, 2)), tonumber("0x"..col:sub(3, 4)), tonumber("0x"..col:sub(5, 6)), 255)
		end
		last = e + 1
		s, e, cap, col = str:find(pat, last)
	end
	if last <= #str then
		cap = str:sub(last)
		local w = dxGetTextWidth(cap, scale, font,"left","top",clip,wordbreak,postgui)
		dxDrawText(cap, ax, ay, ax + w, by, color, scale, font)
	end
end

--public

function createRoundRadarArea(ax,ay,aradius,r,g,b,a)
	if not (tonumber(ax) or tonumber(ay) or tonumber(aradius)) then return false end
	local new=source or createElement("roundradararea")
	roundAreas[new]={r or 255,g or 255,b or 255,a or 150} --default color values
	roundRadarAreaDimensions(new,ax,ay,aradius)
	addEventHandler("onClientElementDestroy",new,function()
		roundAreas[source]=nil
	end)
	return new
end

function roundRadarAreaDimensions(area,ax,ay,aradius)
	if not roundAreas[area] then return false end
	if tonumber(ax) and tonumber(ay) and tonumber(aradius) then
		roundAreas[area][10],roundAreas[area][11],roundAreas[area][12]=ax,ay,aradius --sorry for mixed table index, cba rewriting it
		return true
	else
		return roundAreas[area][10],roundAreas[area][11],roundAreas[area][12]
	end
end

function roundRadarAreaFlashing(area,interval,r,g,b,a,easetype,easeperiod,easeamplitude,easeovershoot)
	if not roundAreas[area] then return false end
	if interval then
		roundAreas[area][5],roundAreas[area][6],roundAreas[area][7],roundAreas[area][8],roundAreas[area][9],roundAreas[area][13],roundAreas[area][14],roundAreas[area][15],roundAreas[area][16]=interval,r,g,b,a,easetype,easeperiod,easeamplitude,easeovershoot
		return true
	else
		return roundAreas[area][5],roundAreas[area][6],roundAreas[area][7],roundAreas[area][8],roundAreas[area][9],roundAreas[area][13],roundAreas[area][14],roundAreas[area][15],roundAreas[area][16]
	end
end

function roundRadarAreaColor(area,r,g,b,a)
	if not roundAreas[area] then return false end
	if tonumber(r) and tonumber(g) and tonumber(b) then
		roundAreas[area][1],roundAreas[area][2],roundAreas[area][3],roundAreas[area][4]=r,g,b,tonumber(a) or 150
		return true
	else
		return roundAreas[area][1],roundAreas[area][2],roundAreas[area][3],roundAreas[area][4]
	end
end

function isElementInRoundRadarArea(element,area)
	if not (roundAreas[area] or isElement(element)) then return false end
	local ex,ey=getElementPosition(element)
	local ax,ay,arad=roundAreas[area][10],roundAreas[area][11],roundAreas[area][12]
	return getDistanceBetweenPoints2D(ex,ey,ax,ay)<=arad
end

function getElementsInRoundRadarArea(area,elemtype)
	if not roundAreas[area] then return false end
	local ax,ay,arad=roundAreas[area][10],roundAreas[area][11],roundAreas[area][12]
	local colcircle=createColCircle(ax,ay,arad)
	local elems=getElementsWithinColShape(colcicle,elemtype)
	destroyElement(colcircle)
	return elems
end

--events

addEvent("onServerCreateRoundArea",true)
addEvent("onServerChangeRoundAreaDimensions",true)
addEvent("onServerChangeRoundAreaFlashing",true)
addEvent("onServerChangeRoundAreaColor",true)
addEventHandler("onServerCreateRoundArea",root,createRoundRadarArea)
addEventHandler("onServerChangeRoundAreaDimensions",root,roundRadarAreaDimensions)
addEventHandler("onServerChangeRoundAreaFlashing",root,roundRadarAreaFlashing)
addEventHandler("onServerChangeRoundAreaColor",root,roundRadarAreaColor)
addEventHandler("onClientPlayerWeaponFire",root,weaponFire)
addEventHandler("onClientPlayerWeaponSwitch",root,weaponSwitch)
addEventHandler("onClientResourceStart",resRoot,onStart)
addEventHandler("onClientResourceStop",resRoot,onStop)
local race=getResourceFromName("race")
if race then
	addEvent("onClientMapStarting",true)
	addEventHandler("onClientMapStarting",getResourceRootElement(race),onRaceStart)
	addEventHandler("onClientResourceStop",getResourceRootElement(race),onRaceStop)
end
addEventHandler("onClientPlayerDamage",localP,ultilizeDamageScreen)
addEventHandler("onClientElementDataChange",root,refreshElementData)
addEventHandler("onClientPlayerVehicleEnter",localP,vehEnter)
addEventHandler("onClientPlayerVehicleStartExit",localP,vehExit)