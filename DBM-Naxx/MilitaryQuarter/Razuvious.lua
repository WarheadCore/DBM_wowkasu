local mod	= DBM:NewMod("Razuvious", "DBM-Naxx", 4)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 2248 $"):sub(12, -3))
mod:SetCreatureID(16061)

mod:RegisterCombat("yell", "Не щадите никого!")

mod:RegisterEvents(
	"SPELL_CAST_SUCCESS"
)

local warnShoutNow		= mod:NewSpellAnnounce(55543, 1)
local warnShoutSoon		= mod:NewSoonAnnounce(55543, 3)
local warnShieldWall	= mod:NewAnnounce("WarningShieldWallSoon", 3, 29061)

local timerShout		= mod:NewNextTimer(25, 55543)
local timerTaunt		= mod:NewCDTimer(20, 29060)
local timerShieldWall	= mod:NewCDTimer(20, 29061)

function mod:OnCombatStart(delay)
	timerShout:Start(25 - delay)
	warnShoutSoon:Schedule(20 - delay)
end

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(55543, 29107) then -- Disrupting Shout
		timerShout:Start(25)
		warnShoutNow:Show()
		warnShoutSoon:Schedule(20)
	elseif args:IsSpellID(29060) then -- Taunt
		timerTaunt:Start()
	elseif args:IsSpellID(29061) then -- ShieldWall
		timerShieldWall:Start()
		warnShieldWall:Schedule(15)
	end
end

