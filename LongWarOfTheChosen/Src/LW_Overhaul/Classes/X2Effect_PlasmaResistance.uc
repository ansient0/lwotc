// This is an Unreal Script
class X2Effect_PlasmaResistance extends X2Effect_Persistent;

function int GetDefendingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, X2Effect_ApplyWeaponDamage WeaponDamageEffect, optional XComGameState NewGameState)
{
    local int DamageMod;
   local XComGameState_Item SourceWeapon;
    local X2WeaponTemplate WeaponTemplate;

    DamageMod = 0;
    if (EffectState.ApplyEffectParameters.EffectRef.SourceTemplateName == 'PlasmaResistance')
    {
        SourceWeapon = AbilityState.GetSourceWeapon();
        if (SourceWeapon != none)
            WeaponTemplate = X2WeaponTemplate(SourceWeapon.GetMyTemplate());

        
        if (WeaponTemplate != none && WeaponTemplate.DamageTypeTemplateName == 'Projectile_BeamXCom')
            
        {
            DamageMod = -int(float(CurrentDamage) * 0.75);
        }
    }

    return DamageMod;
}