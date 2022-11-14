
local PLUGIN = PLUGIN;
local Clockwork = Clockwork;

Clockwork.chatBox:RegisterClass("localevent", nil, function(info)
	Clockwork.chatBox:Add(info.filtered, nil, Color(200, 100, 50, 255), "(LOCAL) "..info.text);
end);

Clockwork.chatBox:RegisterClass("me", "ic", function(info)				
	local color;
	if (!info.focusedOn) then
		color = Color(255, 255, 150, 255);
	else
		color = Color(175, 255, 175, 255);
	end;
	
	if (string.sub(info.text, 1, 1) == "'") then
		Clockwork.chatBox:Add(info.filtered, nil, color, "*** "..info.name..info.text);
	else
		Clockwork.chatBox:Add(info.filtered, nil, color, "*** "..info.name.." "..info.text);
	end;
end);

Clockwork.chatBox:RegisterClass("mec", "ic", function(info)				
	local color;
	if (!info.focusedOn) then
		color = Color(255, 255, 150, 255);
	else
		color = Color(175, 255, 175, 255);
	end;
	
	if (string.sub(info.text, 1, 1) == "'") then
		Clockwork.chatBox:Add(info.filtered, nil, color, "* "..info.name..info.text);
	else
		Clockwork.chatBox:Add(info.filtered, nil, color, "* "..info.name.." "..info.text);
	end;
end);

Clockwork.chatBox:RegisterClass("mel", "ic", function(info)				
	local color;
	if (!info.focusedOn) then
		color = Color(255, 255, 150, 255);
	else
		color = Color(175, 255, 175, 255);
	end;
	
	if (string.sub(info.text, 1, 1) == "'") then
		Clockwork.chatBox:Add(info.filtered, nil, color, "***** "..info.name..info.text);
	else
		Clockwork.chatBox:Add(info.filtered, nil, color, "***** "..info.name.." "..info.text);
	end;
end);

Clockwork.chatBox:RegisterClass("it", "ic", function(info)				
	local color;
	if (!info.focusedOn) then
		color = Color(255, 255, 150, 255);
	else
		color = Color(175, 255, 175, 255);
	end;
	
	Clockwork.chatBox:Add(info.filtered, nil, color, "***' "..info.text);
end);

Clockwork.chatBox:RegisterClass("itc", "ic", function(info)				
	local color;
	if (!info.focusedOn) then
		color = Color(255, 255, 150, 255);
	else
		color = Color(175, 255, 175, 255);
	end;
	
	Clockwork.chatBox:Add(info.filtered, nil, color, "*' "..info.text);
end);

Clockwork.chatBox:RegisterClass("itl", "ic", function(info)				
	local color;
	if (!info.focusedOn) then
		color = Color(255, 255, 150, 255);
	else
		color = Color(175, 255, 175, 255);
	end;
	
	Clockwork.chatBox:Add(info.filtered, nil, color, "*****' "..info.text);
end);
