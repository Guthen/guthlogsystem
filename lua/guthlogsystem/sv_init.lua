guthlogsystem = guthlogsystem or {}
guthlogsystem.categories = {}

util.AddNetworkString( "guthlogsystem:network" )

--  >

function guthlogsystem.addCategory( name, color )
    if not isstring( name ) or not IsColor( color ) then print( "nop2: " .. name ) return false end
    if guthlogsystem.categories[name] then return false end

    local t = { name = name, color = color, logs = {} }

    guthlogsystem.categories[name] = t
    guthlogsystem.network( t, false )

    return true
end

function guthlogsystem.addLog( category, log )
    if not isstring( category ) or not isstring( log ) then return false end
    if not guthlogsystem.categories[category] then return false end

    local t = { category = category, time = os.time(), msg = log }

    table.insert( guthlogsystem.categories[category].logs, t )
    guthlogsystem.network( t, true )

    return true
end

--  >

function guthlogsystem.network( t, isLog, isCats )
    local data = util.Compress( util.TableToJSON( t ) )
    net.Start( "guthlogsystem:network" )
        net.WriteData( data, #data )
        net.WriteBool( isLog or false )
        net.WriteBool( isCats or false )
    net.Broadcast()
end


--  >

hook.Add( "InitPostEntity", "guthlogsystem:hooks", function()
    include( "guthlogsystem/sv_hooks.lua" )
    guthlogsystem.load()
end )

--  > Send logs on first spawn
hook.Add( "PlayerInitialSpawn", "guthlogsystem:categories", function( ply )
    timer.Simple( 0, function()
        guthlogsystem.network( guthlogsystem.categories, false, true )
    end )
end )

function guthlogsystem.load( cat )
    if cat then
        if not guthlogsystem.categories[cat] then return end

        local t = string.gsub( cat, " ", "_" ):lower()
            t = string.gsub( t, "/", "_" )

        local result = sql.Query( "CREATE TABLE guthlogsystem_" .. t .. "( Log TEXT, Time INTEGER )" )
        if result == false then return print( "guthlogsystem - SQL ERROR ON CATEGORY : " .. sql.LastError() ) end
        return
    end

    local good = false
    for k, v in pairs( guthlogsystem.categories ) do
        local t = string.gsub( v.name, " ", "_" ):lower()
            t = string.gsub( t, "/", "_" )
        if not sql.TableExists( "guthlogsystem_" .. t ) then continue end

        local result = sql.Query( "SELECT * FROM guthlogsystem_" .. t )
        if result == false then return print( "guthlogsystem - SQL ERROR ON LOAD : " .. sql.LastError() ) end

        if istable( result ) then
            for _, lv in pairs( result ) do
                local _t = { category = k, time = tonumber( lv.Time ), msg = lv.Log }
                table.insert( v.logs, _t )
            end
            good = true
        end
    end
    if good then print( "guthlogsystem - SQL Table has been loaded" ) end
end

function guthlogsystem.save()
    guthlogsystem.delete() -- delete before adding every logs

    for _, v in pairs( guthlogsystem.categories ) do
        local t = string.gsub( v.name, " ", "_" ):lower()
            t = string.gsub( t, "/", "_" )
        if not sql.TableExists( "guthlogsystem_" .. t ) then guthlogsystem.load( v.name ) end

        for _, lv in ipairs( v.logs ) do
            local format = ("INSERT INTO guthlogsystem_%s( Log, Time ) VALUES ( %s, %d )"):format( t, sql.SQLStr( lv.msg ), lv.time )
            local result = sql.Query( format )
            if result == false then return print( "guthlogsystem - SQL ERROR ON SAVE : " .. sql.LastError() ) end
        end
    end
    print( "guthlogsystem - Saved into SQL Database" )
end

function guthlogsystem.delete()
    local i = 0
    for _, v in pairs( guthlogsystem.categories ) do
        local t = string.gsub( v.name, " ", "_" ):lower()
            t = string.gsub( t, "/", "_" )
        if not sql.TableExists( "guthlogsystem_" .. t ) then continue end

        local result = sql.Query( "DROP TABLE guthlogsystem_" .. t )
        if result == false then return print( "guthlogsystem - SQL ERROR ON DELETE : " .. sql.LastError() ) end

        i = i + 1
    end

    print( "guthlogsystem - Deleted from SQL Database (" .. i .. ")" )
end

hook.Add( "ShutDown", "guthlogsystem:save", guthlogsystem.save )
timer.Create( "guthlogsystem:save", 5*60, 0, guthlogsystem.save )
