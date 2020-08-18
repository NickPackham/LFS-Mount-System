EPS_Mounts = {}

--[[

	Global Functions

--]]

function EPS_Mounts:IsMountPurchased(mount)
    if istable(EPS_PurchasedMounts[LocalPlayer():SteamID64()]) then
    	for k, v in pairs(EPS_PurchasedMounts[LocalPlayer():SteamID64()]) do
    		if v.Mount == mount then
    			return true
    		end
    	end
    end

	return false
end

function EPS_Mounts:IsHangarOccupied(hangarname)
	local hangar = EPS_Mounts_Config.SpawnPositions[hangarname]

	for k, v in pairs(ents.FindInSphere(hangar.Position, 250)) do
		if v:IsPlayer() or v:IsVehicle() then
			return true
		end
	end

	return false
end