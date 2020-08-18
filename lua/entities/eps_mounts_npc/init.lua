AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
include("eps_armory/config.lua")

function ENT:Initialize()
    self:SetModel(table.Random(EPS_Mounts_Config.NPCModels))
    self:SetSolid(SOLID_BBOX)
    self:PhysicsInit(SOLID_BBOX)
    self:SetHullType(HULL_HUMAN)
    self:SetHullSizeNormal()
    self:SetNPCState(NPC_STATE_SCRIPT)
    self:CapabilitiesAdd(CAP_ANIMATEDFACE)
    self:CapabilitiesAdd(CAP_TURN_HEAD)
    self:SetUseType(SIMPLE_USE)
    self:DropToFloor()

    timer.Simple(1, function()
    	if IsValid(self) then
        	self:ResetSequence(table.Random(EPS_Mounts_Config.NPCStances))
        end
    end)

    local phys = self:GetPhysicsObject()

    if phys:IsValid() then
        phys:Wake()
        phys:EnableMotion(false)
    end
end

function ENT:Use(activator)
    if IsValid(activator) then
    	net.Start("EPS_OpenMountMenu")
    	net.Send(activator)
    end
end