---
-- This file defines the default settings the player will have
-- before he changes and saves the settings himself (if he does).
--
-- @author driver2
-- @copyright 2010 driver2
--
-- Recent changes:
-- 2010-02-08: Commented out "fpsTextEnabled" setting, cleaned up

defaultSettings = {
	["enabled"] = true,
	["currentEnabled"] = true,
	["maxEnabled"] = true,
	["minEnabled"] = true,
	["avgEnabled"] = true,
	["lastMinuteEnabled"] = true,
	["fullEnabled"] = false,
	--["fpsTextEnabled"] = true,
	["fontSize"] = 1,
	["fontType"] = "default",
	["width"] = 1,
	["height"] = 1.2,
	["seconds"] = 120,
	-- Position
	["top"] = 0.958,
	["left"] = 0.06,

	-- Colors
	["avgLineColorRed"] = 0,
	["avgLineColorGreen"] = 0,
	["avgLineColorBlue"] = 0,
	["avgLineColorAlpha"] = 50,

	["minLineColorRed"] = 0,
	["minLineColorGreen"] = 0,
	["minLineColorBlue"] = 0,
	["minLineColorAlpha"] = 50,

	["fontColorRed"] = 255,
	["fontColorGreen"] = 255,
	["fontColorBlue"] = 255,
	["fontColorAlpha"] = 255,

	["backgroundColorRed"] = 255,
	["backgroundColorGreen"] = 255,
	["backgroundColorBlue"] = 255,
	["backgroundColorAlpha"] = 50,

	["dataColorRed"] = 0,
	["dataColorGreen"] = 0,
	["dataColorBlue"] = 0,
	["dataColorAlpha"] = 80

}
