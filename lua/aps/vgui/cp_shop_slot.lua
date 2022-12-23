local PANEL = {}

function PANEL:Init()
    self.shopItem = {}

    self.coords = { x = 0, y = 0 }
    self:SetSize(140, 200)

    local iconBg = self:Add("DPanel")
    iconBg:SetPaintBackground(false)
    iconBg:SetSize(self:GetWide(), self:GetTall() - 50)
    iconBg.Paint = function(s, w, h)
        draw.RoundedBox(8, 0, 0, w, h, ASEEEM_PS.theme.shopItemIconBackgroundColor)
    end

    self.btn = self:Add("DButton")
    self.btn:SetText('')
    self.btn:SetSize(self:GetWide(), self:GetTall())
    self.btn.item = self.shopItem
    self.btn.Paint = function(s, w, h)
        return true
    end
    self.btn.active = false
end

function PANEL:Paint(w, h)
    --背景颜色
    if self.btn:IsHovered() then
        draw.RoundedBox(8, 0, 0, w, h, ASEEEM_PS.theme.shopItemHoverBackgroundColor)
    elseif self.btn.active then
        draw.RoundedBox(8, 0, 0, w, h, ASEEEM_PS.theme.shopItemActiveBackgroundColor)
    else
        draw.RoundedBox(8, 0, 0, w, h, ASEEEM_PS.theme.shopItemBackgroundColor)
    end
end

function PANEL:Think()
end

function PANEL:SetCoords(x, y)
    self.coords = { x = x, y = y }
end

function PANEL:GetCoords()
    return self.coords
end

function PANEL:GetItem()
    return self.shopItem
end

function PANEL:SetItem(item)
    self.shopItem = item
    self.btn.item = item

    if IsValid(self.icon) then
        self.icon:Remove()
    end
    if IsValid(self.itemName) then
        self.itemName:Remove()
    end
    if IsValid(self.price) then
        self.price:Remove()
    end
    if IsValid(self.pro_price) then
        self.pro_price:Remove()
    end

    if self.shopItem.show_pic then
        self.icon = self:Add("DImage")
        self.icon:SetImage(self.shopItem.show_pic, "vgui/avatar_default")
        self.icon:SetPos(0, 0)
        self.icon:SetSize(self:GetWide(), self:GetTall() - 50)
    elseif self.shopItem.show_mdl then
        self.icon = self:Add("DModelPanel")
        self.icon:SetModel(self.shopItem.show_mdl)
        self.icon:SetPos(0, 0)
        self.icon:SetSize(self:GetWide(), self:GetTall() - 50)
        self.icon:SetDisabled(false)

        local mn, mx = self.icon.Entity:GetRenderBounds()
        local size = 0
        size = math.max( size, math.abs(mn.x) + math.abs(mx.x) )
        size = math.max( size, math.abs(mn.y) + math.abs(mx.y) )
        size = math.max( size, math.abs(mn.z) + math.abs(mx.z) )
        self.icon:SetFOV(50)
        self.icon:SetCamPos(Vector(size, size, size))
        self.icon:SetLookAt((mn + mx) * 0.5)
        self.icon:SetMouseInputEnabled(false)
    elseif self.shopItem.show_txt then
        self.icon = self:Add("DLabel")
        self.icon:SetContentAlignment(5)
        -- self.icon:SetWrap(true)
        self.icon:SetFont("Roboto24")
        self.icon:SetText(self.shopItem.show_txt)
        self.icon:SetSize(self:GetWide(), self:GetTall() - 50)
        -- self.icon.Paint = function(s, w, h)
            -- draw.RoundedBox(0, 0, 0, w, h, color_white)
        -- end
        -- self.icon:SizeToContents()
        -- self.icon:SetPos(self:GetWide()/2 - self.icon:GetWide()/2, (self:GetTall() - 50)/2 - self.icon:GetTall()/2)
    else
        self.icon = self:Add("DLabel")
        self.icon:SetFont("Roboto24")
        self.icon:SetText('?')
        self.icon:SizeToContents()
        self.icon:SetPos(self:GetWide()/2 - self.icon:GetWide()/2, (self:GetTall() - 50)/2 - self.icon:GetTall()/2)
    end

    self.itemName = self:Add("DLabel")
    self.itemName:SetFont('JXZK18')
    self.itemName:SetText(self.shopItem.name)
    self.itemName:SizeToContents()
    self.itemName:SetPos(self:GetWide()/2 - self.itemName:GetWide()/2, self:GetTall() - 25 - self.itemName:GetTall()/2)

    if self.shopItem.price > 0 then
        self.price = self:Add("DLabel")
        self.price:SetFont('Roboto16')
        self.price:SetText(string.format(language.GetPhrase('ASEEEM_PS_price'), self.shopItem.price))
        self.price:SizeToContents()
        self.price:SetPos(self:GetWide()/2 - self.price:GetWide()/2, 0)

        if self.shopItem.pro_price > 0 then
            self.pro_price = self:Add("DLabel")
            self.pro_price:SetFont('Roboto16')
            self.pro_price:SetText(string.format(language.GetPhrase('ASEEEM_PS_proPrice'), self.shopItem.pro_price))
            self.pro_price:SizeToContents()
            self.pro_price:SetPos(self:GetWide()/2 - self.pro_price:GetWide()/2, self.price:GetTall())
        end
    else
        if self.shopItem.pro_price > 0 then
            self.pro_price = self:Add("DLabel")
            self.pro_price:SetFont('Roboto16')
            self.pro_price:SetText(string.format(language.GetPhrase('ASEEEM_PS_proPrice'), self.shopItem.pro_price))
            self.pro_price:SizeToContents()
            self.pro_price:SetPos(self:GetWide()/2 - self.pro_price:GetWide()/2, 0)
        else 
            self.price = self:Add("DLabel")
            self.price:SetFont('Roboto16')
            self.price:SetText('#ASEEEM_PS_free')
            self.price:SizeToContents()
            self.price:SetPos(self:GetWide()/2 - self.price:GetWide()/2, 0)
        end
    end
end

vgui.Register('AShopSlot', PANEL, 'DPanel')