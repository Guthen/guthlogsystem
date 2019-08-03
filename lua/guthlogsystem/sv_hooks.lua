
--  > Player Logs
guthlogsystem.addCategory( "Player Say", Color( 52, 152, 219 ) )
guthlogsystem.addCategory( "Player Hurt", Color( 52, 152, 219 ) )
guthlogsystem.addCategory( "Player Spawns/Deaths", Color( 52, 152, 219 ) )
guthlogsystem.addCategory( "Player Connect/Disconnect", Color( 52, 152, 219 ) )
guthlogsystem.addCategory( "Player Vehicle", Color( 52, 152, 219 ) )

--  > Say

hook.Add( "PlayerSay", "guthlogsystem:log", function( ply, txt, teamChat )
    guthlogsystem.addLog( "Player Say", string.format( "*%s* (%s) say &%s& %s", ply:GetName(), ply:SteamID(), string.gsub( txt, "&", "" ), teamChat and " in ?Team Chat?" or "" ) )
end )

--  > Spawns/Deaths

hook.Add( "PlayerInitialSpawn", "guthlogsystem:log", function( ply )
    guthlogsystem.addLog( "Player Spawns/Deaths", string.format( "*%s* (%s) first spawn", ply:GetName(), ply:SteamID() ) )
end )

hook.Add( "PlayerSpawn", "guthlogsystem:log", function( ply )
    guthlogsystem.addLog( "Player Spawns/Deaths", string.format( "*%s* (%s) spawn", ply:GetName(), ply:SteamID() ) )
end )

hook.Add( "PlayerDeath", "guthlogsystem:log", function( ply, inf, atk )
    local _inf = IsValid( inf ) and "using &" .. inf:GetClass() .. "&" or ""
    local _atk = atk:IsPlayer() and atk:GetName() or atk:GetClass()

    guthlogsystem.addLog( "Player Spawns/Deaths", string.format( "*%s* (%s) die by ?%s? %s", ply:GetName(), ply:SteamID(), _atk, _inf ) )
end )

--  > Hurt

hook.Add( "PlayerHurt", "guthlogsystem:log", function( ply, atk, hp, dmg )
    local _atk = atk:IsPlayer() and atk:GetName() or atk:GetClass()
    guthlogsystem.addLog( "Player Hurt", string.format( "*%s* (%s) toke &%d& damage from ?%s? and left !%s! HP", ply:GetName(), ply:SteamID(), dmg, _atk, hp ) )
end )

--  > Connect/Disconnect

gameevent.Listen( "player_connect_client" )
hook.Add( "player_connect_client", "guthlogsystem:log", function( _, id, name, _, _, ip )
    guthlogsystem.addLog( "Player Connect/Disconnect", string.format( "*%s* (%s) is connecting with ip : &%s&", name, id, ip ) )
end )
hook.Add( "PlayerAuthed", "guthlogsystem:log", function( ply, steamid )
    guthlogsystem.addLog( "Player Connect/Disconnect", string.format( "*%s* is authed as &%s&", ply:GetName(), steamid ) )
end )
gameevent.Listen( "player_disconnect" )
hook.Add( "player_disconnect", "guthlogsystem:log", function( _, id, name, _, reason )
    guthlogsystem.addLog( "Player Connect/Disconnect", string.format( "*%s* (%s) is disconnecting for &%s&", name, id, reason ) )
end )

--  > Vehicle

hook.Add( "PlayerEnteredVehicle", "guthlogsystem:log", function( ply, veh )
    local class = veh.GetVehicleClass and veh:GetVehicleClass() or veh:GetClass()
    guthlogsystem.addLog( "Player Vehicle", string.format( "*%s* (%s) has entered in ?%s?", ply:GetName(), ply:SteamID(), class ) )
end )
hook.Add( "PlayerLeaveVehicle", "guthlogsystem:log", function( ply, veh )
    local class = veh.GetVehicleClass and veh:GetVehicleClass() or veh:GetClass()
    guthlogsystem.addLog( "Player Vehicle", string.format( "*%s* (%s) has left of ?%s?", ply:GetName(), ply:SteamID(), class ) )
end )

--  > Spawned Entities // SANDBOX

if GAMEMODE.IsSandboxDerived then
    guthlogsystem.addCategory( "Player Spawned Entities", Color( 52, 152, 219 ) )

    hook.Add( "PlayerSpawnedProp", "guthlogsystem:log", function( ply, _, ent )
        guthlogsystem.addLog( "Player Spawned Entities", string.format( "*%s* (%s) has spawned ?%s? : &%s&", ply:GetName(), ply:SteamID(), ent:GetClass(), ent:GetModel() ) )
    end )
    hook.Add( "PlayerSpawnedRagdoll", "guthlogsystem:log", function( ply, _, ent )
        guthlogsystem.addLog( "Player Spawned Entities", string.format( "*%s* (%s) has spawned ?%s? : &%s&", ply:GetName(), ply:SteamID(), ent:GetClass(), ent:GetModel() ) )
    end )
    hook.Add( "PlayerSpawnedVehicle", "guthlogsystem:log", function( ply, ent )
        local class = ent.GetVehicleClass and ent:GetVehicleClass() or ent:GetClass() -- check if func exists cause of SCars
        guthlogsystem.addLog( "Player Spawned Entities", string.format( "*%s* (%s) has spawned ?%s? : &%s&", ply:GetName(), ply:SteamID(), class, ent:GetModel() ) )
    end )
    hook.Add( "PlayerSpawnedNPC", "guthlogsystem:log", function( ply, ent )
        guthlogsystem.addLog( "Player Spawned Entities", string.format( "*%s* (%s) has spawned ?%s?", ply:GetName(), ply:SteamID(), ent:GetClass() ) )
    end )
    hook.Add( "PlayerSpawnedSENT", "guthlogsystem:log", function( ply, ent )
        guthlogsystem.addLog( "Player Spawned Entities", string.format( "*%s* (%s) has spawned ?%s?", ply:GetName(), ply:SteamID(), ent:GetClass() ) )
    end )
    hook.Add( "PlayerSpawnedSWEP", "guthlogsystem:log", function( ply, ent )
        guthlogsystem.addLog( "Player Spawned Entities", string.format( "*%s* (%s) has spawned ?%s?", ply:GetName(), ply:SteamID(), ent:GetClass() ) )
    end )
    hook.Add( "PlayerGiveSWEP", "guthlogsystem:log", function( ply, class )
        guthlogsystem.addLog( "Player Spawned Entities", string.format( "*%s* (%s) has given ?%s?", ply:GetName(), ply:SteamID(), class ) )
    end )

end

--  > Entities Logs

-- guthlogsystem.addCategory( "Entity Created/Removed", Color( 155, 89, 182 ) )
-- guthlogsystem.addCategory( "Entity Sound", Color( 155, 89, 182 ) )
--
-- hook.Add( "OnEntityCreated", "guthlogsystem:log", function( ent )
--     guthlogsystem.addLog( "Entity Created/Removed", string.format( "?%s? has been created", ent:GetClass() ) )
-- end )
-- hook.Add( "EntityRemoved", "guthlogsystem:log", function( ent )
--     guthlogsystem.addLog( "Entity Created/Removed", string.format( "?%s? has been removed", ent:GetClass() ) )
-- end )
-- hook.Add( "EntityEmitSound", "guthlogsystem:log", function( data )
--     local ent = data.Entity
--         ent = ent:IsPlayer() and ent:GetName() or ent:GetClass()
--     guthlogsystem.addLog( "Entity Sound", string.format( "?%s? has played : ~%s~", ent, data.SoundName ) )
-- end )

--  > Server Logs

guthlogsystem.addCategory( "Server General", Color( 230, 126, 34 ) )

hook.Add( "PostCleanupMap", "guthlogsystem:log", function()
    guthlogsystem.addLog( "Server General", "Map has been clean up" )
end )
hook.Add( "ShutDown", "guthlogsystem:log", function()
    guthlogsystem.addLog( "Server General", "Server is shutting down" )
end )
hook.Add( "InitPostEntity", "guthlogsystem:log", function()
    guthlogsystem.addLog( "Server General", "Server is up" )
end )

--  > DarkRP Logs // DARKRP

if DarkRP then
    guthlogsystem.addCategory( "DarkRP Name", Color( 231, 76, 60 ) )
    guthlogsystem.addCategory( "DarkRP Laws", Color( 231, 76, 60 ) )
    guthlogsystem.addCategory( "DarkRP Lottery", Color( 231, 76, 60 ) )
    guthlogsystem.addCategory( "DarkRP Teams", Color( 231, 76, 60 ) )
    guthlogsystem.addCategory( "DarkRP Hitman", Color( 231, 76, 60 ) )
    guthlogsystem.addCategory( "DarkRP Doors", Color( 231, 76, 60 ) )
    guthlogsystem.addCategory( "DarkRP Money", Color( 231, 76, 60 ) )

    --  > Name

    hook.Add( "onPlayerChangedName", "guthlogsystem:log", function( ply, old, new )
        guthlogsystem.addLog( "DarkRP Name", string.format( "*%s* (%s) has changed his name to ~%s~", old, ply:SteamID(), new ) )
    end )

    --  > Laws

    hook.Add( "addLaw", "guthlogsystem:log", function( n, law )
        guthlogsystem.addLog( "DarkRP Laws", string.format( "Law &%d& has been added : ~%s~", n, law ) )
    end )
    hook.Add( "removeLaw", "guthlogsystem:log", function( n, law )
        guthlogsystem.addLog( "DarkRP Laws", string.format( "Law &%d& has been removed : ~%s~", n, law ) )
    end )
    hook.Add( "resetLaws", "guthlogsystem:log", function( ply )
        guthlogsystem.addLog( "DarkRP Laws", string.format( "Laws has been reseted by *%s*", ply:GetName() ) )
    end )

    --  > Lottery

    hook.Add( "lotteryStarted", "guthlogsystem:log", function( ply, price )
        guthlogsystem.addLog( "DarkRP Lottery", string.format( "Lottery with &%d&$ to pay has been started by *%s* (%s)", price, ply:GetName(), ply:SteamID() ) )
    end )
    hook.Add( "lotteryEnded", "guthlogsystem:log", function( ptp, ply, money )
        guthlogsystem.addLog( "DarkRP Lottery", string.format( "Lottery with &%d& participants has ended and *%s* (%s) won ~%d~$", #ptp, ply:GetName(), ply:SteamID(), money ) )
    end )
    hook.Add( "playerEnteredLottery", "guthlogsystem:log", function( ply )
        guthlogsystem.addLog( "DarkRP Lottery", string.format( "*%s* (%s) entered in the current lottery", ply:GetName(), ply:SteamID() ) )
    end )

    --  > Teams

    hook.Add( "OnPlayerChangedTeam", "guthlogsystem:log", function( ply, old, new )
        guthlogsystem.addLog( "DarkRP Teams", string.format( "*%s* (%s) get from &%s& to ~%s~", ply:GetName(), ply:SteamID(), team.GetName( old ), team.GetName( new ) ) )
    end )
    hook.Add( "demoteTeam", "guthlogsystem:log", function( ply )
        guthlogsystem.addLog( "DarkRP Teams", string.format( "*%s* (%s) has been demoted", ply:GetName(), ply:SteamID() ) )
    end )

    --  > Hitman

    hook.Add( "onHitAccepted", "guthlogsystem:log", function( hit, trg, buy )
        guthlogsystem.addLog( "DarkRP Hitman", string.format( "*%s* has accepted to kill *%s*, ordered by *%s*", hit:GetName(), trg:GetName(), buy:GetName() ) )
    end )
    hook.Add( "onHitCompleted", "guthlogsystem:log", function( hit, trg, buy )
        guthlogsystem.addLog( "DarkRP Hitman", string.format( "*%s* has killed *%s*, ordered by *%s*", hit:GetName(), trg:GetName(), buy:GetName() ) )
    end )
    hook.Add( "onHitCompleted", "guthlogsystem:log", function( hit, trg, reason )
        guthlogsystem.addLog( "DarkRP Hitman", string.format( "*%s* has failed to kill *%s* : *%s*", hit:GetName(), trg:GetName(), reason ) )
    end )

    --  > Doors

    hook.Add( "lockpickStarted", "guthlogsystem:log", function( ply, ent )
        local _ent = ent.GetVehicleClass and ent:GetVehicleClass() or ent:GetClass()
        guthlogsystem.addLog( "DarkRP Doors", string.format( "*%s* has started to lockpick ?%s?", ply:GetName(), _ent ) )
    end )
    hook.Add( "onLockpickCompleted", "guthlogsystem:log", function( ply, bool, ent )
        local _ent = ent.GetVehicleClass and ent:GetVehicleClass() or ent:GetClass()
        local lockpick = bool and "lockpicked" or "failed to lockpick"
        guthlogsystem.addLog( "DarkRP Doors", string.format( "*%s* has %s ?%s?", ply:GetName(), lockpick, _ent ) )
    end )
    hook.Add( "onHitCompleted", "guthlogsystem:log", function( hit, trg, reason )
        guthlogsystem.addLog( "DarkRP Doors", string.format( "*%s* has failed to kill *%s* : *%s*", hit:GetName(), trg:GetName(), reason ) )
    end )

    --  > Money

    hook.Add( "playerGaveMoney", "guthlogsystem:log", function( ply, trg, amount )
        guthlogsystem.addLog( "DarkRP Money", string.format( "*%s* (%s) has given &%d&$ to *%s*", ply:GetName(), ply:SteamID(), amount, trg:GetName() ) )
    end )
    hook.Add( "playerDroppedMoney", "guthlogsystem:log", function( ply, amount )
        guthlogsystem.addLog( "DarkRP Money", string.format( "*%s* (%s) has dropped &%d&$", ply:GetName(), ply:SteamID(), amount ) )
    end )
    hook.Add( "playerDroppedCheque", "guthlogsystem:log", function( ply, trg, amount )
        guthlogsystem.addLog( "DarkRP Money", string.format( "*%s* (%s) has dropped a cheque to *%s* of &%d&$", ply:GetName(), ply:SteamID(), trg:GetName(), amount ) )
    end )
    hook.Add( "playerPickedUpMoney", "guthlogsystem:log", function( ply, amount )
        guthlogsystem.addLog( "DarkRP Money", string.format( "*%s* (%s) has picked up &%d&$", ply:GetName(), ply:SteamID(), amount ) )
    end )
    hook.Add( "playerPickedUpCheque", "guthlogsystem:log", function( ply, trg, amount, bool )
        local pick = bool and "succesfully picked" or "failed to pick"
        guthlogsystem.addLog( "DarkRP Money", string.format( "*%s* (%s) has %s up a cheque to *%s* of &%d&$", ply:GetName(), ply:SteamID(), pick, trg:GetName(), amount ) )
    end )
    hook.Add( "playerGetSalary", "guthlogsystem:log", function( ply, amount )
        guthlogsystem.addLog( "DarkRP Money", string.format( "*%s* (%s) has got his salary of &%d&$ as ~%s~", ply:GetName(), ply:SteamID(), amount, team.GetName( ply:Team() ) ) )
    end )
    hook.Add( "onPropertyTax", "guthlogsystem:log", function( ply, tax )
        guthlogsystem.addLog( "DarkRP Money", string.format( "*%s* (%s) has paid &%d&$ of tax", ply:GetName(), ply:SteamID(), amount ) )
    end )

end

if ULib then
    guthlogsystem.addCategory( "ULib Groups", Color( 46, 204, 113 ) )
    guthlogsystem.addCategory( "ULib Ban/Kick", Color( 46, 204, 113 ) )
    guthlogsystem.addCategory( "ULib Users", Color( 46, 204, 113 ) )

    hook.Add( "ULibGroupRenamed", "guthlogsystem:log", function( old, new )
        guthlogsystem.addLog( "ULib Groups", string.format( "&%s& has been renamed as ~%s~", old, new ) )
    end )
    hook.Add( "ULibGroupInheritanceChanged", "guthlogsystem:log", function( group, new, old )
        guthlogsystem.addLog( "ULib Groups", string.format( "&%s&'s inheritance changed from !%s! to ~%s~", group, old, new ) )
    end )
    hook.Add( "ULibGroupCanTargetChanged", "guthlogsystem:log", function( group, new, old )
        local msg = old == nil and "" or "from !" .. old .. "!"
        guthlogsystem.addLog( "ULib Groups", string.format( "&%s&'s target changed %s to ~%s~", group, msg, new ) )
    end )
    hook.Add( "ULibGroupAccessChanged", "guthlogsystem:log", function( group, access, bool )
        local msg = bool == true and "revoking" or "adding"
        guthlogsystem.addLog( "ULib Groups", string.format( "&%s& has been %s from !%s! access", group, msg, access[1] ) )
    end )
    hook.Add( "ULibGroupCreated", "guthlogsystem:log", function( group )
        guthlogsystem.addLog( "ULib Groups", string.format( "&%s& has been created", group ) )
    end )
    hook.Add( "ULibGroupRemoved", "guthlogsystem:log", function( group )
        guthlogsystem.addLog( "ULib Groups", string.format( "&%s& has been removed", group ) )
    end )

    --  >

    hook.Add( "ULibPlayerKicked", "guthlogsystem:log", function( id, reason, ply )
        local msg = ply and "by *" .. ply:GetName() .. "*" or ""
        guthlogsystem.addLog( "ULib Ban/Kick", string.format( "&%s& has been kicked for ~%s~ %s", id, reason, msg ) )
    end )
    hook.Add( "ULibPlayerBanned", "guthlogsystem:log", function( id, data )
        local msg = data.admin and "by " .. data.admin:GetName() or ""
        guthlogsystem.addLog( "ULib Ban/Kick", string.format( "&%s& has been banned for !%s! for ~%d~ %s", id, data.reason, data.time, msg ) )
    end )
    hook.Add( "ULibPlayerUnBanned", "guthlogsystem:log", function( id, admin )
        local msg = admin and "by " .. admin:GetName() or ""
        guthlogsystem.addLog( "ULib Ban/Kick", string.format( "&%s& has been unbanned %s", id, msg ) )
    end )

    --  >

    hook.Add( "ULibUserGroupChange", "guthlogsystem:log", function( id, _, _, old, new )
        guthlogsystem.addLog( "ULib Users", string.format( "&%s&'s group changed from ~%s~ to !%s!", id, old, new ) )
    end )
end

print( "guthlogsystem - 'sv_hooks.lua' loaded" )
