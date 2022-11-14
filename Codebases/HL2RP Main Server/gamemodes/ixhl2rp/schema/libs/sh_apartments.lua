/*
	struct Apartment

	number doorID The creation ID of the apartment's door.
	string name The door's name, in the format of A1, A2, A3, B1, B2, etc.
	string building The building the apartment is located in.
	number maxTenants The maximum number of tenants that can be assigned to the apartment.
	table tenants A table of the CIDs of the characters assigned to the apartment.
*/

/*
    ix.apartments.list contains tables indexed by the building name,
    with Apartment tables in it, indexed by the apartment name 
*/
ix.apartments = ix.apartments or {}
ix.apartments.list = ix.apartments.list or {}

function Apartment(name, building, doorID, maxTenants, tenants)
	return {
		doorID = doorID,
		name = name,
		building = building,
		maxTenants = maxTenants or 2,
		tenants = tenants or {}
	}
end

local CHAR = ix.meta.character
local EntityMeta = FindMetaTable("Entity")


if SERVER then
	
	function ix.apartments.LoadBaseData(setupData)
		for k, v in ipairs(ents.FindByClass("ix_testent3")) do
			v:Remove()
		end

		/*

		for buildName, building in pairs(setupData) do
			ix.apartments.list[buildName] = {}
			for aptName, apartment in pairs(building) do
				ix.apartments.list[buildName][aptName] = Apartment(aptName, buildName, apartment.doorID, apartment.maxTenants, {})
				local doorEnt = ents.GetMapCreatedEntity(apartment.doorID)
				doorEnt:SetNetVar("title", aptName)
				doorEnt:SetNetVar("visible", true)

				if IsValid(doorEnt.ixLock) then
					doorEnt.ixLock:Remove()
				end
			end
		end

		*/
	end

    function ix.apartments.AddBuilding(building)
        ix.apartments.list[building] = {}
    end

    function ix.apartments.RemoveBuilding(building)
        ix.apartments.list[building] = nil
    end

    function ix.apartments.AddApartment(name, building, doorID, maxTenants, tenants)
        local newApt = Apartment(name, building, doorID, maxTenants, tenants)
        ix.apartments.list[building][name] = newApt
    end

    function ix.apartments.AddTenant(name, building, CID)
        local apt = ix.apartments.list[building][name]
        ix.apartments.list[building][name].tenants[#apt.tenants + 1] = CID
    end

    function ix.apartments.RemoveTenant(name, building, CID)
        table.RemoveByValue(ix.apartments.list[building][name].tenants, CID)
    end

	function ix.apartments.IsTenant(name, building, CID)
		return table.HasValue(ix.apartments.list[building][name].tenants, CID)
	end

	function ix.apartments.FindByCreationID(mapCreationID)
		for _, building in pairs(ix.apartments.list) do
			for __, apartment in pairs(building) do
				if apartment.doorID == mapCreationID then
					return apartment
				end
			end
		end

		return nil
	end

    function CHAR:GetApartments()
		local apts = {}
		local CID = self:GetData("cid", "00000")

		for k, apartment in ipairs(ix.apartments.list) do
			if table.HasValue(apartment.tenants, CID) then
				apts[#apts + 1] = apartment.name 
			end
		end

		return apts
	end

	function EntityMeta:GetApartment()
		return ix.apartments.FindByCreationID(self:MapCreationID())
	end

end