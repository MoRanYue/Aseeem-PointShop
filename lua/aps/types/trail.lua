ASEEEM_PS.data.itemTypes.trail = {}

ASEEEM_PS.data.itemTypes.trail.class = "trail"
ASEEEM_PS.data.itemTypes.trail.display = "尾迹"
ASEEEM_PS.data.itemTypes.trail.purchasable = true
ASEEEM_PS.data.itemTypes.trail.multiple_equip = false
ASEEEM_PS.data.itemTypes.trail.equipable = true
ASEEEM_PS.data.itemTypes.trail.color = Color(20, 13, 50)

ASEEEM_PS.data.itemTypes.trail.on_buy = function(itm, ply)
end
ASEEEM_PS.data.itemTypes.trail.on_equip = function(itm, ply, inv_item)
    if next(inv_item.data) then
        itm.data = inv_item.data
    end
    ply.trail = util.SpriteTrail(ply, 0, itm.data[1], true, itm.data[2], itm.data[3], itm.data[4], 1 / ( itm.data[2] + itm.data[3] ) * 0.5, itm.data[5])
end
ASEEEM_PS.data.itemTypes.trail.on_unequip = function(itm, ply, inv_item)
    if IsValid(ply.trail) then
        ply.trail:Remove()
    end
end
ASEEEM_PS.data.itemTypes.trail.on_sell = function(itm, ply)
end
ASEEEM_PS.data.itemTypes.trail.on_adjust = function(itm, ply, inv_item)
end