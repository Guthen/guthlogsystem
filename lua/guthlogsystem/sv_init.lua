guthlogsystem = guthlogsystem or {}
guthlogsystem.categories = guthlogsystem.categories or {}

util.AddNetworkString( "guthlogsystem:network" )

--  > Add logs/categories
function guthlogsystem.addCategory( name, color )
    if not isstring( name ) or not IsColor( color ) then return false end
    --if guthlogsystem.categories[name] then return false end

    local t = { name = name, color = color }
    guthlogsystem.categories[name] = t

    return function( log )
        return guthlogsystem.addLog( name, log )
    end
end

function guthlogsystem.addLog( category, log )
    if not isstring( category ) or not isstring( log ) then return false end
    if not guthlogsystem.categories[category] then return false end

    local query = ( "INSERT INTO guthlogsystem_logs ( log, category, time ) VALUES ( %s, %s, %d )" ):format( SQLStr( log ), SQLStr( category ), os.time() )
    return sql.Query( query ) == nil and true or false
end

--  > Network
function guthlogsystem.networkCategories( ply )
    local data = util.Compress( util.TableToJSON( guthlogsystem.categories ) )

    net.Start( "guthlogsystem:network" )
        net.WriteBool( false )
        net.WriteUInt( 1, guthlogsystem.config.maxPagesInBits )
        net.WriteData( data, #data )
    net.Send( ply )

    print( "guthlogsystem - Sent categories to " .. ply:GetName() )
end
hook.Add( "PlayerInitialSpawn", "guthlogsystem:categories", function( ply )
    timer.Simple( 0, function()
        guthlogsystem.networkCategories( ply )
    end )
end )

net.Receive( "guthlogsystem:network", function( len, ply )
    if not guthlogsystem.config.accessRanks[ply:GetUserGroup()] then return end

    --  > Read data
    local page = net.ReadUInt( guthlogsystem.config.maxPagesInBits )
    local category_name = net.ReadString()
    local escaped_category_name = SQLStr( category_name )

    --  > Fetch logs
    local logs = sql.Query( ( "SELECT * FROM guthlogsystem_logs WHERE category = %s ORDER BY time DESC LIMIT %d OFFSET %d" ):format( escaped_category_name, guthlogsystem.config.logsPerPage, ( page - 1 ) * guthlogsystem.config.logsPerPage ) )
    if not logs then
        net.Start( "guthlogsystem:network" )
            net.WriteBool( true )
            net.WriteUInt( 0, guthlogsystem.config.maxPagesInBits )
        net.Send( ply )
        return 
    end

    --  > Count logs
    local count = select( 2, next( sql.Query( ( "SELECT COUNT( * ) FROM guthlogsystem_logs WHERE category = %s" ):format( escaped_category_name ) )[1] ) )

    --  > Remove useless params
    for i, v in ipairs( logs ) do
        v.category = nil
        v.id = nil
    end

    --  > Send logs
    local data = util.Compress( util.TableToJSON( logs ) )
    net.Start( "guthlogsystem:network" )
        net.WriteBool( true )
        net.WriteUInt( math.ceil( count / guthlogsystem.config.logsPerPage ), guthlogsystem.config.maxPagesInBits )
        net.WriteData( data, #data )
    net.Send( ply )
end )

--  > Clean-Up
concommand.Add( "guthlogsystem_delete_logs", function( ply, cmd, args )
    --  > Security
    if not ( args[1] == "yes" ) then
        return print( "guthlogsystem - Are you sure to do this command? This command deletes all logs from the database. If you are sure, enter 'guthlogsystem_delete_logs yes'." )
    end

    --  > Delete all logs
    if sql.Query( "DELETE FROM `guthlogsystem_logs` WHERE time > 0" ) then
        print( "guthlogsystem - All logs have been erased" )
    else
        print( "guthlogsystem - Failed : " .. sql.LastError() )
    end
end )

--  > Initialization
hook.Add( "InitPostEntity", "guthlogsystem:hooks", function()
    sql.Query( "CREATE TABLE IF NOT EXISTS guthlogsystem_logs ( id INTEGER PRIMARY KEY AUTOINCREMENT, category TEXT NOT NULL, log TEXT NOT NULL, time INTEGER NOT NULL )" )

    include( "guthlogsystem/sv_hooks.lua" )
    --guthlogsystem.load()
end )

print( "guthlogsystem - 'sv_init.lua' loaded" )
