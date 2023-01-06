local PANEL = {}

function PANEL:Init()
    self.avt = self:Add('AvatarImage')
    self.avt:Dock(FILL)
    self.avt:SetPaintedManually(true)
end

function PANEL:PushMask(mask)
    render.ClearStencil()
    render.SetStencilEnable(true)
    render.SetStencilWriteMask(1)
    render.SetStencilTestMask(1)
    render.SetStencilFailOperation(STENCILOPERATION_REPLACE)
    render.SetStencilPassOperation(STENCILOPERATION_ZERO)
    render.SetStencilZFailOperation(STENCILOPERATION_ZERO)
    render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_NEVER)
    render.SetStencilReferenceValue(1)

    mask()

    render.SetStencilFailOperation(STENCILOPERATION_ZERO)
    render.SetStencilPassOperation(STENCILOPERATION_REPLACE)
    render.SetStencilZFailOperation(STENCILOPERATION_ZERO)
    render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_EQUAL)
    render.SetStencilReferenceValue(1)
end

function PANEL:PopMask(arguments)
    render.SetStencilEnable(false)
    render.ClearStencil()
end

function PANEL:Paint(w, h)
    self:PushMask(function()
        local cir, x, y = {}, w/2, h/2

        for ang=1, 360 do --经典的绘制圆函数
            local rad = math.rad(ang)
            local cos, sin = math.cos(rad)*y, math.sin(rad)*y

            cir[#cir+1] = {
                x = x + cos,
                y = y + sin
            }
        end

        draw.NoTexture()
        surface.SetDrawColor(255, 255, 255)
        surface.DrawPoly(cir)
    end)

    -- self.avt:SetPaintedManually(false)
    self.avt:PaintManual()
    -- self.avt:SetPaintedManually(true)
    self:PopMask()
end

function PANEL:SetPlayer(ply, res)
    self.avt:SetPlayer(ply, res)
end
function PANEL:SetSteamID(steamid, res)
    self.avt:SetSteamID(steamid, res)
end

vgui.Register('ARoundAvatar', PANEL, 'DPanel')