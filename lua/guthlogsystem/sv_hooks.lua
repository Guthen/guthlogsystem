
--  > Player Logs
local color = Color( 52, 152, 219 )

--  > Say
local log = guthlogsystem.addCategory( "Player Say", color )
hook.Add( "PlayerSay", "guthlogsystem:log", function( ply, txt, teamChat )
    log( ( "*%s* (%s) say &%s& %s" ):format( ply:GetName(), ply:SteamID(), string.gsub( txt, "&", "" ), teamChat and " in ?Team Chat?" or "" ) )
end )

--  > Spawns/Deaths
local log = guthlogsystem.addCategory( "Player Spawns/Deaths", color )
hook.Add( "PlayerInitialSpawn", "guthlogsystem:log", function( ply )
    log( ( "*%s* (%s) first spawn" ):format( ply:GetName(), ply:SteamID() ) )
end )

hook.Add( "PlayerSpawn", "guthlogsystem:log", function( ply )
    log( ( "*%s* (%s) spawn" ):format( ply:GetName(), ply:SteamID() ) )
end )

hook.Add( "PlayerDeath", "guthlogsystem:log", function( ply, inf, atk )
    local _inf = IsValid( inf ) and "using &" .. inf:GetClass() .. "&" or ""
    local _atk = not IsValid( atk ) and "NULL" or atk:IsPlayer() and atk:GetName() or atk:GetClass()

    log( ( "*%s* (%s) die by ?%s? %s" ):format( ply:GetName(), ply:SteamID(), _atk, _inf ) )
end )

--  > Hurt
local log = guthlogsystem.addCategory( "Player Hurt", color )
hook.Add( "PlayerHurt", "guthlogsystem:log", function( ply, atk, hp, dmg )
    local _atk = atk:IsPlayer() and atk:GetName() or atk:GetClass()
    log( ( "*%s* (%s) toke &%d& damage from ?%s? and left !%s! HP" ):format( ply:GetName(), ply:SteamID(), dmg, _atk, hp ) )
end )

--  > Connect/Disconnect
local log = guthlogsystem.addCategory( "Player Connect/Disconnect", color )

gameevent.Listen( "player_connect_client" )
hook.Add( "player_connect_client", "guthlogsystem:log", function( _, id, name, _, _, ip )
    log( ( "*%s* (%s) is connecting with ip : &%s&" ):format( name, id, ip ) )
end )

hook.Add( "PlayerAuthed", "guthlogsystem:log", function( ply, steamid )
    log( ( "*%s* is authed as &%s&" ):format( ply:GetName(), steamid ) )
end )

gameevent.Listen( "player_disconnect" )
hook.Add( "player_disconnect", "guthlogsystem:log", function( _, id, name, _, reason )
    log( ( "*%s* (%s) is disconnecting for &%s&" ):format( name, id, reason ) )
end )

--  > Vehicle
local log = guthlogsystem.addCategory( "Player Vehicle", color )
hook.Add( "PlayerEnteredVehicle", "guthlogsystem:log", function( ply, veh )
    local class = veh.GetVehicleClass and veh:GetVehicleClass() or veh:GetClass()
    log( ( "*%s* (%s) has entered in ?%s?" ):format( ply:GetName(), ply:SteamID(), class ) )
end )

hook.Add( "PlayerLeaveVehicle", "guthlogsystem:log", function( ply, veh )
    local class = veh.GetVehicleClass and veh:GetVehicleClass() or veh:GetClass()
    log( ( "*%s* (%s) has left of ?%s?" ):format( ply:GetName(), ply:SteamID(), class ) )
end )

--  > Sandbox Logs
if GAMEMODE.IsSandboxDerived then

    local log = guthlogsystem.addCategory( "Player Spawned Entities", color )
    hook.Add( "PlayerSpawnedProp", "guthlogsystem:log", function( ply, _, ent )
        log( ( "*%s* (%s) has spawned ?%s? : &%s&" ):format( ply:GetName(), ply:SteamID(), ent:GetClass(), ent:GetModel() ) )
    end )

    hook.Add( "PlayerSpawnedRagdoll", "guthlogsystem:log", function( ply, _, ent )
        log( ( "*%s* (%s) has spawned ?%s? : &%s&" ):format( ply:GetName(), ply:SteamID(), ent:GetClass(), ent:GetModel() ) )
    end )

    hook.Add( "PlayerSpawnedVehicle", "guthlogsystem:log", function( ply, ent )
        local class = ent.GetVehicleClass and ent:GetVehicleClass() or ent:GetClass() -- check if func exists cause of SCars
        log( ( "*%s* (%s) has spawned ?%s? : &%s&" ):format( ply:GetName(), ply:SteamID(), class, ent:GetModel() ) )
    end )

    hook.Add( "PlayerSpawnedNPC", "guthlogsystem:log", function( ply, ent )
        log( ( "*%s* (%s) has spawned ?%s?" ):format( ply:GetName(), ply:SteamID(), ent:GetClass() ) )
    end )

    hook.Add( "PlayerSpawnedSENT", "guthlogsystem:log", function( ply, ent )
        log( ( "*%s* (%s) has spawned ?%s?" ):format( ply:GetName(), ply:SteamID(), ent:GetClass() ) )
    end )

    hook.Add( "PlayerSpawnedSWEP", "guthlogsystem:log", function( ply, ent )
        log( ( "*%s* (%s) has spawned ?%s?" ):format( ply:GetName(), ply:SteamID(), ent:GetClass() ) )
    end )

    hook.Add( "PlayerGiveSWEP", "guthlogsystem:log", function( ply, class )
        log( ( "*%s* (%s) has given ?%s?" ):format( ply:GetName(), ply:SteamID(), class ) )
    end )

end

--  > Entities Logs

-- guthlogsystem.addCategory( "Entity Created/Removed", Color( 155, 89, 182 ) )
-- guthlogsystem.addCategory( "Entity Sound", Color( 155, 89, 182 ) )
--
-- hook.Add( "OnEntityCreated", "guthlogsystem:log", function( ent )
--     log( ( "?%s? has been created", ent:GetClass() ) )
-- end )
-- hook.Add( "EntityRemoved", "guthlogsystem:log", function( ent )
--     log( ( "?%s? has been removed", ent:GetClass() ) )
-- end )
-- hook.Add( "EntityEmitSound", "guthlogsystem:log", function( data )
--     local ent = data.Entity
--         ent = ent:IsPlayer() and ent:GetName() or ent:GetClass()
--     log( ( "?%s? has played : ~%s~", ent, data.SoundName ) )
-- end )

--  > Server Logs
local log = guthlogsystem.addCategory( "Server General", Color( 230, 126, 34 ) )
hook.Add( "PostCleanupMap", "guthlogsystem:log", function()
    log( "Map has been clean up" )
end )

hook.Add( "ShutDown", "guthlogsystem:log", function()
    log( "Server is shutting down" )
end )

hook.Add( "InitPostEntity", "guthlogsystem:log", function()
    log( "Server is up" )
end )

--  > DarkRP Logs
if DarkRP then

    local color = Color( 231, 76, 60 )

    --  > Name
    local log = guthlogsystem.addCategory( "DarkRP Name", color )
    hook.Add( "onPlayerChangedName", "guthlogsystem:log", function( ply, old, new )
        log( ( "*%s* (%s) has changed his name to ~%s~" ):format( old, ply:SteamID(), new ) )
    end )

    --  > Laws
    local log = guthlogsystem.addCategory( "DarkRP Laws", color )
    hook.Add( "addLaw", "guthlogsystem:log", function( n, law )
        log( ( "Law &%d& has been added : ~%s~" ):format( n, law ) )
    end )

    hook.Add( "removeLaw", "guthlogsystem:log", function( n, law )
        log( ( "Law &%d& has been removed : ~%s~" ):format( n, law ) )
    end )

    hook.Add( "resetLaws", "guthlogsystem:log", function( ply )
        log( ( "Laws has been reseted by *%s*" ):format( ply:GetName() ) )
    end )

    --  > Lottery
    local log = guthlogsystem.addCategory( "DarkRP Lottery", color )
    hook.Add( "lotteryStarted", "guthlogsystem:log", function( ply, price )
        log( ( "Lottery with &%d&$ to pay has been started by *%s* (%s)" ):format( price, ply:GetName(), ply:SteamID() ) )
    end )

    hook.Add( "lotteryEnded", "guthlogsystem:log", function( ptp, ply, money )
        log( ( "Lottery with &%d& participants has ended and *%s* (%s) won ~%d~$" ):format( #ptp, ply:GetName(), ply:SteamID(), money ) )
    end )

    hook.Add( "playerEnteredLottery", "guthlogsystem:log", function( ply )
        log( ( "*%s* (%s) entered in the current lottery" ):format( ply:GetName(), ply:SteamID() ) )
    end )

    --  > Teams
    local log = guthlogsystem.addCategory( "DarkRP Teams", color )
    hook.Add( "OnPlayerChangedTeam", "guthlogsystem:log", function( ply, old, new )
        log( ( "*%s* (%s) get from &%s& to ~%s~" ):format( ply:GetName(), ply:SteamID(), team.GetName( old ), team.GetName( new ) ) )
    end )

    hook.Add( "demoteTeam", "guthlogsystem:log", function( ply )
        log( ( "*%s* (%s) has been demoted" ):format( ply:GetName(), ply:SteamID() ) )
    end )

    --  > Hitman
    local log = guthlogsystem.addCategory( "DarkRP Hitman", color )
    hook.Add( "onHitAccepted", "guthlogsystem:log", function( hit, trg, buy )
        log( ( "*%s* has accepted to kill *%s*, ordered by *%s*" ):format( hit:GetName(), trg:GetName(), buy:GetName() ) )
    end )

    hook.Add( "onHitCompleted", "guthlogsystem:log", function( hit, trg, buy )
        log( ( "*%s* has killed *%s*, ordered by *%s*" ):format( hit:GetName(), trg:GetName(), buy:GetName() ) )
    end )

    hook.Add( "onHitCompleted", "guthlogsystem:log", function( hit, trg, reason )
        log( ( "*%s* has failed to kill *%s* : *%s*" ):format( hit:GetName(), trg:GetName(), reason ) )
    end )

    --  > Doors
    local log = guthlogsystem.addCategory( "DarkRP Doors", color )
    hook.Add( "lockpickStarted", "guthlogsystem:log", function( ply, ent )
        local _ent = ent.GetVehicleClass and ent:GetVehicleClass() or ent:GetClass()
        log( ( "*%s* has started to lockpick ?%s?" ):format( ply:GetName(), _ent ) )
    end )

    hook.Add( "onLockpickCompleted", "guthlogsystem:log", function( ply, bool, ent )
        local _ent = ent.GetVehicleClass and ent:GetVehicleClass() or ent:GetClass()
        local lockpick = bool and "lockpicked" or "failed to lockpick"
        log( ( "*%s* has %s ?%s?" ):format( ply:GetName(), lockpick, _ent ) )
    end )

    hook.Add( "onHitCompleted", "guthlogsystem:log", function( hit, trg, reason )
        log( ( "*%s* has failed to kill *%s* : *%s*" ):format( hit:GetName(), trg:GetName(), reason ) )
    end )

    --  > Money
    local log = guthlogsystem.addCategory( "DarkRP Money", color )
    hook.Add( "playerGaveMoney", "guthlogsystem:log", function( ply, trg, amount )
        log( ( "*%s* (%s) has given &%d&$ to *%s*" ):format( ply:GetName(), ply:SteamID(), amount, trg:GetName() ) )
    end )

    hook.Add( "playerDroppedMoney", "guthlogsystem:log", function( ply, amount )
        log( ( "*%s* (%s) has dropped &%d&$" ):format( ply:GetName(), ply:SteamID(), amount ) )
    end )

    hook.Add( "playerDroppedCheque", "guthlogsystem:log", function( ply, trg, amount )
        log( ( "*%s* (%s) has dropped a cheque to *%s* of &%d&$" ):format( ply:GetName(), ply:SteamID(), trg:GetName(), amount ) )
    end )

    hook.Add( "playerPickedUpMoney", "guthlogsystem:log", function( ply, amount )
        log( ( "*%s* (%s) has picked up &%d&$" ):format( ply:GetName(), ply:SteamID(), amount ) )
    end )

    hook.Add( "playerPickedUpCheque", "guthlogsystem:log", function( ply, trg, amount, bool )
        local pick = bool and "succesfully picked" or "failed to pick"
        log( ( "*%s* (%s) has %s up a cheque to *%s* of &%d&$" ):format( ply:GetName(), ply:SteamID(), pick, trg:GetName(), amount ) )
    end )

    hook.Add( "playerGetSalary", "guthlogsystem:log", function( ply, amount )
        log( ( "*%s* (%s) has got his salary of &%d&$ as ~%s~" ):format( ply:GetName(), ply:SteamID(), amount, team.GetName( ply:Team() ) ) )
    end )

    hook.Add( "onPropertyTax", "guthlogsystem:log", function( ply, tax )
        log( ( "*%s* (%s) has paid &%d&$ of tax" ):format( ply:GetName(), ply:SteamID(), amount ) )
    end )

end

if ULib then

    local color = Color( 46, 204, 113 )
    
    --  > Groups
    local log = guthlogsystem.addCategory( "ULib Groups", color )
    hook.Add( "ULibGroupRenamed", "guthlogsystem:log", function( old, new )
        log( ( "&%s& has been renamed as ~%s~" ):format( old, new ) )
    end )

    hook.Add( "ULibGroupInheritanceChanged", "guthlogsystem:log", function( group, new, old )
        log( ( "&%s&'s inheritance changed from !%s! to ~%s~" ):format( group, old, new ) )
    end )

    hook.Add( "ULibGroupCanTargetChanged", "guthlogsystem:log", function( group, new, old )
        local msg = old == nil and "" or "from !" .. old .. "!"
        log( ( "&%s&'s target changed %s to ~%s~" ):format( group, msg, new ) )
    end )

    hook.Add( "ULibGroupAccessChanged", "guthlogsystem:log", function( group, access, bool )
        local msg = bool == true and "revoking" or "adding"
        log( ( "&%s& has been %s from !%s! access" ):format( group, msg, access[1] ) )
    end )

    hook.Add( "ULibGroupCreated", "guthlogsystem:log", function( group )
        log( ( "&%s& has been created" ):format( group ) )
    end )

    hook.Add( "ULibGroupRemoved", "guthlogsystem:log", function( group )
        log( ( "&%s& has been removed" ):format( group ) )
    end )

    --  > Ban and Kick
    local log = guthlogsystem.addCategory( "ULib Ban/Kick", color )
    hook.Add( "ULibPlayerKicked", "guthlogsystem:log", function( id, reason, ply )
        local msg = ply and "by *" .. ply:GetName() .. "*" or ""
        log( ( "&%s& has been kicked for ~%s~ %s" ):format( id, reason, msg ) )
    end )

    hook.Add( "ULibPlayerBanned", "guthlogsystem:log", function( id, data )
        local msg = data.admin and "by " .. data.admin:GetName() or ""
        log( ( "&%s& has been banned for !%s! for ~%d~ %s" ):format( id, data.reason, data.time, msg ) )
    end )

    hook.Add( "ULibPlayerUnBanned", "guthlogsystem:log", function( id, admin )
        local msg = admin and "by " .. admin:GetName() or ""
        log( ( "&%s& has been unbanned %s" ):format( id, msg ) )
    end )

    --  > Users
    local log = guthlogsystem.addCategory( "ULib Users", Color( 46, 204, 113 ) )
    hook.Add( "ULibUserGroupChange", "guthlogsystem:log", function( id, _, _, old, new )
        log( ( "&%s&'s group changed from ~%s~ to !%s!" ):format( id, old, new ) )
    end )
    
end

print( "guthlogsystem - 'sv_hooks.lua' loaded" )
