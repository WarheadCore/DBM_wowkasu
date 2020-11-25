local mod	= DBM:NewMod("Faerlina", "DBM-Naxx", 1)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 3000 $"):sub(12, -3))
mod:SetCreatureID(15953)

mod:RegisterCombat("combat")

mod:RegisterEvents(
	"SPELL_CAST_SUCCESS",
	"SPELL_AURA_APPLIED"
)

local warnEmbraceActive		= mod:NewSpellAnnounce(28732, 1)
local warnEmbraceExpire		= mod:NewAnnounce("WarningEmbraceExpire", 2, 28732)
local warnEmbraceExpired	= mod:NewAnnounce("WarningEmbraceExpired", 3, 28732)
local warnEnrageSoon		= mod:NewSoonAnnounce(28798, 3)
local warnEnrageNow			= mod:NewSpellAnnounce(28798, 4)

local timerEmbrace			= mod:NewBuffActiveTimer(30, 28732)
local timerEnrage			= mod:NewCDTimer(60, 28798)

local embraceSpam = 0
local enraged = false

function mod:OnCombatStart(delay)
	enraged = false
end

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(28732, 54097)			-- Widow's Embrace
	and (GetTime() - embraceSpam) > 5 then  -- This spell is casted twice in Naxx 25 (bug?)
		embraceSpam = GetTime()
		warnEmbraceExpire:Cancel()
		warnEmbraceExpired:Cancel()
		warnEnrageSoon:Cancel()
		timerEnrage:Stop()
		if enraged then
			timerEnrage:Start(60)
			warnEnrageSoon:Schedule(55)
		end
		timerEmbrace:Start()
		warnEmbraceActive:Show()
		warnEmbraceExpire:Schedule(25)
		warnEmbraceExpired:Schedule(30)
		enraged = false
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(28798, 54100) then -- Frenzy
		warnEnrageNow:Show()
		
		if enraged then
			timerEnrage:Start(30)
			warnEnrageSoon:Schedule(25)
		else
			timerEnrage:Start(60)
			warnEnrageSoon:Schedule(55)
		end
		
		enraged = true
	end
end

