local PANEL = {}

local function letters( txt )
    return txt:gmatch( "." ) 
end

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

function PANEL:AddDelimiter( txt )
    local delimiter = self.scroll:Add( "DPanel" )
    delimiter:Dock( TOP )
    function delimiter:Paint( w, h )
        surface.SetDrawColor( guthlogsystem.colors.bg )
        surface.DrawRect( 0, 0, w, h )

        draw.SimpleText( txt, nil, w / 2, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
    end
end

function PANEL:AddLog( txt, time )
    --  > Add date delimiter
    local current_date, current_formated_date, last_button = os.date( "*t", time ), os.date( "%d %B %Y (%d/%m/%y)", time ), self.buttons[#self.buttons]
    if last_button then
        local last_date = os.date( "*t", last_button.time )
        if not ( current_date.day == last_date.day ) or not ( current_date.month == last_date.month ) or not ( current_date.year == last_date.year ) then 
            self:AddDelimiter( current_formated_date )
        end
    else
        self:AddDelimiter( current_formated_date )
    end

    --  > Compute unregexed text
    local unregexed_txt = ""
    for l in letters( txt ) do
        if guthlogsystem.regex[l] then continue end
        unregexed_txt = unregexed_txt .. l
    end

    --  > Log
    local i, font = #self.buttons, "DermaDefaultBold"

    local log = self.scroll:Add( "DPanel" )
    log:Dock( TOP )
    log.time = time
    function log:Paint( w, h )
        if i % 2 == 0 then
            surface.SetDrawColor( Color( 0, 0, 0, 0 ) )
        else
            surface.SetDrawColor( Color( 44, 62, 80 ) )
        end
        surface.DrawRect( 0, 0, w, h )

        --  > Log text
        surface.SetFont( font )

        local offset_x, offset_y, last_regex_color, i = 0, draw.GetFontHeight( font ) / 2, nil, 1
        for l in letters( txt ) do
            --  > Find regex and change next color
            local regex_color = guthlogsystem.regex[l]
            if regex_color then
                if not last_regex_color then
                    last_regex_color = regex_color
                else
                    last_regex_color = nil
                end
                continue
            end

            --  > Set text color
            if last_regex_color then
                surface.SetTextColor( last_regex_color )
            else
                surface.SetTextColor( color_white )
            end

            --  > Draw letter
            surface.SetTextPos( 55 + offset_x, offset_y )
            surface.DrawText( l )

            --  > Change variables
            offset_x = offset_x + surface.GetTextSize( unregexed_txt:sub( i, i ) )
            i = i + 1
        end

        --  > Date out
        draw.SimpleText( os.date( "%H:%M:%S", time ), "DermaDefault", 5, h / 2, Color( 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
    end

    self.buttons[#self.buttons + 1] = log
    return log
end

vgui.Register( "GLSLog", PANEL, "DPanel" )

print( "VGUI: 'GLSLog' registered !" )
