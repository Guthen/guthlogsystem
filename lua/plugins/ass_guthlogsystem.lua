--  > ASSMod support for guthlogsystem
--  > https://steamcommunity.com/sharedfiles/filedetails/?id=174404341

local PLUGIN = {}
PLUGIN.Name = "guthlogsystem"
PLUGIN.Author = "Guthen"
PLUGIN.Date = "September 30 2020"
PLUGIN.Filename = PLUGIN_FILENAME
PLUGIN.ClientSide = false
PLUGIN.ServerSide = true
PLUGIN.APIVersion = guthlogsystem.Version
PLUGIN.Gamemodes = {}

if SERVER then

    local log = guthlogsystem.addCategory( "ASS Logs", Color( 46, 204, 113 ) )

    local _ASS_LogAction = ASS_LogAction
    function ASS_LogAction( ply, acl, message )
        log( ( "*%s* (%s) %s" ):format( ply:GetName(), ply:SteamID(), message ) )

        _ASS_LogAction( ply, acl, message )
    end

end

ASS_RegisterPlugin( PLUGIN )