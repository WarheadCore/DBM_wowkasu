local mod	= DBM:NewMod("Gluth", "DBM-Naxx", 2)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 3000 $"):sub(12, -3))
mod:SetCreatureID(15932)

mod:RegisterCombat("combat")

mod:EnableModel()

mod:RegisterEvents(
	"SPELL_DAMAGE",
	"SPELL_AURA_APPLIED"
)

local warnDecimateSoon	= mod:NewSoonAnnounce(54426, 2)
local warnDecimateNow	= mod:NewSpellAnnounce(54426, 3)
local warnEnrageSoon	= mod:NewSoonAnnounce(28371, 2)

local berserkTimer		= mod:NewBerserkTimer(480)
local timerDecimate		= mod:NewCDTimer(105, 54426)
local timerEnrage		= mod:NewCDTimer(30, 28371)

function mod:OnCombatStart(delay)
	berserkTimer:Start(480 - delay)
	timerDecimate:Start(105 - delay)
	warnDecimateSoon:Schedule(95 - delay)
	timerEnrage:Start(30 - delay)
	warnEnrageSoon:Schedule(25 - delay)
end

local decimateSpam = 0
function mod:SPELL_DAMAGE(args)
	if args:IsSpellID(28375) and (GetTime() - decimateSpam) > 20 then
		decimateSpam = GetTime()
		warnDecimateNow:Show()
		timerDecimate:Start()
		warnDecimateSoon:Schedule(95)
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if (args:IsSpellID(28371, 54427)) then
		timerEnrage:Start()
		warnEnrageSoon:Schedule(25)
	end
end
