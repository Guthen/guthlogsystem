guthlogsystem = guthlogsystem or {}
guthlogsystem.categories = guthlogsystem.categories or {}
guthlogsystem.regex = {}

function guthlogsystem.addRegex( regex, color )
    table.insert( guthlogsystem.regex, { regex = regex, color = color } )
end
guthlogsystem.addRegex( "*", Color( 52, 152, 219 ) ) -- Player regex
guthlogsystem.addRegex( "&", Color( 46, 204, 113 ) ) -- Msg/Number regex
guthlogsystem.addRegex( "~", Color( 46, 204, 113 ) ) -- Msg/Number regex
guthlogsystem.addRegex( "!", Color( 46, 204, 113 ) ) -- Msg/Number regex
guthlogsystem.addRegex( "?", Color( 155, 89, 182 ) ) -- Class/Msg regex

--  >

net.Receive( "guthlogsystem:network", function( len )
    local t =  util.JSONToTable( util.Decompress( net.ReadData( len/8 ) ) )
    local isLog = net.ReadBool()
    local isCats = net.ReadBool()

    if isLog and not isCats then
        if not guthlogsystem.categories[t.category] then return end
        table.insert( guthlogsystem.categories[t.category].logs, t )
    elseif not isCats then
        if not t.name then return end
        guthlogsystem.categories[t.name] = t
    else
        guthlogsystem.categories = t
        print( "guthlogsystem - Receive all logs (" .. table.Count( t ) .. ")" )
    end
    --print( "guthlogsystem - Receive network" )
end )

local function lerpColor( t, fColor, eColor )
    return Color( Lerp( t, fColor.r, eColor.r ), Lerp( t, fColor.g, eColor.g ), Lerp( t, fColor.b, eColor.b ) )
end

concommand.Add( "guthlogsystem_panel", function( ply )
    if not IsValid( ply ) or not ply:IsAdmin() then return end

    gui.EnableScreenClicker( true )

    local panel = vgui.Create( "DPanel" )
        panel:SetSize( ScrW()/1.96, ScrH()/1.7 )
        panel:Center()
        panel:SetAlpha( 0 )
        panel:AlphaTo( 255, .2, 0 )
        panel.Paint = function( self, w, h )
            local color = Color( 52, 73, 94 )
            local endColor = Color( 44, 62, 80 )

            w = w - ScrW()/8

            for x = 0, w do -- make a gradient, very easy
                surface.SetDrawColor( lerpColor( x / w, color, endColor ) )

                surface.DrawLine( x, 0, x, h )
            end
            surface.SetDrawColor( color ) -- line before the nav
            -- surface.DrawRect( 0, 0, w, h )

            surface.DrawLine( w-1, 0, w-1, h )

            surface.SetDrawColor( endColor )
            surface.DrawLine( 0, 0, 0, h )
            surface.DrawLine( 0, 0, w, 0 )
            surface.DrawLine( 0, h-1, w, h-1 )

            -- Credits
            draw.SimpleText( ("v%s by %s"):format( guthlogsystem.Version, guthlogsystem.Author ), "HudHintTextSmall", 5, h - 12 )
        end

    local log = vgui.Create( "GLSLog", panel )
    --  > NAVIGATION
    local nav = vgui.Create( "GLSNav", panel )

    local i = 0
    local befWord
    for k, v in SortedPairs( guthlogsystem.categories ) do
        local newWord = string.match( v.name, "^(%w+)" )

        local c = Color( math.Clamp( v.color.r - 30, 0, 255 ), math.Clamp( v.color.g - 30, 0, 255 ), math.Clamp( v.color.b - 30, 0, 255 ) )
        local cat = nav:AddButton( v.name, v.color, c )
            if befWord and not (befWord == newWord) then
                cat:DockMargin( 0, 5, 0, 0 )
            end
            cat.DoClick = function()
                log:Clear()
                for _, lv in SortedPairsByMemberValue( v.logs, "time", true ) do
                    log:AddLog( lv.msg, lv.time )
                end
                if #v.logs == 0 then
                    log:AddLog( "", 0 )
                end
            end

        if i == 0 then cat.DoClick() end
        i = i + 1

        befWord = newWord
    end

    local close = nav:AddButton( "Close", Color( 231, 76, 60 ), Color( 192, 57, 43 ) )
        close:DockMargin( 0, 5, 0, 0 )
        close.DoClick = function()
            panel:AlphaTo( 0, .2, 0, function()
                panel:Remove()
            end )
            gui.EnableScreenClicker( false )
        end

    --  > LOGS
    log:SetPos( 15, 15 )
    log:SetSize( panel:GetWide() - nav:GetWide() - 30, ScrH() / 1.8 )

end )

--  > Hook PANEL

hook.Add( "OnPlayerChat", "guthlogsystem:panel", function( ply, txt )
    if not ( ply == LocalPlayer() ) then return end

    if ( string.StartWith( txt, guthlogsystem.conf.PanelTChatCommand ) ) then
        RunConsoleCommand( "guthlogsystem_panel" )
    end
end )
