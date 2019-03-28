addEventHandler("onClientResourceStart", resourceRoot,
	function ()
		local txd = engineLoadTXD("lan2office.txd")
		
		if txd then
			engineImportTXD(txd, 3781)
		end
	end
)