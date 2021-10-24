//---------------------------------------------------------------------------------------
//  FILE:    X2Ability_PerkPackAbilitySet2
//  AUTHOR:  Amineri (Pavonis Interactive)
//  PURPOSE: Defines general use ability templates -- second set to reduce merging issues
//--------------------------------------------------------------------------------------- 

class X2Ability_PerkPackAbilitySet2 extends XMBAbility config (LW_SoldierSkills) dependson(X2Effect_TemporaryItem);

var localized string TrojanVirus;
var localized string TrojanVirusTriggered;

var config int NUM_AIRDROP_CHARGES;
var config int SAVIOR_BONUS_HEAL;
var config int REQUIRED_TO_HIT_FOR_OVERWATCH;
var config float BONUS_SLICE_DAMAGE_PER_TILE;
var config float FIELD_SURGEON_WOUND_REDUCTION;
var config int MAX_SLICE_FLECHE_DAMAGE;
var config int FLECHE_COOLDOWN;
var config array<name> REQUIRED_OVERWATCH_TO_HIT_EXCLUDED_ABILITIES;

var config int PHANTOM_DURATION;
var config float PHANTOM_DETECTION_RANGE_REDUCTION;
var config int PHANTOM_COOLDOWN;
var config int PHANTOM_CHARGES;
var config int CONCEAL_BONUS_CHARGES;
var config float REAPER_PCT_DMG_REDUCTION;
var config int SERIAL_PCT_DMG_REDUCTION;

var config int SPRAY_AND_PRAY_DODGE;
var config int STOCK_SPRAY_AND_PRAY_DODGE;

const DAMAGED_COUNT_NAME = 'DamagedCountThisTurn';

var localized string PhantomExpiredFlyover;
static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	Templates.AddItem(AddSnapShot());
	Templates.AddItem(SnapShotOverwatch());
	Templates.AddItem(AddSnapShotAimModifierAbility());
	Templates.AddItem(AddTrojan());
	Templates.AddItem(AddTrojanVirus());
	Templates.AddItem(AddFlashbanger());
	Templates.AddItem(AddSmokeGrenade());
	Templates.AddItem(AddSavior());
	Templates.AddItem(AddDenseSmoke());
	Templates.AddItem(AddRapidDeployment());
	Templates.AddItem(AddAirdrop());
	Templates.AddItem(AddSwordSlice_LWAbility());
	Templates.AddItem(AddFleche());
	Templates.AddItem(AddBastion());
	Templates.AddItem(AddBastionPassive());
	Templates.AddItem(AddBastionCleanse());
	Templates.AddItem(AddFullKit());
	Templates.AddItem(AddStingGrenades());
	Templates.AddItem(AddFieldSurgeon());
	Templates.AddItem(AddDamageInstanceTracker());
	Templates.AddItem(AddNewEVTrigger());
	Templates.AddItem(AddNewPhantom());
	Templates.AddItem(CreateImpact());
	Templates.AddItem(CreatePlatformStability());
	Templates.AddItem(CreateImpact());
	Templates.AddItem(CreateNewConceal());
	Templates.AddItem(InTheZone());
	Templates.AddItem(Reaper());
	Templates.AddItem(SprayAndPray());
	Templates.AddItem(StockSprayAndPray());

	Templates.AddItem(OverrideImpairingAbility());
	Templates.AddItem(OverrideStunImpairingAbility());
	Templates.AddItem(CreateImprovedProtocols());

	Templates.AddItem(AddSawedOffReload());
	Templates.AddItem(CreateAdvancedRobotics());
	Templates.AddItem(ChainingJolt());
	Templates.AddItem(CreateBulletStorm());
	
	
	return Templates;
}

// - Generic : Standard Shot -
static function X2AbilityTemplate AddSnapShot()
{
	local X2AbilityTemplate                 Template;	
	local X2AbilityCost_Ammo                AmmoCost;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local array<name>                       SkipExclusions;
	local X2Effect_Knockback				KnockbackEffect;
	local X2Condition_Visibility            VisibilityCondition;

	// Macro to do localisation and stuffs
	`CREATE_X2ABILITY_TEMPLATE(Template, 'SnapShot');

	// Icon Properties
	//Template.bDontDisplayInAbilitySummary = true;
	Template.IconImage = "img:///UILibrary_LW_PerkPack.LW_AbilitySnapShot";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.STANDARD_SHOT_PRIORITY;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_HideIfOtherAvailable;
	Template.HideIfAvailable.AddItem('SniperStandardFire');
	Template.DisplayTargetHitChance = true;
	Template.AbilitySourceName = 'eAbilitySource_Perk';                                       // color of the icon
	Template.bCrossClassEligible = false;
	Template.Hostility = eHostility_Offensive;
	// Activated by a button press; additionally, tells the AI this is an activatable
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	if (!class'X2Ability_PerkPackAbilitySet'.default.NO_STANDARD_ATTACKS_WHEN_ON_FIRE)
	{
		SkipExclusions.AddItem(class'X2StatusEffects'.default.BurningName);
	}

	SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName);
	Template.AddShooterEffectExclusions(SkipExclusions);

	// Targeting Details
	// Can only shoot visible enemies
	VisibilityCondition = new class'X2Condition_Visibility';
	VisibilityCondition.bRequireGameplayVisible = true;
	VisibilityCondition.bAllowSquadsight = true;
	Template.AbilityTargetConditions.AddItem(VisibilityCondition);
	// Can't target dead; Can't target friendlies
	Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);
	// Can't shoot while dead
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	// Only at single targets that are in range.
	Template.AbilityTargetStyle = default.SimpleSingleTarget;

	// Action Point
	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);	

	// Ammo
	AmmoCost = new class'X2AbilityCost_Ammo';	
	AmmoCost.iAmmo = 1;
	Template.AbilityCosts.AddItem(AmmoCost);
	Template.bAllowAmmoEffects = true; // 	

	// Weapon Upgrade Compatibility
	Template.bAllowFreeFireWeaponUpgrade = true;                        // Flag that permits action to become 'free action' via 'Hair Trigger' or similar upgrade / effects

	//  Put holo target effect first because if the target dies from this shot, it will be too late to notify the effect.
	Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());
	//  Various Soldier ability specific effects - effects check for the ability before applying	
	Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.ShredderDamageEffect());
	
	// Damage Effect
	Template.AddTargetEffect(default.WeaponUpgradeMissDamage);

	// Hit Calculation (Different weapons now have different calculations for range)
	Template.AbilityToHitCalc = default.SimpleStandardAim;
	Template.AbilityToHitOwnerOnMissCalc = default.SimpleStandardAim;
		
	// Targeting Method
	Template.TargetingMethod = class'X2TargetingMethod_OverTheShoulder';
	Template.bUsesFiringCamera = true;
	Template.CinescriptCameraType = "StandardGunFiring";	

	Template.AssociatedPassives.AddItem('HoloTargeting');

	// MAKE IT LIVE!
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;

	//Template.bDisplayInUITooltip = false;
	//Template.bDisplayInUITacticalText = false;

	KnockbackEffect = new class'X2Effect_Knockback';
	KnockbackEffect.KnockbackDistance = 2;
	Template.AddTargetEffect(KnockbackEffect);
	
	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotLostSpawnIncreasePerUse;

	//Template.OverrideAbilities.AddItem('SniperStandardFire');

	Template.AdditionalAbilities.AddItem('SnapShotAimModifier');
	//Template.AdditionalAbilities.AddItem('SnapShotOverwatch');

	return Template;	
}

static function X2AbilityTemplate SnapShotOverwatch()
{
	local X2AbilityTemplate                 Template;	
	local X2AbilityCost_Ammo                AmmoCost;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2Effect_ReserveActionPoints      ReserveActionPointsEffect;
	local array<name>                       SkipExclusions;
	local X2Effect_CoveringFire             CoveringFireEffect;
	local X2Condition_AbilityProperty       CoveringFireCondition;
	local X2Condition_UnitProperty          ConcealedCondition;
	local X2Effect_SetUnitValue             UnitValueEffect;
	local X2Condition_UnitEffects           SuppressedCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'SnapShotOverwatch');
	
	AmmoCost = new class'X2AbilityCost_Ammo';	
	AmmoCost.iAmmo = 1;
	AmmoCost.bFreeCost = true;                  //  ammo is consumed by the shot, not by this, but this should verify ammo is available
	Template.AbilityCosts.AddItem(AmmoCost);
	
	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;  // change to 1 for SnapShot
	ActionPointCost.bConsumeAllPoints = true;
	ActionPointCost.bFreeCost = true;           //  ReserveActionPoints effect will take all action points away
	Template.AbilityCosts.AddItem(ActionPointCost);
	
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

	SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName);
	Template.AddShooterEffectExclusions(SkipExclusions);
	SuppressedCondition = new class'X2Condition_UnitEffects';
	SuppressedCondition.AddExcludeEffect(class'X2Effect_Suppression'.default.EffectName, 'AA_UnitIsSuppressed');
	SuppressedCondition.AddExcludeEffect(class'X2Effect_AreaSuppression'.default.EffectName, 'AA_UnitIsSuppressed');
	Template.AbilityShooterConditions.AddItem(SuppressedCondition);
	
	ReserveActionPointsEffect = new class'X2Effect_ReserveOverwatchPoints';
	Template.AddTargetEffect(ReserveActionPointsEffect);

	CoveringFireEffect = new class'X2Effect_CoveringFire';
	CoveringFireEffect.AbilityToActivate = 'OverwatchShot';
	CoveringFireEffect.BuildPersistentEffect(1, false, true, false, eGameRule_PlayerTurnBegin);
	CoveringFireCondition = new class'X2Condition_AbilityProperty';
	CoveringFireCondition.OwnerHasSoldierAbilities.AddItem('CoveringFire');
	CoveringFireEffect.TargetConditions.AddItem(CoveringFireCondition);
	Template.AddTargetEffect(CoveringFireEffect);

	ConcealedCondition = new class'X2Condition_UnitProperty';
	ConcealedCondition.ExcludeFriendlyToSource = false;
	ConcealedCondition.IsConcealed = true;
	UnitValueEffect = new class'X2Effect_SetUnitValue';
	UnitValueEffect.UnitName = class'X2Ability_DefaultAbilitySet'.default.ConcealedOverwatchTurn;
	UnitValueEffect.CleanupType = eCleanup_BeginTurn;
	UnitValueEffect.NewValueToSet = 1;
	UnitValueEffect.TargetConditions.AddItem(ConcealedCondition);
	Template.AddTargetEffect(UnitValueEffect);

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	
	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_HideIfOtherAvailable;
	Template.HideIfAvailable.AddItem('SniperRifleOverwatch');

	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_overwatch";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.OVERWATCH_PRIORITY;
	Template.bDisplayInUITooltip = false;
	Template.bDisplayInUITacticalText = false;
	Template.AbilityConfirmSound = "Unreal2DSounds_OverWatch";

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = class'X2Ability_DefaultAbilitySet'.static.OverwatchAbility_BuildVisualization;
	Template.CinescriptCameraType = "Overwatch";

	Template.Hostility = eHostility_Defensive;

	Template.DefaultKeyBinding = class'UIUtilities_Input'.const.FXS_KEY_Y;
	Template.bNoConfirmationWithHotKey = true;

	//Template.OverrideAbilities.AddItem('');

	return Template;	
}

static function X2AbilityTemplate AddSnapShotAimModifierAbility()
{
	local X2AbilityTemplate						Template;
	local X2Effect_SnapShotAimModifier			AimModifier;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'SnapShotAimModifier');
	Template.IconImage = "img:///UILibrary_LW_PerkPack.LW_AbilitySnapShot";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	Template.bIsPassive = true;
	AimModifier = new class 'X2Effect_SnapShotAimModifier';
	AimModifier.BuildPersistentEffect (1, true, false);
	AimModifier.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,,Template.AbilitySourceName);
	Template.AddTargetEffect (AimModifier);
	Template.bCrossClassEligible = false;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}

//this ability places an effect on the unit that can hack, and triggers when the unit successfully hacks another unit
static function X2AbilityTemplate AddTrojan()
{
	local X2AbilityTemplate						Template;
	local X2Effect_Trojan			TrojanEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Trojan');
	Template.IconImage = "img:///UILibrary_LW_PerkPack.LW_AbilityTrojan";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	Template.bIsPassive = true;
	TrojanEffect = new class 'X2Effect_Trojan';
	TrojanEffect.BuildPersistentEffect (1, true, false);
	TrojanEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,,Template.AbilitySourceName);
	Template.AddTargetEffect (TrojanEffect);
	Template.bCrossClassEligible = false;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.AdditionalAbilities.AddItem('TrojanVirus');

	return Template;
}

//this ability is what gets triggered by a successful hack, and places the TrojanVirus effect on the hacked unit
static function X2AbilityTemplate AddTrojanVirus()
{
	local X2AbilityTemplate                 Template;		
	local X2AbilityCost_ActionPoints        ActionPointCost;	
	local X2Condition_UnitProperty          ShooterPropertyCondition;	
	local X2Condition_UnitProperty          TargetUnitPropertyCondition;	
	//local X2Condition_Visibility            TargetVisibilityCondition;
	local X2AbilityTarget_Single            SingleTarget;
	local X2AbilityTrigger_Placeholder		UseTrigger;
	local X2Effect_TrojanVirus				TrojanVirusEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'TrojanVirus');
	
	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.bFreeCost = true;
	Template.AbilityCosts.AddItem(ActionPointCost);
	
	//Can't evaluate stimuli while dead
	ShooterPropertyCondition = new class'X2Condition_UnitProperty';	
	ShooterPropertyCondition.ExcludeDead = true;                    	
	Template.AbilityShooterConditions.AddItem(ShooterPropertyCondition);

	//No triggering on dead, or friendlies
	TargetUnitPropertyCondition = new class'X2Condition_UnitProperty';	
	TargetUnitPropertyCondition.ExcludeDead = true;                    	
	TargetUnitPropertyCondition.ExcludeFriendlyToSource = false;	
	Template.AbilityTargetConditions.AddItem(TargetUnitPropertyCondition);

	// Note: No visibility requirement (matches intrusion protocol)
	// These must be the same or you can hack a robot and not have trojan apply.

	//Always applied when triggered
	Template.AbilityToHitCalc = default.DeadEye;

	//Single target ability
	SingleTarget = new class'X2AbilityTarget_Single';
	Template.AbilityTargetStyle = SingleTarget;

	//Triggered by persistent effect from Trojan
	UseTrigger = new class'X2AbilityTrigger_Placeholder';
	Template.AbilityTriggers.AddItem(UseTrigger);
	
	TrojanVirusEffect = new class 'X2Effect_TrojanVirus';
	TrojanVirusEffect.BuildPersistentEffect (1, true, false /*Remove on Source Death*/,, eGameRule_UnitGroupTurnBegin);
	TrojanVirusEffect.bTickWhenApplied = false;
	//TrojanVirusEffect.SetDisplayInfo(ePerkBuff_Penalty, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,,Template.AbilitySourceName);
	TrojanVirusEffect.EffectRemovedVisualizationFn = TrojanVirusVisualizationRemoved;
	Template.AddTargetEffect (TrojanVirusEffect);

	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_overwatch";
	Template.Hostility = eHostility_Neutral;

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//Template.BuildVisualizationFn = none; // no visualization on application on purpose -- it would be fighting with the hacking stuff

	return Template;	
}

// plays Trojan Virus flyover and message when the effect is removed (which is when the meaningful effects are triggered)
static function TrojanVirusVisualizationRemoved(XComGameState VisualizeGameState, out VisualizationActionMetadata BuildTrack, const name EffectApplyResult)
{
	local XComGameState_Unit UnitState;
	local X2Action_PlaySoundAndFlyOver SoundAndFlyOver;
	local XGParamTag kTag;
	local X2Action_PlayWorldMessage MessageAction;

	UnitState = XComGameState_Unit(BuildTrack.StateObject_NewState);
	if (UnitState == none)
		return;

	SoundAndFlyOver = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyOver'.static.AddToVisualizationTree(BuildTrack, VisualizeGameState.GetContext(), false, BuildTrack.LastActionAdded));
	SoundAndFlyOver.SetSoundAndFlyOverParameters(None, default.TrojanVirus, '', eColor_Bad, class'UIUtilities_Image'.const.UnitStatus_Haywire, 1.0);

	kTag = XGParamTag(`XEXPANDCONTEXT.FindTag("XGParam"));
	kTag.StrValue0 = UnitState.GetFullName();

	MessageAction = X2Action_PlayWorldMessage(class'X2Action_PlayWorldMessage'.static.AddToVisualizationTree(BuildTrack, VisualizeGameState.GetContext(), false, BuildTrack.LastActionAdded));
	MessageAction.AddWorldMessage(`XEXPAND.ExpandString(default.TrojanVirusTriggered));
}

//this ability grants a free equip of a flashbang grenade
static function X2AbilityTemplate AddFlashbanger()
{
	local X2AbilityTemplate						Template;
	local X2Effect_TemporaryItem				TemporaryItemEffect;
	local X2AbilityTrigger_UnitPostBeginPlay	Trigger;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Flashbanger');

	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_grenade_flash";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	
	Trigger = new class'X2AbilityTrigger_UnitPostBeginPlay';
	Trigger.Priority -= 20; // delayed so that Full Kit happen first
	Template.AbilityTriggers.AddItem(Trigger);
	
	Template.bIsPassive = true;
	Template.bCrossClassEligible = true;
	TemporaryItemEffect = new class'X2Effect_TemporaryItem';
	TemporaryItemEffect.EffectName = 'FlashbangerEffect';
	TemporaryItemEffect.ItemName = 'FlashbangGrenade';
	TemporaryItemEffect.AlternativeItemNames.AddItem('StingGrenade');
	TemporaryItemEffect.ForceCheckAbilities.AddItem('LaunchGrenade');
	TemporaryItemEffect.bIgnoreItemEquipRestrictions = true;
	TemporaryItemEffect.BuildPersistentEffect(1, true, false);
	TemporaryItemEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, false,,Template.AbilitySourceName);
	TemporaryItemEffect.DuplicateResponse = eDupe_Ignore;
	Template.AddTargetEffect(TemporaryItemEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}

//this ability grants a free equip of a smoke grenade, dense smoke grenade, smoke bomb, or dense smoke bomb
static function X2AbilityTemplate AddSmokeGrenade()
{
	local X2AbilityTemplate						Template;
	local X2Effect_TemporaryItem				TemporaryItemEffect;
	local X2AbilityTrigger_UnitPostBeginPlay	Trigger;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'SmokeGrenade');

	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_grenade_smoke";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;

	Trigger = new class'X2AbilityTrigger_UnitPostBeginPlay';
	Trigger.Priority -= 20; // delayed so that Full Kit happen first
	Template.AbilityTriggers.AddItem(Trigger);

	Template.bIsPassive = true;
	Template.bCrossClassEligible = true;


	TemporaryItemEffect = new class'X2Effect_TemporaryItem';
	TemporaryItemEffect.EffectName = 'SmokeGrenadeEffect';
	TemporaryItemEffect.ItemName = 'SmokeGrenade';
	//TemporaryItemEffect.ResearchOptionalItems.AddItem(Conditional);
	TemporaryItemEffect.AlternativeItemNames.AddItem('DenseSmokeGrenade');
	TemporaryItemEffect.AlternativeItemNames.AddItem('DenseSmokeGrenadeMk2');
	TemporaryItemEffect.ForceCheckAbilities.AddItem('LaunchGrenade');
	TemporaryItemEffect.bIgnoreItemEquipRestrictions = true;
	TemporaryItemEffect.BuildPersistentEffect(1, true, false);
	TemporaryItemEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, false,,Template.AbilitySourceName);
	TemporaryItemEffect.DuplicateResponse = eDupe_Ignore;
	Template.AddTargetEffect(TemporaryItemEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}

//this ability causes the unit to heal more when using medikits
static function X2AbilityTemplate AddSavior()
{
	local X2AbilityTemplate						Template;
	local X2Effect_Savior						SaviorEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Savior');
	Template.IconImage = "img:///UILibrary_LW_PerkPack.LW_AbilitySavior";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	Template.bIsPassive = true;
	Template.bCrossClassEligible = true;

	SaviorEffect = new class 'X2Effect_Savior';
	SaviorEffect.BuildPersistentEffect (1, true, false);
	SaviorEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,,Template.AbilitySourceName);
	SaviorEffect.BonusHealAmount = default.SAVIOR_BONUS_HEAL;
	Template.AddTargetEffect(SaviorEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}

//this increases the defense bonus of smoke grenades and smoke bombs used by the unit
// accomplished by swapping out existing smoke grenade/bomb for a dense smoke version
static function X2AbilityTemplate AddDenseSmoke()
{
	local X2AbilityTemplate						Template;
	local X2Effect_TemporaryItem				TemporaryItemEffect;
	local X2AbilityTrigger_UnitPostBeginPlay	Trigger;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'DenseSmoke');

	Template.IconImage = "img:///UILibrary_LW_PerkPack.LW_AbilityDenseSmoke";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.bIsPassive = true;
	Template.bCrossClassEligible = true;

	Trigger = new class'X2AbilityTrigger_UnitPostBeginPlay';
	Trigger.Priority -= 40; // delayed so that any other abilities that add items happen first
	Template.AbilityTriggers.AddItem(Trigger);

	TemporaryItemEffect = new class'X2Effect_TemporaryItem';
	TemporaryItemEffect.EffectName = 'DenseSmokeGrenadeEffect';
	TemporaryItemEffect.ItemName = 'DenseSmokeGrenade';
	TemporaryItemEffect.bReplaceExistingItemOnly = true;
	TemporaryItemEffect.ExistingItemName = 'SmokeGrenade';
	TemporaryItemEffect.ForceCheckAbilities.AddItem('LaunchGrenade');
	TemporaryItemEffect.bIgnoreItemEquipRestrictions = true;
	TemporaryItemEffect.BuildPersistentEffect(1, true, false);
	TemporaryItemEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,,Template.AbilitySourceName);
	TemporaryItemEffect.DuplicateResponse = eDupe_Ignore;
	Template.AddTargetEffect(TemporaryItemEffect);

	TemporaryItemEffect = new class'X2Effect_TemporaryItem';
	TemporaryItemEffect.EffectName = 'DenseSmokeBombEffect';
	TemporaryItemEffect.ItemName = 'DenseSmokeGrenadeMk2';
	TemporaryItemEffect.bReplaceExistingItemOnly = true;
	TemporaryItemEffect.ExistingItemName = 'SmokeGrenadeMk2';
	TemporaryItemEffect.ForceCheckAbilities.AddItem('LaunchGrenade');
	TemporaryItemEffect.bIgnoreItemEquipRestrictions = true;
	TemporaryItemEffect.BuildPersistentEffect(1, true, false);
	//TemporaryItemEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,,Template.AbilitySourceName);
	TemporaryItemEffect.DuplicateResponse = eDupe_Ignore;
	Template.AddTargetEffect(TemporaryItemEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;

	return Template;
}

//this ability allows the next use (this turn) of smoke grenade or flashbang to be free
static function X2AbilityTemplate AddRapidDeployment()
{
	local X2AbilityTemplate					Template;
	local X2Effect_RapidDeployment			RapidDeploymentEffect;
	local X2AbilityCooldown					Cooldown;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'RapidDeployment');
	Template.IconImage = "img:///UILibrary_LW_PerkPack.LW_AbilityRapidDeployment";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.STASIS_LANCE_PRIORITY;
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_AlwaysShow;
	Template.Hostility = eHostility_Neutral;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	Template.bIsPassive = true;
	Template.AddShooterEffectExclusions();
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

	Cooldown = new class'X2AbilityCooldown';
    Cooldown.iNumTurns = class'X2Effect_RapidDeployment'.default.RAPID_DEPLOYMENT_COOLDOWN;
    Template.AbilityCooldown = Cooldown;

	Template.AbilityCosts.AddItem(default.FreeActionCost);
	
	RapidDeploymentEffect = new class 'X2Effect_RapidDeployment';
	RapidDeploymentEffect.BuildPersistentEffect (1, false, true, true, eGameRule_PlayerTurnEnd);
	RapidDeploymentEFfect.EffectName = 'RapidDeploymentEffect';
	RapidDeploymentEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,,Template.AbilitySourceName);
	Template.AddTargetEffect (RapidDeploymentEffect);

	Template.bCrossClassEligible = true;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = RapidDeployment_BuildVisualization;
	Template.bShowActivation = false;

	return Template;
}

// plays Rapid Deployment flyover and message when the ability is activated
static function RapidDeployment_BuildVisualization(XComGameState VisualizeGameState)
{
	local XComGameStateHistory				History;
    local XComGameStateContext_Ability		context;
    local StateObjectReference				InteractingUnitRef;
    local VisualizationActionMetadata		EmptyTrack, BuildTrack; 
	local X2Action_PlaySoundAndFlyOver		SoundAndFlyover; 
	local XComGameState_Ability				Ability;

    History = `XCOMHISTORY;
    context = XComGameStateContext_Ability(VisualizeGameState.GetContext());
	Ability = XComGameState_Ability(History.GetGameStateForObjectID(context.InputContext.AbilityRef.ObjectID, 1, VisualizeGameState.HistoryIndex - 1));
    InteractingUnitRef = context.InputContext.SourceObject;
    BuildTrack = EmptyTrack;
    BuildTrack.StateObject_OldState = History.GetGameStateForObjectID(InteractingUnitRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
    BuildTrack.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(InteractingUnitRef.ObjectID);
    BuildTrack.VisualizeActor = History.GetVisualizer(InteractingUnitRef.ObjectID);
    
    SoundAndFlyover = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyOver'.static.AddToVisualizationTree(BuildTrack, context, false, BuildTrack.LastActionAdded));
    SoundAndFlyover.SetSoundAndFlyOverParameters(none, Ability.GetMyTemplate().LocFlyOverText, 'None', eColor_xcom);
}

//this ability grants a free equip of a either a frag grenade or plasma grenade to the targetted unit
static function X2AbilityTemplate AddAirdrop()
{
	local X2AbilityTemplate					Template;
	local X2AbilityCost_ActionPoints		ActionPointCost;
	local X2Effect_TemporaryItem			TemporaryItemEffect;
	local ResearchConditional				Conditional;
	local X2Condition_UnitProperty			TargetProperty;
	local X2AbilityCost_Charges             ChargeCost;
	local X2AbilityCharges                  Charges;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Airdrop');

	Template.IconImage = "img:///UILibrary_LW_PerkPack.LW_AbilityAirdrop";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_SQUADDIE_PRIORITY;
	Template.Hostility = eHostility_Neutral;
	Template.bLimitTargetIcons = true;
	Template.DisplayTargetHitChance = false;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SingleTargetWithSelf;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	Template.bCrossClassEligible = false;

	Charges = new class'X2AbilityCharges';
	Charges.InitialCharges = default.NUM_AIRDROP_CHARGES;
	Template.AbilityCharges = Charges;

	ChargeCost = new class'X2AbilityCost_Charges';
	ChargeCost.NumCharges = 1;
	Template.AbilityCosts.AddItem(ChargeCost);

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = false;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	TargetProperty = new class'X2Condition_UnitProperty';
	TargetProperty.ExcludeDead = true;
	TargetProperty.ExcludeHostileToSource = true;
	TargetProperty.ExcludeFriendlyToSource = false;
	TargetProperty.TreatMindControlledSquadmateAsHostile = true;
	TargetProperty.RequireSquadmates = true;
	TargetProperty.ExcludeRobotic = true;
	TargetProperty.ExcludeAlien = true;
	Template.AbilityTargetConditions.AddItem(TargetProperty);



	TemporaryItemEffect = new class'X2Effect_TemporaryItem';

	Conditional.ResearchProjectName = 'AutopsyMuton';
	Conditional.ItemName = 'MagGrenade_LW';
	TemporaryItemEffect.ResearchOptionalItems.AddItem(Conditional);

	Conditional.ResearchProjectName = 'AdvancedGrenades';
	Conditional.ItemName = 'AlienGrenade';
	TemporaryItemEffect.ResearchOptionalItems.AddItem(Conditional);

	TemporaryItemEffect.EffectName = 'AirdropGrenadeEffect';
	TemporaryItemEffect.ItemName = 'FragGrenade';
	TemporaryItemEffect.ForceCheckAbilities.AddItem('LaunchGrenade');
	TemporaryItemEffect.bIgnoreItemEquipRestrictions = true;
	TemporaryItemEffect.BuildPersistentEffect(1, true, false);
	TemporaryItemEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, false,,Template.AbilitySourceName);
	TemporaryItemEffect.DuplicateResponse = eDupe_Allow;
	Template.AddTargetEffect(TemporaryItemEffect);

	Template.bStationaryWeapon = true;
	Template.BuildNewGameStateFn = class'X2Ability_SpecialistAbilitySet'.static.AttachGremlinToTarget_BuildGameState;
	Template.BuildVisualizationFn = class'X2Ability_SpecialistAbilitySet'.static.GremlinSingleTarget_BuildVisualization;
	Template.bSkipPerkActivationActions = true;
	Template.PostActivationEvents.AddItem('ItemRecalled');
	
	Template.CustomSelfFireAnim = 'NO_CombatProtocol';
	Template.CinescriptCameraType = "Specialist_CombatProtocol";

	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.NonAggressiveChosenActivationIncreasePerUse;

	return Template;
}


static function X2AbilityTemplate AddSwordSlice_LWAbility()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2AbilityToHitCalc_StandardMelee  StandardMelee;
	local X2Effect_ApplyWeaponDamage        WeaponDamageEffect;
	local X2AbilityCooldown Cooldown;
	`CREATE_X2ABILITY_TEMPLATE(Template, 'SwordSlice_LW');

	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_AlwaysShow;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.CinescriptCameraType = "Ranger_Reaper";
	Template.IconImage = "img:///UILibrary_LW_PerkPack.LW_AbilityFleche";
	Template.bHideOnClassUnlock = false;
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_SQUADDIE_PRIORITY;
	Template.AbilityConfirmSound = "TacticalUI_SwordConfirm";
	Template.bCrossClassEligible = false;

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Cooldown = new class'X2AbilityCooldown';
    Cooldown.iNumTurns = default.FLECHE_COOLDOWN;
    Template.AbilityCooldown = Cooldown;

	
	StandardMelee = new class'X2AbilityToHitCalc_StandardMelee';
	Template.AbilityToHitCalc = StandardMelee;

	Template.AbilityTargetStyle = new class'X2AbilityTarget_MovingMelee';
	Template.TargetingMethod = class'X2TargetingMethod_MeleePath';

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	Template.AbilityTriggers.AddItem(new class'X2AbilityTrigger_EndOfMove');

	// Target Conditions
	//
	Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);
	Template.AbilityTargetConditions.AddItem(default.MeleeVisibilityCondition);

	// Shooter Conditions
	//
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	// Damage Effect
	//
	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	Template.AddTargetEffect(WeaponDamageEffect);

	Template.bAllowBonusWeaponEffects = true;
	Template.bSkipMoveStop = true;
	
	// Voice events
	//
	Template.SourceMissSpeech = 'SwordMiss';

	//Template.ConcealmentRule = eConceal_Always;

	Template.BuildNewGameStateFn = TypicalMoveEndAbility_BuildGameState;
	Template.BuildInterruptGameStateFn = TypicalMoveEndAbility_BuildInterruptGameState;

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.MeleeLostSpawnIncreasePerUse;

	//Template.AdditionalAbilities.AddItem('Fleche');

	return Template;
}

//this passive causes SwordSlice to deal more damage the further the unit moved
static function X2AbilityTemplate AddFleche()
{
	local X2AbilityTemplate						Template;
	local X2Effect_FlecheBonusDamage			FlecheBonusDamageEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Fleche');
	Template.IconImage = "img:///UILibrary_LW_PerkPack.LW_AbilityFleche";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	Template.bIsPassive = true;
	Template.bHideOnClassUnlock = true;
	Template.bCrossClassEligible = false;
	FlecheBonusDamageEffect = new class 'X2Effect_FlecheBonusDamage';
	FlecheBonusDamageEffect.BonusDmgPerTile = default.BONUS_SLICE_DAMAGE_PER_TILE;
	FlecheBonusDamageEffect.MaxBonusDamage = default.MAX_SLICE_FLECHE_DAMAGE;
	FlecheBonusDamageEffect.AbilityNames.AddItem('SwordSlice');
	FlecheBonusDamageEffect.AbilityNames.AddItem('SwordSlice_LW');
	//FlecheBonusDamageEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,,Template.AbilitySourceName);
	FlecheBonusDamageEffect.BuildPersistentEffect (1, true, false);
	Template.AddTargetEffect (FlecheBonusDamageEffect);
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}

static function X2AbilityTemplate AddBastion()
{
	local X2AbilityTemplate             Template;
	local X2Effect_Bastion               Effect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Bastion');

	Template.IconImage = "img:///UILibrary_LW_PerkPack.LW_AbilityBastion";
	Template.AbilitySourceName = 'eAbilitySource_Psionic';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.bCrossClassEligible = false;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	Template.AbilityMultiTargetStyle = new class'X2AbilityMultiTarget_AllAllies';

	Effect = new class'X2Effect_Bastion';
	Effect.BuildPersistentEffect(1, true, false);
	Effect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,, Template.AbilitySourceName);
	Template.AddMultiTargetEffect(Effect);

	Template.AdditionalAbilities.AddItem('BastionCleanse');
	Template.AdditionalAbilities.AddItem('BastionPassive');

	Template.bSkipFireAction = true;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	Template.PrerequisiteAbilities.AddItem('Fortress');

	return Template;
}

static function X2AbilityTemplate AddBastionPassive()
{
	return PurePassive('BastionPassive', "img:///UILibrary_LW_PerkPack.LW_AbilityBastion", , 'eAbilitySource_Psionic');
}

static function X2AbilityTemplate AddBastionCleanse()
{
	local X2AbilityTemplate                     Template;
	local X2AbilityTrigger_EventListener        EventListener;
	local X2Condition_UnitProperty              DistanceCondition;
	local X2Effect_RemoveEffects				FortressRemoveEffect;
	local X2Condition_UnitProperty              FriendCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'BastionCleanse');

	Template.IconImage = "img:///UILibrary_LW_PerkPack.LW_AbilityBastion";
	Template.AbilitySourceName = 'eAbilitySource_Psionic';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SimpleSingleTarget;
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

	EventListener = new class'X2AbilityTrigger_EventListener';
	EventListener.ListenerData.Deferral = ELD_OnStateSubmitted;
	EventListener.ListenerData.EventID = 'UnitMoveFinished';
	EventListener.ListenerData.Filter = eFilter_None;
	EventListener.ListenerData.EventFn = class'XComGameState_Ability'.static.SolaceCleanseListener;  // keep this, since it's generically just calling the associate ability
	Template.AbilityTriggers.AddItem(EventListener);

	//removes any ongoing effects
	FortressRemoveEffect = new class'X2Effect_RemoveEffects';
	FortressRemoveEffect.EffectNamesToRemove.AddItem(class'X2StatusEffects'.default.AcidBurningName);
	FortressRemoveEffect.EffectNamesToRemove.AddItem(class'X2StatusEffects'.default.BurningName);
	FortressRemoveEffect.EffectNamesToRemove.AddItem(class'X2StatusEffects'.default.PoisonedName);
	FortressRemoveEffect.EffectNamesToRemove.AddItem(class'X2Effect_ParthenogenicPoison'.default.EffectName);
	FriendCondition = new class'X2Condition_UnitProperty';
	FriendCondition.ExcludeFriendlyToSource = false;
	FriendCondition.ExcludeHostileToSource = true;
	FortressRemoveEffect.TargetConditions.AddItem(FriendCondition);
	Template.AddTargetEffect(FortressRemoveEffect);

	DistanceCondition = new class'X2Condition_UnitProperty';
	DistanceCondition.RequireWithinRange = true;
	DistanceCondition.WithinRange = Sqrt(class'X2Effect_Bastion'.default.BASTION_DISTANCE_SQ) *  class'XComWorldData'.const.WORLD_StepSize; // same as Solace for now
	DistanceCondition.ExcludeFriendlyToSource = false;
	DistanceCondition.ExcludeHostileToSource = false;
	Template.AbilityTargetConditions.AddItem(DistanceCondition);

	Template.bSkipFireAction = true;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	return Template;
}

//this ability grants the unit +1 charge for each grenade in a utility slot
static function X2AbilityTemplate AddFullKit()
{
	local X2AbilityTemplate						Template;
	local X2Effect_FullKit					FullKitEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'FullKit');
	Template.IconImage = "img:///UILibrary_LW_PerkPack.LW_AbilityFullKit";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	Template.bIsPassive = true;
	FullKitEffect = new class 'X2Effect_FullKit';
	FullKitEffect.BuildPersistentEffect (1, true, false);
	FullKitEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,,Template.AbilitySourceName);
	Template.AddTargetEffect (FullKitEffect);
	Template.bCrossClassEligible = true;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}

//this improves the effectiveness of flashbangs by giving them a chance to stun non-robotic units
// accomplished by swapping out existing flashbang items for new sting grenade item
static function X2AbilityTemplate AddStingGrenades()
{
	local X2AbilityTemplate						Template;
	local X2Effect_TemporaryItem				TemporaryItemEffect;
	local X2AbilityTrigger_UnitPostBeginPlay	Trigger;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'StingGrenades');

	Template.IconImage = "img:///UILibrary_LW_PerkPack.LW_AbilityStunGrenades";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.bIsPassive = true;
	Template.bCrossClassEligible = false;

	Trigger = new class'X2AbilityTrigger_UnitPostBeginPlay';
	Trigger.Priority -= 40; // delayed so that any other abilities that add items happen first
	Template.AbilityTriggers.AddItem(Trigger);

	TemporaryItemEffect = new class'X2Effect_TemporaryItem';
	TemporaryItemEffect.EffectName = 'StingGrenadeEffect';
	TemporaryItemEffect.ItemName = 'StingGrenade';
	TemporaryItemEffect.bReplaceExistingItemOnly = true;
	TemporaryItemEffect.ExistingItemName = 'FlashbangGrenade';
	TemporaryItemEffect.ForceCheckAbilities.AddItem('LaunchGrenade');
	TemporaryItemEffect.bIgnoreItemEquipRestrictions = true;
	TemporaryItemEffect.BuildPersistentEffect(1, true, false);
	TemporaryItemEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,,Template.AbilitySourceName);
	TemporaryItemEffect.DuplicateResponse = eDupe_Ignore;
	Template.AddTargetEffect(TemporaryItemEffect);

	TemporaryItemEffect = new class'X2Effect_TemporaryItem';
	TemporaryItemEffect.EffectName = 'StingGrenadeEffect2';
	TemporaryItemEffect.ItemName = 'StingGrenade';
	TemporaryItemEffect.bReplaceExistingItemOnly = true;
	TemporaryItemEffect.ExistingItemName = 'HunterFlashbang';
	TemporaryItemEffect.ForceCheckAbilities.AddItem('LaunchGrenade');
	TemporaryItemEffect.bIgnoreItemEquipRestrictions = true;
	TemporaryItemEffect.BuildPersistentEffect(1, true, false);
	TemporaryItemEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,,Template.AbilitySourceName);
	TemporaryItemEffect.DuplicateResponse = eDupe_Ignore;
	Template.AddTargetEffect(TemporaryItemEffect);

	TemporaryItemEffect = new class'X2Effect_TemporaryItem';
	TemporaryItemEffect.EffectName = 'StingGrenadeEffect3';
	TemporaryItemEffect.ItemName = 'StingGrenade';
	TemporaryItemEffect.bReplaceExistingItemOnly = true;
	TemporaryItemEffect.ExistingItemName = 'AdvGrenadierFlashbangGrenade';
	TemporaryItemEffect.ForceCheckAbilities.AddItem('LaunchGrenade');
	TemporaryItemEffect.bIgnoreItemEquipRestrictions = true;
	TemporaryItemEffect.BuildPersistentEffect(1, true, false);
	TemporaryItemEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,,Template.AbilitySourceName);
	TemporaryItemEffect.DuplicateResponse = eDupe_Ignore;
	Template.AddTargetEffect(TemporaryItemEffect);


	
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}

//this ability allows some healing of wounds (reducing lowest HP) at end of mission, if the field surgeon is alive and well
static function X2AbilityTemplate AddFieldSurgeon()
{
	local X2AbilityTemplate						Template;
	local X2AbilityTrigger_EventListener 		EventListener;	
	local X2Condition_UnitProperty              TargetProperty;
	local X2Effect_GreaterPadding FieldSurgeonEffect;
	`CREATE_X2ABILITY_TEMPLATE(Template, 'FieldSurgeon');
	Template.IconImage = "img:///UILibrary_LW_PerkPack.LW_AbilityFieldSurgeon";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SingleTargetWithSelf;

	TargetProperty = new class'X2Condition_UnitProperty';
	TargetProperty.ExcludeDead = true;
	TargetProperty.ExcludeHostileToSource = true;
	TargetProperty.ExcludeFriendlyToSource = false;
	TargetProperty.RequireSquadmates = true;
	Template.AbilityTargetConditions.AddItem(TargetProperty);	

	EventListener = new class'X2AbilityTrigger_EventListener';
	EventListener.ListenerData.EventID = 'OnUnitBeginPlay';	
	EventListener.ListenerData.EventFn = FieldSurgeonOnUnitBeginPlay;
	EventListener.ListenerData.Deferral = ELD_OnStateSubmitted;
	EventListener.ListenerData.Filter = eFilter_None;	
	Template.AbilityTriggers.AddItem(EventListener);

	FieldSurgeonEffect = new class 'X2Effect_GreaterPadding';
	FieldSurgeonEffect.BuildPersistentEffect (1, true, false);
	FieldSurgeonEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,,Template.AbilitySourceName);	
	FieldSurgeonEffect.EffectName = 'Field_Surgeon_Wound';
	FieldSurgeonEffect.DuplicateResponse = eDupe_Ignore;
	FieldSurgeonEffect.Padding_HealHP = default.FIELD_SURGEON_WOUND_REDUCTION;	


	Template.bCrossClassEligible = true;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}

static function EventListenerReturn FieldSurgeonOnUnitBeginPlay(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
	local XComGameState_Unit UnitState;
	local XComGameState_Ability SourceAbilityState;

	SourceAbilityState = XComGameState_Ability(CallbackData);	
	UnitState = XComGameState_Unit(EventData);

	if (SourceAbilityState != None  && UnitState != none) {	
		SourceAbilityState.AbilityTriggerAgainstSingleTarget(UnitState.GetReference(), false);
	}

	return ELR_NoInterrupt;
}

// Ability that tracks how many times a unit has been damaged each turn
static function X2AbilityTemplate AddDamageInstanceTracker()
{
	local X2AbilityTemplate					Template;
	local X2AbilityTrigger_EventListener	Trigger;	
	local X2Effect_IncrementUnitValue		CounterEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'DamageInstanceTracker');
	Template.IconImage = "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_standard";
	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.bDisplayInUITacticalText = false;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

	Trigger = new class'X2AbilityTrigger_EventListener';
	Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
	Trigger.ListenerData.EventID = 'UnitTakeEffectDamage';
	Trigger.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_Self;
	Trigger.ListenerData.Filter = eFilter_Unit;
	Template.AbilityTriggers.AddItem(Trigger);

	CounterEffect = new class'X2Effect_IncrementUnitValue';
	CounterEffect.UnitName = DAMAGED_COUNT_NAME;
	CounterEffect.NewValueToSet = 1;
	CounterEffect.CleanupType = eCleanup_BeginTurn;
	CounterEffect.bApplyOnHit = true;
	Template.AddShooterEffect(CounterEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	// No visualization for this ability

	return Template;
}
	
static function X2AbilityTemplate AddNewEVTrigger()
{
	local X2AbilityTemplate						Template;
	local X2AbilityTargetStyle                  TargetStyle;
	local X2AbilityTrigger						Trigger;
	local X2Effect_EverVigilant					EVEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'NewEverVigilantTrigger');

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

	Template.AbilityToHitCalc = default.DeadEye;

	TargetStyle = new class'X2AbilityTarget_Self';
	Template.AbilityTargetStyle = TargetStyle;

	Trigger = new class'X2AbilityTrigger_UnitPostBeginPlay';
	Template.AbilityTriggers.AddItem(Trigger);

	EVEffect = new class'X2Effect_EverVigilant';
	EVEffect.BuildPersistentEffect(1, true, false, false, eGameRule_PlayerTurnBegin);
	Template.AddTargetEffect(EVEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!

	return Template;
}



static function X2DataTemplate OverrideImpairingAbility()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityTarget_Single            SingleTarget;
	local X2Effect_Stunned				    StunnedEffect;
	local X2Condition_UnitProperty          UnitPropertyCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'ImpairingAbility');

	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;

	Template.bDontDisplayInAbilitySummary = true;
	SingleTarget = new class'X2AbilityTarget_Single';
	SingleTarget.OnlyIncludeTargetsInsideWeaponRange = true;
	Template.AbilityTargetStyle = SingleTarget;

	Template.AbilityTriggers.AddItem(new class'X2AbilityTrigger_Placeholder');      //  ability is activated by another ability that hits

	// Target Conditions
	//
	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.ExcludeImpaired = true;
	UnitPropertyCondition.ExcludeAlive = false;
	UnitPropertyCondition.ExcludeDead = true;
	UnitPropertyCondition.ExcludeFriendlyToSource = false;
	UnitPropertyCondition.ExcludeHostileToSource = false;
	UnitPropertyCondition.FailOnNonUnits = true;

	Template.AbilityTargetConditions.AddItem(UnitPropertyCondition);
	Template.AbilityTargetConditions.AddItem(default.GameplayVisibilityCondition);

	// Shooter Conditions
	//
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

	Template.AddShooterEffectExclusions();

	Template.AbilityToHitCalc = default.DeadEye;

	//  Stunned effect for 3 or 4 unblocked hit
	StunnedEffect = class'X2StatusEffects'.static.CreateStunnedStatusEffect(1, 100, false);
	StunnedEffect.bRemoveWhenSourceDies = false;
	//Template.AddTargetEffect(StunnedEffect);

	Template.bSkipFireAction = true;

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
//BEGIN AUTOGENERATED CODE: Template Overrides 'ImpairingAbility'
	Template.bFrameEvenWhenUnitIsHidden = true;
//END AUTOGENERATED CODE: Template Overrides 'ImpairingAbility'

	return Template;
}


static function X2DataTemplate OverrideStunImpairingAbility()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityTarget_Single            SingleTarget;
	local X2Effect_Stunned				    StunnedEffect;
	local X2Condition_UnitProperty          UnitPropertyCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'StunImpairingAbility');

	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;

	Template.bDontDisplayInAbilitySummary = true;
	SingleTarget = new class'X2AbilityTarget_Single';
	SingleTarget.OnlyIncludeTargetsInsideWeaponRange = true;
	Template.AbilityTargetStyle = SingleTarget;

	Template.AbilityTriggers.AddItem(new class'X2AbilityTrigger_Placeholder');      //  ability is activated by another ability that hits

	// Target Conditions
	//
	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.ExcludeImpaired = true;
	UnitPropertyCondition.ExcludeAlive = false;
	UnitPropertyCondition.ExcludeDead = true;
	UnitPropertyCondition.ExcludeFriendlyToSource = false;
	UnitPropertyCondition.ExcludeHostileToSource = false;
	UnitPropertyCondition.FailOnNonUnits = true;

	Template.AbilityTargetConditions.AddItem(UnitPropertyCondition);
	Template.AbilityTargetConditions.AddItem(default.GameplayVisibilityCondition);

	// Shooter Conditions
	//
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

	Template.AddShooterEffectExclusions();

	Template.AbilityToHitCalc = default.DeadEye;

	//  Stunned effect for 3 or 4 unblocked hit
	StunnedEffect = class'X2StatusEffects'.static.CreateStunnedStatusEffect(1, 100, false);
	StunnedEffect.bRemoveWhenSourceDies = false;
	Template.AddTargetEffect(StunnedEffect);

	Template.bSkipFireAction = true;

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
//BEGIN AUTOGENERATED CODE: Template Overrides 'ImpairingAbility'
	Template.bFrameEvenWhenUnitIsHidden = true;
//END AUTOGENERATED CODE: Template Overrides 'ImpairingAbility'

	return Template;
}

	static function X2AbilityTemplate AddNewPhantom()
{
	local X2AbilityTemplate						Template;
	local X2Effect_RangerStealth                StealthEffect;
	local X2AbilityCharges_BonusCharges                      Charges;
	local X2Effect_PersistentStatChange StealthyEffect;
	local X2AbilityCooldown	Cooldown;
	local X2Effect_SilentMelee GhostEffect;
	`CREATE_X2ABILITY_TEMPLATE(Template, 'Phantom_LW');

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_phantom";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_COLONEL_PRIORITY;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	Template.AbilityCosts.AddItem(new class'X2AbilityCost_Charges');
	Template.AbilityCosts.AddItem(default.FreeActionCost);

	Cooldown = new class'X2AbilityCooldown';
    Cooldown.iNumTurns = default.PHANTOM_COOLDOWN;
    Template.AbilityCooldown = Cooldown;

	Charges = new class'X2AbilityCharges_BonusCharges';
	Charges.InitialCharges = default.PHANTOM_CHARGES;
	Charges.BonusAbility = 'Stealth_LW';
	Charges.BonusChargesCount = default.CONCEAL_BONUS_CHARGES;
	Template.AbilityCharges = Charges;


	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	//Template.AbilityShooterConditions.AddItem(new class'X2Condition_Stealth');
	Template.AddShooterEffectExclusions();


	StealthyEffect = new class'X2Effect_PersistentStatChange';
	StealthyEffect.EffectName = 'TemporaryPhantomConcealment';
	StealthyEffect.BuildPersistentEffect(default.PHANTOM_DURATION, false, true, false, eGameRule_PlayerTurnBegin);
	// StealthyEffect.SetDisplayInfo (ePerkBuff_Bonus,Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage,,, Template.AbilitySourceName); 
	StealthyEffect.AddPersistentStatChange(eStat_DetectionModifier, default.PHANTOM_DETECTION_RANGE_REDUCTION);
	StealthyEffect.bRemoveWhenTargetDies = true;
	StealthyEffect.DuplicateResponse = eDupe_Refresh;
	StealthyEffect.EffectRemovedFn = PhantomExpired;
	StealthyEffect.EffectRemovedVisualizationFn = VisualizePhantomExpired;
	Template.AddTargetEffect(StealthyEffect);

	GhostEffect = new class'X2Effect_SilentMelee';
	GhostEffect.EffectName = 'GhostEffect';
	GhostEffect.BuildPersistentEffect(default.PHANTOM_DURATION, false, true, false, eGameRule_PlayerTurnBegin);
	// StealthyEffect.SetDisplayInfo (ePerkBuff_Bonus,Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage,,, Template.AbilitySourceName); 
	GhostEffect.bRemoveWhenTargetConcealmentBroken = true;
	GhostEffect.DuplicateResponse = eDupe_Refresh;
	Template.AddTargetEffect(GhostEffect);

	StealthEffect = new class'X2Effect_RangerStealth';
	StealthEffect.BuildPersistentEffect(1, true, true, false, eGameRule_PlayerTurnEnd);
	StealthEffect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, true);
	StealthEffect.bRemoveWhenTargetConcealmentBroken = true;
	Template.AddTargetEffect(StealthEffect);

	Template.AddTargetEffect(class'X2Effect_Spotted'.static.CreateUnspottedEffect());

	Template.ActivationSpeech = 'ActivateConcealment';
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.bSkipFireAction = true;

	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.NonAggressiveChosenActivationIncreasePerUse;

	return Template;

}


static function PhantomExpired(
	X2Effect_Persistent PersistentEffect,
	const out EffectAppliedData ApplyEffectParameters,
	XComGameState NewGameState,
	bool bCleansed)
{
	local XComGameState_Unit UnitState;

	UnitState = XComGameState_Unit(NewGameState.ModifyStateObject(class'XComGameState_Unit', ApplyEffectParameters.TargetStateObjectRef.ObjectID));

	`XEVENTMGR.TriggerEvent('EffectBreakUnitConcealment', UnitState, UnitState, NewGameState);
}


static function VisualizePhantomExpired(
	XComGameState VisualizeGameState,
	out VisualizationActionMetadata ActionMetadata,
	const name EffectApplyResult)
{
	local X2Action_PlaySoundAndFlyOver SoundAndFlyOver;
	local XComGameState_Unit UnitState;

	UnitState = XComGameState_Unit(ActionMetadata.StateObject_NewState);
	if (UnitState == none)
		return;

	SoundAndFlyOver = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyOver'.static.AddToVisualizationTree(ActionMetadata, VisualizeGameState.GetContext(), false, ActionMetadata.LastActionAdded));
	SoundAndFlyOver.SetSoundAndFlyOverParameters(none, default.PhantomExpiredFlyover, '', eColor_Bad);
}


static function X2AbilityTemplate CreateImpact()
{
	local X2AbilityTemplate		Template;

	Template = PurePassive('Impact', "img:///UILibrary_XPerkIconPack.UIPerk_stasis_overwatch", , 'eAbilitySource_Perk');

	Template.bDisplayInUITooltip = true;
	Template.bDisplayInUITacticalText = true;

	return Template;
}

static function X2AbilityTemplate CreateSteadFast()
{
	local X2AbilityTemplate		Template;

	Template = PurePassive('SteadFast', "img:///UILibrary_XPerkIconPack.UIPerk_suppression_defense2", , 'eAbilitySource_Perk');

	Template.bDisplayInUITooltip = true;
	Template.bDisplayInUITacticalText = true;

	return Template;
}
static function X2AbilityTemplate CreateBulletStorm()
{
	local X2AbilityTemplate		Template;

	Template = PurePassive('BulletStorm', "img:///UILibrary_XPerkIconPack.UIPerk_suppression_bullet_x3", , 'eAbilitySource_Perk');

	Template.bDisplayInUITooltip = true;
	Template.bDisplayInUITacticalText = true;

	return Template;
}

static function X2AbilityTemplate CreatePlatformStability()
{
	local X2AbilityTemplate		Template;

	Template = PurePassive('PlatformStability', "img:///UILibrary_XPerkIconPack.UIPerk_rocket_shot", , 'eAbilitySource_Perk');

	Template.bDisplayInUITooltip = true;
	Template.bDisplayInUITacticalText = true;

	return Template;
}

static function X2AbilityTemplate CreateImprovedProtocols()
{
	local X2AbilityTemplate		Template;

	Template = PurePassive('ImprovedProtocols', "img:///UILibrary_WOTC_APA_Class_Pack.perk_HotChargedBatteries", , 'eAbilitySource_Perk');

	Template.bDisplayInUITooltip = true;
	Template.bDisplayInUITacticalText = true;

	return Template;
}

static function X2AbilityTemplate CreateNewConceal()
{
	local X2AbilityTemplate		Template;

	Template = PurePassive('Stealth_LW', "img:///UILibrary_PerkIcons.UIPerk_stealth", , 'eAbilitySource_Perk');

	Template.bDisplayInUITooltip = true;
	Template.bDisplayInUITacticalText = true;

	return Template;
}

static function X2AbilityTemplate InTheZone()
{
	local X2AbilityTemplate				Template;
	local X2Effect_Serial_LW               SerialEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'InTheZone');

	// Icon Properties
	Template.DisplayTargetHitChance = false;
	Template.AbilitySourceName = 'eAbilitySource_Perk';                                       // color of the icon
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_InTheZone";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_COLONEL_PRIORITY;
	Template.Hostility = eHostility_Neutral;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";

	Template.bIsPassive = true;
	Template.AbilityToHitCalc = default.DeadEye;

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	SerialEffect = new class'X2Effect_Serial_LW';
	SerialEffect.PCT_DMG_Reduction = default.SERIAL_PCT_DMG_REDUCTION;
	SerialEffect.BuildPersistentEffect(1, true, true);
	SerialEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, true, , Template.AbilitySourceName);
	Template.AddTargetEffect(SerialEffect);

	Template.AbilityTargetStyle = default.SelfTarget;	
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	
	//Template.bShowActivation = true;
	Template.bSkipFireAction = true;

	//Template.ActivationSpeech = 'InTheZone';
	Template.bCrossClassEligible = true;
		
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	return Template;
}

static function X2AbilityTemplate Reaper()
{
	local X2AbilityTemplate				Template;
	local X2Effect_Reaper_LW               ReaperEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Reaper');

	// Icon Properties
	Template.DisplayTargetHitChance = false;
	Template.AbilitySourceName = 'eAbilitySource_Perk';                                       // color of the icon
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_reaper";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_COLONEL_PRIORITY;
	Template.Hostility = eHostility_Neutral;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";

	Template.AbilityToHitCalc = default.DeadEye;

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	ReaperEffect = new class'X2Effect_Reaper_LW';
	ReaperEffect.PCT_DMG_Reduction = default.REAPER_PCT_DMG_REDUCTION;
	ReaperEffect.BuildPersistentEffect(1, true, true);
	ReaperEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, true, , Template.AbilitySourceName);
	Template.AddTargetEffect(ReaperEffect);

	Template.AbilityTargetStyle = default.SelfTarget;	
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	
	//Template.bShowActivation = true;
	Template.bSkipFireAction = true;

	//Template.ActivationSpeech = 'Reaper';
		
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	return Template;
}

static function X2AbilityTemplate SprayAndPray()
{
	local X2AbilityTemplate					Template;
	local X2Effect_DodgeModifier			DodgeModifier;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'SprayAndPray');
	Template.IconImage = "img:///UILibrary_XPerkIconPack.UIPerk_move_blaze";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	Template.bIsPassive = true;
	DodgeModifier = new class 'X2Effect_DodgeModifier';
	DodgeModifier.DodgeReductionBonus = default.SPRAY_AND_PRAY_DODGE;
	DodgeModifier.BuildPersistentEffect (1, true, true);
	DodgeModifier.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, false,,Template.AbilitySourceName);
	Template.AddTargetEffect(DodgeModifier);

	Template.DefaultSourceItemSlot = eInvSlot_Pistol;

	Template.bCrossClassEligible = false;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	return Template;		
}
	


static function X2AbilityTemplate StockSprayAndPray()
{
	local X2AbilityTemplate					Template;
	local X2Effect_DodgeModifier			DodgeModifier;
	local X2Condition_PrimaryWeapon PrimaryWeaponCondition;
	`CREATE_X2ABILITY_TEMPLATE(Template, 'StockSprayAndPray');
	Template.IconImage = "img:///UILibrary_XPerkIconPack.UIPerk_move_blaze";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	Template.bIsPassive = true;

	PrimaryWeaponCondition = new class'X2Condition_PrimaryWeapon';
	PrimaryWeaponCondition.RequirePrimary = true;

	DodgeModifier = new class 'X2Effect_DodgeModifier';
	DodgeModifier.DodgeReductionBonus = default.STOCK_SPRAY_AND_PRAY_DODGE;
	DodgeModifier.BuildPersistentEffect (1, true, true);
	DodgeModifier.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, false,,Template.AbilitySourceName);
	DodgeModifier.TargetConditions.AddItem(PrimaryWeaponCondition);
	Template.AddTargetEffect(DodgeModifier);
	Template.DefaultSourceItemSlot = eInvSlot_PrimaryWeapon;
	Template.bCrossClassEligible = false;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	return Template;		
}

static function X2AbilityTemplate CreateAdvancedRobotics()
{
	local X2AbilityTemplate		Template;

	Template = PurePassive('AdvancedRobotics_LW', "img:///UILibrary_WOTC_APA_Class_Pack.perk_AdvancedRobotics", , 'eAbilitySource_Perk');

	Template.bDisplayInUITooltip = true;
	Template.bDisplayInUITacticalText = true;

	Template.AdditionalAbilities.AddItem('ThreatAssessment');
	Template.AdditionalAbilities.AddItem('ChainingJolt_LW');

	return Template;
}


static function X2AbilityTemplate AddSawedOffReload()
{
    local X2AbilityTemplate                 Template;   
    local X2AbilityCost_ActionPoints        ActionPointCost;
    local X2Condition_UnitProperty          ShooterPropertyCondition;
    local X2Condition_AbilitySourceWeapon   WeaponCondition;
    local X2AbilityTrigger_PlayerInput      InputTrigger;
    local array<name>                       SkipExclusions;
    
    `CREATE_X2ABILITY_TEMPLATE(Template, 'SawedOffReload');
    
	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	// Charges
	ShooterPropertyCondition = new class'X2Condition_UnitProperty';	
	ShooterPropertyCondition.ExcludeDead = true;
	Template.AbilityShooterConditions.AddItem(ShooterPropertyCondition);

	WeaponCondition = new class'X2Condition_AbilitySourceWeapon';
	WeaponCondition.WantsReload = true;
	Template.AbilityShooterConditions.AddItem(WeaponCondition);

	SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName);
	Template.AddShooterEffectExclusions(SkipExclusions);

	InputTrigger = new class'X2AbilityTrigger_PlayerInput';
	Template.AbilityTriggers.AddItem(InputTrigger);

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	
	Template.AbilitySourceName = 'eAbilitySource_Standard';
    Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_ShowIfAvailable;
	Template.IconImage = "img:///UILibrary_LWSecondariesWOTC.UIPerk_ReloadSawedOff";
    Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.STANDARD_PISTOL_SHOT_PRIORITY + 2;

	Template.bDisplayInUITooltip = false;
	Template.bDisplayInUITacticalText = false;
	Template.DisplayTargetHitChance = false;
	Template.bDontDisplayInAbilitySummary = false;
	
	Template.CustomFireAnim = 'HL_ReloadSawedOffA';
	Template.CustomSelfFireAnim = 'HL_ReloadSawedOffA';
	Template.bSkipExitCoverWhenFiring = false;
	Template.ActivationSpeech = 'Reloading';
	Template.Hostility = eHostility_Neutral;
	Template.CinescriptCameraType = "GenericAccentCam";
	Template.BuildNewGameStateFn = class'X2Ability_DefaultAbilitySet'.static.ReloadAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;	

	return Template;	
}


static function X2AbilityTemplate ChainingJolt()
{
	local X2AbilityTemplate                     Template;
	local X2AbilityCost_ActionPoints            ActionPointCost;
	local X2Effect_ApplyWeaponDamage            RobotDamage;
	local X2AbilityCooldown_ABCProtocol         Cooldown;
	local X2Condition_Visibility                VisCondition;
	local X2Condition_AbilityProperty			ShockTherapyCondition;
	local X2Effect_Persistent					DisorientedEffect;
	local X2Effect_Stunned						StunnedEffect;
	local X2Effect_SetUnitValue					UnitValueEffect;
	local X2Condition_UnitValue					UnitValueCondition;
	local X2Effect_DisableWeapon				DisableEffect;
	local X2Condition_AbilityProperty			AbilityCondition;
	local X2Condition_UnitProperty RobotProperty;
	`CREATE_X2ABILITY_TEMPLATE(Template, 'ChainingJolt_LW');

	Template.IconImage = "img:///UILibrary_MZChimeraIcons.Ability_ChainingJolt";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.Hostility = eHostility_Offensive;
	Template.DisplayTargetHitChance = false;
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_CORPORAL_PRIORITY;
	//Template.bFeatureInCharacterUnlock = true;

	Template.AbilityMultiTargetStyle = new class'X2AbilityMultiTarget_Volt';

	Cooldown = new class'X2AbilityCooldown_ABCProtocol';
	Template.AbilityCooldown = Cooldown;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SingleTargetWithSelf;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = false;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	Template.AbilityTargetConditions.AddItem(default.LivingHostileUnitOnlyProperty);
	Template.AbilityMultiTargetConditions.AddItem(default.LivingHostileUnitDisallowMindControlProperty);
	
	VisCondition = new class'X2Condition_Visibility';
	VisCondition.bRequireGameplayVisible = true;
	VisCondition.bActAsSquadsight = true;
	Template.AbilityTargetConditions.AddItem(VisCondition);

	Template.AddTargetEffect(new class'X2Effect_ApplyWeaponDamage');
	Template.AddMultiTargetEffect(new class'X2Effect_ApplyWeaponDamage');
	
	RobotDamage = new class'X2Effect_ApplyWeaponDamage';
	RobotDamage.bIgnoreBaseDamage = true;
	RobotDamage.DamageTag = 'CombatProtocol_Robotic';
	RobotProperty = new class'X2Condition_UnitProperty';
	RobotProperty.ExcludeOrganic = true;
	RobotDamage.TargetConditions.AddItem(RobotProperty);
	Template.AddTargetEffect(RobotDamage);
	Template.AddMultiTargetEffect(RobotDamage);

	AbilityCondition = new class'X2Condition_AbilityProperty';
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('GrimySabotage');
	DisableEffect = new class'X2Effect_DisableWeapon';
	DisableEffect.TargetConditions.AddItem(AbilityCondition);
	Template.AddTargetEffect(DisableEffect);
	Template.AddMultiTargetEffect(DisableEffect);

	ShockTherapyCondition = new class'X2Condition_AbilityProperty';
	ShockTherapyCondition.OwnerHasSoldierAbilities.AddItem('MZShockTherapy');

	// Stun effect
	UnitValueEffect = new class'X2Effect_SetUnitValue';
	UnitValueEffect.NewValueToSet = 1;
	UnitValueEffect.UnitName = 'MZShockTherapyStunResult';
	UnitValueEffect.CleanupType = eCleanup_BeginTurn;
	UnitValueEffect.ApplyChance = 50;
	Template.AddTargetEffect(UnitValueEffect);
	Template.AddMultiTargetEffect(UnitValueEffect);

	UnitValueCondition = new class'X2Condition_UnitValue';
	UnitValueCondition.AddCheckValue('MZShockTherapyStunResult', 1);

	StunnedEffect = class'X2StatusEffects'.static.CreateStunnedStatusEffect(2, 100, false);
	StunnedEffect.bRemoveWhenSourceDies = false;
	StunnedEffect.TargetConditions.AddItem(ShockTherapyCondition);
	StunnedEffect.TargetConditions.AddItem(UnitValueCondition);
	Template.AddTargetEffect(StunnedEffect);
	Template.AddMultiTargetEffect(StunnedEffect);

	// Disorient effect
	UnitValueCondition = new class'X2Condition_UnitValue';
	UnitValueCondition.AddCheckValue('MZShockTherapyStunResult', 0);

	DisorientedEffect = class'X2StatusEffects'.static.CreateDisorientedStatusEffect(, , false);
	DisorientedEffect.bRemoveWhenSourceDies = false;
	DisorientedEffect.TargetConditions.AddItem(ShockTherapyCondition);
	DisorientedEffect.TargetConditions.AddItem(UnitValueCondition);
	Template.AddTargetEffect(DisorientedEffect);
	Template.AddMultiTargetEffect(DisorientedEffect);
	
	// remove the result value, so other Shock Therapy abilities will roll correctly.
	UnitValueEffect = new class'X2Effect_SetUnitValue';
	UnitValueEffect.NewValueToSet = 0;
	UnitValueEffect.UnitName = 'MZShockTherapyStunResult';
	UnitValueEffect.CleanupType = eCleanup_BeginTurn;
	Template.AddTargetEffect(UnitValueEffect);

	Template.TargetingMethod = class'X2TargetingMethod_Volt';

	Template.bStationaryWeapon = true;
	Template.BuildNewGameStateFn = class'X2Ability_SpecialistAbilitySet'.static.AttachGremlinToTarget_BuildGameState;
	Template.BuildVisualizationFn = ChainingJolt_BuildVisualization;
	Template.bSkipPerkActivationActions = true;
	Template.PostActivationEvents.AddItem('ItemRecalled');

	//Template.CinescriptCameraType = "Specialist_CombatProtocol";
	Template.AdditionalAbilities.AddItem('ChainingJoltFocus');
	Template.bFrameEvenWhenUnitIsHidden = true;
	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotLostSpawnIncreasePerUse;
	Template.OverrideAbilities.AddItem('CombatProtocol');

	//Template.ActivationSpeech = 'AbilCombatProtocol';

	return Template;
}

simulated function ChainingJolt_BuildVisualization(XComGameState VisualizeGameState)
{
	local XComGameStateHistory			History;
	local XComGameStateContext_Ability  Context;
	local X2AbilityTemplate             AbilityTemplate;
	local XComGameState_Item			GremlinItem;
	local XComGameState_Unit			GremlinUnitState;
	local StateObjectReference          InteractingUnitRef;
	local VisualizationActionMetadata   EmptyTrack;
	local VisualizationActionMetadata   ActionMetadata;
	local X2Action_CameraLookAt			CameraAction;
	local X2Action_PlaySoundAndFlyOver	SoundAndFlyOver;
	local Actor							TargetVisualizer;
	local XComGameState_Unit			AttachedUnitState;
	local XComGameState_Unit			TargetUnitState;
	local array<PathPoint>				Path;
	local TTile                         TargetTile;
	local TTile							StartTile;
	local PathingInputData              PathData;
	local PathingResultData				ResultData;
	local X2Action_CameraLookAt			TargetCameraAction;
	local X2Action_AbilityPerkStart		PerkStartAction;
	local int							i, j;
	local X2VisualizerInterface			TargetVisualizerInterface;
	local X2Action_WaitForAbilityEffect DelayAction;
	local int							EffectIndex;

	History = `XCOMHISTORY;

	Context = XComGameStateContext_Ability(VisualizeGameState.GetContext());
	AbilityTemplate = class'XComGameState_Ability'.static.GetMyTemplateManager().FindAbilityTemplate(Context.InputContext.AbilityTemplateName);

	TargetUnitState = XComGameState_Unit(VisualizeGameState.GetGameStateForObjectID(Context.InputContext.PrimaryTarget.ObjectID));

	GremlinItem = XComGameState_Item(History.GetGameStateForObjectID(Context.InputContext.ItemObject.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1));
	GremlinUnitState = XComGameState_Unit(History.GetGameStateForObjectID(GremlinItem.CosmeticUnitRef.ObjectID));
	AttachedUnitState = XComGameState_Unit(History.GetGameStateForObjectID(GremlinItem.AttachedUnitRef.ObjectID));

	if (GremlinUnitState == none)
	{
		`RedScreen("Attempting GremlinSingleTarget_BuildVisualization with a GremlinUnitState of none");
		return;
	}

	//Configure the visualization track for the shooter
	//****************************************************************************************

	//****************************************************************************************
	InteractingUnitRef = Context.InputContext.SourceObject;
	ActionMetadata = EmptyTrack;
	ActionMetadata.StateObject_OldState = History.GetGameStateForObjectID(InteractingUnitRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
	ActionMetadata.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(InteractingUnitRef.ObjectID);
	ActionMetadata.VisualizeActor = History.GetVisualizer(InteractingUnitRef.ObjectID);

	CameraAction = X2Action_CameraLookAt(class'X2Action_CameraLookAt'.static.AddToVisualizationTree(ActionMetadata, Context, false, ActionMetadata.LastActionAdded));
	CameraAction.LookAtActor = ActionMetadata.VisualizeActor;
	CameraAction.BlockUntilActorOnScreen = true;

	class'X2Action_IntrusionProtocolSoldier'.static.AddToVisualizationTree(ActionMetadata, Context, false, ActionMetadata.LastActionAdded);

	if (AbilityTemplate.ActivationSpeech != '')
	{
		SoundAndFlyOver = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyOver'.static.AddToVisualizationTree(ActionMetadata, Context, false, ActionMetadata.LastActionAdded));
		SoundAndFlyOver.SetSoundAndFlyOverParameters(None, "", AbilityTemplate.ActivationSpeech, eColor_Good);
	}

	// make sure he waits for the gremlin to come back, so that the cinescript camera doesn't pop until then
	X2Action_WaitForAbilityEffect(class'X2Action_WaitForAbilityEffect'.static.AddToVisualizationTree(ActionMetadata, Context, false, ActionMetadata.LastActionAdded)).SetCustomTimeOutSeconds(30);

	//Configure the visualization track for the gremlin
	//****************************************************************************************

	InteractingUnitRef = GremlinUnitState.GetReference();

	ActionMetadata = EmptyTrack;
	History.GetCurrentAndPreviousGameStatesForObjectID(GremlinUnitState.ObjectID, ActionMetadata.StateObject_OldState, ActionMetadata.StateObject_NewState, , VisualizeGameState.HistoryIndex);
	ActionMetadata.VisualizeActor = GremlinUnitState.GetVisualizer();
	TargetVisualizer = History.GetVisualizer(Context.InputContext.PrimaryTarget.ObjectID);

	class'X2Action_WaitForAbilityEffect'.static.AddToVisualizationTree(ActionMetadata, Context, false, ActionMetadata.LastActionAdded);

	if (AttachedUnitState.TileLocation != TargetUnitState.TileLocation)
	{
		// Given the target location, we want to generate the movement data.  

		//Handle tall units.
		TargetTile = TargetUnitState.GetDesiredTileForAttachedCosmeticUnit();
		StartTile = AttachedUnitState.GetDesiredTileForAttachedCosmeticUnit();

		class'X2PathSolver'.static.BuildPath(GremlinUnitState, StartTile, TargetTile, PathData.MovementTiles);
		class'X2PathSolver'.static.GetPathPointsFromPath(GremlinUnitState, PathData.MovementTiles, Path);
		class'XComPath'.static.PerformStringPulling(XGUnitNativeBase(ActionMetadata.VisualizeActor), Path);

		PathData.MovingUnitRef = GremlinUnitState.GetReference();
		PathData.MovementData = Path;
		Context.InputContext.MovementPaths.AddItem(PathData);

		class'X2TacticalVisibilityHelpers'.static.FillPathTileData(PathData.MovingUnitRef.ObjectID, PathData.MovementTiles, ResultData.PathTileData);
		Context.ResultContext.PathResults.AddItem(ResultData);

		class'X2VisualizerHelpers'.static.ParsePath(Context, ActionMetadata);

		if (TargetVisualizer != none)
		{
			TargetCameraAction = X2Action_CameraLookAt(class'X2Action_CameraLookAt'.static.AddToVisualizationTree(ActionMetadata, Context, false, ActionMetadata.LastActionAdded));
			TargetCameraAction.LookAtActor = TargetVisualizer;
			TargetCameraAction.BlockUntilActorOnScreen = true;
			TargetCameraAction.LookAtDuration = 10.0f;		// longer than we need - camera will be removed by tag below
			TargetCameraAction.CameraTag = 'TargetFocusCamera';
			TargetCameraAction.bRemoveTaggedCamera = false;
		}
	}

	PerkStartAction = X2Action_AbilityPerkStart(class'X2Action_AbilityPerkStart'.static.AddToVisualizationTree(ActionMetadata, Context, false, ActionMetadata.LastActionAdded));
	PerkStartAction.NotifyTargetTracks = true;

	class'MZ_Action_ChainJolt'.static.AddToVisualizationTree(ActionMetadata, Context, false, ActionMetadata.LastActionAdded);

	class'X2Action_AbilityPerkEnd'.static.AddToVisualizationTree(ActionMetadata, Context);

	//****************************************************************************************

	//Configure the visualization track for the target(s)
	//****************************************************************************************
	InteractingUnitRef = Context.InputContext.PrimaryTarget;
	ActionMetadata = EmptyTrack;
	ActionMetadata.StateObject_OldState = History.GetGameStateForObjectID(InteractingUnitRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
	ActionMetadata.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(InteractingUnitRef.ObjectID);
	ActionMetadata.VisualizeActor = TargetVisualizer;

	DelayAction = X2Action_WaitForAbilityEffect(class'X2Action_WaitForAbilityEffect'.static.AddToVisualizationTree(ActionMetadata, Context));
	DelayAction.ChangeTimeoutLength(class'X2Ability_SpecialistAbilitySet'.default.GREMLIN_ARRIVAL_TIMEOUT);       //  give the gremlin plenty of time to show up

	for (EffectIndex = 0; EffectIndex < AbilityTemplate.AbilityTargetEffects.Length; ++EffectIndex)
	{
		AbilityTemplate.AbilityTargetEffects[EffectIndex].AddX2ActionsForVisualization(VisualizeGameState, ActionMetadata, Context.FindTargetEffectApplyResult(AbilityTemplate.AbilityTargetEffects[EffectIndex]));
	}

	TargetVisualizerInterface = X2VisualizerInterface(ActionMetadata.VisualizeActor);
	if (TargetVisualizerInterface != none)
	{
		//Allow the visualizer to do any custom processing based on the new game state. For example, units will create a death action when they reach 0 HP.
		TargetVisualizerInterface.BuildAbilityEffectsVisualization(VisualizeGameState, ActionMetadata);
	}

	for (i = 0; i < Context.InputContext.MultiTargets.Length; ++i)
	{
		InteractingUnitRef = Context.InputContext.MultiTargets[i];
		ActionMetadata = EmptyTrack;
		ActionMetadata.StateObject_OldState = History.GetGameStateForObjectID(InteractingUnitRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
		ActionMetadata.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(InteractingUnitRef.ObjectID);
		ActionMetadata.VisualizeActor = History.GetVisualizer(InteractingUnitRef.ObjectID);
	
		class'X2Action_WaitForAbilityEffect'.static.AddToVisualizationTree(ActionMetadata, Context);
	
		for (j = 0; j < Context.ResultContext.MultiTargetEffectResults[i].Effects.Length; ++j)
		{
			Context.ResultContext.MultiTargetEffectResults[i].Effects[j].AddX2ActionsForVisualization(VisualizeGameState, ActionMetadata, Context.ResultContext.MultiTargetEffectResults[i].ApplyResults[j]);
		}
	
		TargetVisualizerInterface = X2VisualizerInterface(ActionMetadata.VisualizeActor);
		if (TargetVisualizerInterface != none)
		{
			//Allow the visualizer to do any custom processing based on the new game state. For example, units will create a death action when they reach 0 HP.
			TargetVisualizerInterface.BuildAbilityEffectsVisualization(VisualizeGameState, ActionMetadata);
		}
	}

	if (TargetCameraAction != none)
	{
		TargetCameraAction = X2Action_CameraLookAt(class'X2Action_CameraLookAt'.static.AddToVisualizationTree(ActionMetadata, Context, false, ActionMetadata.LastActionAdded));
		TargetCameraAction.CameraTag = 'TargetFocusCamera';
		TargetCameraAction.bRemoveTaggedCamera = true;
	}
}

