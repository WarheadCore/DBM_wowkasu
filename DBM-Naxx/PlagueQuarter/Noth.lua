local mod	= DBM:NewMod("Noth", "DBM-Naxx", 3)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 3000 $"):sub(12, -3))
mod:SetCreatureID(15954)

mod:RegisterCombat("combat")

mod:RegisterEvents(
	"SPELL_CAST_SUCCESS"
)

local warnTeleportNow	= mod:NewAnnounce("WarningTeleportNow", 3, 46573)
local warnTeleportSoon	= mod:NewAnnounce("WarningTeleportSoon", 1, 46573)
local warnCurse			= mod:NewSpellAnnounce(29213, 2)
local warnBlink			= mod:NewSoonAnnounce(29208, 2)

local timerTeleport		= mod:NewTimer(110, "TimerTeleport", 46573)
local timerTeleportBack	= mod:NewTimer(70, "TimerTeleportBack", 46573)
local timerBlink		= mod:NewCDTimer(30, 29208)

local firstBlink = true
local blickCastCount = 0

function mod:OnCombatStart(delay)
	self:InRoom()
	blickCastCount = 0
	firstBlink = true
end

function mod:Balcony()
	local timer = 70
	blickCastCount = 0
	firstBlink = true
	
	timerTeleportBack:Show(timer)
	warnTeleportSoon:Schedule(timer - 10)
	warnTeleportNow:Schedule(timer)
	self:ScheduleMethod(timer, "InRoom")
	self:UnscheduleMethod("CastBlink")
end

function mod:InRoom()
	local timer = 110
	
	timerTeleport:Show(timer)
	warnTeleportSoon:Schedule(timer - 10)
	warnTeleportNow:Schedule(timer)
	self:ScheduleMethod(timer, "Balcony")

	if mod:IsDifficulty("normal25") or mod:IsDifficulty("heroic25") then
		if (firstBlink == true) then
			self:CastBlink(26)
		else
			self:CastBlink(30)
		end
	end
end

function mod:CastBlink(delay)
	if (delay == 26) then 
		firstBlink = false 
	end

	local timer = delay or 30
	blickCastCount = blickCastCount + 1

	timerBlink:Start(timer)
	warnBlink:Schedule(timer - 5)
	
	if (blickCastCount >= 2) then
		return
	end
	
	self:ScheduleMethod(timer, "CastBlink")
end

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(29213, 54835) then -- Curse of the Plaguebringer
		warnCurse:Show()
	end
end
