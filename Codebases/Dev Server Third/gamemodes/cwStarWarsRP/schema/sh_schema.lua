--[[
	© 2012 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

Clockwork.kernel:IncludePrefixed("cl_hooks.lua");
Clockwork.kernel:IncludePrefixed("cl_schema.lua");
Clockwork.kernel:IncludePrefixed("cl_theme.lua");
Clockwork.kernel:IncludePrefixed("sh_hooks.lua");
Clockwork.kernel:IncludePrefixed("sv_hooks.lua");
Clockwork.kernel:IncludePrefixed("sv_schema.lua");

Clockwork.option:SetKey("default_date", {month = 1, year = 2013, day = 1});
Clockwork.option:SetKey("default_time", {minute = 0, hour = 0, day = 1});

Clockwork.option:SetKey("intro_image", "example/example");
Clockwork.option:SetKey("schema_logo", "example/example_logo");

Clockwork.option:SetKey("menu_music", "music/hl1_song3.mp3");
Clockwork.option:SetKey("model_shipment", "models/props_junk/cardboard_box002a.mdl");
Clockwork.option:SetKey("name_cash", "Dollars");

Clockwork.config:ShareKey("intro_text_big");
Clockwork.config:ShareKey("intro_text_small");

Clockwork.quiz:SetEnabled(true);
Clockwork.quiz:AddQuestion("Am I an example quiz?", 1, "Yes.", "No.");

Clockwork.flag:Add("e", "Example Flag", "Access to an example flag.");