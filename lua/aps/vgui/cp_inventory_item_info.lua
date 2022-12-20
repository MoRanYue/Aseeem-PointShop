local PANEL = {}

function PANEL:Init()
    self.item = {}
    
    self:SetSize(100, 100)
end

function PANEL:SetItem(item)
    self.item = item

    if IsValid(self.iconBg) then
        self.iconBg:Remove()
    end
    if IsValid(self.icon) then
        self.icon:Remove()
    end
    if IsValid(self.itemName) then
        self.itemName:Remove()
    end
    if IsValid(self.itemType) then
        self.itemType:Remove()
    end
    if IsValid(self.itemDesc) then
        self.itemDesc:Remove()
    end
    if IsValid(self.sell) then
        self.sell:Remove()
    end
    if IsValid(self.sellPrice) then
        self.sellPrice:Remove()
    end
    if IsValid(self.equip) then
        self.equip:Remove()
    end
    if IsValid(self.adjust) then
        self.adjust:Remove()
    end
    if !self.item then
        return
    end 

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
        draw.RoundedBox(8, 0, 0, w, h, ASEEEM_PS.theme.invItemIconBackgroundColor)
    end

    if self.item.show_pic then
        self.icon = self.iconBg:Add("DImage")
        self.icon:SetImage(self.item.show_pic, "vgui/avatar_default")
        self.icon:SetSize(200, 200)
    elseif self.item.show_mdl then
        self.icon = self.iconBg:Add("DModelPanel")
        self.icon:SetModel(self.item.show_mdl)
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

        -- self.icon.LayoutEntity = function(s, ent)
        --     return 
        -- end
    elseif self.item.show_txt then
        self.icon = self.iconBg:Add("DLabel")
        self.icon:SetFont("Roboto24")
        self.icon:SetText(self.item.show_txt)
        self.icon:SizeToContents()
        self.icon:SetPos(self.iconBg:GetWide()/2 - self.icon:GetWide()/2, self.iconBg:GetTall()/2 - self.icon:GetTall()/2)
    else
        self.icon = self.iconBg:Add("DLabel")
        self.icon:SetFont("Roboto24")
        self.icon:SetText("?")
        self.icon:SizeToContents()
        self.icon:SetPos(self.iconBg:GetWide()/2 - self.icon:GetWide()/2, self.iconBg:GetTall()/2 - self.icon:GetTall()/2)
    end

    self.itemDesc = self:Add("DLabel")
    self.itemDesc:SetColor(ASEEEM_PS.theme.invItemInfoDescColor)
    self.itemDesc:SetFont('JXZK24')
    self.itemDesc:SetContentAlignment(7)
    self.itemDesc:SetText(self.item.description)
    self.itemDesc:SetPos(self.iconBg:GetWide() + 20, self.iconBg:GetY())
    self.itemDesc:SetWrap(true)
    self.itemDesc:SetSize(self:GetWide() - self.itemDesc:GetX() - 10, self.iconBg:GetWide() - 5)

    self.sell = self:Add("AButton")
    self.sell:SetPos(self.iconBg:GetX(), self.iconBg:GetY() + self.iconBg:GetTall() + 20)
    self.sell:SetText("#ASEEEM_PS_sell")
    self.sell:SetBackgroundColor(ASEEEM_PS.theme.invItemInfoSellBtnBackgroundColor)
    self.sell:SetHoverColor(ASEEEM_PS.theme.invItemInfoSellBtnHoverColor)
    self.sell:SetColor(ASEEEM_PS.theme.invItemInfoSellBtnTextColor)
    self.sell:SetSize(self:GetWide() - self.iconBg:GetX()*2, 40)
    self.sell:ClickEvent(function(s)
        local function close()
            self.sell:Show()
            self.acceptSelling:Remove()
            self.cancelSell:Remove()
        end

        local x, y = self.iconBg:GetX(), self.iconBg:GetY() + self.iconBg:GetTall() + 20
        self.sell:Hide()
        self.acceptSelling = self:Add("AButton")
        self.acceptSelling:SetPos(x, y)
        self.acceptSelling:SetText('#ASEEEM_PS_acceptSell')
        self.acceptSelling:SetBackgroundColor(ASEEEM_PS.theme.shopItemInfoPointBuyBtnBackgroundColor)
        self.acceptSelling:SetSize(self:GetWide()/2 - x, s:GetTall())
        self.acceptSelling:ClickEvent(function(s)
            ASEEEM_PS.func.Net('itemOperation', false, 
                        { type = ASEEEM_PS.enums.NetType.INT, data = ASEEEM_PS.enums.ItemOperation.SELL },
                        { type = ASEEEM_PS.enums.NetType.TABLE, data = { self.item.class } })
            ASEEEM_PS.func.NetServer()
            
            timer.Simple(0.2, function()
                if ASEEEM_PS.business.success then
                    local itemTypeTemp = ASEEEM_PS.func.GetItemTypeByItem(self.item)
                    if itemTypeTemp.client and itemTypeTemp.client.on_sell then
                        itemTypeTemp.client.on_sell(ASEEEM_PS.func.GetItemByClass(self.item.class))
                    end
                end
            end)
            if !ASEEEM_PS.func.GetInventoryItemByClass(self.item.class) or ASEEEM_PS.func.GetInventoryItemByClass(self.item.class).amount <= 1 then
                self:ClosePanel()
            end
            
            close()
        end)

        self.cancelSell = self:Add("AButton")
        self.cancelSell:SetPos(x*2 + self.acceptSelling:GetWide(), y)
        self.cancelSell:SetText('#ASEEEM_PS_cancel')
        self.cancelSell:SetSize(self:GetWide()/2 - x*2, self.acceptSelling:GetTall())
        self.cancelSell:ClickEvent(function(s)
            close()
        end)
    end)

    self.sellPrice = self:Add("APoint")
    self.sellPrice:SetMat(ASEEEM_PS.theme.matPoint)
    self.sellPrice:SetPoint(math.floor(self.item.price*ASEEEM_PS.data.itemSoldMultiplier))
    self.sellPrice:SetPos(self.sell:GetX(), self.sell:GetY() + self.sell:GetTall() + 10)

    self.itemType = self:Add("DLabel")
    self.itemType:SetFont("Roboto24")
    self.itemType:SetText(string.format(language.GetPhrase("ASEEEM_PS_itemType"), ASEEEM_PS.data.itemTypes[self.item.type].display))
    self.itemType:SizeToContents()
    self.itemType:SetPos(self.sellPrice:GetX() + self.sellPrice:GetWide() + 10, self.sellPrice:GetY() + self.itemType:GetTall()/3)

    if self.item.equipable then
        self.equip = self:Add("AButton")
        self.equip:SetPos(self.sellPrice:GetX(), self.sellPrice:GetY() + self.sellPrice:GetTall() + 20)
        self.equip:SetSize(self.sell:GetWide(), self.sell:GetTall())
        local itm = ASEEEM_PS.func.GetInventoryItemByClass(self.item.class)
        if itm and itm.equipped then
            self.equip:SetText("#ASEEEM_PS_unequip")
            self.equip:ClickEvent(function(s)
                ASEEEM_PS.func.Net('itemOperation', false, 
                        { type = ASEEEM_PS.enums.NetType.INT, data = ASEEEM_PS.enums.ItemOperation.UNEQUIP },
                        { type = ASEEEM_PS.enums.NetType.TABLE, data = { self.item.class } })
                ASEEEM_PS.func.NetServer()

                timer.Simple(0.2, function()
                    if ASEEEM_PS.business.success then
                        local itemTypeTemp = ASEEEM_PS.func.GetItemTypeByItem(self.item)
                        if itemTypeTemp.client and itemTypeTemp.client.on_unequip then
                            itemTypeTemp.client.on_unequip(ASEEEM_PS.func.GetItemByClass(self.item.class), ASEEEM_PS.func.GetInventoryItemByClass(self.item.class))
                        end
                    end

                    self:SetItem(ASEEEM_PS.func.GetItemByClass(self.item.class))
                end)
            end)
        else
            self.equip:SetText("#ASEEEM_PS_equip")
            self.equip:ClickEvent(function(s)
                ASEEEM_PS.func.Net('itemOperation', false, 
                        { type = ASEEEM_PS.enums.NetType.INT, data = ASEEEM_PS.enums.ItemOperation.EQUIP },
                        { type = ASEEEM_PS.enums.NetType.TABLE, data = { self.item.class } })
                ASEEEM_PS.func.NetServer()

                timer.Simple(0.2, function()
                    if ASEEEM_PS.business.success then
                        local itemTypeTemp = ASEEEM_PS.func.GetItemTypeByItem(self.item)
                        if itemTypeTemp.client and itemTypeTemp.client.on_equip then
                            itemTypeTemp.client.on_equip(ASEEEM_PS.func.GetItemByClass(self.item.class), ASEEEM_PS.func.GetInventoryItemByClass(self.item.class))
                        end
                    end

                    self:SetItem(ASEEEM_PS.func.GetItemByClass(self.item.class))
                end)

                if self.item.disposable then
                    self:ClosePanel()
                end
            end)
        end
    end

    if self.item.adjustable then
        self.adjust = self:Add("AButton")
        self.adjust:SetPos(self.sellPrice:GetX(), self.sellPrice:GetY() + self.sellPrice:GetTall() + self.sell:GetTall() + 40)
        self.adjust:SetSize(self.sell:GetWide(), self.sell:GetTall())
        self.adjust:SetText("#ASEEEM_PS_adjust")
        self.adjust:ClickEvent(function(s)
            if IsValid(self.adjustWindow) then
                self.adjustWindow:Remove()
            end
            self.adjustWindow = vgui.Create("AItemAdjust")
            self.adjustWindow:SetItem(self.item)
            self.adjustWindow:MakePopup(true)
        end)
    end
end

function PANEL:Paint(w, h)
    draw.RoundedBox(13, 0, 0, w + 13, h - 10, ASEEEM_PS.theme.invItemInfoBackgroundColor)

    if self.item and ASEEEM_PS.func.GetInventoryItemByClass(self.item.class) then
        draw.SimpleText(string.format(language.GetPhrase("ASEEEM_PS_youHave"), ASEEEM_PS.func.GetInventoryItemByClass(self.item.class).amount), "JXZK24", self.itemName:GetWide() + self.itemName:GetX() + 10, self.itemName:GetTall() + self.itemName:GetY() - 24, ASEEEM_PS.theme.invItemAmountTextColor)
    end

    if ASEEEM_PS.business.success then
        draw.SimpleText('#ASEEEM_PS_itemOpSuccess', 'JXZK24', w/2, h - 48, ASEEEM_PS.theme.invItemInfoDescColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    elseif ASEEEM_PS.business.success == false then
        draw.SimpleText('#ASEEEM_PS_itemOpFailed', 'JXZK24', w/2, h - 48, ASEEEM_PS.theme.invItemInfoDescColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.SimpleText(ASEEEM_PS.business.error, 'JXZK24', w/2, h - 24, ASEEEM_PS.theme.invItemInfoDescColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
end

function PANEL:ClosePanel()
    self:Remove()
end

vgui.Register("AInvItemInfo", PANEL, 'DPanel')