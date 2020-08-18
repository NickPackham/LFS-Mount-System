include("shared.lua")
AddCSLuaFile()

surface.CreateFont("EPS_Mounts_NPC_Overhead", {
    font = "Arial",
    extended = false,
    size = 65,
    weight = 500,
    blursize = 0,
    scanlines = 0,
    antialias = true
})

function ENT:Draw()
    self:DrawModel()
    
    cam.Start3D2D(self:GetPos() + Vector(0, 0, 82.5), Angle(0, Angle(0, (LocalPlayer():GetPos() - self:GetPos()):Angle().y + 90, 90).y, 90), 0.1)

        draw.SimpleText("Mounts", "EPS_Mounts_NPC_Overhead", 0, 0, Color(255, 255, 255), TEXT_ALIGN_CENTER)

    cam.End3D2D()
end