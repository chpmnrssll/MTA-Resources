addEventHandler("onPlayerLogin", root,
	function ()
		local account = getPlayerAccount(source)
		setElementData(source, "bankBalance", getAccountData(account, "bankBalance") or 0)
	end
)

addEventHandler("onPlayerLogout", root,
	function ()
		local account = getPlayerAccount(source)
		setElementData(source, "bankBalance", getAccountData(account, "bankBalance") or 0)
	end
)

addEventHandler("onResourceStart", resourceRoot,
	function ()
		for i, player in ipairs(getElementsByType("player")) do
			local account = getPlayerAccount(player)
			setElementData(player, "bankBalance", getAccountData(account, "bankBalance") or 0)
		end
	end
)

addEvent("purchaseWeapon", true)
addEventHandler("purchaseWeapon", root,
	function (weaponID, amount, price)
		if weaponID == "armor" then
			setPedArmor(source, 100)
		else
			giveWeapon(source, weaponID, amount, true)
		end
		takePlayerMoney(source, price)
	end
)

addEvent("purchaseHealth", true)
addEventHandler("purchaseHealth", root,
	function (amount, price)
		setElementHealth(source, getElementHealth(source)+amount)
		takePlayerMoney(source, price)
	end
)

addEvent("depositMoney", true)
addEventHandler("depositMoney", root,
	function (amount)
		local account = getPlayerAccount(source)
		local cash = getPlayerMoney(source)
		local bankBalance = getElementData(source, "bankBalance") or 0
		
		setPlayerMoney(source, cash-amount)
		setAccountData(account, "bankBalance", bankBalance+amount)
		setElementData(source, "bankBalance", bankBalance+amount)
	end
)

addEvent("withdrawMoney", true)
addEventHandler("withdrawMoney", root,
	function (amount)
		local account = getPlayerAccount(source)
		local cash = getPlayerMoney(source)
		local bankBalance = getElementData(source, "bankBalance") or 0
		
		setPlayerMoney(source, cash+amount)
		setAccountData(account, "bankBalance", bankBalance-amount)
		setElementData(source, "bankBalance", bankBalance-amount)
	end
)
