function ASEEEM_PS.func.AddHook(ev, id, func)
    if isstring(id) then
        hook.Add(ev, "Aseeem_PS_" .. ev .. "_" .. id, func)
    else
        hook.Add(ev, id, func)
    end
end
function ASEEEM_PS.func.RemoveHook(ev, id)
    if isstring(id) then
        hook.Remove(ev, "Aseeem_PS_" .. ev .. "_" .. id, func)
    else
        hook.Remove(ev, id, func)
    end
end
function ASEEEM_PS.func.RunHook(ev, ...)
    return hook.Run(ev, ...)
end
function ASEEEM_PS.func.AddCHook(ev, id, func)
    if isstring(id) then
        hook.Add('Aseeem_PS_' .. ev, 'Aseeem_PS_' .. ev .. '_' .. id, func)
    else
        hook.Add('Aseeem_PS_' .. ev, id, func)
    end
end
function ASEEEM_PS.func.RemoveCHook(ev, id)
    if isstring(id) then
        hook.Remove('Aseeem_PS_' .. ev, 'Aseeem_PS_' .. ev .. '_' .. id, func)
    else
        hook.Remove('Aseeem_PS_' .. ev, id, func)
    end
end
function ASEEEM_PS.func.RunCHook(ev, ...)
    return hook.Run('Aseeem_PS_' .. ev, ...)
end

function ASEEEM_PS.func.SetPData(ply, id, value)
    return ply:SetPData("Aseeem_PS_" .. id, value)
end
function ASEEEM_PS.func.GetPData(ply, id, default)
    default = default or -200
    return ply:GetPData("Aseeem_PS_" .. id, default)
end
function ASEEEM_PS.func.RemovePData(ply, id)
    return ply:RemovePData("Aseeem_PS_" .. id)
end

function ASEEEM_PS.func.SetNW(ent, key, value, NWType)
    NWType = NWType or ASEEEM_PS.enums.NWType.INT

    if type(value) == 'boolean' then
        NWType = ASEEEM_PS.enums.NWType.BOOL
    elseif type(value) == 'number' then
        NWType = type and ASEEEM_PS.enums.NWType.FLOAT or ASEEEM_PS.enums.NWType.INT
    elseif type(value) == 'string' then
        NWType = ASEEEM_PS.enums.NWType.STRING
    end
    
    if NWType == ASEEEM_PS.enums.NWType.INT then
        ent:SetNWInt("Aseeem_PS_" .. key, value)
    elseif NWType == ASEEEM_PS.enums.NWType.FLOAT then
        ent:SetNWFloat("Aseeem_PS_" .. key, value)
    elseif NWType == ASEEEM_PS.enums.NWType.STRING then
        ent:SetNWString("Aseeem_PS_" .. key, value)
    elseif NWType == ASEEEM_PS.enums.NWType.BOOL then
        ent:SetNWBool("Aseeem_PS_" .. key, value)
    elseif NWType == ASEEEM_PS.enums.NWType.ANGLE then
        ent:SetNWAngle("Aseeem_PS_" .. key, value)
    elseif NWType == ASEEEM_PS.enums.NWType.VECTOR then
        ent:SetNWVector("Aseeem_PS_" .. key, value)
    elseif NWType == ASEEEM_PS.enums.NWType.ENTITY then
        ent:SetNWEntity("Aseeem_PS_" .. key, value)
    elseif NWType == ASEEEM_PS.enums.NWType.VARPROXY then
        ent:SetNWVarProxy("Aseeem_PS_" .. key, value)
    end
end
function ASEEEM_PS.func.GetNW(ent, key, type, fallback)
    fallback = fallback or -200
    type = type or ASEEEM_PS.enums.NWType.INT

    if type == ASEEEM_PS.enums.NWType.INT then
        return ent:GetNWInt("Aseeem_PS_" .. key, fallback)
    elseif type == ASEEEM_PS.enums.NWType.FLOAT then
        return ent:GetNWFloat("Aseeem_PS_" .. key, fallback)
    elseif type == ASEEEM_PS.enums.NWType.STRING then
        return ent:GetNWString("Aseeem_PS_" .. key, fallback)
    elseif type == ASEEEM_PS.enums.NWType.BOOL then
        return ent:GetNWBool("Aseeem_PS_" .. key, fallback)
    elseif type == ASEEEM_PS.enums.NWType.ANGLE then
        return ent:GetNWAngle("Aseeem_PS_" .. key, fallback)
    elseif type == ASEEEM_PS.enums.NWType.VECTOR then
        return ent:GetNWVector("Aseeem_PS_" .. key, fallback)
    elseif type == ASEEEM_PS.enums.NWType.ENTITY then
        return ent:GetNWEntity("Aseeem_PS_" .. key, fallback)
    elseif type == ASEEEM_PS.enums.NWType.VARPROXY then
        return ent:GetNWVarProxy("Aseeem_PS_" .. key, fallback)
    elseif type == ASEEEM_PS.enums.NWType.VARTABLE then
        return ent:GetNWVarTable()
    else 
        return ent:GetNWInt("Aseeem_PS_" .. key, fallback)
    end
end

function ASEEEM_PS.func.IsValidItem(item)
    -- if 
end

function ASEEEM_PS.func.FindPlayerByName(name)
    local players = player.GetAll()
    local foundPlayers = {}

    for _, v in ipairs(players) do
        if string.lower(v:Name()) == string.lower(name) then
            table.insert(foundPlayers, v)
        end
    end

    if !next(foundPlayers) then
        return nil
    elseif #foundPlayers == 1 then
        return foundPlayers[1]
    else 
        return foundPlayers
    end
end

function ASEEEM_PS.func.FindPlayersByRegex(pattern)
    local players = player.GetAll()
    local foundPlayers = {}

    for _, v in ipairs(players) do
        if string.match(string.lower(v:Name()), string.lower(pattern)) then
            table.insert(foundPlayers, v)
        end
    end

    if !next(foundPlayers) then
        return nil
    elseif #foundPlayers == 1 then
        return foundPlayers[1]
    else 
        return foundPlayers
    end
end