
local Clockwork = Clockwork;

-- Sceen overlay texture files
Clockwork.kernel:AddFile("materials/effects/gasmask_screen_1.vtf");
Clockwork.kernel:AddFile("materials/effects/gasmask_screen_2.vtf");
Clockwork.kernel:AddFile("materials/effects/gasmask_screen_3.vtf");
Clockwork.kernel:AddFile("materials/effects/gasmask_screen_4.vtf");
Clockwork.kernel:AddFile("materials/effects/gasmask_screen.vtf");

Clockwork.kernel:AddFile("materials/effects/gasmask_screen_1.vmt");
Clockwork.kernel:AddFile("materials/effects/gasmask_screen_2.vmt");
Clockwork.kernel:AddFile("materials/effects/gasmask_screen_3.vmt");
Clockwork.kernel:AddFile("materials/effects/gasmask_screen_4.vmt");
Clockwork.kernel:AddFile("materials/effects/gasmask_screen.vmt");

Clockwork.hint:Add("Durability", "Your suit degrades as it takes damage. Don't forget to repair it.");
Clockwork.hint:Add("RadResistance", "Some armor suits can protect you against radiation!");
Clockwork.hint:Add("Gasmask", "Gasmasks need a filter to provide additional protection against radiation.");
Clockwork.hint:Add("Protection", "Better armor provides more damage reduction, regardless of durability.");