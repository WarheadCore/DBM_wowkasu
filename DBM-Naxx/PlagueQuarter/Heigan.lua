local mod	= DBM:NewMod("Heigan", "DBM-Naxx", 3)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 2248 $"):sub(12, -3))
mod:SetCreatureID(15936)

mod:RegisterCombat("combat")

mod:EnableModel()

mod:RegisterEvents()

local warnTeleportSoon	= mod:NewAnnounce("WarningTeleportSoon", 2, 46573)
local warnTeleportNow	= mod:NewAnnounce("WarningTeleportNow", 3, 46573)

local timerTeleport		= mod:NewTimer(90, "TimerTeleport", 46573)

function mod:OnCombatStart(delay)
	mod:BackInRoom(90 - delay)
end

function mod:DancePhase()
	local timer = 45
	
	timerTeleport:Show(timer)
	warnTeleportSoon:Schedule(timer - 10, 10)
	warnTeleportNow:Schedule(timer)
	self:ScheduleMethod(timer, "BackInRoom", 90)
end

function mod:BackInRoom(time)
	timerTeleport:Show(time)
	warnTeleportSoon:Schedule(time - 15, 15)
	warnTeleportNow:Schedule(time)
	self:ScheduleMethod(time, "DancePhase")
end
