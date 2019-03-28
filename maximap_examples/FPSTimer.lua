local frames=0
local fpsTimer={}

local function cleanTable(t)
	if #t>0 then
		for i=1,#t do
			t[i]=nil
		end
	end
end

function setFPSTimer(func,totalTime,timesToExecute,...)
	local argTable={...}
	local timer=createElement("FPS-timer")
	fpsTimer[timer]={func=func,startTime=frames,time=totalTime,times=timesToExecute,arg=argTable}
	return element
end

local function handleTimerRender()
	frames=frames+1
	
	for k,v in pairs(fpsTimer) do
		if frames>=v.startTime+v.time then
			v.func(unpack(v.arg))
			v.times=v.times-1
			if v.times==0 then
				fpsTimer[k]=nil
			end
		end
	end
end
addEventHandler("onClientRender",getRootElement(),handleTimerRender)