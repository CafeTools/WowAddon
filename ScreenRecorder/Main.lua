local Cafe = LibStub("AceAddon-3.0"):NewAddon("Cafe", "AceConsole-3.0", "AceEvent-3.0", "AceTimer-3.0")
local timer = nil;


function Cafe:OnInitialize()
	self.db = LibStub("AceDB-3.0"):New("CafeDB");
	SetCVar("advancedCombatLogging", 1);

	self:RegisterEvent("UPDATE_INSTANCE_INFO", "OnEvent");
	self:RegisterEvent("PLAYER_LOGOUT", "OnLogout");

	LoggingCombat(true);
	local _, instanceType = GetInstanceInfo();
	if instanceType == 'none' then
		timer = self:ScheduleTimer("OnTimer", 30);
	end
end


function Cafe:OnEvent()
	local zone, instanceType, _, _, _, _, _, instanceID = GetInstanceInfo();
	self:EndTimer();

	if instanceType == 'none' then
		self:StartTimer();
	else
		LoggingCombat(true);
	end

	self:Print("ScreenRecorder:", zone, instanceID, instanceType);
end


function Cafe:OnLogout()
	self:SavePlayerInfo();
end


function Cafe:OnTimer()
	LoggingCombat(false);
	self:CancelTimer(timer);
	timer = nil;
end


function Cafe:StartTimer()
	if LoggingCombat() == true then
		timer = self:ScheduleTimer("OnTimer", 30);
	end
end


function Cafe:EndTimer()
	self:CancelTimer(timer);
	timer = nil;
end


function Cafe:IsPVP()
	local a = C_PvP.IsRatedBattleground();
	local b = C_PvP.IsRatedArena();
	local c = C_PvP.IsBattleground();
	local d = _G.IsArenaSkirmish();
	return (a or b or c or d);
end


function Cafe:SavePlayerInfo()
	local x = "player";
	self.db.global.playerGUID = UnitGUID(x);
	self.db.global.playerName = UnitName(x);
	self.db.global.className = UnitClass(x);
	self.db.global.classNameEng = self:UnitClassEng(x);
	self.db.global.race = UnitRace(x);
	self.db.global.raceEng = self:UnitRaceEng(x);
	self.db.global.level = UnitLevel(x);
	self.db.global.unitSex = UnitSex(x);
	self.db.global.realm = GetRealmName();
	self.db.global.locale = GetLocale();
	self.db.global.buildInfo = GetBuildInfo();
	self.db.global.expansionLevel = GetExpansionLevel();
	self.db.global.expansionName = self:ExpansionName();
end


function Cafe:ExpansionName()
	local level = GetExpansionLevel();
	local names = { 
		"Classic", "The Burning Crusade", "Wrath of the Lich King",
		"Cataclysm", "Mists of Pandaria", "Warlords of Draenor", "Legion", 
		"Battle for Azeroth", "Shadowlands", "Dragonflight", "The Worldsoul Saga",
		"...", "...", "...", "...", "...", "...", "...", "...", "...", "..."
	};
	return names[level+1];
end


function Cafe:UnitClassEng(x)
	local localized, english = UnitClass(x);
	return english;
end


function Cafe:UnitRaceEng(x)
	local localized, english = UnitRace(x);
	return english;
end



