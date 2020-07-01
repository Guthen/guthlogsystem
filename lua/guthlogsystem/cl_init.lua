guthlogsystem = guthlogsystem or {}
guthlogsystem.categories = guthlogsystem.categories or {}
guthlogsystem.regex = {}

function guthlogsystem.addRegex( regex, color )
    guthlogsystem.regex[regex] = color
end
guthlogsystem.addRegex( "*", Color( 52, 152, 219 ) ) -- Player regex
guthlogsystem.addRegex( "&", Color( 46, 204, 113 ) ) -- Msg/Number regex
guthlogsystem.addRegex( "~", Color( 46, 204, 113 ) ) -- Msg/Number regex
guthlogsystem.addRegex( "!", Color( 46, 204, 113 ) ) -- Msg/Number regex
guthlogsystem.addRegex( "?", Color( 155, 89, 182 ) ) -- Class/Msg regex

--  > Gradient
local function lerpColor( t, fColor, eColor )
    return Color( Lerp( t, fColor.r, eColor.r ), Lerp( t, fColor.g, eColor.g ), Lerp( t, fColor.b, eColor.b ) )
end

function guthlogsystem.drawGradient( x, y, w, h, color, end_color )
    for x = 0, w do -- make a gradient, very easy
        --[[ if self:IsHovered() then
            local t = math.abs( math.sin( CurTime() ) / w ) * 100 * 2
            surface.SetDrawColor( lerpColor( t, color, end_color ) )
        else ]]
        surface.SetDrawColor( lerpColor( x / w, color, end_color ) )
        surface.DrawLine( x, 0, x, h )
    end
end

--  > Panel
guthlogsystem.colors = {
    fg = Color( 52, 73, 94 ),
    bg = Color( 44, 62, 80 ),
    blue_fg = Color( 52, 152, 219 ),
    blue_bg = Color( 41, 128, 185 ),
}

function guthlogsystem.createButton( parent, text, dock, doclick, color, end_color )
    local color = color or guthlogsystem.colors.blue_fg
    local end_color = end_color or guthlogsystem.colors.blue_bg

    local button = parent:Add( "DButton" )
    button:Dock( dock )
    button:SetText( text )
    button:SetTextColor( color_white )
    button:SetFont( "DermaDefaultBold" )
    function button:Paint( w, h )
        guthlogsystem.drawGradient( 0, 0, w, h, self:IsHovered() and end_color or color, self:IsHovered() and color or end_color )
    end
    function button:DoClickInternal()
        surface.PlaySound( "ui/buttonclick.wav" )
    end
    function button:OnCursorEntered()
        surface.PlaySound( "ui/buttonrollover.wav" )
    end
    button.DoClick = doclick

    return button
end

local parse = function() end
net.Receive( "guthlogsystem:network", function( len )
    local is_logs = net.ReadBool()
    local max_pages = net.ReadUInt( guthlogsystem.config.maxPagesInBits )

    if max_pages > 0 then
        local data = util.JSONToTable( util.Decompress( net.ReadData( len - 1 - ( is_logs and guthlogsystem.config.maxPagesInBits or 0 ) ) ) )

        if is_logs then
            parse( data, max_pages )
        else
            guthlogsystem.categories = data
        end
    else
        parse()
    end
end )

concommand.Add( "guthlogsystem_panel", function( ply )
    if not guthlogsystem.config.accessRanks[ply:GetUserGroup()] then return end

    gui.EnableScreenClicker( true )

    local credit_text = ( "v%s by %s" ):format( guthlogsystem.Version, guthlogsystem.Author )
    local panel = vgui.Create( "DPanel" )
    panel:SetSize( ScrW() / 1.96, ScrH() / 1.7 )
    panel:Center()
    panel:SetAlpha( 0 )
    panel:AlphaTo( 255, .2, 0 )
    panel.Paint = function( self, w, h )
        w = w - ScrW() / 8

        --  > Gradient
        guthlogsystem.drawGradient( 0, 0, w, h, guthlogsystem.colors.fg, guthlogsystem.colors.bg )

        --  > Separation line
        surface.SetDrawColor( guthlogsystem.colors.fg )
        surface.DrawLine( w - 1, 0, w - 1, h )

        --  > Credits
        draw.SimpleText( credit_text, "HudHintTextSmall", 5, h - 12 )
    end

    --  > Logs viewer
    local log = panel:Add( "GLSLog" )

    --  > Page controller
    local pager = log:Add( "DPanel" )
    pager:Dock( BOTTOM )
    pager:DockMargin( 0, 10, 0, 0 )
    pager.cur_page = 1
    pager.max_page = 1
    function pager:Paint( w, h )
        draw.SimpleText( ( "Page %d/%d" ):format( self.cur_page, self.max_page ), "DermaDefaultBold", w / 2, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
    end

    --  > Next
    guthlogsystem.createButton( pager, "Next", RIGHT, function()
        if not log.category then return end

        --  > Previous page
        local old_page = pager.cur_page
        pager.cur_page = math.Clamp( pager.cur_page + 1, 1, pager.max_page )

        --  > Fetch
        if old_page == pager.cur_page then return end
        log.category:DoClick()
    end )

    --  > Previous
    guthlogsystem.createButton( pager, "Previous", LEFT, function()
        if not log.category then return end

        --  > Previous page
        local old_page = pager.cur_page
        pager.cur_page = math.Clamp( pager.cur_page - 1, 1, pager.max_page )

        --  > Fetch
        if old_page == pager.cur_page then return end
        log.category:DoClick()
    end )

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
            --  > Reset pager
            if not ( log.category == self ) then
                pager.cur_page = 1
            end

            --  > Set category panel
            log.category = self

            --  > Clear logs
            log:Clear()

            --  > Fetch logs
            net.Start( "guthlogsystem:network" )
                net.WriteUInt( pager.cur_page, guthlogsystem.config.maxPagesInBits )
                net.WriteString( v.name )
            net.SendToServer()
            log:AddDelimiter( "Fetching logs.." )

            --  > Parse logs
            parse = function( logs, max_page )
                if not IsValid( cat ) then return end
                log:Clear()

                if logs and max_page then
                    for id, lv in ipairs( logs ) do
                        log:AddLog( lv.log, tonumber( lv.time ) )
                    end

                    pager.max_page = max_page
                else
                    log:AddDelimiter( "No log found" )
                end
            end
        end

        if i == 0 then cat.DoClick() end
        i = i + 1

        before_word = new_word
    end

    --  > Close button
    local close = nav:AddButton( "Close", Color( 231, 76, 60 ), Color( 192, 57, 43 ) )
    close:SetParent( nav )
    close:Dock( BOTTOM )
    close:DockMargin( 0, 0, 0, 5 )
    close.DoClick = function()
        panel:AlphaTo( 0, .2, 0, function()
            panel:Remove()
        end )
        gui.EnableScreenClicker( false )
    end

    --  > Final setup of logs viewer
    log:AddDelimiter( "COUCOU" )
    log:SetPos( 15, 15 )
    log:SetSize( panel:GetWide() - nav:GetWide() - 30, ScrH() / 1.8 )
end )

--  > Chat command
hook.Add( "OnPlayerChat", "guthlogsystem:panel", function( ply, txt )
    if not ( ply == LocalPlayer() ) then return end
    if not string.StartWith( txt, guthlogsystem.config.chatCommand ) then return end

    RunConsoleCommand( "guthlogsystem_panel" )
end )
