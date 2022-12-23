local PANEL = {}

function PANEL:Init()
    self.item = {}

    self:SetSize(100, 100)

    local closeBtn = self:Add("DButton")
    closeBtn:SetSize(30, 30)
    closeBtn:SetText('')
    closeBtn.Think = function(s)
        closeBtn:SetPos(self:GetWide() - closeBtn:GetWide() - ASEEEM_PS.theme.closeBtnRight, ASEEEM_PS.theme.closeBtnTop)
    end
    closeBtn.Paint = function(s, w, h)
        draw.RoundedBox(5, 0, 0, w, h, ASEEEM_PS.theme.btnBackgroundColor)
        
        surface.SetDrawColor(HSVToColor((CurTime()*ASEEEM_PS.theme.rainbowBtnColorSpeed) % 360, 1, 1))
        surface.SetMaterial(ASEEEM_PS.theme.matDisable)
        surface.DrawTexturedRect(0, 0, w, h)
    end
    closeBtn.DoClick = function(s)
        self:ClosePanel()
    end
end

function PANEL:Paint(w, h)
    draw.RoundedBox(20, 0, 0, w + 20, h - 10, ASEEEM_PS.theme.shopItemInfoBackgroundColor)

    --购买成功、失败提示
    if ASEEEM_PS.business.success then
        draw.SimpleText('#ASEEEM_PS_itemOpSuccess', 'JXZK24', w/2, h - 48, ASEEEM_PS.theme.shopItemInfoDescColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    elseif ASEEEM_PS.business.success == false then
        draw.SimpleText('#ASEEEM_PS_itemOpFailed', 'JXZK24', w/2, h - 48, ASEEEM_PS.theme.shopItemInfoDescColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.SimpleText(ASEEEM_PS.business.error, 'JXZK24', w/2, h - 24, ASEEEM_PS.theme.shopItemInfoDescColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
end

function PANEL:SetItem(item)
    self.item = item

    if IsValid(self.iconBg) then
        self.iconBg:Remove()
    end
    if IsValid(self.itemName) then
        self.itemName:Remove()
    end
    if IsValid(self.itemDesc) then
        self.itemDesc:Remove()
    end
    if IsValid(self.buy) then
        self.buy:Remove()
    end
    if IsValid(self.price) then
        self.price:Remove()
    end
    if IsValid(self.proPrice) then
        self.proPrice:Remove()
    end
    if IsValid(self.purchasableHint) then
        self.purchasableHint:Remove()
    end
    if !self.item then
        return end

    self.itemName = self:Add("DLabel")
    self.itemName:SetFont("Roboto36")
    self.itemName:SetText(self.item.name)
    self.itemName:SizeToContents()
    self.itemName:SetPos(ASEEEM_PS.theme.titleLeft, ASEEEM_PS.theme.titleTop)

    self.iconBg = self:Add('DPanel')
    self.iconBg:SetPos(ASEEEM_PS.theme.titleLeft, ASEEEM_PS.theme.titleTop + self.itemName:GetTall() + ASEEEM_PS.theme.headerBottom)
    self.iconBg:SetSize(200, 200)
    self.iconBg:SetPaintBackground(false)
    self.iconBg.Paint = function(s, w, h)
        draw.RoundedBox(8, 0, 0, w, h, ASEEEM_PS.theme.shopItemIconBackgroundColor)
    end

    if self.item.show_pic then
        self.icon = self.iconBg:Add("DImage")
        self.icon:SetImage(self.item.show_pic, "vgui/avatar_default")
        -- self.icon:SetPos(ASEEEM_PS.theme.titleLeft, ASEEEM_PS.theme.titleTop + self.itemName:GetTall() + ASEEEM_PS.theme.headerBottom)
        self.icon:SetSize(200, 200)
    elseif self.item.show_mdl then
        self.icon = self.iconBg:Add("DModelPanel")
        self.icon:SetModel(self.item.show_mdl)
        -- self.icon:SetPos(ASEEEM_PS.theme.titleLeft, ASEEEM_PS.theme.titleTop + self.itemName:GetTall() + ASEEEM_PS.theme.headerBottom)
        self.icon:SetSize(200, 200)

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
        self.icon = self.iconBg:Add("DLabel")
        self.icon:SetSize(self.iconBg:GetWide(), self.iconBg:GetTall())
        self.icon:SetContentAlignment(5)
        -- self.icon:SetWrap(true)
        self.icon:SetFont("Roboto24")
        self.icon:SetText(self.item.show_txt)
        -- self.icon:SizeToContents()
        -- self.icon:SetPos(self.iconBg:GetWide()/2 - self.icon:GetWide()/2, self.iconBg:GetTall()/2 - self.icon:GetTall()/2)
    else
        self.icon = self.iconBg:Add("DLabel")
        self.icon:SetFont("Roboto24")
        self.icon:SetText('?')
        self.icon:SizeToContents()
        self.icon:SetPos(self.iconBg:GetWide()/2 - self.icon:GetWide()/2, self.iconBg:GetTall()/2 - self.icon:GetTall()/2)
    end

    self.itemDesc = self:Add("DLabel")
    self.itemDesc:SetColor(ASEEEM_PS.theme.shopItemInfoDescColor)
    self.itemDesc:SetFont('JXZK24')
    self.itemDesc:SetContentAlignment(7)
    self.itemDesc:SetWrap(true)
    self.itemDesc:SetText(self.item.description)
    self.itemDesc:SetPos(self.iconBg:GetWide() + 20, self.iconBg:GetY())
    self.itemDesc:SetSize(self:GetWide() - self.itemDesc:GetX() - 10, self.iconBg:GetWide() - 5)

    self.buy = self:Add("AButton")
    self.buy:SetPos(self.iconBg:GetX(), self.iconBg:GetY() + self.iconBg:GetTall() + 20)
    self.buy:SetText("#ASEEEM_PS_buy")
    self.buy:SetBackgroundColor(ASEEEM_PS.theme.shopItemInfoBuyBtnBackgroundColor)
    self.buy:SetHoverColor(ASEEEM_PS.theme.shopItemInfoBuyBtnHoverColor)
    self.buy:SetSize(self:GetWide() - self.iconBg:GetX()*2, 40)
    self.buy:ClickEvent(function(s)
        local function close()
            self.buy:Show()
            if IsValid(self.proPointBuy) then
                self.proPointBuy:Remove()
            end
            self.pointBuy:Remove()
            self.cancelBuy:Remove()
        end

        --让玩家选择使用哪种货币
        local x, y = self.iconBg:GetX(), self.iconBg:GetY() + self.iconBg:GetTall() + 20
        self.buy:Hide()
        self.pointBuy = self:Add("AButton")
        self.pointBuy:SetPos(x, y)
        self.pointBuy:SetText('#ASEEEM_PS_buyUsePoint')
        self.pointBuy:SetBackgroundColor(ASEEEM_PS.theme.shopItemInfoPointBuyBtnBackgroundColor)
        self.pointBuy:SetSize(self:GetWide()/3 - x, s:GetTall())
        self.pointBuy:ClickEvent(function(s)
            ASEEEM_PS.func.Net('itemOperation', false, 
                        { type = ASEEEM_PS.enums.NetType.INT, data = ASEEEM_PS.enums.ItemOperation.BUY },
                        { type = ASEEEM_PS.enums.NetType.TABLE, data = { ASEEEM_PS.enums.PointType.POINT, self.item.class } })
            ASEEEM_PS.func.NetServer()
            close()
        end)

        if self.item.pro_price > 0 then
            self.proPointBuy = self:Add("AButton")
            self.proPointBuy:SetPos(x*2 + self.pointBuy:GetWide(), y)
            self.proPointBuy:SetText('#ASEEEM_PS_buyUseProPoint')
            self.proPointBuy:SetBackgroundColor(ASEEEM_PS.theme.shopItemInfoProPointBuyBtnBackgroundColor)
            self.proPointBuy:SetSize(self:GetWide()/3 - x, self.pointBuy:GetTall())
            self.proPointBuy:ClickEvent(function(s)
                ASEEEM_PS.func.Net('itemOperation', false, 
                            { type = ASEEEM_PS.enums.NetType.INT, data = ASEEEM_PS.enums.ItemOperation.BUY },
                            { type = ASEEEM_PS.enums.NetType.TABLE, data = { ASEEEM_PS.enums.PointType.PROPOINT, self.item.class } })
                ASEEEM_PS.func.NetServer()
                close()
            end)
        else
            self.pointBuy:SetWide(self:GetWide()/3*2 - x)
        end

        self.cancelBuy = self:Add("AButton")
        if IsValid(self.proPointBuy) then
            self.cancelBuy:SetPos(x*3 + self.pointBuy:GetWide() + self.proPointBuy:GetWide(), y)
        else
            self.cancelBuy:SetPos(x*2 + self.pointBuy:GetWide(), y)
        end
        self.cancelBuy:SetText('#ASEEEM_PS_cancel')
        -- self.cancelBuy:SetBackgroundColor(ASEEEM_PS.theme.shopItemInfoProPointBuyBtnBackgroundColor)
        self.cancelBuy:SetSize(self:GetWide()/3 - x*2, self.pointBuy:GetTall())
        self.cancelBuy:ClickEvent(function(s)
            close()
        end)
    end)

    self.price = self:Add("APoint")
    self.price:SetMat(ASEEEM_PS.theme.matPoint)
    self.price:SetPoint(self.item.price)
    self.price:SetPos(self.buy:GetX(), self.buy:GetY() + self.buy:GetTall() + 10)
    -- self.price:SetBgColor(ASEEEM_PS.theme.shopItemInfoBuyBtnBackgroundColor)

    self.proPrice = self:Add("APoint")
    self.proPrice:SetMat(ASEEEM_PS.theme.matProPoint)
    self.proPrice:SetPoint(self.item.pro_price)
    self.proPrice:SetPos(self.buy:GetX() + self.buy:GetWide() - self.proPrice:GetWide(), self.price:GetY())

    self.purchasableHint = self:Add("DLabel")
    self.purchasableHint:SetColor(ASEEEM_PS.theme.shopItemInfoHintTextColor)
    if ASEEEM_PS.func.GetNW(LocalPlayer(), 'point') < self.item.price and ASEEEM_PS.func.GetNW(LocalPlayer(), 'proPoint') < self.item.pro_price then
        self.purchasableHint:SetText("#ASEEEM_PS_youCantBuyThis")
        self.buy:SetDisabled(true)
    elseif ASEEEM_PS.func.GetNW(LocalPlayer(), 'proPoint') < self.item.pro_price and self.item.pro_point != 0 then
        self.purchasableHint:SetText(string.format(language.GetPhrase("ASEEEM_PS_AfterBuyingThisYouHavePoint"), ASEEEM_PS.func.GetNW(LocalPlayer(), 'point') - self.item.price))
    elseif self.item.point != 0 and self.item.pro_point != 0 then
        self.purchasableHint:SetText(string.format(language.GetPhrase("ASEEEM_PS_AfterBuyingThisYouHave"), ASEEEM_PS.func.GetNW(LocalPlayer(), 'point') - self.item.price, ASEEEM_PS.func.GetNW(LocalPlayer(), 'proPoint') - self.item.pro_price))
    end
    self.purchasableHint:SizeToContents()
    self.purchasableHint:SetPos(self:GetWide()/2 - self.purchasableHint:GetWide()/2, self.price:GetY())

    local cl = LocalPlayer()

    if next(ASEEEM_PS.data.inventory) then
        if IsValid(self.invHint) then
            self.invHint:Remove()
        end

        self.invHint = self:Add("DLabel")
        self.invHint:SetColor(ASEEEM_PS.theme.shopItemInfoHintTextColor)
        self.invHint:SetFont('Roboto16')
        local itm = ASEEEM_PS.func.GetInventoryItemByClass(self.item.class)
        if itm then
            self.invHint:SetText(string.format(language.GetPhrase('ASEEEM_PS_yourInventoryAlreadyHave'), itm.amount))
        else 
            self.invHint:SetText('')
        end
        self.invHint:SizeToContents()
        self.invHint.Think = function(s)
            if ASEEEM_PS.business.success then
                local itm = ASEEEM_PS.func.GetInventoryItemByClass(self.item.class)
                if itm then
                    self.invHint:SetText(string.format(language.GetPhrase('ASEEEM_PS_yourInventoryAlreadyHave'), itm.amount))
                else 
                    self.invHint:SetText('')
                end
                self.invHint:SizeToContents()
            end
        end
        self.invHint:SetPos(self.itemDesc:GetX(), self.itemDesc:GetY() + self.itemDesc:GetTall() + 2)
    end
end

function PANEL:ClosePanel()
    self:Remove()
end

vgui.Register('AShopItemInfo', PANEL, 'DPanel')