local PANEL = {}

function PANEL:Init()
    self.buttons = {}

    self:Dock( RIGHT )
    self:SetWidth( ScrW() / 8 )

    self.scroll = vgui.Create( "DScrollPanel", self )
    self.scroll:Dock( FILL )
    self.scroll:DockMargin( 0, 90, 0, 5 )

    local vbar = self.scroll:GetVBar()
    vbar:SetHideButtons( true )
    vbar:SetWide( 0 )
end

function PANEL:Paint( w, h )
    surface.SetDrawColor( 44, 62, 80 )
    surface.DrawRect( 0, 0, w, h )

    draw.SimpleText( "guthlogsystem", "DermaLarge", w / 2, 35, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
    draw.SimpleText( "Guthen's logs system", "DermaDefaultBold", w / 2, 60, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
end

function PANEL:AddButton( txt, color, end_color )
    local button = guthlogsystem.createButton( self.scroll, txt, TOP, nil, color, end_color )

    self.buttons[#self.buttons + 1] = button
    return button
end

vgui.Register( "GLSNav", PANEL, "DPanel" )

print( "VGUI: 'GLSNav' registered !" )
