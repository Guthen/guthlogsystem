local PANEL = {}

local function lerpColor( t, fColor, eColor )
    return Color( Lerp( t, fColor.r, eColor.r ), Lerp( t, fColor.g, eColor.g ), Lerp( t, fColor.b, eColor.b ) )
end

function PANEL:Init()
    self.buttons = {}

    self:Dock( RIGHT )
    self:SetWidth( ScrW()/8 )

    self.scroll = vgui.Create( "DScrollPanel", self )
        self.scroll:SetPos( 0, 90 )
        self.scroll:SetSize( self:GetWide() + 15, ScrH() / 2.06 )

        local vbar = self.scroll:GetVBar()
        vbar:SetHideButtons( true )
end

function PANEL:Paint( w, h )
    surface.SetDrawColor( 44, 62, 80 )
    surface.DrawRect( 0, 0, w, h )

    draw.SimpleText( "guthlogsystem", "DermaLarge", w/2, 35, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
    draw.SimpleText( "Guthen's logs system", "DermaDefaultBold", w/2, 60, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
end

function PANEL:AddButton( txt, color, endColor )
    if not color.r or not color.g or not color.b then color = Color( 155, 89, 182 ) end
    if not IsColor( endColor ) then endColor = Color( 142, 68, 173 ) end

    local but = vgui.Create( "DButton", self.scroll )
        but:Dock( TOP )
        but:SetText( txt )
        but:SetTextColor( Color( 236, 240, 241 ) )
        but:SetFont( "DermaDefaultBold" )
        but.DoClickInternal = function()
            surface.PlaySound( "ui/buttonclick.wav" )
        end
        but.OnCursorEntered = function()
            surface.PlaySound( "ui/buttonrollover.wav" )
        end
        but.Paint = function( self, w, h )
            if color == endColor then
                surface.SetDrawColor( color )
                surface.DrawRect( 0, 0, w, h )
            else
                for x = 0, w do -- make a gradient, very easy
                    if self:IsHovered() then
                        local t = math.abs( math.sin( CurTime() ) / w ) * 100 * 2
                        surface.SetDrawColor( lerpColor( t, color, endColor ) )
                    else
                        surface.SetDrawColor( lerpColor( x / w, color, endColor ) )
                    end
                    surface.DrawLine( x, 0, x, h )
                end
            end
        end

    table.insert( self.buttons, but )
    return but
end

vgui.Register( "GLSNav", PANEL, "DPanel" )

print( "VGUI: 'GLSNav' registered !" )
