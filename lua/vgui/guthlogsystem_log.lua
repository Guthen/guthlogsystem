local PANEL = {}

function PANEL:Init()
    self.buttons = {}

    self.scroll = vgui.Create( "DScrollPanel", self )
    self.scroll:Dock( FILL )

    local vbar = self.scroll:GetVBar()
    vbar:SetHideButtons( true )
    vbar.Paint = function( _, w, h )
        surface.SetDrawColor( Color( 52, 73, 94 ) )
        surface.DrawRect( w/2, 0, w/2, h )
    end
    vbar.btnGrip.Paint = function( _self, w, h )
        --if not _self:IsHovered() then return end
        surface.SetDrawColor( Color( 40, 58, 75 ) )
        surface.DrawRect( w/2, 0, w/2, h )
    end
end

function PANEL:Paint( w, h )
end

function PANEL:Clear()
    self.buttons = {}
    self.scroll:Clear()
end

function PANEL:AddLog( txt, time )
    local i = #self.buttons
    local lastDate, curDate, sameDate
    if self.buttons[i] then
        lastDate = os.date( "*t", self.buttons[i].time )
        curDate = os.date( "*t", time )
        sameDate = lastDate.day == curDate.day and lastDate.month == curDate.month and lastDate.year == curDate.year
    end
    if i == 0 or not sameDate then
        local but = vgui.Create( "DButton", self.scroll )
            but:Dock( TOP )
            if time and time > 0 then
                but:SetText( os.date( "%d %B %Y (%d/%m/%y)", time ) )
            else
                but:SetText( "NO LOG" )
            end
            but:SetTextColor( Color( 236, 240, 241 ) )
            but:SetFont( "DermaDefaultBold" )
            but.Paint = function( _, w, h )
                surface.SetDrawColor( Color( 44, 62, 80 ) )

                surface.DrawRect( 0, 0, w, h )
            end
    end

    if not time or time == 0 then return end

    --  > Log
    surface.SetFont( "DermaDefaultBold" )
    local but = self.scroll:Add( "DPanel" )
    but:Dock( TOP )
    but.Paint = function( _, w, h )
        if i % 2 == 0 then
            surface.SetDrawColor( Color( 0, 0, 0, 0 ) )
        else
            surface.SetDrawColor( Color( 44, 62, 80 ) )
        end
        surface.DrawRect( 0, 0, w, h )

        --  > Log out
        surface.SetFont( "DermaDefaultBold" )

        local reg = {}
        local _txt = txt -- copy
        for _, v in pairs( guthlogsystem.regex ) do
            local t = { color = v.color, doing = false }
            local regex = "(%b" .. v.regex .. v.regex .. ")"
            t.s, t.e = string.find( _txt, regex )

            if t.s and t.e then
                table.insert( reg, t )
                _txt = string.gsub( _txt, v.regex, "" )
            end
        end
        table.SortByMember( reg, "s", true )

        for i = 1, #_txt do
            for k, v in pairs( reg ) do
                local off = 0
                --if k > 2 then off = k - 1 end
                if i == v.s - off or v.doing then
                    v.doing = true
                    surface.SetTextColor( v.color )
                else
                    surface.SetTextColor( Color( 255, 255, 255 ) )
                end
                if i == v.e - 1 - off then v.doing = false end
                if v.doing then break end
            end
            local _w, _h = surface.GetTextSize( string.sub( _txt, 1, i - 1 ) )
            surface.SetTextPos( 55 + _w, h/2 - _h/2 + 1 )
            surface.DrawText( string.sub( _txt, i, i ) )
        end

        --  > Date out
        --draw.SimpleText( txt, "DermaDefaultBold", 55, h/2, Color( 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
        draw.SimpleText( os.date( "%H:%M:%S", time ), "DermaDefault", 5, h/2, Color( 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
    end

    --self.scroll:ScrollToChild( but )

    table.insert( self.buttons, but )
    return but
end

vgui.Register( "GLSLog", PANEL, "DPanel" )

print( "VGUI: 'GLSLog' registered !" )
