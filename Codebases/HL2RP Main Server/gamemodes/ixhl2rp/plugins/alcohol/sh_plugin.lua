PLUGIN.name = "Alcohol"
PLUGIN.author = "AleXXX_007, Frosty"
PLUGIN.description = "Adds alcohol with effects."

ix.lang.AddTable("english", {
	itemBeerDesc = "An alcoholic drink brewed from cereal grains—most commonly from malted barley, though wheat, maize (corn), and rice are also used.",
	itemBourbonDesc = "A bottle of American whiskey, a barrel-aged distilled spirit made primarily from corn.",
	itemMoonshineDesc = "A bottle of illegally distilled liquor that is so named because its manufacture may be conducted without artificial light at night-time.",
	itemNukaColaDarkDesc = 'A ready to drink bottle of Nuka-Cola and rum boasting an alcohol-by-volume content of 35%, the beverage was touted as "the most thirst-quenching way to unwind."',
	itemRumDesc = "A distilled spirit derived from fermented cane sugar and molasses.",
	itemVodkaDesc = "A clear distilled alcoholic liquor made from grain mash.",
	itemWhiskeyDesc = "A liquor distilled from the fermented mash of grain (as rye, corn, or barley).",
	itemWineDesc = "An alcoholic beverage made by fermenting the juice of grapes.",
})
ix.lang.AddTable("korean", {
	["Alcohol"] = "술",
	Drink = "마시기",
	["Beer"] = "맥주",
	itemBeerDesc = "보리와 같은 곡물을 발효시키고 향신료인 홉을 첨가시켜 맛을 낸 술입니다.",
	["Bourbon"] = "버본",
	itemBourbonDesc = "미국 켄터키를 중심으로 생산되는 위스키입니다.",
	["Moonshine"] = "밀주",
	itemMoonshineDesc = "가정에서 양조해서 가끔씩 마시는 술로, 보통 옥수수를 주 원료로 사용한 콘 위스키의 형태를 가지고 있으며 거기에 맥아와 이스트 등을 사용해 발효한 밑술을 위의 제조 공정에 따라 증류하여 만듭니다.",
	["Nuka-Cola Dark"] = "누카 콜라 다크",
	itemNukaColaDarkDesc = "비쩍 타들어가는 듯한 갈증을 풀어주는 어른들의 누카 콜라입니다.",
	["Rum"] = "럼",
	itemRumDesc = "사탕수수를 착즙해서 설탕을 만들고 남은 찌꺼기인 당밀이나 사탕수수 즙을 발효시킨 뒤 증류한 술로, 옛날 뱃사람들이 주로 마셨다고 합니다.",
	["Vodka"] = "보드카",
	itemVodkaDesc = "수수, 옥수수, 감자, 밀, 호밀 등 탄수화물 함량이 높은 식물로 빚은 러시아 원산의 증류주입니다.",
	["Whiskey"] = "위스키",
	itemWhiskeyDesc = "스코틀랜드에서 유래한 술로 가장 유명한 증류주입니다.",
	["Wine"] = "포도주",
	itemWineDesc = "포도를 으깨서 나온 즙을 발효시킨 과실주로, 상류층이 주로 즐깁니다.",
})

function PLUGIN:Drunk(client)
	local endurance = client:GetCharacter():GetAttribute("end")
	local strength = client:GetCharacter():GetAttribute("str")
	
	if endurance == nil then
		endurance = 0
	end
	
	if strength then
		client:GetCharacter():SetAttrib("str", strength + 3)
	end
	
	client:SetLocalVar("drunk", client:GetLocalVar("drunk") + client:GetCharacter():GetData("drunk"))
	
	if client:GetLocalVar("drunk") > 100 then
		local unctime = (client:GetLocalVar("drunk") - 100) * 7.5
		client:ConCommand("say /fallover ".. unctime .."")
	end
	
	timer.Create("drunk", 5, 0, function()
		client:SetLocalVar("drunk", client:GetLocalVar("drunk") - 1)
		client:GetCharacter():SetData("drunk", client:GetLocalVar("drunk"))
		if client:GetCharacter():GetData("drunk") == 0 then
			if strength then
				client:GetCharacter():SetAttrib("str", strength)
			end
			
			timer.Remove("drunk")
		end
	end)
end

if (SERVER) then
	function PLUGIN:PostPlayerLoadout(client)
		client:SetLocalVar("drunk", 0)
		client:GetCharacter():SetData("drunk", 0)
	end
	
	function PLUGIN:PlayerDeath(client)
		client:SetLocalVar("drunk", 0)
		client:GetCharacter():SetData("drunk", 0)
	end
end

if (CLIENT) then
	function PLUGIN:RenderScreenspaceEffects()
		
		local default = {}
		default["$pp_colour_addr"] = 0
		default["$pp_colour_addg"] = 0
		default["$pp_colour_addb"] = 0
		default["$pp_colour_brightness"] = 0
		default["$pp_colour_contrast"] = 1
		default["$pp_colour_colour"] = 0.90
		default["$pp_colour_mulr"] = 0
		default["$pp_colour_mulg"] = 0
		default["$pp_colour_mulb"] = 0

		local a = LocalPlayer():GetLocalVar("drunk")
		
		if a == nil then
			a = 0
		end
		
		if (a > 20) then
			local value = (LocalPlayer():GetLocalVar("drunk"))*0.01
			DrawMotionBlur( 0.2, value, 0.05 )
		else
			DrawColorModify(default)
		end
	end
end