PLUGIN.name = "PAC3 Restriction";
PLUGIN.author = "Casadis";
PLUGIN.desc = "Restricts PAC3 to people with permissions.";

nut.flag.add("P", "Access to PAC3.")

if (CLIENT) then
	function PLUGIN:PrePACEditorOpen()
		local client = LocalPlayer()
		local char = client:getChar()

		print(char and char:hasFlags("P"))
		return char and char:hasFlags("P")
	end
else
	-- Reject unauthorized PAC3 submits
	net.Receive("pac_submit", function(_, ply)
		if (!ply) then return end -- ???

		if (!ply:getChar():hasFlags("P")) then
			ply:notifyLocalized("illegalAccess")
			return
		end

		local data = pace.net.DeserializeTable()
		pace.HandleReceivedData(ply, data)
	end)	
end