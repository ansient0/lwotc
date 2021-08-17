class X2StatusEffects_LW extends X2StatusEffects config(GameCore);

var config int MAIMED_TURNS;

var localized string MaimedFriendlyName;
var localized string MaimedFriendlyDesc;

var name LWBurningName;
// Creates the Maimed status effect, which is in fact *two* effects,
// one for normal enemies and a one for the Chosen.
static function X2Effect_Immobilize CreateMaimedStatusEffect(optional int NumTurns = default.MAIMED_TURNS, optional name AbilitySourceName = 'eAbilitySource_Standard')
{
	local X2Effect_Immobilize ImmobilizeEffect;

	ImmobilizeEffect = new class'X2Effect_Immobilize';
	ImmobilizeEffect.EffectName = 'Maim_Immobilize';
	ImmobilizeEffect.DuplicateResponse = eDupe_Refresh;
	ImmobilizeEffect.BuildPersistentEffect(NumTurns, false, false, , eGameRule_PlayerTurnBegin);
	ImmobilizeEffect.SetDisplayInfo(ePerkBuff_Penalty, default.MaimedFriendlyName, default.MaimedFriendlyDesc,
			"img:///UILibrary_XPerkIconPack.UIPerk_move_blossom", true, , AbilitySourceName);
	ImmobilizeEffect.AddPersistentStatChange(eStat_Mobility, 0.0f, MODOP_PostMultiplication);
	ImmobilizeEffect.VisualizationFn = class'XMBAbility'.static.EffectFlyOver_Visualization;

	return ImmobilizeEffect;
}

static function X2Effect_Burning CreateBurningStatusEffect(int DamagePerTick, int DamageSpreadPerTick)
{
	local X2Effect_Burning BurningEffect;
	local X2Condition_UnitProperty UnitPropCondition;

	BurningEffect = new class'X2Effect_Burning';
	BurningEffect.EffectName = default.LWBurningName;
	BurningEffect.BuildPersistentEffect(default.BURNING_TURNS,, false,,eGameRule_PlayerTurnBegin);
	BurningEffect.SetDisplayInfo(ePerkBuff_Penalty, default.BurningFriendlyName, default.BurningFriendlyDesc, "img:///UILibrary_PerkIcons.UIPerk_burn");
	BurningEffect.SetBurnDamage(DamagePerTick, DamageSpreadPerTick, 'Fire');
	BurningEffect.VisualizationFn = BurningVisualization;
	BurningEffect.EffectTickedVisualizationFn = BurningVisualizationTicked;
	BurningEffect.EffectRemovedVisualizationFn = BurningVisualizationRemoved;
	BurningEffect.bRemoveWhenTargetDies = true;
	BurningEffect.DamageTypes.AddItem('Fire');
	BurningEffect.DuplicateResponse = eDupe_Refresh;
	BurningEffect.bCanTickEveryAction = true;
	BurningEffect.EffectAppliedEventName = class'X2Effect_Burning'.default.BurningEffectAddedEventName;

	if (default.FireEnteredParticle_Name != "")
	{
		BurningEffect.VFXTemplateName = default.FireEnteredParticle_Name;
		BurningEffect.VFXSocket = default.FireEnteredSocket_Name;
		BurningEffect.VFXSocketsArrayName = default.FireEnteredSocketsArray_Name;
	}
	BurningEffect.PersistentPerkName = default.FireEnteredPerk_Name;

	BurningEffect.EffectTickedFn = BurningTicked;

	UnitPropCondition = new class'X2Condition_UnitProperty';
	UnitPropCondition.ExcludeFriendlyToSource = false;
	BurningEffect.TargetConditions.AddItem(UnitPropCondition);

	return BurningEffect;
}

	static function X2Effect_Burning CreateAcidBurningStatusEffect(int DamagePerTick, int DamageSpreadPerTick)
{
	local X2Effect_Burning BurningEffect;
	local X2Condition_UnitProperty UnitPropCondition;

	BurningEffect = new class'X2Effect_Burning';
	BurningEffect.EffectName = default.AcidBurningName;
	BurningEffect.BuildPersistentEffect(default.ACID_BURNING_TURNS, , false, , eGameRule_PlayerTurnBegin);
	BurningEffect.SetDisplayInfo(ePerkBuff_Penalty, default.AcidBurningFriendlyName, default.AcidBurningFriendlyDesc, "img:///UILibrary_PerkIcons.UIPerk_burn");
	BurningEffect.SetBurnDamage(DamagePerTick, DamageSpreadPerTick, 'Acid');

	X2Effect_ApplyWeaponDamage(BurningEffect.ApplyOnTick[0]).EffectDamageValue.Shred = 1;
	BurningEffect.VisualizationFn = AcidBurningVisualization;
	BurningEffect.EffectTickedVisualizationFn = AcidBurningVisualizationTicked;
	BurningEffect.EffectRemovedVisualizationFn = AcidBurningVisualizationRemoved;
	BurningEffect.bRemoveWhenTargetDies = true;
	BurningEffect.DamageTypes.Length = 0;   // By default X2Effect_Burning has a damage type of fire, but acid is not fire
	BurningEffect.DamageTypes.InsertItem(0, 'Acid');
	BurningEffect.DuplicateResponse = eDupe_Refresh;
	BurningEffect.bCanTickEveryAction = true;

	if (default.AcidEnteredParticle_Name != "")
	{
		BurningEffect.VFXTemplateName = default.AcidEnteredParticle_Name;
		BurningEffect.VFXSocket = default.AcidEnteredSocket_Name;
		BurningEffect.VFXSocketsArrayName = default.AcidEnteredSocketsArray_Name;
	}
	BurningEffect.PersistentPerkName = default.AcidEnteredPerk_Name;

	UnitPropCondition = new class'X2Condition_UnitProperty';
	UnitPropCondition.ExcludeFriendlyToSource = false;
	BurningEffect.TargetConditions.AddItem(UnitPropCondition);

	return BurningEffect;
}

DefaultProperties
{
	LWBurningName="Burning_LW"
}