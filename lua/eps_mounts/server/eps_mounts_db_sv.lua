if EPS_Mounts_Config.Mysqloo then

    local MySqloo = require("mysqloo")

    EPS_MountSys = mysqloo.connect(EPS_Mounts_Config.Database.Host, EPS_Mounts_Config.Database.Username, EPS_Mounts_Config.Database.Password, EPS_Mounts_Config.Database.Name, EPS_Mounts_Config.Database.Port)

    --[[

    		Connect to the Database.

    --]]

    local function ConnectToDatabase()
        EPS_MountSys.onConnected = function()
            print("[" .. EPS_Mounts_Config.Prefix .. "] Connected to the Database!")
        end

        EPS_MountSys.onConnectionFailed = function(db, msg)
            print("[" .. EPS_Mounts_Config.Prefix .. "] Failed to Connect to the Database!")
        end

        EPS_MountSys:connect()
    end

    --[[

    		Check the Connection.

    --]]

    local function CheckConnectionToDatabase()
        if EPS_MountSys:status() ~= mysqloo.DATABASE_CONNECTED then
            ConnectToDatabase()
        end
    end

    timer.Create("EPS_MountSys_CheckDBConnection", 5, 0, function()
        CheckConnectionToDatabase()
    end)

    --[[

    		Connect to the Database on Initialization

    	--]]
    hook.Add("Initialize", "EPS_Init_StartMountSysDB", function()
        ConnectToDatabase()

        local createtable = EPS_MountSys:query("CREATE TABLE IF NOT EXISTS eps_mountsys(SteamID TEXT, Mount TEXT, PurchaseTime TEXT)")
        createtable:start()
    end)
else
    hook.Add("Initialize", "EPS_Init_StartMountSysDB", function()
        local quer = "CREATE TABLE IF NOT EXISTS eps_mountsys(SteamID TEXT, Mount TEXT, PurchaseTime TEXT)"

        local finish = sql.Query(quer)
    end)
end