// This is an Unreal Script
class X2Item_MutonHunter_Weapon extends X2Item_DefaultWeapons config(MutonHunter);

var config WeaponDamageValue              MUTON_HUNTER_RIFLE_BASEDAMAGE;
var config array<int>                     MUTON_HUNTER_RIFLE_RANGE;
var config int                            MUTON_HUNTER_RIFLE_ICLIPSIZE;
var config int                            MUTON_HUNTER_RIFLE_ISOUNDRANGE;
var config int                            MUTON_HUNTER_RIFLE_IENVIRONMENTDAMAGE;
var config int                            MUTON_HUNTER_RIFLE_IDEALRANGE;

var config WeaponDamageValue              MUTON_PROWLER_RIFLE_BASEDAMAGE;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Weapons;
	
	Weapons.AddItem(CreateTemplate_Muton_Hunter_Rifle());
	Weapons.AddItem(CreateTemplate_Muton_Prowler_Rifle());

	return Weapons;
}

static function X2DataTemplate CreateTemplate_Muton_Hunter_Rifle()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'Muton_Hunter_Rifle');
	
	Template.WeaponPanelImage = "_ConventionalRifle";                       // used by the UI. Probably determines iconview of the weapon.
	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'rifle';
	Template.WeaponTech = 'magnetic';
	Template.strImage = "img:///WoTC_Muton_Hunter.UI.MutonHunterRifle_Icon"; //Texture2D'WoTC_Muton_Hunter.UI.MutonHunterRifle_Icon'
	Template.RemoveTemplateAvailablility(Template.BITFIELD_GAMEAREA_Multiplayer); //invalidates multiplayer availability

	Template.RangeAccuracy = default.MUTON_HUNTER_RIFLE_RANGE;
	Template.BaseDamage = default.MUTON_HUNTER_RIFLE_BASEDAMAGE;
	Template.iClipSize = default.MUTON_HUNTER_RIFLE_ICLIPSIZE;
	Template.iSoundRange = default.MUTON_HUNTER_RIFLE_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.MUTON_HUNTER_RIFLE_IENVIRONMENTDAMAGE;
	Template.iIdealRange = default.MUTON_HUNTER_RIFLE_IDEALRANGE;

	Template.DamageTypeTemplateName = 'Heavy';
	
	Template.InventorySlot = eInvSlot_PrimaryWeapon;
	Template.Abilities.AddItem('StandardShot');
	Template.Abilities.AddItem('Overwatch');
	Template.Abilities.AddItem('OverwatchShot');
	Template.Abilities.AddItem('Reload');
	Template.Abilities.AddItem('HotLoadAmmo');
	Template.Abilities.AddItem('Implacable');
	
	
	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "WoTC_Muton_Hunter.Archetypes.WP_Muton_Hunter_Rifle"; //XComWeapon'WoTC_Muton_Hunter.Archetypes.WP_Muton_Hunter_Rifle'

	Template.iPhysicsImpulse = 5;

	Template.CanBeBuilt = false;
	Template.TradingPostValue = 30;

	return Template;
}


static function X2DataTemplate CreateTemplate_Muton_Prowler_Rifle()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'Muton_Prowler_Rifle');
	
	Template.WeaponPanelImage = "_ConventionalRifle";                       // used by the UI. Probably determines iconview of the weapon.
	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'rifle';
	Template.WeaponTech = 'magnetic';
	Template.strImage = "img:///WoTC_Muton_Hunter.UI.MutonHunterRifle_Icon"; //Texture2D'WoTC_Muton_Hunter.UI.MutonHunterRifle_Icon'
	Template.RemoveTemplateAvailablility(Template.BITFIELD_GAMEAREA_Multiplayer); //invalidates multiplayer availability

	Template.RangeAccuracy = default.MUTON_HUNTER_RIFLE_RANGE;
	Template.BaseDamage = default.MUTON_PROWLER_RIFLE_BASEDAMAGE;
	Template.iClipSize = default.MUTON_HUNTER_RIFLE_ICLIPSIZE;
	Template.iSoundRange = default.MUTON_HUNTER_RIFLE_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.MUTON_HUNTER_RIFLE_IENVIRONMENTDAMAGE;
	Template.iIdealRange = default.MUTON_HUNTER_RIFLE_IDEALRANGE;

	Template.DamageTypeTemplateName = 'Heavy';
	
	Template.InventorySlot = eInvSlot_PrimaryWeapon;
	Template.Abilities.AddItem('StandardShot');
	Template.Abilities.AddItem('Overwatch');
	Template.Abilities.AddItem('OverwatchShot');
	Template.Abilities.AddItem('Reload');
	Template.Abilities.AddItem('HotLoadAmmo');
	Template.Abilities.AddItem('Shadowstep');
	Template.Abilities.AddItem('Implacable');
	
	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "WoTC_Muton_Hunter.Archetypes.WP_Muton_Hunter_Rifle"; //XComWeapon'WoTC_Muton_Hunter.Archetypes.WP_Muton_Hunter_Rifle'

	Template.iPhysicsImpulse = 5;

	Template.CanBeBuilt = false;
	Template.TradingPostValue = 30;

	return Template;
}

defaultproperties
{
	bShouldCreateDifficultyVariants = true
}