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

local parse = function() end
net.Receive( "guthlogsystem:network", function( len )
    local is_logs = net.ReadBool()
    local max_pages = net.ReadUInt( guthlogsystem.config.maxPagesInBits )
    local data = util.JSONToTable( util.Decompress( net.ReadData( len - 1 - ( is_logs and guthlogsystem.config.maxPagesInBits or 0 ) ) ) )

    if is_logs then
        parse( data, max_pages )
    else
        guthlogsystem.categories = data
    end
end )

local function lerpColor( t, fColor, eColor )
    return Color( Lerp( t, fColor.r, eColor.r ), Lerp( t, fColor.g, eColor.g ), Lerp( t, fColor.b, eColor.b ) )
end

concommand.Add( "guthlogsystem_panel", function( ply )
    if not guthlogsystem.config.accessRanks[ply:GetUserGroup()] then return end

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

            surface.DrawLine( w - 1, 0, w - 1, h )

            surface.SetDrawColor( endColor )
            surface.DrawLine( 0, 0, 0, h )
            surface.DrawLine( 0, 0, w, 0 )
            surface.DrawLine( 0, h - 1, w, h - 1 )

            --  > Credits
            draw.SimpleText( ("v%s by %s"):format( guthlogsystem.Version, guthlogsystem.Author ), "HudHintTextSmall", 5, h - 12 )
        end

    --  > Logs viewer
    local log = panel:Add( "GLSLog" )

    --  > Page controller
    local pager = log:Add( "DPanel" )
    pager:Dock( BOTTOM )
    pager.cur_page = 1
    pager.max_page = 1
    function pager:Paint( w, h )
        draw.SimpleText( ( "Page %d/%d" ):format( self.cur_page, self.max_page ), "DermaDefaultBold", w / 2, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
    end
    
    local next_page = pager:Add( "DButton" )
    next_page:Dock( RIGHT )
    next_page:SetText( "Next" )
    --next_page:SetDisabled( true )
    function next_page:DoClick()
        if not log.category then return end

        --  > Next page
        local old_page = pager.cur_page
        pager.cur_page = math.Clamp( pager.cur_page + 1, 1, pager.max_page )

        --  > Fetch
        if old_page == pager.cur_page then return end
        log.category:DoClick()
    end

    local previous_page = pager:Add( "DButton" )
    previous_page:Dock( LEFT )
    previous_page:SetText( "Previous" )
    --previous_page:SetDisabled( true )
    function previous_page:DoClick()
        if not log.category then return end

        --  > Previous page
        local old_page = pager.cur_page
        pager.cur_page = math.Clamp( pager.cur_page - 1, 1, pager.max_page )

        --  > Fetch
        if old_page == pager.cur_page then return end
        log.category:DoClick()
    end

    --  > Categories navigation 
    local nav = panel:Add( "GLSNav" )

    local i, before_word = 0
    for k, v in SortedPairs( guthlogsystem.categories or {} ) do
        local new_word = string.match( v.name, "^(%w+)" )

        local c = Color( math.Clamp( v.color.r - 30, 0, 255 ), math.Clamp( v.color.g - 30, 0, 255 ), math.Clamp( v.color.b - 30, 0, 255 ) )
        local cat = nav:AddButton( v.name, v.color, c )
        if before_word and not ( before_word == new_word ) then
            cat:DockMargin( 0, 5, 0, 0 )
        end
        function cat:DoClick()
            log.category = self

            --  > Clear logs
            log:Clear()

            --  > Fetch logs
            net.Start( "guthlogsystem:network" )
                net.WriteUInt( pager.cur_page, guthlogsystem.config.maxPagesInBits )
                net.WriteString( v.name )
            net.SendToServer()
            log:AddLog( "Fetching logs..", 0 )

            --  > Parse logs
            parse = function( logs, max_page )
                if not IsValid( cat ) then return end
                log:Clear()

                for id, lv in ipairs( logs ) do
                    log:AddLog( lv.log, tonumber( lv.time ) )
                end

                --[[ if #logs == 0 then
                    log:AddLog( "", 0 )
                end ]]
                pager.max_page = max_page
            end
        end

        if i == 0 then cat.DoClick() end
        i = i + 1

        before_word = new_word
    end

    --  > Close button
    local close = nav:AddButton( "Close", Color( 231, 76, 60 ), Color( 192, 57, 43 ) )
    close:DockMargin( 0, 5, 0, 0 )
    close.DoClick = function()
        panel:AlphaTo( 0, .2, 0, function()
            panel:Remove()
        end )
        gui.EnableScreenClicker( false )
    end

    --  > Final setup of logs viewer
    log:SetPos( 15, 15 )
    log:SetSize( panel:GetWide() - nav:GetWide() - 30, ScrH() / 1.8 )
end )

--  > Chat command
hook.Add( "OnPlayerChat", "guthlogsystem:panel", function( ply, txt )
    if not ( ply == LocalPlayer() ) then return end
    if not string.StartWith( txt, guthlogsystem.config.chatCommand ) then return end

    RunConsoleCommand( "guthlogsystem_panel" )
end )
