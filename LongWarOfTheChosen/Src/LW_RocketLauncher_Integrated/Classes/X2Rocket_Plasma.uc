class X2Rocket_Plasma extends X2Item config(Rockets);

var config bool CREATE_ROCKET;

var config WeaponDamageValue BaseDamage;
var config int iEnvironmentDamage;
var config int iClipSize;
var config int iSoundRange;
var config int Range;
var config int Radius;
var config int MOBILITY_PENALTY;

var config bool REQUIRE_ARMING;
var config int TYPICAL_ACTION_COST;

var config string Image;
var config string GAME_ARCHETYPE;

var config name WEAPON_TECH;
var config int Tier;

var config array<name> COMPATIBLE_LAUNCHERS;

var config bool STARTING_ITEM;
var config bool INFINITE_ITEM;
var config name CREATOR_TEMPLATE_NAME;
var config name HIDE_IF_TECH_RESEARCHED;
var config name HIDE_IF_ITEM_PURCHASED;
var config name BASE_ITEM;
var config bool CAN_BE_BUILT;
var config array<name> REQUIRED_TECHS;
var config array<name> REWARD_DECKS;
var config array<name> RESOURCE_COST_TYPE;
var config array<int> RESOURCE_COST_QUANTITY;
var config int BLACKMARKET_VALUE;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;
	
	if (default.CREATE_ROCKET)
	{
		Templates.AddItem(Create_Rocket_Main());
		Templates.AddItem(Create_Rocket_Pair());
	}
	return Templates;
}

static function X2DataTemplate Create_Rocket_Main()
{
	local X2RocketTemplate 				Template;
	local X2Effect_ApplyWeaponDamage	WeaponDamageEffect;
	local X2Effect_Knockback			KnockbackEffect;
	local ArtifactCost					Resources;
	local int i;
	
	`CREATE_X2TEMPLATE(class'X2RocketTemplate', Template, 'IRI_X2Rocket_Plasma');

	Template.strImage = default.IMAGE;

	Template.AddAbilityIconOverride('IRI_FireRocket', "img:///IRI_RocketLaunchers.UI.Fire_Plasma");
	Template.AddAbilityIconOverride('IRI_FireRocket_Spark', "img:///IRI_RocketLaunchers.UI.Fire_Plasma");
	Template.AddAbilityIconOverride('IRI_GiveRocket', "img:///IRI_RocketLaunchers.UI.Give_Plasma");
	Template.AddAbilityIconOverride('IRI_ArmRocket', "img:///IRI_RocketLaunchers.UI.Arm_Plasma");

	Template.EquipSound = "StrategyUI_Heavy_Weapon_Equip";
	
	Template.WeaponTech = default.WEAPON_TECH;
	Template.Tier = default.TIER;

	Template.COMPATIBLE_LAUNCHERS = default.COMPATIBLE_LAUNCHERS;

	Template.RequireArming = default.REQUIRE_ARMING;
	Template.iTypicalActionCost = default.TYPICAL_ACTION_COST;
	
	Template.GameArchetype = default.GAME_ARCHETYPE;
	Template.BaseDamage = default.BASEDAMAGE;
	Template.iEnvironmentDamage = default.IENVIRONMENTDAMAGE;
	Template.iRange = default.RANGE;
	Template.iRadius = default.RADIUS;
	Template.iSoundRange = default.ISOUNDRANGE;
	Template.iClipSize = default.ICLIPSIZE;
	if (Template.iClipSize <= 1) Template.bHideClipSizeStat = true;
	Template.MobilityPenalty = default.MOBILITY_PENALTY;
	
	Template.CanBeBuilt = default.CAN_BE_BUILT;
	Template.bInfiniteItem = default.INFINITE_ITEM;
	Template.StartingItem = default.STARTING_ITEM;
	
	Template.CreatorTemplateName = default.CREATOR_TEMPLATE_NAME;
	Template.BaseItem = default.BASE_ITEM;
	
	Template.RewardDecks = default.REWARD_DECKS;
	Template.HideIfResearched = default.HIDE_IF_TECH_RESEARCHED;
	Template.HideIfPurchased = default.HIDE_IF_ITEM_PURCHASED;
	
	if (!Template.bInfiniteItem)
	{
		Template.TradingPostValue = default.BLACKMARKET_VALUE;
		
		if (Template.CanBeBuilt)
		{
			Template.Requirements.RequiredTechs = default.REQUIRED_TECHS;
			
			for (i = 0; i < default.RESOURCE_COST_TYPE.Length; i++)
			{
				if (default.RESOURCE_COST_QUANTITY[i] > 0)
				{
					Resources.ItemTemplateName = default.RESOURCE_COST_TYPE[i];
					Resources.Quantity = default.RESOURCE_COST_QUANTITY[i];
					Template.Cost.ResourceCosts.AddItem(Resources);
				}
			}
		}
	}
	
	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.bExplosiveDamage = true;
	Template.ThrownGrenadeEffects.AddItem(WeaponDamageEffect);

	Template.OnThrowBarkSoundCue = 'RocketLauncher';

	KnockbackEffect = new class'X2Effect_Knockback';
	KnockbackEffect.KnockbackDistance = 2;
	Template.ThrownGrenadeEffects.AddItem(KnockbackEffect);
	
	Template.DamageTypeTemplateName = Template.BaseDamage.DamageType;

	Template.Abilities.AddItem('GrenadeFuse');
	Template.Abilities.AddItem('IRI_FireRocket');
	//Template.Abilities.AddItem('IRI_RocketMobilityPenalty');
	//Template.Abilities.AddItem('IRI_GiveRocket');
	Template.Abilities.AddItem('IRI_AggregateRocketAmmo');
	//Template.Abilities.AddItem('IRI_ArmRocket');
	//Template.Abilities.AddItem('IRI_DisarmRocket');

	Template.iPhysicsImpulse = 10;

	Template.SetUIStatMarkup(class'XLocalizedData'.default.RangeLabel,, default.RANGE);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.RadiusLabel,, default.RADIUS);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.ShredLabel,, default.BASEDAMAGE.Shred);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.MobilityLabel, eStat_Mobility, Template.MobilityPenalty);

	Template.PairedTemplateName = 'IRI_X2Rocket_Plasma_Pair';

	return Template;
}

static function X2DataTemplate Create_Rocket_Pair()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'IRI_X2Rocket_Plasma_Pair');

	Template.GameArchetype = default.GAME_ARCHETYPE;
	
	Template.ItemCat = 'cosmetic_rocket';
	Template.WeaponCat = 'rocket';

	return Template;
}