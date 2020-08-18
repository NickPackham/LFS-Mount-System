EPS_Mounts_Config = {}

EPS_Mounts_Config.Prefix = "Mounts"

EPS_Mounts_Config.NPCModels = {"models/player/ishtari/ct_arf/ct_arf.mdl"}
EPS_Mounts_Config.NPCStances = {"pose_standing_01", "pose_standing_02", "idle_all_01", "idle_all_02"}

EPS_Mounts_Config.PrefixColor = Color(255,0,0)

EPS_Mounts_Config.Mysqloo = false

EPS_Mounts_Config.Database = {
    Host = "",
    Port = 3306,
    Name = "",
    Username = "",
    Password = "",
}

EPS_Mounts_Config.Mounts = {
	["lunasflightschool_niksacokica_at-rt"] = {
		Name = "AT-RT",
		Price = 2000000,
		Description = "AT-RT",
		Jobs = {
		},
	},
	["lunasflightschool_niksacokica_barc"] = {
		Name = "Barc Speeder",
		Description = "Barc Speeder thing",

		Price = 200,

		Jobs = {
			["Citizen"] = true,
		},
	},
	["ranz_lfs_landspeeder"] = {
		Name = "Landspeeder",
		Description = "Land Speeder thing from the movies.",

		Price = 200,

		Jobs = {
		},
	},
}

EPS_Mounts_Config.SpawnPositions = {
	["Vehicle Bay One"] = {
		Position = Vector(-320.307129, 430.434479, -12287.968750),
		Angle = Angle(14.552097, -107.535988, 0.000000),
		Map = "gm_flatgrass",
	},
}