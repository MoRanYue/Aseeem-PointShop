ASEEEM_PS.data.itemTypes.playermodel = {}

ASEEEM_PS.data.itemTypes.playermodel.class = "playermodel"
ASEEEM_PS.data.itemTypes.playermodel.display = "玩家模型"
ASEEEM_PS.data.itemTypes.playermodel.purchasable = true
ASEEEM_PS.data.itemTypes.playermodel.multiple_equip = false
ASEEEM_PS.data.itemTypes.playermodel.equipable = true
ASEEEM_PS.data.itemTypes.playermodel.color = Color(20, 13, 70)

ASEEEM_PS.data.itemTypes.playermodel.on_buy = function(itm, ply)
end
ASEEEM_PS.data.itemTypes.playermodel.on_equip = function(itm, ply)
    ply.native_model = ply:GetModel()
    ply.native_color = ply:GetPlayerColor()
    ply:SetModel(itm.data[1])
    ply:SetupHands()
    ply:SetPlayerColor(Vector(itm.data[2].r, itm.data[2].g, itm.data[2].b))
end
ASEEEM_PS.data.itemTypes.playermodel.on_unequip = function(itm, ply)
    ply:SetModel(ply.native_model)
    ply:SetupHands()
    ply:SetPlayerColor(ply.native_color)
end
ASEEEM_PS.data.itemTypes.playermodel.on_sell = function(itm, ply)
end
ASEEEM_PS.data.itemTypes.playermodel.on_adjust = function(itm, ply)
end
