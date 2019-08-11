guthlogsystem = guthlogsystem or {}
guthlogsystem.Version   =   "1.1.0"
guthlogsystem.Author    =   "Guthen"

include( 'guthlogsystem/sh_config.lua' )

if SERVER then
   include( 'guthlogsystem/sv_init.lua' )
   AddCSLuaFile( 'guthlogsystem/cl_init.lua' )
   AddCSLuaFile( 'guthlogsystem/sh_config.lua' )
else
   include( 'guthlogsystem/cl_init.lua' )
end

print( "guthlogsystem - Loaded" )
