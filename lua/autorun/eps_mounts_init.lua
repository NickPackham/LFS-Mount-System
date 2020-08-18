if SERVER then
	include("eps_mounts/config.lua")
	include("eps_mounts/server/eps_mounts_db_sv.lua")
	include("eps_mounts/server/eps_mounts_functions_sv.lua")
	include("eps_mounts/server/eps_mounts_main_sv.lua")
	include("eps_mounts/server/eps_mounts_net_sv.lua")

	AddCSLuaFile("eps_mounts/client/eps_mounts_main_cl.lua")
	AddCSLuaFile("eps_mounts/client/eps_mounts_functions_cl.lua")
	AddCSLuaFile("eps_mounts/client/eps_mounts_net_cl.lua")

	AddCSLuaFile("eps_mounts/config.lua")
else
	include("eps_mounts/config.lua")

	include("eps_mounts/client/eps_mounts_main_cl.lua")
	include("eps_mounts/client/eps_mounts_functions_cl.lua")
	include("eps_mounts/client/eps_mounts_net_cl.lua")
end
