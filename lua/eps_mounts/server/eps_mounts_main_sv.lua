hook.Add("EPS_PlayerReadyForNetworking", "EPS_Mounts_ReadyForNetworking", function(ply)
	ply:EPS_UpdatePurchasedMounts()
end)