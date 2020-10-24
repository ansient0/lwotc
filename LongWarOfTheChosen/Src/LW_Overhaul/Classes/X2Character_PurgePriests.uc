class X2Character_PurgePriests extends X2Character_DefaultCharacters config(PurgePriests);

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	Templates.AddItem(CreateTemplate_PurgePriest());
	Templates.AddItem(CreateTemplate_PurgeBishop());
	Templates.AddItem(CreateTemplate_ExaltedPurgePriest());
	Templates.AddItem(CreateTemplate_ExaltedPurgeArchbishop());
	
	return Templates;
}

static function X2CharacterTemplate CreateTemplate_PurgePriest()
{
	local X2CharacterTemplate CharTemplate;
	local LootReference Loot;

	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, 'PurgePriest');
	CharTemplate.CharacterGroupName = 'PurgePriest';
	CharTemplate.DefaultLoadout = 'PurgePriest_Loadout';
	CharTemplate.BehaviorClass = class'XGAIBehavior';
	CharTemplate.strPawnArchetypes.AddItem("WoTC_PurgePriest.ARC_GameUnit_PurgePriest_Tier1_M");
	//CharTemplate.strPawnArchetypes.AddItem("GameUnit_AdvPriest.ARC_GameUnit_AdvPriestM1_F");
	CharTemplate.strBehaviorTree = "PurgePriestRoot";

	// Auto-Loot
	Loot.ForceLevel = 0;
	Loot.LootTableName = 'AdvPriestM1_BaseLoot';
	CharTemplate.Loot.LootReferences.AddItem(Loot);

	// Timed Loot
	Loot.ForceLevel = 0;
	Loot.LootTableName = 'AdvPriestM1_TimedLoot';
	CharTemplate.TimedLoot.LootReferences.AddItem(Loot);
	Loot.LootTableName = 'AdvPriestM1_VultureLoot';
	CharTemplate.VultureLoot.LootReferences.AddItem(Loot);

	CharTemplate.strMatineePackages.AddItem("CIN_Advent");
	CharTemplate.strMatineePackages.AddItem("CIN_Soldier");	
	CharTemplate.strMatineePackages.AddItem("CIN_PurgePriest");	
	CharTemplate.RevealMatineePrefix = "CIN_PurgePriest";
	//CharTemplate.GetRevealMatineePrefixFn = GetAdventMatineePrefix;

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
	CharTemplate.bSetGenderAlways = true;
	CharTemplate.bCanTakeCover = true;

	CharTemplate.bIsAlien = false;
	CharTemplate.bIsAdvent = true;
	CharTemplate.bIsCivilian = false;
	CharTemplate.bIsPsionic = true;
	CharTemplate.bIsRobotic = false;
	CharTemplate.bIsSoldier = false;

	CharTemplate.bCanBeTerrorist = false;
	CharTemplate.bCanBeCriticallyWounded = false;
	CharTemplate.bIsAfraidOfFire = false;
	
	
	CharTemplate.Abilities.AddItem('PurgeFocus');
	CharTemplate.Abilities.AddItem('PurgingFocus');
	CharTemplate.Abilities.AddItem('FlameControl');
	CharTemplate.Abilities.Additem('CloseCombatSpecialist');

	CharTemplate.Abilities.AddItem('AdventStilettoRounds');
	CharTemplate.Abilities.AddItem('DarkEventAbility_ReturnFire');
	CharTemplate.Abilities.AddItem('DarkEventAbility_SealedArmor');
	CharTemplate.Abilities.AddItem('DarkEventAbility_UndyingLoyalty');
	CharTemplate.Abilities.AddItem('DarkEventAbility_Barrier');
	CharTemplate.Abilities.AddItem('DarkEventAbility_Counterattack');
	

	//CharTemplate.SightedNarrativeMoments.AddItem(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_TYG_T_First_Seen_Adv_Priest_M1');

	CharTemplate.strHackIconImage = "UILibrary_Common.TargetIcons.Hack_captain_icon";
	CharTemplate.strTargetIconImage = class'UIUtilities_Image'.const.TargetIcon_Advent;

	return CharTemplate;
}


static function X2CharacterTemplate CreateTemplate_PurgeBishop()
{
	local X2CharacterTemplate CharTemplate;
	local LootReference Loot;

	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, 'PurgeBishop');
	CharTemplate.CharacterGroupName = 'PurgeBishop';
	CharTemplate.DefaultLoadout = 'PurgeBishop_Loadout';
	CharTemplate.BehaviorClass = class'XGAIBehavior';
	CharTemplate.strPawnArchetypes.AddItem("WoTC_PurgePriest.ARC_GameUnit_PurgePriest_M");
	//CharTemplate.strPawnArchetypes.AddItem("GameUnit_AdvPriest.ARC_GameUnit_AdvPriestM1_F");
	CharTemplate.strBehaviorTree = "PurgeBishopRoot";

	// Auto-Loot
	Loot.ForceLevel = 0;
	Loot.LootTableName = 'AdvPriestM1_BaseLoot';
	CharTemplate.Loot.LootReferences.AddItem(Loot);

	// Timed Loot
	Loot.ForceLevel = 0;
	Loot.LootTableName = 'AdvPriestM1_TimedLoot';
	CharTemplate.TimedLoot.LootReferences.AddItem(Loot);
	Loot.LootTableName = 'AdvPriestM1_VultureLoot';
	CharTemplate.VultureLoot.LootReferences.AddItem(Loot);

	CharTemplate.strMatineePackages.AddItem("CIN_Advent");
	CharTemplate.strMatineePackages.AddItem("CIN_Soldier");	
	CharTemplate.strMatineePackages.AddItem("CIN_PurgePriest");	
	CharTemplate.RevealMatineePrefix = "CIN_PurgePriest";

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
	CharTemplate.bSetGenderAlways = true;
	CharTemplate.bCanTakeCover = true;

	CharTemplate.bIsAlien = false;
	CharTemplate.bIsAdvent = true;
	CharTemplate.bIsCivilian = false;
	CharTemplate.bIsPsionic = true;
	CharTemplate.bIsRobotic = false;
	CharTemplate.bIsSoldier = false;

	CharTemplate.bCanBeTerrorist = false;
	CharTemplate.bCanBeCriticallyWounded = false;
	CharTemplate.bIsAfraidOfFire = false;
	
	
	CharTemplate.Abilities.AddItem('PurgeFocus');
	CharTemplate.Abilities.AddItem('PurgingFocus');
	CharTemplate.Abilities.AddItem('BlazingFocus');
	CharTemplate.Abilities.AddItem('FlameControl');
	CharTemplate.Abilities.AddItem('Jail');
	CharTemplate.Abilities.Additem('CloseCombatSpecialist');

	CharTemplate.Abilities.AddItem('AdventStilettoRounds');
	CharTemplate.Abilities.AddItem('DarkEventAbility_ReturnFire');
	CharTemplate.Abilities.AddItem('DarkEventAbility_SealedArmor');
	CharTemplate.Abilities.AddItem('DarkEventAbility_UndyingLoyalty');
	CharTemplate.Abilities.AddItem('DarkEventAbility_Barrier');
	CharTemplate.Abilities.AddItem('DarkEventAbility_Counterattack');
	

	//CharTemplate.SightedNarrativeMoments.AddItem(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_TYG_T_First_Seen_Adv_Priest_M1');

	CharTemplate.strHackIconImage = "UILibrary_Common.TargetIcons.Hack_captain_icon";
	CharTemplate.strTargetIconImage = class'UIUtilities_Image'.const.TargetIcon_Advent;

	return CharTemplate;
}



static function X2CharacterTemplate CreateTemplate_ExaltedPurgePriest()
{
	local X2CharacterTemplate CharTemplate;
	local LootReference Loot;

	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, 'ExaltedPurgePriest');
	CharTemplate.CharacterGroupName = 'PurgePriest';
	CharTemplate.DefaultLoadout = 'ExaltedPurgeBishop_Loadout';
	CharTemplate.BehaviorClass = class'XGAIBehavior';
	CharTemplate.strPawnArchetypes.AddItem("WoTC_PurgePriest.ARC_GameUnit_ExaltedPurgePriest_M");
	//CharTemplate.strPawnArchetypes.AddItem("GameUnit_AdvPriest.ARC_GameUnit_AdvPriestM1_F");
	CharTemplate.strBehaviorTree = "ExaltedPurgePriestRoot";

	// Auto-Loot
	Loot.ForceLevel = 0;
	Loot.LootTableName = 'AdvPriestM1_BaseLoot';
	CharTemplate.Loot.LootReferences.AddItem(Loot);

	// Timed Loot
	Loot.ForceLevel = 0;
	Loot.LootTableName = 'AdvPriestM1_TimedLoot';
	CharTemplate.TimedLoot.LootReferences.AddItem(Loot);
	Loot.LootTableName = 'AdvPriestM1_VultureLoot';
	CharTemplate.VultureLoot.LootReferences.AddItem(Loot);

	CharTemplate.strMatineePackages.AddItem("CIN_Advent");
	CharTemplate.strMatineePackages.AddItem("CIN_Soldier");	
	CharTemplate.strMatineePackages.AddItem("CIN_PurgePriest");	
	CharTemplate.RevealMatineePrefix = "CIN_PurgePriest";

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
	CharTemplate.bSetGenderAlways = true;
	CharTemplate.bCanTakeCover = true;

	CharTemplate.bIsAlien = false;
	CharTemplate.bIsAdvent = true;
	CharTemplate.bIsCivilian = false;
	CharTemplate.bIsPsionic = true;
	CharTemplate.bIsRobotic = false;
	CharTemplate.bIsSoldier = false;

	CharTemplate.bCanBeTerrorist = false;
	CharTemplate.bCanBeCriticallyWounded = false;
	CharTemplate.bIsAfraidOfFire = false;
	
	
	CharTemplate.Abilities.AddItem('PurgeFocus');
	CharTemplate.Abilities.AddItem('PurgingFocus');
	CharTemplate.Abilities.AddItem('BlazingFocus');
	CharTemplate.Abilities.AddItem('ExaltedFocus');
	CharTemplate.Abilities.AddItem('MassJail');
	CharTemplate.Abilities.AddItem('FlameControl');
	CharTemplate.Abilities.Additem('CloseCombatSpecialist');



	CharTemplate.Abilities.AddItem('AdventStilettoRounds');
	CharTemplate.Abilities.AddItem('DarkEventAbility_ReturnFire');
	CharTemplate.Abilities.AddItem('DarkEventAbility_SealedArmor');
	CharTemplate.Abilities.AddItem('DarkEventAbility_UndyingLoyalty');
	CharTemplate.Abilities.AddItem('DarkEventAbility_Barrier');
	CharTemplate.Abilities.AddItem('DarkEventAbility_Counterattack');

	//CharTemplate.SightedNarrativeMoments.AddItem(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_TYG_T_First_Seen_Adv_Priest_M1');

	CharTemplate.strHackIconImage = "UILibrary_Common.TargetIcons.Hack_captain_icon";
	CharTemplate.strTargetIconImage = class'UIUtilities_Image'.const.TargetIcon_Advent;

	return CharTemplate;
}

static function X2CharacterTemplate CreateTemplate_ExaltedPurgeArchbishop()
{
	local X2CharacterTemplate CharTemplate;
	local LootReference Loot;

	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, 'ExaltedPurgeArchbishop');
	CharTemplate.CharacterGroupName = 'PurgePriest';
	CharTemplate.DefaultLoadout = 'ExaltedPurgeArchbishop_Loadout';
	CharTemplate.BehaviorClass = class'XGAIBehavior';
	CharTemplate.strPawnArchetypes.AddItem("WoTC_PurgePriest.ARC_GameUnit_ExaltedPurgeArchbishop_M");
	//CharTemplate.strPawnArchetypes.AddItem("GameUnit_AdvPriest.ARC_GameUnit_AdvPriestM1_F");
	CharTemplate.strBehaviorTree = "ExaltedPurgeArchbishopRoot";

	// Auto-Loot
	Loot.ForceLevel = 0;
	Loot.LootTableName = 'AdvPriestM1_BaseLoot';
	CharTemplate.Loot.LootReferences.AddItem(Loot);

	// Timed Loot
	Loot.ForceLevel = 0;
	Loot.LootTableName = 'AdvPriestM1_TimedLoot';
	CharTemplate.TimedLoot.LootReferences.AddItem(Loot);
	Loot.LootTableName = 'AdvPriestM1_VultureLoot';
	CharTemplate.VultureLoot.LootReferences.AddItem(Loot);

	CharTemplate.strMatineePackages.AddItem("CIN_Advent");
	CharTemplate.strMatineePackages.AddItem("CIN_Soldier");	
	CharTemplate.strMatineePackages.AddItem("CIN_PurgeArchbishop");	
	CharTemplate.RevealMatineePrefix = "CIN_PurgeArchbishop";
	//CharTemplate.GetRevealMatineePrefixFn = GetAdventMatineePrefix;

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
	CharTemplate.bCanUse_eTraversal_BreakWall = true;
	CharTemplate.bAppearanceDefinesPawn = false;
	CharTemplate.bSetGenderAlways = true;
	CharTemplate.bCanTakeCover = true;

	CharTemplate.bIsAlien = false;
	CharTemplate.bIsAdvent = true;
	CharTemplate.bIsCivilian = false;
	CharTemplate.bIsPsionic = true;
	CharTemplate.bIsRobotic = false;
	CharTemplate.bIsSoldier = false;

	CharTemplate.bCanBeTerrorist = false;
	CharTemplate.bCanBeCriticallyWounded = false;
	CharTemplate.bIsAfraidOfFire = false;
	
	CharTemplate.Abilities.AddItem('PurgeFocus');
	CharTemplate.Abilities.AddItem('PurgingFocus');
	CharTemplate.Abilities.AddItem('BlazingFocus');
	CharTemplate.Abilities.AddItem('ExaltedFocus');
	CharTemplate.Abilities.AddItem('ApocalypticFocus');
	CharTemplate.Abilities.AddItem('PlasmaResistance');
	CharTemplate.Abilities.AddItem('SuperHeated');
	CharTemplate.Abilities.AddItem('MassJail');


	CharTemplate.Abilities.AddItem('AdventStilettoRounds');
	CharTemplate.Abilities.AddItem('DarkEventAbility_ReturnFire');
	CharTemplate.Abilities.AddItem('DarkEventAbility_SealedArmor');
	CharTemplate.Abilities.AddItem('DarkEventAbility_UndyingLoyalty');
	CharTemplate.Abilities.AddItem('DarkEventAbility_Barrier');
	CharTemplate.Abilities.AddItem('DarkEventAbility_Counterattack');
	CharTemplate.Abilities.Additem('CloseCombatSpecialist');

	//CharTemplate.SightedNarrativeMoments.AddItem(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_TYG_T_First_Seen_Adv_Priest_M1');

	CharTemplate.strHackIconImage = "UILibrary_Common.TargetIcons.Hack_captain_icon";
	CharTemplate.strTargetIconImage = class'UIUtilities_Image'.const.TargetIcon_Advent;

	return CharTemplate;
	}