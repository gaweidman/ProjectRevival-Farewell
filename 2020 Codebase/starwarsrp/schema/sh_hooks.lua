
-- Here is where all of your shared hooks should go.

-- Disable entity driving.
function Schema:CanDrive(client, entity)
	return false
end

function Schema:CanPlayerUseBusiness(client, uniqueID)
	return false
end