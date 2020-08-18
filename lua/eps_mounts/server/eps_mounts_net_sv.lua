util.AddNetworkString("EPS_OpenMountMenu")
util.AddNetworkString("EPS_PurchaseMount")
util.AddNetworkString("EPS_SpawnMount")
util.AddNetworkString("EPS_ReturnMount")
util.AddNetworkString("EPS_Mounts_UpdatePurchasedMounts")

net.Receive("EPS_PurchaseMount", function(len, ply)
	local mount = net.ReadString()
	local mount_info = EPS_Mounts_Config.Mounts[mount]
	local canbuy, message = ply:EPS_CanPurchaseMount(mount)

	if canbuy then
		ply:EPS_PurchaseMount(mount, function(success)
			if success then
				ply:EPS_UpdatePurchasedMounts()
				ply:addMoney(-mount_info.Price)

				ply:EPS_AddText(EPS_Mounts_Config.PrefixColor, "["..EPS_Mounts_Config.Prefix.."] ", Color(255,255,255), "You've purchased the "..mount_info.Name.." Mount.")
			else
				ply:EPS_AddText(EPS_Mounts_Config.PrefixColor, "["..EPS_Mounts_Config.Prefix.."] ", Color(255,255,255), "There's been a problem while purchasing this Mount.")
			end
		end)
	else
		ply:EPS_AddText(EPS_Mounts_Config.PrefixColor, "["..EPS_Mounts_Config.Prefix.."] ", Color(255,255,255), message)
	end
end)

net.Receive("EPS_SpawnMount", function(len, ply)
	local mount = net.ReadString()
	local hangar = net.ReadString()

	local canspawn, message = ply:EPS_CanSpawnMount(mount, hangar)

	if canspawn then
		local vehicle = ents.Create(mount)

		if not IsValid(vehicle) then
			ply:EPS_AddText(EPS_Mounts_Config.PrefixColor, "["..EPS_Mounts_Config.Prefix.."] ", Color(255,255,255), "Invalid Vehicle")
			return
		end

		vehicle:SetPos(Vector(EPS_Mounts_Config.SpawnPositions[hangar].Position))
		vehicle:SetAngles(Angle(EPS_Mounts_Config.SpawnPositions[hangar].Angle))
		vehicle:Spawn()
		vehicle.MountOwner = ply

		ply:EPS_AddText(EPS_Mounts_Config.PrefixColor, "["..EPS_Mounts_Config.Prefix.."] ", Color(255,255,255), "You've spawned the "..EPS_Mounts_Config.Mounts[mount].Name.." Mount at "..hangar..".")
		ply.CurrentMount = vehicle
	else
		ply:EPS_AddText(EPS_Mounts_Config.PrefixColor, "["..EPS_Mounts_Config.Prefix.."] ", Color(255,255,255), message)
	end
end)

net.Receive("EPS_ReturnMount", function(len, ply)
	if IsValid(ply.CurrentMount) then
		ply.CurrentMount:Remove()

		ply:EPS_AddText(EPS_Mounts_Config.PrefixColor, "["..EPS_Mounts_Config.Prefix.."] ", Color(255,255,255), "You've returned your current Mount.")
	else
		ply:EPS_AddText(EPS_Mounts_Config.PrefixColor, "["..EPS_Mounts_Config.Prefix.."] ", Color(255,255,255), "You don't have a current Mount.")
	end
end)

hook.Add("CanPlayerEnterVehicle", "EPS_CanEnterMount", function(ply, veh)
	if IsValid(veh:GetParent().MountOwner) then
		if veh:GetParent().MountOwner == ply then
			ply:EPS_AddText(EPS_Mounts_Config.PrefixColor, "["..EPS_Mounts_Config.Prefix.."] ", Color(255,255,255), "You cannot access this Vehicle, it is owned by "..veh:GetParent().MountOwner:Name()..".")
			return false
		end
	end
end)