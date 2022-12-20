local PANEL = {}

function PANEL:Init()
    self.point = 0
    self.type = 0
    self.color = ASEEEM_PS.theme.pointBackgroundColor
    self:SetSize(150, 32)

    self.bg = self:Add("DPanel")
    self.bg:SetPaintBackground(false)
    self.bg:SetSize(150, 25)
    self.bg:SetPos(0, 8)
    self.bg.Paint = function(s, w, h)
        draw.RoundedBox(20, 0, 0, w, h, self.color)
        
        if self.type == 0 then
            draw.SimpleText(tostring(ASEEEM_PS.func.GetNW(LocalPlayer(), 'point', ASEEEM_PS.enums.NWType.INT, -114514)), 'Roboto24', w/2, h/2, ASEEEM_PS.theme.btnTextColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        elseif self.type == 1 then
            draw.SimpleText(tostring(ASEEEM_PS.func.GetNW(LocalPlayer(), 'proPoint', ASEEEM_PS.enums.NWType.INT, -114514)), 'Roboto24', w/2, h/2, ASEEEM_PS.theme.btnTextColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        elseif self.type == -1 then
            draw.SimpleText(tostring(self.point), 'Roboto24', w/2, h/2, HSVToColor((CurTime()*ASEEEM_PS.theme.rainbowBtnColorSpeed) % 360, 1, 1), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
    end
end

function PANEL:Paint(w, h)
end

function PANEL:SetPointType(type)
    self.type = type
end

function PANEL:SetPoint(amount)
    self.type = -1
    self.point = amount
end

function PANEL:SetBgColor(color)
    self.color = color
end

function PANEL:SetMat(mat)
    self.matPoint = mat

    if IsValid(self.icon) then
        self.icon:Remove()
    end

    self.icon = self:Add("DImage")
    self.icon:SetMaterial(self.matPoint)
    self.icon:SetSize(32, 32)
    self.icon:SetPos(10, 0)
end

vgui.Register('APoint', PANEL, "DPanel")