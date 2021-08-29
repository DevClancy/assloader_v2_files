-- Init Menu
Menu.Spacing()
Menu.Separator()
Menu.Spacing()
Menu.Checkbox("Enable AspectRatio", "bAspect", false)
Menu.SliderFloat("AspectRatio", "fAspect", 0, 5, "%.2f", 0)

local r_aspectratio = ICvar.FindVar("r_aspectratio")

local bAspect2 = Menu.GetBool("bAspect")
local fAspect2 = Menu.GetFloat("fAspect")

function PaintTraverse()
    if (not Utils.IsLocal()) then 
        bAspect2 = 0
        fAspect2 = 0
        return
    end

    if (bAspect2 ~= Menu.GetBool("bAspect") and fAspect2 ~= Menu.GetFloat("fAspect")) then
        return
    end

    bAspect2 = Menu.GetBool("bAspect")
    fAspect2 = Menu.GetFloat("fAspect")

    if (bAspect2) then
        r_aspectratio:SetFloat(fAspect2)
    else
        r_aspectratio:SetFloat(0)
    end
end
Hack.RegisterCallback("PaintTraverse", PaintTraverse)