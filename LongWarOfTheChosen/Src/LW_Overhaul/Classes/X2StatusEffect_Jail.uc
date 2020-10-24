// This is an Unreal Script
class X2StatusEffect_Jail extends X2StatusEffects config(PurgePriests);

var name JailName;
var config int JAIL_TURNS;
//var config int JAIL_MOBILITY_ADJUST;
var localized string JailFriendlyName;
var localized string JailFriendlyDesc;

static function X2Effect_PersistentStatChange CreateJailStatusEffect()
{
	local X2Effect_PersistentStatChange                   PersistentStatChangeEffect;

	PersistentStatChangeEffect = new class'X2Effect_PersistentStatChange';
	PersistentStatChangeEffect.EffectName = default.JailName;
	PersistentStatChangeEffect.DuplicateResponse = eDupe_Refresh;
	PersistentStatChangeEffect.BuildPersistentEffect(default.JAIL_TURNS,, true,,eGameRule_PlayerTurnBegin);
	PersistentStatChangeEffect.SetDisplayInfo(ePerkBuff_Penalty, default.JailFriendlyName, default.JailFriendlyDesc, "img:///WoTC_PurgePriest_UI.UIPerk_Jail");
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_Mobility, 0, MODOP_Multiplication);

	return PersistentStatChangeEffect;
}

DefaultProperties
{
	PoisonedName="Jail"
}