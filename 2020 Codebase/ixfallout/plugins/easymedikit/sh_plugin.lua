local PLUGIN = PLUGIN
PLUGIN.name = "Easy Medikit"
PLUGIN.description = "A small base of medical kit (Heal yourself, heal others, works with medical attribute)"
PLUGIN.author = "Subleader, Frosty"

ix.lang.AddTable("english", {
	itemMedkitDesc01 = "\n \n Required knowledge:",
	itemMedkitDesc02 = "\n Heal points: ",
	selfheal = "Heal yourself",
	heal = "Heal",
	lackKnowledge = "You don't know how to use it.",
	cNotValid = "You are not looking at a valid character!",
	itemBandageDesc = "A piece of material used either to support a medical device such as a dressing or splint, or on its own to provide support to or to restrict the movement of a part of the body.",
	itemDoctorbagDesc = "A large, leather bags, filled with tools specifically for doctors. Field medics need not apply.",
	itemStimpakDesc = "A hand-held medication used in healing the body. When the medicine is injected, it provides immediate healing of the body's minor wounds.",
	itemSuperStimpakDesc = "A more advanced version of the regular stimpak. While it heals more severe wounds, it also has unpleasant side effects. The super version comes in a hypodermic needle, but with an additional vial containing more powerful drugs than the basic model and a leather belt to strap the needle to the injured limb.",
})
ix.lang.AddTable("korean", {
	["Intelligence"] = "지능",
	itemMedkitDesc01 = "\n \n 의학 지식:",
	itemMedkitDesc02 = "\n 회복력: ",
	selfheal = "자가 치료하기",
	heal = "치료해주기",
	lackKnowledge = "당신은 이 아이템을 사용하는 방법을 모릅니다.",
	cNotValid = "유효한 캐릭터를 바라보고 있어야 합니다.",
	["Bandage"] = "붕대",
	itemBandageDesc = "상처 부위를 압박하여 출혈을 줄여 줍니다.",
	["Doctor's bag"] = "의사의 왕진 가방",
	itemDoctorbagDesc = "의사 전용 도구로 채워진 커다란 가죽 가방입니다. 현장 의료진을 쓸 필요가 없습니다.",
	["Stimpak"] = "스팀팩",
	itemStimpakDesc = "부상을 치료하는 휴대용 의료 주사입니다.",
	["Super stimpak"] = "슈퍼 스팀팩",
	itemSuperStimpakDesc = "부상을 치료하는 휴대용 의료 주사인 스팀팩의 강화판으로, 좋지 않은 부작용이 있다는 이야기가 있습니다.",
})