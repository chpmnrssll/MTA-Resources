local collisions = {}

addEventHandler("onClientResourceStart", resourceRoot,
	function ()
		table.insert(collisions, { engineLoadCOL("ab_mafiasuite01zzz.col"), 14581 })
		table.insert(collisions, { engineLoadCOL("cj_bag_reclaim.col"), 3971 })
		table.insert(collisions, { engineLoadCOL("hubinterior_sfs.col"), 11389 })
		table.insert(collisions, { engineLoadCOL("lan2officeflrs.col"), 3781 })
		table.insert(collisions, { engineLoadCOL("mafcastopfoor.col"), 14590 })
		table.insert(collisions, { engineLoadCOL("mp_dinersmall.col"), 18058 })
		table.insert(collisions, { engineLoadCOL("skyscrapn203.col"), 4587 })
		table.insert(collisions, { engineLoadCOL("tr_man_main.col"), 14639 })
		table.insert(collisions, { engineLoadCOL("tr_man_pillar.col"), 14569 })
		colfix()
	end
)

function colfix()
	for i, collision in ipairs(collisions) do
		engineReplaceCOL(collision[1], collision[2])
	end
end

addEvent("colfix", true)
addEventHandler("colfix", getRootElement(), colfix)
