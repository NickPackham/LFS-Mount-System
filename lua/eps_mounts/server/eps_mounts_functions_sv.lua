if not EPS_PurchasedMounts then
	EPS_PurchasedMounts = {}
	EPS_MountWhitelist = {}
end

EPS_Mounts = {}

local plyMeta = FindMetaTable("Player")

function plyMeta:EPS_PurchaseMount(mount, success)
	if EPS_Mounts_Config.Mysqloo then
		local db = EPS_MountSys

		local q = " INSERT INTO eps_mountsys(SteamID, Mount, PurchaseTime) VALUES( '%s', '%s', '%s') "
		local test = q:format( self:SteamID64(), db:escape(mount), os.time())

		local insert = db:query(test)
	    insert:start()

	    insert.onSuccess = function()
	    	success(true)
	    end
	else
		local q = " INSERT INTO eps_mountsys(SteamID, Mount, PurchaseTime) VALUES( '%s', '%s', '%s' ) "
		local test = q:format( self:SteamID64(), sql.SQLStr(mount, true), os.time() )


		local query = sql.Query(test)

		if query == nil then
			success(true)
		else
			success(false)
		end
	end
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

function plyMeta:EPS_IsMountPurchased(mount)
	if istable(EPS_PurchasedMounts[self:SteamID64()]) then
		for k, v in pairs(EPS_PurchasedMounts[self:SteamID64()]) do
			if v.Mount == mount then
				return true
			end
		end
	end

	return false
end

function plyMeta:EPS_GetPurchasedMounts_Sql(callback)
	if EPS_Mounts_Config.Mysqloo then
		local db = EPS_MountSys
		local q = " SELECT * FROM eps_mountsys WHERE SteamID='%s' "
		local test = q:format( self:SteamID64() )
		local insert = db:query(test)

		insert:start()

		insert.onSuccess = function(q, data)
			if istable(data) then
				callback(data)
			else
				callback(false)
			end
		end
	else
		local q = " SELECT * FROM eps_mountsys WHERE SteamID='%s' "
		local test = q:format( self:SteamID64() )

		local result = sql.Query(test)

		callback(result)
	end
end

function plyMeta:EPS_GetPurchasedMounts()
	return EPS_PurchasedMounts[self:SteamID64()]
end

function plyMeta:EPS_UpdatePurchasedMounts()
	self:EPS_GetPurchasedMounts_Sql(function(data)
		EPS_PurchasedMounts[self:SteamID64()] = data

		net.Start("EPS_Mounts_UpdatePurchasedMounts")
			if istable(EPS_PurchasedMounts[self:SteamID64()]) then
				net.WriteTable(EPS_PurchasedMounts[self:SteamID64()])
			else
				net.WriteTable({})
			end
		net.Send(self)
	end)
end

function plyMeta:EPS_CanPurchaseMount(mount)
	local mount = EPS_Mounts_Config.Mounts[mount]

	if self:EPS_IsMountPurchased(mount) then
		return false, "You already own this Mount."
	end

	if not self:canAfford(mount.Price) then
		return false, "You cannot afford this."
	end

	if not table.IsEmpty(mount.Jobs) and not mount.Jobs[team.GetName(self:Team())] then
		return false, "You are not the appropriate Job to purchase / spawn this!"
	end

	return true
end

function plyMeta:EPS_CanSpawnMount(mount, hangar)
	local mountlist = EPS_Mounts_Config.Mounts[mount]
	local hangarlist = EPS_Mounts_Config.SpawnPositions[hangar]

	if IsValid(self.CurrentMount) then
		return false, "You already have a current Vehicle."
	end

	if hangarlist.Map ~= game.GetMap() then
		return false, "Not the right Map."
	end

	if EPS_Mounts:IsHangarOccupied(hangar) then
		return false, "This Hangar is occupied."
	end

	if not self:EPS_IsMountPurchased(mount) then
		return false, "You do not own this Mount!"
	end

	if not table.IsEmpty(mountlist.Jobs) and not mountlist.Jobs[team.GetName(self:Team())] then
		return false, "You are not the appropriate Job to spawn this Mount!"
	end

	return true
end