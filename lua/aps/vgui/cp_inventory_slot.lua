local PANEL = {}

function PANEL:Init()
    self.item = {}
    self.active = false
    self.full = false

    self:SetSize(80, 80)

    self.btn = self:Add("DButton")
    self.btn:SetSize(self:GetWide(), self:GetTall())
    self.btn:SetText('')
    self.btn.Paint = function(s, w, h)
        if s:IsHovered() then
            draw.RoundedBox(4, 0, 0, w, h, ASEEEM_PS.theme.invBtnHoverColor)
        end
    end
end

function PANEL:SetItem(item)
    self.item = item

    if IsValid(self.icon) then
        self.icon:Remove()
    end
    if IsValid(self.isEquipped) then
        self.isEquipped:Remove()
    end
    if !self.item then
        self.active = false
        self.full = false
        self.btn.DoClick = function() end
        return
    end

    self.full = true

    if self.item.show_pic then
        self.icon = self:Add("DImage")
        self.icon:SetImage(self.item.show_pic, "vgui/avatar_default")
        self.icon:SetSize(self:GetWide(), self:GetTall())
    elseif self.item.show_mdl then
        self.icon = self:Add("DModelPanel")
        self.icon:SetModel(self.item.show_mdl)
        self.icon:SetSize(self:GetWide(), self:GetTall())

        local mn, mx = self.icon.Entity:GetRenderBounds()
        local size = 0
        size = math.max( size, math.abs(mn.x) + math.abs(mx.x) )
        size = math.max( size, math.abs(mn.y) + math.abs(mx.y) )
        size = math.max( size, math.abs(mn.z) + math.abs(mx.z) )
        self.icon:SetFOV(50)
        self.icon:SetCamPos(Vector(size, size, size))
        self.icon:SetLookAt((mn + mx) * 0.5)
        self.icon:SetMouseInputEnabled(false)
    elseif self.item.show_txt then
        self.icon = self:Add("DLabel")
        self.icon:SetContentAlignment(5)
        -- self.icon:SetWrap(true)
        self.icon:SetFont("Roboto16")
        self.icon:SetText(self.item.show_txt)
        self.icon:SetSize(self:GetWide(), self:GetTall())
    else
        self.icon = self:Add("DLabel")
        self.icon:SetFont("Roboto36")
        self.icon:SetText("?")
        self.icon:SizeToContents()
        self.icon:SetPos(self:GetWide()/2 - self.icon:GetWide()/2, self:GetTall()/2 - self.icon:GetTall()/2)
    end

    if ASEEEM_PS.func.GetInventoryItemByClass(self.item.class) and ASEEEM_PS.func.GetInventoryItemByClass(self.item.class).equipped then
        self.isEquipped = self:Add('DImage')
        self.isEquipped:SetPos(0, 0)
        self.isEquipped:SetSize(25, 25)
        self.isEquipped:SetMaterial(ASEEEM_PS.theme.matEquipped)
    end
end

function PANEL:Paint(w, h)
    if self.active then
        draw.RoundedBox(4, 0, 0, w, h, ASEEEM_PS.theme.invItemActiveColor)
    else
        draw.RoundedBox(4, 0, 0, w, h, ASEEEM_PS.theme.invItemColor)
    end
end

vgui.Register("AInvSlot", PANEL, "DPanel")