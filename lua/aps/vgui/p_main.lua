ASEEEM_PS.menu.relative = {}
ASEEEM_PS.menu.absolute = {}

local rainbowColor

local matDisable = Material('aps/disable.png')
local matPoint = Material('aps/point.png')

function ASEEEM_PS.func.openMenu()
    local cl = LocalPlayer()
    if !IsValid(cl) then
        return 
    end

    local scrw, scrh = ScrW(), ScrH()
    local frameW, frameH, animTime, animDelay, animEase = 1152, 648, 1.8, 0, .1

    --检测是否已经存在
    if ASEEEM_PS.func.checkMenu() then
        ASEEEM_PS.menu.relative = {}
        ASEEEM_PS.menu.absolute = {}
        ASEEEM_PS.func.closeMenu()
    end

    if !next(ASEEEM_PS.data.items) or !next(ASEEEM_PS.data.itemTypes) then
        ASEEEM_PS.func.RequestItems()
    end
    if !ASEEEM_PS.data.invSlots then
        ASEEEM_PS.func.RequestInventory()
        return
    end

    ASEEEM_PS.menu.frame = vgui.Create("DFrame")
    ASEEEM_PS.menu.frame:SetTitle('')
    ASEEEM_PS.menu.frame:SetDraggable(false)
    ASEEEM_PS.menu.frame:ShowCloseButton()
    ASEEEM_PS.menu.frame:MakePopup(true)
    ASEEEM_PS.menu.frame:SetSize(0, 0)
    ASEEEM_PS.menu.frame:Center()

    local isAnimating = true
    ASEEEM_PS.menu.frame:SizeTo(frameW, frameH, animTime, animDelay, animEase, function()
        isAnimating = false
    end)

    ASEEEM_PS.menu.frame.Paint = function(s, w, h)
        surface.SetDrawColor(ASEEEM_PS.theme.frameBackgroundColor)
        surface.DrawRect(0, 0, w, h)

        draw.SimpleText("#ASEEEM_PS_title", 'JXZK36', ASEEEM_PS.theme.titleTop, ASEEEM_PS.theme.titleLeft, ASEEEM_PS.theme.titleColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
    end

    --动画时不断调整位置
    ASEEEM_PS.menu.frame.Think = function(s) 
        if isAnimating then
            s:Center()
        end
    end

    ASEEEM_PS.menu.frame.OnSizeChanged = function(s, w, h)
        if isAnimating then
            s:Center()
        end
        for _, v in pairs(ASEEEM_PS.menu.relative) do
            v:SetWide(w*ASEEEM_PS.theme.relativeWidth)
            v:SetTall(h*ASEEEM_PS.theme.relativeHeight)
        end
    end

    --关闭按钮
    ASEEEM_PS.menu.absolute.closeBtn = ASEEEM_PS.menu.frame:Add("DButton")
    ASEEEM_PS.menu.absolute.closeBtn:SetSize(30, 30)
    ASEEEM_PS.menu.absolute.closeBtn:SetText("")
    ASEEEM_PS.menu.absolute.closeBtn.Think = function(s)
        if isAnimating then
            s:SetX(ASEEEM_PS.menu.frame:GetWide() - s:GetWide() - ASEEEM_PS.theme.closeBtnRight)
            s:SetY(ASEEEM_PS.theme.closeBtnTop)
        end
    end
    ASEEEM_PS.menu.absolute.closeBtn.Paint = function(s, w, h)
        surface.SetDrawColor(ASEEEM_PS.theme.btnBackgroundColor)
        surface.DrawRect(0, 0, w, h)
        
        -- surface.SetDrawColor(ASEEEM_PS.theme.btnTextColor)
        surface.SetDrawColor(HSVToColor((CurTime()*ASEEEM_PS.theme.rainbowBtnColorSpeed) % 360, 1, 1))
        surface.SetMaterial(matDisable)
        surface.DrawTexturedRect(0, 0, w, h)
    end
    ASEEEM_PS.menu.absolute.closeBtn.DoClick = function(s)
        ASEEEM_PS.func.closeMenu()
    end

    ASEEEM_PS.menu.panel = ASEEEM_PS.menu.frame:Add("DPanel")
    ASEEEM_PS.menu.panel:SetPos(0, ASEEEM_PS.theme.headerTop + ASEEEM_PS.theme.headerBottom + ASEEEM_PS.theme.headerFill)
    ASEEEM_PS.menu.panel:SetPaintBackground(false)
    ASEEEM_PS.menu.panel.Paint = function(s, w, h)
        surface.SetDrawColor(ASEEEM_PS.theme.panelBackgroundColor)
        surface.DrawRect(0, 0, w, h)
    end
    ASEEEM_PS.menu.panel.Think = function(s)
        if isAnimating then
            ASEEEM_PS.menu.panel:SetSize(ASEEEM_PS.menu.frame:GetWide(), ASEEEM_PS.menu.frame:GetTall() - (ASEEEM_PS.theme.headerTop + ASEEEM_PS.theme.headerBottom + ASEEEM_PS.theme.headerFill))
        end
    end

    --显示当前点数
    ASEEEM_PS.menu.absolute.showPoint = ASEEEM_PS.menu.panel:Add("APoint")
    ASEEEM_PS.menu.absolute.showPoint:SetPointType(0)
    -- ASEEEM_PS.menu.absolute.showPoint:SetPoint()
    ASEEEM_PS.menu.absolute.showPoint:SetMat(ASEEEM_PS.theme.matPoint)
    ASEEEM_PS.menu.absolute.showPoint.Think = function(s) 
        if isAnimating then
            s:SetPos(ASEEEM_PS.menu.panel:GetWide() - s:GetWide() - ASEEEM_PS.theme.pointTextRight, 7)
        end
    end

    ASEEEM_PS.menu.absolute.showProPoint = ASEEEM_PS.menu.panel:Add("APoint")
    ASEEEM_PS.menu.absolute.showProPoint:SetPointType(1)
    ASEEEM_PS.menu.absolute.showProPoint:SetMat(ASEEEM_PS.theme.matProPoint)
    ASEEEM_PS.menu.absolute.showProPoint.Think = function(s)
        if isAnimating then
            s:SetPos(ASEEEM_PS.menu.panel:GetWide() - s:GetWide() - ASEEEM_PS.theme.pointTextRight*2 - ASEEEM_PS.menu.absolute.showPoint:GetWide(), 7)
        end
    end

    --商店
    ASEEEM_PS.menu.shop = ASEEEM_PS.menu.panel:Add("DScrollPanel")
    ASEEEM_PS.menu.shop:SetPos(160, 42)
    ASEEEM_PS.menu.shop.Paint = function(s, w, h)
        draw.RoundedBox(10, 0, 0, w, h, ASEEEM_PS.theme.shopBackgroundColor)

        --显示当前的类别
        if ASEEEM_PS.menu.selectedSideBarItem != '' and ASEEEM_PS.data.itemTypes then
            draw.SimpleText(string.format(language.GetPhrase('ASEEEM_PS_itemType'), ASEEEM_PS.data.itemTypes[ASEEEM_PS.menu.selectedSideBarItem].display), 
                        "JXZK18", 10, 10, ASEEEM_PS.theme.ShopItemsTypeTextColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        end
    end
    ASEEEM_PS.menu.shop.Think = function(s)
        if isAnimating then
            s:SetSize(ASEEEM_PS.menu.panel:GetWide() - s:GetX(), ASEEEM_PS.menu.panel:GetTall() - 32)
        end
    end

    local shopBar = ASEEEM_PS.menu.shop:GetVBar()
    shopBar:SetHideButtons(true)
    shopBar.Paint = function(s, w, h)
        surface.SetDrawColor(ASEEEM_PS.theme.shopVBarBackgroundColor)
        surface.DrawRect(0, 0, w, h)
    end
    -- shopBar.btnUp.Paint = function(s, w, h)
    -- end
    -- shopBar.btnDown.Paint = function(s, w, h)
    -- end
    shopBar.btnGrip.Paint = function(s, w, h)
        draw.RoundedBox(10, 0, 0, w, h, ASEEEM_PS.theme.shopVBarColor)
    end

    ASEEEM_PS.menu.shopLayout = ASEEEM_PS.menu.shop:Add("DListLayout")
    ASEEEM_PS.menu.shopLayout:SetPaintBackground(false)
    ASEEEM_PS.menu.shopLayout.Think = function(s)
        if isAnimating then
            s:SetSize(ASEEEM_PS.menu.shop:GetWide(), ASEEEM_PS.menu.shop:GetTall())
        end
    end

    ASEEEM_PS.menu.absolute.shopRow = {}
    for i=0, #ASEEEM_PS.data.items, ASEEEM_PS.theme.shopWidth do
        local temp = ASEEEM_PS.menu.shopLayout:Add("DPanel")
        temp:SetPaintBackground(false)
        temp.Think = function(s)
            if isAnimating then
                s:SetSize(ASEEEM_PS.menu.shopLayout:GetWide(), 200 + ASEEEM_PS.theme.shopItemMargin)
            end
        end

        table.insert(ASEEEM_PS.menu.absolute.shopRow, temp)
    end
    
    local shopItemInfoShowed = false
    --商店物品信息
    ASEEEM_PS.menu.shopItemInfo = ASEEEM_PS.menu.panel:Add("AShopItemInfo")
    --先放到面板外，之后再用动画调出
    -- ASEEEM_PS.menu.shopItemInfo:SetPos(ASEEEM_PS.menu.panel:GetWide(), ASEEEM_PS.menu.shop:GetY())
    -- ASEEEM_PS.menu.shopItemInfo:SetPos(ASEEEM_PS.menu.shop:GetWide() - ASEEEM_PS.menu.shopItemInfo:GetWide(), ASEEEM_PS.menu.shop:GetY())
    ASEEEM_PS.menu.shopItemInfo.Think = function(s)
        if isAnimating then
            s:SetSize(ASEEEM_PS.menu.shop:GetWide()/2, ASEEEM_PS.menu.shop:GetTall())
            -- s:SetPos(ASEEEM_PS.menu.panel:GetWide() - s:GetWide(), ASEEEM_PS.menu.shop:GetY())
            s:SetPos(ASEEEM_PS.menu.panel:GetWide(), ASEEEM_PS.menu.shop:GetY())
        end
    end
    ASEEEM_PS.menu.shopItemInfo.ClosePanel = function(s)
        if shopItemInfoShowed and !isAnimating then
            s:MoveTo(ASEEEM_PS.menu.panel:GetWide(), ASEEEM_PS.menu.shop:GetY(), 
                                                0.7, 0, 1)
            -- ASEEEM_PS.menu.shop:SizeTo(ASEEEM_PS.menu.panel:GetWide() - ASEEEM_PS.menu.shop:GetX(), ASEEEM_PS.menu.panel:GetTall() - 32, 0.8, 0, -1)
            shopItemInfoShowed = false
        end
    end

    local col, row = 1, 1
    for _, v in pairs(ASEEEM_PS.data.items) do
        --只有可购买的物品才能上架
        --查看是否和当前类别相同
        if !v.purchasable or v.type != ASEEEM_PS.menu.selectedSideBarItem then
            continue 
        end
        if col > ASEEEM_PS.theme.shopWidth then
            col = 1
            row = row + 1
        end
        
        local i = ASEEEM_PS.menu.absolute.shopRow[row]:Add("AShopSlot")
        i:SetPos(ASEEEM_PS.theme.shopItemMargin * col + i:GetWide() * (col - 1), ASEEEM_PS.theme.shopItemMargin)
        i:SetCoords(col, row)
        i:SetItem(v)
        i.btn.DoClick = function(s)
            ASEEEM_PS.menu.shopItemInfo:SetItem(s.item)
            if !shopItemInfoShowed and !isAnimating then
                ASEEEM_PS.menu.shopItemInfo:MoveTo(ASEEEM_PS.menu.panel:GetWide() - ASEEEM_PS.menu.shopItemInfo:GetWide(), ASEEEM_PS.menu.shop:GetY(), 
                                                    0.8, 0, 1)
                -- ASEEEM_PS.menu.shop:SizeTo(ASEEEM_PS.menu.panel:GetWide() - ASEEEM_PS.menu.shop:GetX() - ASEEEM_PS.menu.shopItemInfo:GetWide(), ASEEEM_PS.menu.panel:GetTall() - 32, 0.7, 0, -1)
                shopItemInfoShowed = true
                -- s.active = true
            end
        end

        col = col + 1
    end

    --侧边栏
    ASEEEM_PS.menu.sideBarScroll = ASEEEM_PS.menu.panel:Add("DScrollPanel")
    ASEEEM_PS.menu.sideBarScroll:SetPos(10, 42)
    ASEEEM_PS.menu.sideBarScroll.Paint = function(s, w, h)
        draw.RoundedBox(10, 0, 0, w, h, ASEEEM_PS.theme.sideBarBackgroundColor)
    end
    ASEEEM_PS.menu.sideBarScroll.Think = function(s)
        if isAnimating then
            s:SetSize(140, ASEEEM_PS.menu.panel:GetTall() - 200)
        end
    end

    local sideBarVBar = ASEEEM_PS.menu.sideBarScroll:GetVBar()
    sideBarVBar:SetHideButtons(true)
    sideBarVBar.btnGrip.Paint = function(s, w, h)
        draw.RoundedBox(10, 0, 0, w, h, ASEEEM_PS.theme.shopVBarColor)
    end

    ASEEEM_PS.menu.sideBar = ASEEEM_PS.menu.sideBarScroll:Add("DListLayout")
    ASEEEM_PS.menu.sideBar.Think = function(s)
        if isAnimating then
            s:SetSize(ASEEEM_PS.menu.sideBarScroll:GetWide(), ASEEEM_PS.menu.sideBarScroll:GetTall())
        end
    end
    ASEEEM_PS.menu.selectedSideBarItem = ''
    ASEEEM_PS.menu.sideBarItems = {}
    --创建商店类别
    for _, v in SortedPairs(ASEEEM_PS.data.itemTypes) do
        if !next(ASEEEM_PS.func.GetItemsInItemType(v)) then
            continue 
        end

        if ASEEEM_PS.menu.selectedSideBarItem == '' then
            ASEEEM_PS.menu.selectedSideBarItem = v.class
        end
        local temp = ASEEEM_PS.menu.sideBar:Add("AButton")
        temp:SetText(v.display)
        temp:SetHoverAnimType(1)
        temp:SetBackgroundColor(v.color or ASEEEM_PS.theme.btnBackgroundColor)
        temp:DockMargin(0, 0, 0, 7)
        temp.Think = function(s)
            if isAnimating then
                s:SetSize(ASEEEM_PS.menu.sideBar:GetWide(), 30)
            end
        end
        temp.type = v
        temp:ClickEvent(function(s)
            ASEEEM_PS.menu.absolute.inventoryBtnBtn.active = false
            ASEEEM_PS.menu.absolute.optionsBtn.active = false
            ASEEEM_PS.menu.inventory:MoveTo(0, ASEEEM_PS.menu.panel:GetTall(), 0.5, 0, 1)
            ASEEEM_PS.menu.options:MoveTo(ASEEEM_PS.menu.panel:GetWide(), ASEEEM_PS.menu.panel:GetTall(), 0.6, 0, 1)
            ASEEEM_PS.menu.inventoryItemInfo:ClosePanel()
            if invSlots then
                for _, v in pairs(invSlots) do
                    v.active = false
                end
            end

            ASEEEM_PS.menu.selectedSideBarItem = temp.type.class
            if ASEEEM_PS.menu.absolute.shopRow then
                for _, w in pairs(ASEEEM_PS.menu.absolute.shopRow) do
                    local chd = w:GetChildren()
                    for _, x in pairs(chd) do
                        x:Remove()
                    end
                end
            end

            ASEEEM_PS.menu.shopItemInfo.ClosePanel = function(s)
                if shopItemInfoShowed and !isAnimating then
                    s:MoveTo(ASEEEM_PS.menu.panel:GetWide(), ASEEEM_PS.menu.shop:GetY(), 
                                                        0.7, 0, 1)
                    shopItemInfoShowed = false
                end
            end
            
            local col, row = 1, 1
            for _, w in pairs(ASEEEM_PS.data.items) do
                --只有可购买的物品才能上架
                --查看是否和当前类别相同
                if !w.purchasable or w.type != ASEEEM_PS.menu.selectedSideBarItem then
                    continue 
                end
                if col > ASEEEM_PS.theme.shopWidth then
                    col = 1
                    row = row + 1
                end

                local i = ASEEEM_PS.menu.absolute.shopRow[row]:Add("AShopSlot")
                i:SetPos(ASEEEM_PS.theme.shopItemMargin * col + i:GetWide() * (col - 1), ASEEEM_PS.theme.shopItemMargin)
                i:SetCoords(col, row)
                i:SetItem(w)
                i.btn.DoClick = function(s)
                    ASEEEM_PS.menu.shopItemInfo:SetItem(s.item)
                    if !shopItemInfoShowed and !isAnimating then
                        ASEEEM_PS.menu.shopItemInfo:MoveTo(ASEEEM_PS.menu.panel:GetWide() - ASEEEM_PS.menu.shopItemInfo:GetWide(), ASEEEM_PS.menu.shop:GetY(), 
                                                            0.8, 0, 1)
                        shopItemInfoShowed = true
                    end
                end

                col = col + 1
            end
        end)

        table.insert(ASEEEM_PS.menu.sideBarItems, temp)
    end

    --选项界面
    ASEEEM_PS.menu.options = ASEEEM_PS.menu.panel:Add("DScrollPanel")
    ASEEEM_PS.menu.options.Paint = function(s, w, h)
        draw.RoundedBox(10, 0, 0, w, h, ASEEEM_PS.theme.optionsBackgroundColor)
    end
    ASEEEM_PS.menu.options.Think = function(s)
        if isAnimating then
            s:SetPos(ASEEEM_PS.menu.panel:GetWide(), ASEEEM_PS.menu.panel:GetTall())
            s:SetSize(ASEEEM_PS.menu.shop:GetWide(), ASEEEM_PS.menu.shop:GetTall())
        end
    end
    local optBar = ASEEEM_PS.menu.options:GetVBar()
    optBar:SetHideButtons(true)
    optBar.Paint = function(s, w, h)
        surface.SetDrawColor(ASEEEM_PS.theme.optionsVBarBackgroundColor)
        surface.DrawRect(0, 0, w, h)
    end
    optBar.btnGrip.Paint = function(s, w, h)
        draw.RoundedBox(10, 0, 0, w, h, ASEEEM_PS.theme.optionsVBarColor)
    end

    ASEEEM_PS.menu.optionsLayout = ASEEEM_PS.menu.options:Add("DListLayout")
    ASEEEM_PS.menu.optionsLayout:SetPaintBackground(false)
    ASEEEM_PS.menu.optionsLayout.Think = function(s)
        if isAnimating then
            s:SetSize(ASEEEM_PS.menu.options:GetWide(), ASEEEM_PS.menu.options:GetTall())
        end
    end

    --库存界面
    ASEEEM_PS.menu.inventory = ASEEEM_PS.menu.panel:Add("DScrollPanel")
    ASEEEM_PS.menu.inventory.Paint = function(s, w, h)
        draw.RoundedBox(10, 0, 0, w, h, ASEEEM_PS.theme.inventoryBackgroundColor)
    end
    ASEEEM_PS.menu.inventory.Think = function(s)
        if isAnimating then
            s:SetPos(0, ASEEEM_PS.menu.panel:GetTall())
            s:SetSize(ASEEEM_PS.menu.shop:GetWide(), ASEEEM_PS.menu.shop:GetTall())
        end
    end

    local invBar = ASEEEM_PS.menu.inventory:GetVBar()
    invBar:SetHideButtons(true)
    invBar.Paint = function(s, w, h)
        surface.SetDrawColor(ASEEEM_PS.theme.inventoryVBarBackgroundColor)
        surface.DrawRect(0, 0, w, h)
    end
    invBar.btnGrip.Paint = function(s, w, h)
        draw.RoundedBox(10, 0, 0, w, h, ASEEEM_PS.theme.inventoryVBarColor)
    end

    ASEEEM_PS.menu.inventoryLayout = ASEEEM_PS.menu.inventory:Add("DListLayout")
    ASEEEM_PS.menu.inventoryLayout:SetPaintBackground(false)
    ASEEEM_PS.menu.inventoryLayout.Think = function(s)
        if isAnimating then
            s:SetSize(ASEEEM_PS.menu.inventory:GetWide(), ASEEEM_PS.menu.inventory:GetTall())
        end
    end

    ASEEEM_PS.menu.inventoryItemInfo = ASEEEM_PS.menu.panel:Add('AInvItemInfo')
    ASEEEM_PS.menu.inventoryItemInfo.Think = function(s)
        if isAnimating then
            s:SetSize(ASEEEM_PS.menu.shopItemInfo:GetWide(), ASEEEM_PS.menu.shopItemInfo:GetTall())
            s:SetPos(ASEEEM_PS.menu.panel:GetWide(), ASEEEM_PS.menu.shop:GetY())
        end
    end
    ASEEEM_PS.menu.inventoryItemInfo.ClosePanel = function(s)
        s:MoveTo(ASEEEM_PS.menu.panel:GetWide(), ASEEEM_PS.menu.shop:GetY(), 0.6, 0, -1)
        if IsValid(s.adjustWindow) then
            s.adjustWindow:Remove()
        end
    end

    ASEEEM_PS.menu.absolute.invRow = {}
    if !ASEEEM_PS.data.invSlots then
        return
    end
    for i=0, ASEEEM_PS.data.invSlots, ASEEEM_PS.theme.inventoryWidth do
        local temp = ASEEEM_PS.menu.inventoryLayout:Add("DPanel")
        temp:SetPaintBackground(false)
        temp.Think = function(s)
            if isAnimating then
                s:SetSize(ASEEEM_PS.menu.inventoryLayout:GetWide(), 80 + ASEEEM_PS.theme.invItemMargin)
            end
        end

        table.insert(ASEEEM_PS.menu.absolute.invRow, temp)
    end

    local invCol, invRow = 1, 1
    local invSlots = {}
    for v=1, ASEEEM_PS.data.invSlots do
        if invCol > ASEEEM_PS.theme.inventoryWidth then
            invCol = 1
            invRow = invRow + 1
        end

        local i = ASEEEM_PS.menu.absolute.invRow[invRow]:Add("AInvSlot")
        i:SetPos(ASEEEM_PS.theme.invItemMargin * invCol + i:GetWide() * (invCol - 1), ASEEEM_PS.theme.invItemMargin)
        i.btn.DoClick = function(s)
        end

        table.insert(invSlots, i)
        invCol = invCol + 1
    end

    local invIndexDe = 0
    for k, v in pairs(ASEEEM_PS.data.inventory) do
        k = k - invIndexDe
        if k > ASEEEM_PS.data.invSlots then
            break
        end
        -- print(ASEEEM_PS.func.GetItemFromInventoryItem(v))
        if !v.is_valid or !ASEEEM_PS.func.GetItemFromInventoryItem(v) then --无效物品不渲染
            invIndexDe = invIndexDe + 1
            continue
        end
        invSlots[k]:SetItem(ASEEEM_PS.func.GetItemFromInventoryItem(v))
        invSlots[k].btn.DoClick = function(s)
            invSlots[k].active = !invSlots[k].active
            if invSlots[k].active then
                for _, w in pairs(invSlots) do
                    if w != invSlots[k] then
                        w.active = false
                    end
                end
                ASEEEM_PS.menu.inventoryItemInfo:SetItem(invSlots[k].item)
                ASEEEM_PS.menu.inventoryItemInfo:MoveTo(ASEEEM_PS.menu.panel:GetWide() - ASEEEM_PS.menu.inventoryItemInfo:GetWide(), ASEEEM_PS.menu.shop:GetY(), 0.5, 0, -1)
            else
                ASEEEM_PS.menu.inventoryItemInfo:MoveTo(ASEEEM_PS.menu.panel:GetWide(), ASEEEM_PS.menu.shop:GetY(), 0.6, 0, -1)
            end
        end
    end

    timer.Create('ASEEEM_PS_reloadInventory', 0.5, 0, function()
        local invIndexDe, fullSlots = 0, 0
        for k, v in pairs(ASEEEM_PS.data.inventory) do
            k = k - invIndexDe
            if k > ASEEEM_PS.data.invSlots then
                break
            end

            if !v or !v.is_valid or !ASEEEM_PS.func.GetItemFromInventoryItem(v) then
                invIndexDe = invIndexDe + 1
                continue
            end

            fullSlots = fullSlots + 1

            invSlots[k]:SetItem(ASEEEM_PS.func.GetItemFromInventoryItem(v))
            invSlots[k].btn.DoClick = function(s)
                invSlots[k].active = !invSlots[k].active
                if invSlots[k].active then
                    for _, w in pairs(invSlots) do
                        if w != invSlots[k] then
                            w.active = false
                        end
                    end
                    ASEEEM_PS.menu.inventoryItemInfo:SetItem(invSlots[k].item)
                    ASEEEM_PS.menu.inventoryItemInfo:MoveTo(ASEEEM_PS.menu.panel:GetWide() - ASEEEM_PS.menu.inventoryItemInfo:GetWide(), ASEEEM_PS.menu.shop:GetY(), 0.5, 0, -1)
                else
                    ASEEEM_PS.menu.inventoryItemInfo:MoveTo(ASEEEM_PS.menu.panel:GetWide(), ASEEEM_PS.menu.shop:GetY(), 0.6, 0, -1)
                end
            end
        end

        --把超出的物品设置为空
        for i=fullSlots+1, #invSlots do
            invSlots[i]:SetItem(nil)
        end
    end)

    --底部的库存界面调出按钮
    ASEEEM_PS.menu.absolute.inventoryBtn = ASEEEM_PS.menu.panel:Add("DPanel")
    ASEEEM_PS.menu.absolute.inventoryBtn.Think = function(s)
        if isAnimating then
            s:SetSize(ASEEEM_PS.menu.sideBarScroll:GetWide(), ASEEEM_PS.menu.panel:GetTall() - ASEEEM_PS.menu.absolute.inventoryBtn:GetY() - 10)
            s:SetPos(ASEEEM_PS.menu.sideBarScroll:GetX(), ASEEEM_PS.menu.sideBarScroll:GetY() + ASEEEM_PS.menu.sideBarScroll:GetTall() + 10)
        end
    end
    ASEEEM_PS.menu.absolute.inventoryBtn:SetPaintBackground(false)
    ASEEEM_PS.menu.absolute.inventoryBtn.Paint = function(s, w, h)
        draw.RoundedBox(10, 0, 0, w, h, ASEEEM_PS.theme.invBtnBackgroundColor)
    end

    ASEEEM_PS.menu.absolute.inventoryBtnAvt = ASEEEM_PS.menu.absolute.inventoryBtn:Add("AvatarImage")
    ASEEEM_PS.menu.absolute.inventoryBtnAvt:SetPlayer(cl, 64)
    ASEEEM_PS.menu.absolute.inventoryBtnAvt:SetSize(56, 56)
    ASEEEM_PS.menu.absolute.inventoryBtnAvt:SetPos(10, 10)

    ASEEEM_PS.menu.absolute.inventoryBtnNick = ASEEEM_PS.menu.absolute.inventoryBtn:Add("DLabel")
    ASEEEM_PS.menu.absolute.inventoryBtnNick:SetContentAlignment(7)
    ASEEEM_PS.menu.absolute.inventoryBtnNick:SetWrap(true)
    ASEEEM_PS.menu.absolute.inventoryBtnNick:SetFont("JXZK18")
    ASEEEM_PS.menu.absolute.inventoryBtnNick:SetText(cl:Nick())
    ASEEEM_PS.menu.absolute.inventoryBtnNick.Think = function(s) 
        if isAnimating then
            ASEEEM_PS.menu.absolute.inventoryBtnNick:SetPos(ASEEEM_PS.menu.absolute.inventoryBtnAvt:GetX() + ASEEEM_PS.menu.absolute.inventoryBtnAvt:GetWide() + 3, ASEEEM_PS.menu.absolute.inventoryBtnAvt:GetY())
            ASEEEM_PS.menu.absolute.inventoryBtnNick:SetSize(ASEEEM_PS.menu.absolute.inventoryBtn:GetWide()/2 - 10, ASEEEM_PS.menu.absolute.inventoryBtnAvt:GetTall())
        end
    end

    ASEEEM_PS.menu.absolute.inventoryBtnBtn = ASEEEM_PS.menu.absolute.inventoryBtn:Add("AButton")
    ASEEEM_PS.menu.absolute.inventoryBtnBtn:SetText('#ASEEEM_PS_inventory')
    ASEEEM_PS.menu.absolute.inventoryBtnBtn:SetBackgroundColor(ASEEEM_PS.theme.invBtnColor)
    ASEEEM_PS.menu.absolute.inventoryBtnBtn:SetHoverColor(ASEEEM_PS.theme.invBtnHoverColor)
    ASEEEM_PS.menu.absolute.inventoryBtnBtn.Think = function(s)
        if isAnimating then
            ASEEEM_PS.menu.absolute.inventoryBtnBtn:SetSize(ASEEEM_PS.menu.absolute.inventoryBtn:GetWide() - ASEEEM_PS.menu.absolute.inventoryBtnAvt:GetX()*2, 27)
            ASEEEM_PS.menu.absolute.inventoryBtnBtn:SetPos(ASEEEM_PS.menu.absolute.inventoryBtnAvt:GetX(), ASEEEM_PS.menu.absolute.inventoryBtnAvt:GetTall() + ASEEEM_PS.menu.absolute.inventoryBtnAvt:GetY() + 3)
        end
    end
    ASEEEM_PS.menu.absolute.inventoryBtnBtn:ClickEvent(function(s)
        if ASEEEM_PS.menu.absolute.inventoryBtnBtn.active then
            if ASEEEM_PS.menu.absolute.shopRow then
                for _, w in pairs(ASEEEM_PS.menu.absolute.shopRow) do
                    local chd = w:GetChildren()
                    for _, x in pairs(chd) do
                        x:Show()
                    end
                end
            end
            ASEEEM_PS.menu.inventory:MoveTo(0, ASEEEM_PS.menu.panel:GetTall(), 0.5, 0, 1, function()
                if ASEEEM_PS.menu.absolute.shopRow then
                    for _, w in pairs(ASEEEM_PS.menu.absolute.shopRow) do
                        local chd = w:GetChildren()
                        for _, x in pairs(chd) do
                            x:Show()
                        end
                    end
                end
            end)
            ASEEEM_PS.menu.inventoryItemInfo:ClosePanel()
            for _, v in pairs(invSlots) do
                v.active = false
            end
        else
            ASEEEM_PS.menu.inventory:MoveTo(ASEEEM_PS.menu.shop:GetX(), ASEEEM_PS.menu.shop:GetY(), 0.4, 0, 1, function()
                if ASEEEM_PS.menu.absolute.shopRow then
                    for _, w in pairs(ASEEEM_PS.menu.absolute.shopRow) do
                        local chd = w:GetChildren()
                        for _, x in pairs(chd) do
                            x:Hide()
                        end
                    end
                end
            end)
            ASEEEM_PS.menu.options:MoveTo(ASEEEM_PS.menu.panel:GetWide(), ASEEEM_PS.menu.panel:GetTall(), 0.6, 0, 1)
            ASEEEM_PS.menu.absolute.optionsBtn.active = false
            ASEEEM_PS.menu.shopItemInfo:ClosePanel()
        end
        ASEEEM_PS.menu.absolute.inventoryBtnBtn.active = !ASEEEM_PS.menu.absolute.inventoryBtnBtn.active
    end)

    ASEEEM_PS.menu.absolute.optionsBtn = ASEEEM_PS.menu.absolute.inventoryBtn:Add("AButton")
    ASEEEM_PS.menu.absolute.optionsBtn:SetText('#ASEEEM_PS_options')
    ASEEEM_PS.menu.absolute.optionsBtn:SetBackgroundColor(ASEEEM_PS.theme.invBtnColor)
    ASEEEM_PS.menu.absolute.optionsBtn:SetHoverColor(ASEEEM_PS.theme.invBtnHoverColor)
    ASEEEM_PS.menu.absolute.optionsBtn.Think = function(s)
        if isAnimating then
            s:SetSize(ASEEEM_PS.menu.absolute.inventoryBtnBtn:GetWide(), ASEEEM_PS.menu.absolute.inventoryBtnBtn:GetTall())
            s:SetPos(ASEEEM_PS.menu.absolute.inventoryBtnBtn:GetX(), ASEEEM_PS.menu.absolute.inventoryBtnBtn:GetTall() + ASEEEM_PS.menu.absolute.inventoryBtnBtn:GetY() + 10)
        end
    end
    ASEEEM_PS.menu.absolute.optionsBtn:ClickEvent(function(s)
        if ASEEEM_PS.menu.absolute.optionsBtn.active then
            ASEEEM_PS.menu.options:MoveTo(ASEEEM_PS.menu.panel:GetWide(), ASEEEM_PS.menu.panel:GetTall(), 0.6, 0, 1)
        else
            ASEEEM_PS.menu.options:MoveTo(ASEEEM_PS.menu.shop:GetX(), ASEEEM_PS.menu.shop:GetY(), 0.5, 0, 1)
            ASEEEM_PS.menu.inventory:MoveTo(0, ASEEEM_PS.menu.panel:GetTall(), 0.5, 0, 1, function()
                if ASEEEM_PS.menu.absolute.shopRow then
                    for _, w in pairs(ASEEEM_PS.menu.absolute.shopRow) do
                        local chd = w:GetChildren()
                        for _, x in pairs(chd) do
                            x:Show()
                        end
                    end
                end
            end)
            ASEEEM_PS.menu.inventoryItemInfo:ClosePanel()
            for _, v in pairs(invSlots) do
                v.active = false
            end
            ASEEEM_PS.menu.shopItemInfo:ClosePanel()
            ASEEEM_PS.menu.inventoryItemInfo:ClosePanel()
            ASEEEM_PS.menu.absolute.inventoryBtnBtn.active = false
        end
        ASEEEM_PS.menu.absolute.optionsBtn.active = !ASEEEM_PS.menu.absolute.optionsBtn.active
    end)
    
    -- local buttonRainbow = ASEEEM_PS.menu.frame:Add('DButton')
    -- -- buttonRainbow:SetSize(100, 100)
    -- buttonRainbow:Dock(TOP)
    -- buttonRainbow:SetText('')
    -- buttonRainbow.Paint = function(s, w, h)
    --     rainbowColor = HSVToColor((CurTime()*ASEEEM_PS.theme.rainbowBtnColorSpeed) % 360, 1, 1)
    --     surface.SetDrawColor(rainbowColor)
    --     surface.DrawRect(0, 0, w, h)
    --     draw.SimpleText("Rainbow", "Roboto24", w/2, h/2, ASEEEM_PS.theme.btnTe xtColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    -- end

    -- local buttonSlide = ASEEEM_PS.menu.frame:Add('DButton')
    -- buttonSlide:Dock(TOP)
    -- buttonSlide:SetText('')
    -- buttonSlide.Paint = function(s, w, h)
    --     local offset = ASEEEM_PS.theme.slideBtnRange * math.sin(CurTime() * ASEEEM_PS.theme.slideBtnSpeed)
    --     surface.SetDrawColor(ASEEEM_PS.theme.btnBackgroundColor)
    --     surface.DrawRect(0, 0, w, h)
    --     draw.SimpleText("Sliding", "Roboto24", w/2 + offset, h/2, ASEEEM_PS.theme.btnTextColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    -- end

    -- local barStatus = 0
    -- local buttonHover = ASEEEM_PS.menu.frame:Add('DButton')
    -- buttonHover:Dock(TOP)
    -- buttonHover:SetText('')
    -- buttonHover.Paint = function(s, w, h)
    --     if s:IsHovered() then
    --         barStatus = math.Clamp(barStatus + ASEEEM_PS.theme.btnHoverColorSpeed * FrameTime(), 0, 1)
    --     else
    --         barStatus = math.Clamp(barStatus - ASEEEM_PS.theme.btnHoverColorSpeed * FrameTime(), 0, 1)
    --     end
    --     surface.SetDrawColor(ASEEEM_PS.theme.btnBackgroundColor)
    --     surface.DrawRect(0, 0, w, h)
    --     surface.SetDrawColor(ASEEEM_PS.theme.btnHoverColor)
    --     surface.DrawRect(0, h*.9, w * barStatus, h*.1)
    --     draw.SimpleText("Hover", "Roboto24", w/2, h/2, ASEEEM_PS.theme.btnTextColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    -- end

    -- local buttonToggle = ASEEEM_PS.menu.frame:Add('DButton')
    -- buttonToggle:Dock(TOP)
    -- buttonToggle:SetText('')
    -- buttonToggle.isActive = false
    -- buttonToggle.Paint = function(s, w, h)
    --     surface.SetDrawColor(not s.isActive and ASEEEM_PS.theme.btnBackgroundColor or ASEEEM_PS.theme.btnActiveBackgroundColor)
    --     surface.DrawRect(0, 0, w, h)
    --     draw.SimpleText("Toggle", "Roboto24", w/2, h/2, not s.isActive and ASEEEM_PS.theme.btnTextColor or ASEEEM_PS.theme.btnActiveTextColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    -- end
    -- buttonToggle.DoClick = function(s)
    --     s.isActive = !s.isActive
    -- end
end

function ASEEEM_PS.func.closeMenu()
    timer.Remove("ASEEEM_PS_reloadInventory")
    if IsValid(ASEEEM_PS.menu.inventoryItemInfo) and IsValid(ASEEEM_PS.menu.inventoryItemInfo.adjustWindow) then
        ASEEEM_PS.menu.inventoryItemInfo.adjustWindow:Remove()
    end
    ASEEEM_PS.menu.frame:Remove()
end

function ASEEEM_PS.func.checkMenu()
    return IsValid(ASEEEM_PS.menu.frame)
end

ASEEEM_PS.func.NetReceive('callAPSMenu', ASEEEM_PS.func.openMenu)