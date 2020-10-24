// This is an Unreal Script
class X2Character_MutonHunter extends X2Character_DefaultCharacters config(GameData_CharacterStats);

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	Templates.AddItem(CreateTemplate_Muton_Hunter());
	Templates.AddItem(CreateTemplate_Muton_Prowler());

		return Templates;
}

static function X2CharacterTemplate CreateTemplate_Muton_Hunter()
{
	local X2CharacterTemplate CharTemplate;
	local LootReference Loot;

	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, 'Muton_Hunter');
	CharTemplate.CharacterGroupName = 'Muton_Hunter';
	CharTemplate.DefaultLoadout='Muton_Hunter_Loadout';
	CharTemplate.BehaviorClass=class'XGAIBehavior';
	CharTemplate.strPawnArchetypes.AddItem("WoTC_Muton_Hunter.Archetypes.ARC_Muton_Hunter"); //XComAlienPawn'WoTC_Muton_Hunter.Archetypes.ARC_Muton_Hunter'
	Loot.ForceLevel=0;
	Loot.LootTableName='Muton_BaseLoot';
	CharTemplate.Loot.LootReferences.AddItem(Loot);
	CharTemplate.strBehaviorTree = "MutonHunterRoot";

	// Timed Loot
	Loot.ForceLevel = 0;
	Loot.LootTableName = 'Muton_TimedLoot';
	CharTemplate.TimedLoot.LootReferences.AddItem(Loot);
	Loot.LootTableName = 'Muton_VultureLoot';
	CharTemplate.VultureLoot.LootReferences.AddItem(Loot);

	CharTemplate.strMatineePackages.AddItem("CIN_Muton");
	CharTemplate.strTargetingMatineePrefix = "CIN_Muton_FF_StartPos";

	CharTemplate.UnitSize = 1;
	// Traversal Rules
	CharTemplate.bCanUse_eTraversal_Normal = true;
	CharTemplate.bCanUse_eTraversal_ClimbOver = true;
	CharTemplate.bCanUse_eTraversal_ClimbOnto = true;
	CharTemplate.bCanUse_eTraversal_ClimbLadder = true;
	CharTemplate.bCanUse_eTraversal_DropDown = true;
	CharTemplate.bCanUse_eTraversal_Grapple = false;
	CharTemplate.bCanUse_eTraversal_Landing = true;
	CharTemplate.bCanUse_eTraversal_BreakWindow = true;
	CharTemplate.bCanUse_eTraversal_KickDoor = true;
	CharTemplate.bCanUse_eTraversal_JumpUp = false;
	CharTemplate.bCanUse_eTraversal_WallClimb = false;
	CharTemplate.bCanUse_eTraversal_BreakWall = false;
	CharTemplate.bAppearanceDefinesPawn = false;    
	CharTemplate.bCanTakeCover = true;

	CharTemplate.bIsAlien = true;
	CharTemplate.bIsAdvent = false;
	CharTemplate.bIsCivilian = false;
	CharTemplate.bIsPsionic = false;
	CharTemplate.bIsRobotic = false;
	CharTemplate.bIsSoldier = false;
	CharTemplate.bAllowRushCam = false;

	CharTemplate.bCanBeTerrorist = false;
	CharTemplate.bCanBeCriticallyWounded = false;
	CharTemplate.bIsAfraidOfFire = true;
	CharTemplate.AcquiredPhobiaTemplate = 'FearOfMutons';

	CharTemplate.bAllowSpawnFromATT = false;

	//CharTemplate.Abilities.AddItem('CounterattackPreparation');
	//CharTemplate.Abilities.AddItem('CounterattackDescription');
	CharTemplate.Abilities.AddItem('DarkEventAbility_Barrier');
	CharTemplate.Abilities.AddItem('LW_AimAssist');
	CharTemplate.Abilities.AddItem('ChosenImmuneMelee');


	CharTemplate.AddTemplateAvailablility(CharTemplate.BITFIELD_GAMEAREA_Multiplayer); // Allow in MP!
	CharTemplate.MPPointValue = CharTemplate.XpKillscore * 10;

	//CharTemplate.SightedNarrativeMoments.AddItem(XComNarrativeMoment'X2NarrativeMoments.TACTICAL.AlienSitings.T_Central_AlienSightings_Muton');

	CharTemplate.strTargetIconImage = class'UIUtilities_Image'.const.TargetIcon_Alien;

	return CharTemplate;
}

static function X2CharacterTemplate CreateTemplate_Muton_Prowler()
{
	local X2CharacterTemplate CharTemplate;
	local LootReference Loot;

	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, 'Muton_Prowler');
	CharTemplate.CharacterGroupName = 'Muton_Prowler';
	CharTemplate.DefaultLoadout='Muton_Prowler_Loadout';
	CharTemplate.BehaviorClass=class'XGAIBehavior';
	CharTemplate.strPawnArchetypes.AddItem("WoTC_Muton_Hunter.Archetypes.ARC_Muton_Prowler"); //XComAlienPawn'WoTC_Muton_Hunter.Archetypes.ARC_Muton_Prowler'
	Loot.ForceLevel=0;
	Loot.LootTableName='Muton_BaseLoot';
	CharTemplate.Loot.LootReferences.AddItem(Loot);
	CharTemplate.strBehaviorTree = "MutonHunterRoot";

	// Timed Loot
	Loot.ForceLevel = 0;
	Loot.LootTableName = 'Muton_TimedLoot';
	CharTemplate.TimedLoot.LootReferences.AddItem(Loot);
	Loot.LootTableName = 'Muton_VultureLoot';
	CharTemplate.VultureLoot.LootReferences.AddItem(Loot);

	CharTemplate.strMatineePackages.AddItem("CIN_Muton");
	CharTemplate.strTargetingMatineePrefix = "CIN_Muton_FF_StartPos";

	CharTemplate.UnitSize = 1;
	// Traversal Rules
	CharTemplate.bCanUse_eTraversal_Normal = true;
	CharTemplate.bCanUse_eTraversal_ClimbOver = true;
	CharTemplate.bCanUse_eTraversal_ClimbOnto = true;
	CharTemplate.bCanUse_eTraversal_ClimbLadder = true;
	CharTemplate.bCanUse_eTraversal_DropDown = true;
	CharTemplate.bCanUse_eTraversal_Grapple = false;
	CharTemplate.bCanUse_eTraversal_Landing = true;
	CharTemplate.bCanUse_eTraversal_BreakWindow = true;
	CharTemplate.bCanUse_eTraversal_KickDoor = true;
	CharTemplate.bCanUse_eTraversal_JumpUp = false;
	CharTemplate.bCanUse_eTraversal_WallClimb = false;
	CharTemplate.bCanUse_eTraversal_BreakWall = false;
	CharTemplate.bAppearanceDefinesPawn = false;    
	CharTemplate.bCanTakeCover = true;

	CharTemplate.bIsAlien = true;
	CharTemplate.bIsAdvent = false;
	CharTemplate.bIsCivilian = false;
	CharTemplate.bIsPsionic = false;
	CharTemplate.bIsRobotic = false;
	CharTemplate.bIsSoldier = false;
	CharTemplate.bAllowRushCam = false;

	CharTemplate.bCanBeTerrorist = false;
	CharTemplate.bCanBeCriticallyWounded = false;
	CharTemplate.bIsAfraidOfFire = true;
	CharTemplate.AcquiredPhobiaTemplate = 'FearOfMutons';

	CharTemplate.bAllowSpawnFromATT = false;

	//CharTemplate.Abilities.AddItem('CounterattackPreparation');
	//CharTemplate.Abilities.AddItem('CounterattackDescription');
	CharTemplate.Abilities.AddItem('DarkEventAbility_Barrier');
	CharTemplate.Abilities.AddItem('LW_AimAssist');
	CharTemplate.Abilities.AddItem('ChosenImmuneMelee');

	CharTemplate.AddTemplateAvailablility(CharTemplate.BITFIELD_GAMEAREA_Multiplayer); // Allow in MP!
	CharTemplate.MPPointValue = CharTemplate.XpKillscore * 10;

	//CharTemplate.SightedNarrativeMoments.AddItem(XComNarrativeMoment'X2NarrativeMoments.TACTICAL.AlienSitings.T_Central_AlienSightings_Muton');

	CharTemplate.strTargetIconImage = class'UIUtilities_Image'.const.TargetIcon_Alien;

	return CharTemplate;
}

