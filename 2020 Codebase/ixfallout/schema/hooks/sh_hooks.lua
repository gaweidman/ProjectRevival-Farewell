
function Schema:CanPlayerUseBusiness(client, uniqueID)
	return client:IsAdmin() or client:GetCharacter():HasFlags("b")
end

function Schema:CanDrive()
	return false
end
