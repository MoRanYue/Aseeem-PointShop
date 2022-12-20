local PANEL = {}

function PANEL:Init()
    self.color = ASEEEM_PS.theme.btnTextColor
    self.bgColor = ASEEEM_PS.theme.btnBackgroundColor
    self.hoverColor = ASEEEM_PS.theme.btnHoverColor
    self.activeColor = ASEEEM_PS.theme.btnActiveBackgroundColor
    self.animHoverType = 0
    self.active = false
    self.text = ''

    self.btn = self:Add("DButton")
    self.btn:SetText('')
    self:SetSize(100, 50)
    self.btn.barStatus = 0
    self.btn.Paint = function(s, w, h)
        if self.animHoverType == 0 then
            if s:IsHovered() then
                draw.RoundedBox(7, 0, 0, w, h, self.hoverColor)
            else
                if self.active then
                    draw.RoundedBox(7, 0, 0, w, h, self.activeColor)
                else
                    draw.RoundedBox(7, 0, 0, w, h, self.bgColor)
                end
            end
        elseif self.animHoverType == 1 then
            if s:IsHovered() then
                s.barStatus = math.Clamp(s.barStatus + ASEEEM_PS.theme.btnHoverColorSpeed * FrameTime(), 0, 1)
            else
                s.barStatus = math.Clamp(s.barStatus - ASEEEM_PS.theme.btnHoverColorSpeed * FrameTime(), 0, 1)
            end
            if self.active then
                -- surface.SetDrawColor(self.activeColor)
                draw.RoundedBox(7, 0, 0, w, h, self.activeColor)
            else
                draw.RoundedBox(7, 0, 0, w, h, self.bgColor)
            end
            surface.SetDrawColor(self.hoverColor)
            surface.DrawRect(0, h*.9, w * s.barStatus, h*.1)
        end

        draw.SimpleText(self.text, 'Roboto24', w/2, h/2, self.color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
    self.OnSizeChanged = function(s)
        s.btn:SetSize(self:GetWide(), self:GetTall())
    end
end

-- function PANEL:SetSize(w, h)
--     self:SetSize(w, h)
--     self.btn:SetSize(w, h)
-- end

function PANEL:Paint(w, h)
end

function PANEL:SetText(text)
    self.text = text
end

function PANEL:SetColor(color)
    self.color = color
end

function PANEL:SetHoverColor(color)
    self.hoverColor = color
end

function PANEL:SetHoverAnimType(num)
    self.animHoverType = num
end

function PANEL:SetActive(active)
    self.active = active
end

function PANEL:SetBackgroundColor(color)
    self.bgColor = color
end

function PANEL:ClickEvent(func)
    self.btn.DoClick = func
end

vgui.Register("AButton", PANEL, "DPanel")