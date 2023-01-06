local PANEL = {}

function PANEL:Init()
    self.item = {}
    self.isAnimating = true
    self.options = {}

    local frameW, frameH, animTime, animDelay, animEase = ScrW()*.3, ScrH()*.4, 1, 0, .1
    self:SetDraggable(true)
    self:SetTitle('')
    self:ShowCloseButton(false)
    self:SetSize(0, 0)
    self:Center()
    self:SizeTo(frameW, frameH, animTime, animDelay, animEase, function()
        self.isAnimating = false
    end)

    self.panel = self:Add("DPanel")
    self.panel:SetPaintBackground(false)
    self.panel.Think = function(s)
        if self.isAnimating then
            s:SetSize(self:GetWide(), self:GetTall() - s:GetY())
            s:SetPos(0, ASEEEM_PS.theme.headerTop + ASEEEM_PS.theme.headerBottom + ASEEEM_PS.theme.headerFill)
        end
    end
end

function PANEL:Paint(w, h)
    surface.SetDrawColor(ASEEEM_PS.theme.invItemAdjustBackgroundColor)
    surface.DrawRect(0, 0, w, h)

    draw.SimpleText("#ASEEEM_PS_adjustTitle", 'JXZK24', ASEEEM_PS.theme.titleTop, ASEEEM_PS.theme.titleLeft, ASEEEM_PS.theme.titleColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
end

function PANEL:SetItem(item)
    self.item = item
    self.invItem = ASEEEM_PS.func.GetInventoryItemByClass(self.item.class)
    for _, v in pairs(self.options) do
        if IsValid(v) then
            v:Remove()
        end
    end
    if IsValid(self.optScroll) then
        self.optScroll:Remove()
    end
    if IsValid(self.accept) then
        self.accept:Remove()
    end
    if !self.item or !self.invItem then
        return
    end

    self.options = {}
    self.optScroll = self.panel:Add("DScrollPanel")
    self.optScroll:SetPos(3, 0)
    self.optScroll.Paint = function(s, w, h)
        draw.RoundedBox(12, 0, 0, w, h, ASEEEM_PS.theme.invItemAdjustOptionsBackgroundColor)
    end
    self.optScroll.Think = function(s)
        if self.isAnimating then
            s:SetSize(self.panel:GetWide() - s:GetX()*2, self.panel:GetTall() - 50)
        end
    end
    local optScrollVBar = self.optScroll:GetVBar()
    optScrollVBar:SetHideButtons(true)
    optScrollVBar.Paint = function(s, w, h)
        draw.RoundedBox(7, 0, 0, w, h, ASEEEM_PS.theme.invItemAdjustVBarBackgroundColor)
    end
    optScrollVBar.btnGrip.Paint = function(s, w, h)
        draw.RoundedBox(7, 0, 0, w, h, ASEEEM_PS.theme.invItemAdjustVBarColor)
    end

    local itemType = ASEEEM_PS.data.itemTypes[self.item.type]
    if itemType.adjust_options then
        for k, v in pairs(itemType.adjust_options) do
            local pnl = self.optScroll:Add("DPanel")
            pnl:SetPaintBackground(false)
            pnl:Dock(TOP)
            pnl.Think = function(s)
                if self.isAnimating then
                    s:SetSize(self.optScroll:GetWide(), 30)
                end
            end

            local name = pnl:Add("DLabel")
            name:SetFont("JXZK24")
            name:SetText(v.name)
            name:SizeToContents()
            name.Think = function(s)
                if self.isAnimating then
                    s:SetPos(0, pnl:GetTall()/2 - s:GetTall()/2)
                end
            end
            if v.type == ASEEEM_PS.enums.AdjustType.INPUT then
                local inp = pnl:Add("DTextEntry")
                inp:SetValue(v.default)
                inp:SetEnterAllowed(false)
                if self.invItem.data[k] then
                    inp:SetValue(tostring(self.invItem.data[k]))
                end
                inp.Think = function(s)
                    if self.isAnimating then
                        s:SetSize(pnl:GetWide() - name:GetWide(), pnl:GetTall())
                        s:SetPos(name:GetWide() + 2, 0)
                    end
                end
            elseif v.type == ASEEEM_PS.enums.AdjustType.CHECKBOX then
                local inp = pnl:Add("DCheckBox")
                inp:SetChecked(v.default)
                if self.invItem.data[k] then
                    inp:SetValue(self.invItem.data[k])
                end
                inp.Think = function(s)
                    if self.isAnimating then
                        s:SetSize(pnl:GetTall(), pnl:GetTall())
                        s:SetPos(name:GetWide() + 2, 0)
                    end
                end
            elseif v.type == ASEEEM_PS.enums.AdjustType.VECTOR then
                local dx, dy, dz = v.default.x, v.default.y, v.default.z

                -- inpX:SetPaintBackground(false)
                -- inpY:SetPaintBackground(false)
                -- inpZ:SetPaintBackground(false)

                local inpX = pnl:Add("DTextEntry")
                -- inpX:SetPlaceholderColor(ASEEEM_PS.theme.invItemAdjustOptionsInpPlaceHolderColor)
                inpX:SetPlaceholderText("X")
                inpX:SetNumeric(true)
                inpX.Think = function(s)
                    if self.isAnimating then
                        s:SetSize((pnl:GetWide() - name:GetWide() - 2)/3, pnl:GetTall())
                        s:SetPos(name:GetWide() + 2, 0)
                    end
                end

                local inpY = pnl:Add("DTextEntry")
                -- inpY:SetPlaceholderColor(ASEEEM_PS.theme.invItemAdjustOptionsInpPlaceHolderColor)
                inpY:SetPlaceholderText("Y")
                inpY:SetNumeric(true)
                inpY.Think = function(s)
                    if self.isAnimating then
                        s:SetSize((pnl:GetWide() - name:GetWide() - 2)/3, pnl:GetTall())
                        s:SetPos(inpX:GetWide() + inpX:GetX() + 2, 0)
                    end
                end

                local inpZ = pnl:Add("DTextEntry")
                -- inpZ:SetPlaceholderColor(ASEEEM_PS.theme.invItemAdjustOptionsInpPlaceHolderColor)
                inpZ:SetPlaceholderText("Z")
                inpZ:SetNumeric(true)
                inpZ.Think = function(s)
                    if self.isAnimating then
                        s:SetSize((pnl:GetWide() - name:GetWide() - 2)/3, pnl:GetTall())
                        s:SetPos(inpY:GetWide() + inpY:GetX() + 2, 0)
                    end
                end
                
                if self.invItem.data[k] then
                    local cx, cy, cz = self.invItem.data[k].x, self.invItem.data[k].y, self.invItem.data[k].z
                    inpX:SetValue(tostring(cx))
                    inpY:SetValue(tostring(cy))
                    inpZ:SetValue(tostring(cz))
                else
                    inpX:SetValue(tostring(dx) or '0')
                    inpY:SetValue(tostring(dy) or '0')
                    inpZ:SetValue(tostring(dz) or '0')
                end
            elseif v.type == ASEEEM_PS.enums.AdjustType.ANGLE then
                local dp, dy, dr = v.default.p, v.default.y, v.default.r

                local inpX = pnl:Add("DTextEntry")
                -- inpX:SetPlaceholderColor(ASEEEM_PS.theme.invItemAdjustOptionsInpPlaceHolderColor)
                inpX:SetPlaceholderText("Pitch")
                inpX:SetNumeric(true)
                inpX.Think = function(s)
                    if self.isAnimating then
                        s:SetSize((pnl:GetWide() - name:GetWide() - 2)/3, pnl:GetTall())
                        s:SetPos(name:GetWide() + 2, 0)
                    end
                end

                local inpY = pnl:Add("DTextEntry")
                -- inpY:SetPlaceholderColor(ASEEEM_PS.theme.invItemAdjustOptionsInpPlaceHolderColor)
                inpY:SetPlaceholderText("Yaw")
                inpY:SetNumeric(true)
                inpY.Think = function(s)
                    if self.isAnimating then
                        s:SetSize((pnl:GetWide() - name:GetWide() - 2)/3, pnl:GetTall())
                        s:SetPos(inpX:GetWide() + inpX:GetX() + 2, 0)
                    end
                end

                local inpZ = pnl:Add("DTextEntry")
                -- inpZ:SetPlaceholderColor(ASEEEM_PS.theme.invItemAdjustOptionsInpPlaceHolderColor)
                inpZ:SetPlaceholderText("Roll")
                inpZ:SetNumeric(true)
                inpZ.Think = function(s)
                    if self.isAnimating then
                        s:SetSize((pnl:GetWide() - name:GetWide() - 2)/3, pnl:GetTall())
                        s:SetPos(inpY:GetWide() + inpY:GetX() + 2, 0)
                    end
                end
                
                if self.invItem.data[k] then
                    local cp, cy, cr = self.invItem.data[k].p, self.invItem.data[k].y, self.invItem.data[k].r
                    inpX:SetValue(tostring(cp))
                    inpY:SetValue(tostring(cy))
                    inpZ:SetValue(tostring(cr))
                else
                    inpX:SetValue(tostring(dp) or '1')
                    inpY:SetValue(tostring(dy) or '1')
                    inpZ:SetValue(tostring(dr) or '1')
                end
            elseif v.type == ASEEEM_PS.enums.AdjustType.COLOR then
                local dr, dg, db, da = v.default.r, v.default.g, v.default.b, v.default.a
                local inpR = pnl:Add("DTextEntry")
                local inpG = pnl:Add("DTextEntry")
                local inpB = pnl:Add("DTextEntry")
                local inpA = pnl:Add("DTextEntry")
                inpR:SetNumeric(true)
                inpG:SetNumeric(true)
                inpB:SetNumeric(true)
                inpA:SetNumeric(true)
                -- inpR:SetPlaceholderColor(ASEEEM_PS.theme.invItemAdjustOptionsInpPlaceHolderColor)
                -- inpG:SetPlaceholderColor(ASEEEM_PS.theme.invItemAdjustOptionsInpPlaceHolderColor)
                -- inpB:SetPlaceholderColor(ASEEEM_PS.theme.invItemAdjustOptionsInpPlaceHolderColor)
                -- inpA:SetPlaceholderColor(ASEEEM_PS.theme.invItemAdjustOptionsInpPlaceHolderColor)
                inpR:SetPlaceholderText("R")
                inpG:SetPlaceholderText("G")
                inpB:SetPlaceholderText("B")
                inpA:SetPlaceholderText("A")
                inpR:SetValue(tostring(dr) or '0')
                inpG:SetValue(tostring(dg) or '0')
                inpB:SetValue(tostring(db) or '0')
                inpA:SetValue(tostring(da) or '255')
                if self.invItem.data[k] then
                    inpR:SetValue(tostring(self.invItem.data[k].r))
                    inpG:SetValue(tostring(self.invItem.data[k].g))
                    inpB:SetValue(tostring(self.invItem.data[k].b))
                    inpA:SetValue(tostring(self.invItem.data[k].a or 255))
                end
                inpR.Think = function(s)
                    if self.isAnimating then
                        s:SetSize((pnl:GetWide() - name:GetWide() - 2)/4, pnl:GetTall())
                        s:SetPos(name:GetWide() + 2, 0)
                    end
                end
                inpG.Think = function(s)
                    if self.isAnimating then
                        s:SetSize((pnl:GetWide() - name:GetWide() - 2)/4, pnl:GetTall())
                        s:SetPos(inpR:GetWide() + inpR:GetX() + 2, 0)
                    end
                end
                inpB.Think = function(s)
                    if self.isAnimating then
                        s:SetSize((pnl:GetWide() - name:GetWide() - 2)/4, pnl:GetTall())
                        s:SetPos(inpG:GetWide() + inpG:GetX() + 2, 0)
                    end
                end
                inpA.Think = function(s)
                    if self.isAnimating then
                        s:SetSize((pnl:GetWide() - name:GetWide() - 2)/4, pnl:GetTall())
                        s:SetPos(inpB:GetWide() + inpB:GetX() + 2, 0)
                    end
                end
            elseif v.type == ASEEEM_PS.enums.AdjustType.SELECT then
                local inp = pnl:Add("DComboBox")
                inp:SetValue(v.default)
                if self.invItem.data[k] then
                    inp:SetValue(self.invItem.data[k])
                end
                inp.Think = function(s)
                    if self.isAnimating then
                        s:SetSize(pnl:GetWide() - name:GetWide(), pnl:GetTall())
                        s:SetPos(name:GetWide() + 2, 0)
                    end
                end
                for k, v in pairs(v.select_choice) do
                    inp:AddChoice(v, k)
                end
            end

            table.insert(self.options, pnl)
        end

        --确定
        self.accept = self.panel:Add("AButton")
        self.accept.Think = function(s)
            if self.isAnimating then
                s:SetSize(self.panel:GetWide() - 10, 40)
                s:SetPos(5, self.panel:GetTall() - s:GetTall() - 5)
            end
        end
        self.accept:SetText("确定")
        self.accept:ClickEvent(function(s)
            self:CloseFrame()

            local data = {}
            local temp
            for k, v in pairs(itemType.adjust_options) do
                if v.type == ASEEEM_PS.enums.AdjustType.INPUT then
                    temp = self.options[k]:GetChild(1):GetText()
                elseif v.type == ASEEEM_PS.enums.AdjustType.CHECKBOX then
                    temp = self.options[k]:GetChild(1):GetChecked()
                elseif v.type == ASEEEM_PS.enums.AdjustType.VECTOR then
                    local px, py, pz = self.options[k]:GetChild(1):GetText(), self.options[k]:GetChild(2):GetText(), self.options[k]:GetChild(3):GetText()
                    temp = Vector(tonumber(px), tonumber(py), tonumber(pz))
                elseif v.type == ASEEEM_PS.enums.AdjustType.ANGLE then
                    local pp, py, pr = self.options[k]:GetChild(1):GetText(), self.options[k]:GetChild(2):GetText(), self.options[k]:GetChild(3):GetText()
                    temp = Angle(tonumber(pp), tonumber(py), tonumber(pr))
                elseif v.type == ASEEEM_PS.enums.AdjustType.COLOR then
                    local pr, pg, pb, pa = self.options[k]:GetChild(1):GetText(), self.options[k]:GetChild(2):GetText(), self.options[k]:GetChild(3):GetText(), self.options[k]:GetChild(4):GetText()
                    temp = Color(tonumber(pr), tonumber(pg), tonumber(pb), tonumber(pa))
                elseif v.type == ASEEEM_PS.enums.AdjustType.SELECT then
                    _, temp = self.options[k]:GetChild(1):GetSelected()
                end
    
                table.insert(data, temp)
            end

            ASEEEM_PS.func.Net('itemOperation', false, 
                { type = ASEEEM_PS.enums.NetType.INT, data = ASEEEM_PS.enums.ItemOperation.ADJUST },
                { type = ASEEEM_PS.enums.NetType.TABLE, data = { self.item.class, data } })
            ASEEEM_PS.func.NetServer()

            -- timer.Simple(0.3, function()
            --     if ASEEEM_PS.business.success and self.item then
            --         local itemTypeTemp = ASEEEM_PS.func.GetItemTypeByItem(self.item)
            --         if itemTypeTemp.client and itemTypeTemp.client.on_adjust then
            --             itemTypeTemp.client.on_adjust(ASEEEM_PS.func.GetItemByClass(self.item.class), ASEEEM_PS.func.GetInventoryItemByClass(self.invItem.class))
            --         end
            --     end
            -- end)
        end)
    end
end

function PANEL:OnSizeChanged(w, h)
    if self.isAnimating then
        self:Center()
    end
    for _, v in pairs(self.options) do
        v:SetTall(h*ASEEEM_PS.theme.relativeHeight)
    end
end

function PANEL:Think()
    if self.isAnimating then
        self:Center()
    end
end

function PANEL:CloseFrame()
    self:Remove()
end

vgui.Register("AItemAdjust", PANEL, "DFrame")