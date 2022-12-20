ASEEEM_PS.config = ASEEEM_PS.config or {}

ASEEEM_PS.config.whereResource = 'workshop' -- “workshop”/“server”
ASEEEM_PS.config.additionalResource = true

ASEEEM_PS.config.inventorySlots = 40

ASEEEM_PS.config.newPlayerPoint = 20
ASEEEM_PS.config.newPlayerProPoint = 0
ASEEEM_PS.config.newPlayerInventory = {}

ASEEEM_PS.config.itemSoldMultiplier = 0.8
ASEEEM_PS.config.itemPriceMultiplier = 1
ASEEEM_PS.config.itemProPriceMultiplier = 1

ASEEEM_PS.config.rewardForPlaytime = 20 --分钟，改为0表示不给予游玩时间奖励
ASEEEM_PS.config.proRewardForPlaytime = 0

ASEEEM_PS.config.rewardPoint = 120
ASEEEM_PS.config.rewardPointEveryUserGroups = { --会覆盖上一项配置，但如果找不到则会使用上一个项
    ['operater'] = 300,
    ['admin'] = 1000,
    ['superadmin'] = 114514,

    ['user'] = 100,
    ['useri'] = 200,
    ['userii'] = 250,
    ['useriii'] = 300,
    ['useriv'] = 400
}

ASEEEM_PS.config.rewardProPoint = 0
ASEEEM_PS.config.rewardProPointEveryUserGroups = {}--会覆盖上一项配置，但如果找不到则会使用上一个项