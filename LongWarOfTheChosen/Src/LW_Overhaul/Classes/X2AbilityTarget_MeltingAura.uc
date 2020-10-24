// This is an Unreal Script
class X2AbilityTarget_MeltingAura extends X2AbilityTarget_Single config (PurgePriests);

var config int MELTING_AURA_RANGE;
var config bool MELTING_AURA_TURN;

simulated function name GetPrimaryTargetOptions(const XComGameState_Ability Ability, out array<AvailableTarget> Targets)
{
	local XComGameState_Unit	MeltingAura_ShooterUnit, TargetUnit;
	local int					i;
	local name					Code;
		
	Code = super.GetPrimaryTargetOptions(Ability,Targets);
	MeltingAura_ShooterUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(Ability.OwnerStateObject.ObjectID));

	for (i = Targets.Length - 1; i >= 0; --i)
	{
		TargetUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(Targets[i].PrimaryTarget.ObjectID));
		if (MeltingAura_ShooterUnit.TileDistanceBetween(TargetUnit) > default.MELTING_AURA_RANGE)
		{
			Targets.Remove(i,1);
		}								
	}	
	if ((Code == 'AA_Success') && (Targets.Length < 1))
	{
		return 'AA_NoTargets';
	}	
	return code;
}

simulated function bool ValidatePrimaryTargetOption(const XComGameState_Ability Ability, XComGameState_Unit SourceUnit, XComGameState_BaseObject TargetObject)
{
	local bool					b_valid;
	local XComGameState_Unit	TargetUnit;

	b_valid = Super.ValidatePrimaryTargetOption(Ability, SourceUnit, TargetObject);
	TargetUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(TargetObject.ObjectID));
	if (TargetUnit == none)
		return false;
	if (b_valid)
	{
		//`LOG ("CCS Target" @ TargetUnit.GetMyTemplateName() @ "TDB:" @ string(SourceUnit.TileDistanceBetween(TargetUnit)));
		if (SourceUnit.TileDistanceBetween(TargetUnit) > default.MELTING_AURA_RANGE)
		{
			//`LOG ("NO SHOT! CCS Target TDB:" @ string(SourceUnit.TileDistanceBetween(TargetUnit)));
			return false;
		}
		if(!default.MELTING_AURA_TURN && X2TacticalGameRuleset(XComGameInfo(class'Engine'.static.GetCurrentWorldInfo().Game).GameRuleset).GetCachedUnitActionPlayerRef().ObjectID == SourceUnit.ControllingPlayer.ObjectID)
		{
			return false;
		}
	}
	return b_valid;
}