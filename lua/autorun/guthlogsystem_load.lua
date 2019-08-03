guthlogsystem = guthlogsystem or {}
guthlogsystem.Version   =   "1.0.0"
guthlogsystem.Author    =   "Guthen"

if SERVER then
   include( 'guthlogsystem/sv_init.lua' )
   AddCSLuaFile( 'guthlogsystem/cl_init.lua' )
else
   include( 'guthlogsystem/cl_init.lua' )
end
