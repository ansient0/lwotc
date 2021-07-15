//---------------------------------------------------------------------------------------
//  FILE:    X2LWCharactersModTemplate.uc
//  AUTHOR:  Peter Ledbrook
//  PURPOSE: Modifies existing character templates, for example to add "sighted"
//           events to new LWOTC enemies so that the tutorial can hook into them.
//---------------------------------------------------------------------------------------
class X2LWCharactersModTemplate extends X2LWTemplateModTemplate config(LW_Overhaul);

var config array<name> EXCLUDED_CHARACTERS_FROM_GLOBAL_DIFF_MOD;
var config array<float> DIFFICULTY_HP_MODIFIER;
var config array<float> DIFFICULTY_AIM_MODIFIER;
var config array<float> DIFFICULTY_WILL_MODIFIER;

static function UpdateCharacters(X2CharacterTemplate Template, int Difficulty)
{
	switch (Template.DataName)
	{
	case 'LWDroneM1':
	case 'LWDroneM2':
		Template.SightedEvents.AddItem('DroneSighted');
		break;
	case 'AdvGrenadierM1':
	case 'AdvGrenadierM2':
	case 'AdvGrenadierM3':
		Template.SightedEvents.AddItem('EngineerSighted');
		break;
	case 'AdvSentryM1':
	case 'AdvSentryM2':
	case 'AdvSentryM3':
		Template.SightedEvents.AddItem('SentrySighted');
		break;
	case 'AdvGunnerM1':
	case 'AdvGunnerM2':
	case 'AdvGunnerM3':
		Template.SightedEvents.AddItem('GunnerSighted');
		break;
	case 'AdvRocketeerM1':
	case 'AdvRocketeerM2':
	case 'AdvRocketeerM3':
		Template.SightedEvents.AddItem('RocketeerSighted');
		break;
	default:
		break;
	}
	DoaGlobalStatModifierByDifficulty(Template,Difficulty);
}

static function DoaGlobalStatModifierByDifficulty(X2CharacterTemplate Template, int Difficulty)
{
	local X2CharacterTemplate HighestDiffTemplate;
	local array<X2CharacterTemplate> DiffTemplates;
	local X2CharacterTemplateManager TemplateManager;




	if(EXCLUDED_CHARACTERS_FROM_GLOBAL_DIFF_MOD.Find(Template.DataName) != INDEX_NONE || Template.bIsSoldier || Template.bIsCivilian)
	{
		return;
	}

	TemplateManager = class'X2CharacterTemplateManager'.static.GetCharacterTemplateManager();

	//Get The highest difficulty template

	TemplateManager.FindDataTemplateAllDifficulties(TemplateName, DiffTemplates);

	HighestDiffTemplate = DiffTemplates[3];


	Template.CharacterBaseStats[eStat_HP] = Ceil(HighestDiffTemplate.CharacterBaseStats[eStat_HP] * DIFFICULTY_HP_MODIFIER[Difficulty]);
	Template.CharacterBaseStats[eStat_Offense] = Ceil(HighestDiffTemplate.CharacterBaseStats[eStat_Offense] + DIFFICULTY_AIM_MODIFIER[Difficulty]);
	Template.CharacterBaseStats[eStat_Will] = Ceil(HighestDiffTemplate.CharacterBaseStats[eStat_Will] + DIFFICULTY_Will_MODIFIER[Difficulty]);

	Template.CharacterBaseStats[eStat_ArmorMitigation]=HighestDiffTemplate.CharacterBaseStats[eStat_ArmorMitigation];
	Template.CharacterBaseStats[eStat_CritChance]=HighestDiffTemplate.CharacterBaseStats[eStat_CritChance];
	Template.CharacterBaseStats[eStat_Defense]=HighestDiffTemplate.CharacterBaseStats[eStat_Defense];
	Template.CharacterBaseStats[eStat_Dodge]=HighestDiffTemplate.CharacterBaseStats[eStat_Dodge];
	Template.CharacterBaseStats[eStat_HP]=HighestDiffTemplate.CharacterBaseStats[eStat_HP];
	Template.CharacterBaseStats[eStat_Mobility]=HighestDiffTemplate.CharacterBaseStats[eStat_Mobility];
	Template.CharacterBaseStats[eStat_Offense]=HighestDiffTemplate.CharacterBaseStats[eStat_Offense];
	Template.CharacterBaseStats[eStat_PsiOffense]=HighestDiffTemplate.CharacterBaseStats[eStat_PsiOffense];
	Template.CharacterBaseStats[eStat_Will]=HighestDiffTemplate.CharacterBaseStats[eStat_Will];
	Template.CharacterBaseStats[eStat_HackDefense]=HighestDiffTemplate.CharacterBaseStats[eStat_HackDefense];
	Template.CharacterBaseStats[eStat_FlankingCritChance]=HighestDiffTemplate.CharacterBaseStats[eStat_FlankingCritChance];

}

defaultproperties
{
	CharacterTemplateModFn=UpdateCharacters
}
