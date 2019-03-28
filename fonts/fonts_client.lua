local dxFonts = {}
local guiFonts = {}

addEventHandler("onClientResourceStart", resourceRoot,
	function ()
		local fontNames = {
		"FalturaRegular.ttf",
		"D3SmartismA.ttf",
		"featuredItem.ttf",
		"SFMoviePoster-BoldOblique.ttf",
		"SFMoviePosterCondensed-Bold.ttf",
		"SFMoviePosterCondensed-Obli.ttf",
		"UltraCondensedSansSerif.ttf",
		"UNCON___.ttf",
		"UNCONB___.ttf",
		}
		--[[
		local sx,sy = guiGetScreenSize()
		local x = sx/8
		local y = sy/8
		for i, fn in ipairs(fontNames) do
			local label = guiCreateLabel(x,y, 320,64, "Driver Pimpin Truckin", false)
			local font = getGuiFont(fn, 40)
			guiLabelSetHorizontalAlign(label, "left")
			guiLabelSetVerticalAlign(label, "top")
			local c = 192+math.random()*64
			guiLabelSetColor(label, c,c,c)
			guiSetFont(label, font)
			if y < sy-(sy/4) then
				y = y+64
			else
				x = x+(sx/2.5)
				y = sy/8
			end
		end
		]]
	end
)

function getDxFont(filepath, size, bold)
	dxFonts[filepath] = dxCreateFont(filepath or "", size or 9, bold or false)
	return dxFonts[filepath]
end

function getGuiFont(filepath, size)
	guiFonts[filepath] = guiCreateFont(filepath or "", size or 9)
	return guiFonts[filepath]
end
