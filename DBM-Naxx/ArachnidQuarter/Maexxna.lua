local mod	= DBM:NewMod("Maexxna", "DBM-Naxx", 1)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 3000 $"):sub(12, -3))
mod:SetCreatureID(15952)

mod:RegisterCombat("combat")

mod:EnableModel()

mod:RegisterEvents(
	"SPELL_AURA_APPLIED",
	"CHAT_MSG_RAID_BOSS_EMOTE"
)

local warnWebWrap		= mod:NewTargetAnnounce(28622, 2)
local warnWebSpraySoon	= mod:NewSoonAnnounce(29484, 1)
local warnWebSprayNow	= mod:NewSpellAnnounce(29484, 3)
local warnSpidersSoon	= mod:NewAnnounce("WarningSpidersSoon", 2, 17332)

local timerWebSpray		= mod:NewCDTimer(40, 29484)
local timerWebWrap		= mod:NewCDTimer(20, 28622)
local timerSpider		= mod:NewTimer(30, "TimerSpider", 17332)

function mod:OnCombatStart(delay)
	warnWebSpraySoon:Schedule(35 - delay)
	timerWebSpray:Start(40 - delay)
	warnSpidersSoon:Schedule(25 - delay)
	timerSpider:Start(30 - delay)
	timerWebWrap:Start(20 - delay)
end

function mod:OnCombatEnd(wipe)
	if not wipe then
		if DBM.Bars:GetBar(L.ArachnophobiaTimer) then
			DBM.Bars:CancelBar(L.ArachnophobiaTimer) 
		end	
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(28622) then -- Web Wrap
		warnWebWrap:Show(args.destName)		
		if args.destName == UnitName("player") then
			SendChatMessage(L.YellWebWrap, "YELL")
		end
	end
end

function mod:CHAT_MSG_RAID_BOSS_EMOTE(msg)
	if msg == "%s разбрасывает нити паутины." then
		warnWebSprayNow:Show()
		warnWebSpraySoon:Schedule(35)
		timerWebSpray:Start(40)
	end

	if msg == "В паутине появляются паучата!" then
		warnSpidersSoon:Schedule(35)
		timerSpider:Start(40)
	end

	if msg == "%s свивает паутину в кокон!" then
		timerWebWrap:Start(40)
	end
end
