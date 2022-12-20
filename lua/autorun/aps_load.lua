--[[

||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||                `¶¶¶¶```¶¶¶¶``¶¶¶¶¶`¶¶¶¶¶`¶¶¶¶¶`¶¶```¶                ||
||                ¶¶``¶¶`¶¶`````¶¶````¶¶````¶¶````¶¶¶`¶¶                ||
||                ¶¶¶¶¶¶``¶¶¶¶``¶¶¶¶``¶¶¶¶``¶¶¶¶``¶¶`¶`¶                ||
||                ¶¶``¶¶`````¶¶`¶¶````¶¶````¶¶````¶¶```¶                ||
||                ¶¶``¶¶``¶¶¶¶``¶¶¶¶¶`¶¶¶¶¶`¶¶¶¶¶`¶¶```¶                ||
||                           Author: MoRanYue                           ||
||    ¶¶¶¶¶```¶¶¶¶``¶¶¶¶¶¶`¶¶``¶¶`¶¶¶¶¶¶``¶¶¶¶``¶¶``¶¶``¶¶¶¶``¶¶¶¶¶`    ||
||    ¶¶``¶¶`¶¶``¶¶```¶¶```¶¶¶`¶¶```¶¶```¶¶`````¶¶``¶¶`¶¶``¶¶`¶¶``¶¶    ||
||    ¶¶¶¶¶``¶¶``¶¶```¶¶```¶¶`¶¶¶```¶¶````¶¶¶¶``¶¶¶¶¶¶`¶¶``¶¶`¶¶¶¶¶`    ||
||    ¶¶`````¶¶``¶¶```¶¶```¶¶``¶¶```¶¶```````¶¶`¶¶``¶¶`¶¶``¶¶`¶¶````    ||
||    ¶¶``````¶¶¶¶``¶¶¶¶¶¶`¶¶``¶¶```¶¶````¶¶¶¶``¶¶``¶¶``¶¶¶¶``¶¶````    ||
||                                                                      ||
||                           Steam: 墨染月𝑴𝑹𝒀                           ||
||                      Github: Kamisato-Ayaka-233                      ||
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||

]]

ASEEEM_PS = ASEEEM_PS or {}
ASEEEM_PS.func = ASEEEM_PS.func or {}
ASEEEM_PS.enums = ASEEEM_PS.enums or {}
ASEEEM_PS.data = ASEEEM_PS.data or {}
ASEEEM_PS.menu = ASEEEM_PS.menu or {}
ASEEEM_PS.theme = ASEEEM_PS.theme or {}

AddCSLuaFile('aps/cl_init.lua')

AddCSLuaFile('aps/enums.lua')
AddCSLuaFile('aps/net.lua')
AddCSLuaFile('aps/cl_lua.lua')
AddCSLuaFile('aps/utils.lua')

include('aps/enums.lua')
include('aps/net.lua')
include('aps/utils.lua')

if SERVER then
    include('aps/lua.lua')
    include('aps/init.lua')
else
    include('aps/cl_lua.lua')
    include('aps/cl_init.lua')
end

MsgC(Color(211, 200, 199), "Aseeem 点数商店已加载！")
