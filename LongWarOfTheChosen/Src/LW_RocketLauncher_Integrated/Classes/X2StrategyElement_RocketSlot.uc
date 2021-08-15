class X2StrategyElement_RocketSlot extends CHItemSlotSet config (Rockets);

var localized string strRocketFirstLetter;

var config array<name> AbilityUnlocksRocketSlot;

var config bool bLog;
var config array<name> AllowedItemCategories;
var config bool bAllowEmpty;

var config array<name> AllowedSoldierClasses;
var config array<name> AllowedCharacterTemplates;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;
	Templates.AddItem(CreateRocketSlotTemplate());
	return Templates;
}

static function X2DataTemplate CreateRocketSlotTemplate()
{
	local CHItemSlot Template;

	`CREATE_X2TEMPLATE(class'CHItemSlot', Template, 'RocketSlot');

	Template.InvSlot = eInvSlot_ExtraRocket1;
	Template.SlotCatMask = Template.SLOT_WEAPON | Template.SLOT_ITEM;
	// Unused for now
	Template.IsUserEquipSlot = true;
	// Uses unique rule
	Template.IsEquippedSlot = true;
	// Does not bypass unique rule
	Template.BypassesUniqueRule = false;
	Template.IsMultiItemSlot = false;
	Template.IsSmallSlot = true;


	Template.CanAddItemToSlotFn = CanAddItemToRocketSlot;
	Template.UnitHasSlotFn = HasRocketSlot;
	Template.GetPriorityFn = RocketGetPriority;
	Template.ShowItemInLockerListFn = ShowRocketItemInLockerList;
	Template.ValidateLoadoutFn = RocketValidateLoadout;
	Template.GetSlotUnequipBehaviorFn = RocketGetUnequipBehavior;

	return Template;
}

static function bool CanAddItemToRocketSlot(CHItemSlot Slot, XComGameState_Unit Unit, X2ItemTemplate Template, optional XComGameState CheckGameState, optional int Quantity = 1, optional XComGameState_Item ItemState)
{
	local string strDummy;

	local X2WeaponTemplate WeaponTemplate;



	if (!Slot.UnitHasSlot(Unit, strDummy, CheckGameState) || Unit.GetItemInSlot(Slot.InvSlot, CheckGameState) != none)
	{
		return false;
	}
	WeaponTemplate = X2WeaponTemplate(Template);
	if(WeaponTemplate != none)
	{
		if (default.AllowedItemCategories.Find(WeaponTemplate.WeaponCat) != INDEX_NONE)
		{
			return true;
		}
	}
	return false;

}

static function bool HasRocketSlot(CHItemSlot Slot, XComGameState_Unit UnitState, out string LockedReason, optional XComGameState CheckGameState)
{
	local name Ability;
	local X2WeaponTemplate EquipmentTemplate;
	local array<XComGameState_Item> CurrentInventory;
	local XComGameState_Item InventoryItem;

	//	Check for whitelisted soldier classes first.
	if (default.AllowedSoldierClasses.Find(UnitState.GetSoldierClassTemplateName()) != INDEX_NONE)
	{
		`LOG(UnitState.GetFullName() @ "has Rocket Slot, because they have a matching Soldier Class:" @ UnitState.GetSoldierClassTemplateName(), default.bLog, 'RocketSlot');
		return true;
	}
	//	Then check whitelisted character templates. Can come in handy if there are any robotic soldier classes.
	if (default.AllowedCharacterTemplates.Find(UnitState.GetMyTemplateName()) != INDEX_NONE)
	{	
		`LOG(UnitState.GetFullName() @ "has Rocket Slot, because they have a matching Character Template Name:" @ UnitState.GetMyTemplateName(), default.bLog, 'RocketSlot');
		return true;
	}
	//	If there is no soldier class match, check if there are any entries in the config array for abilities that unlock the Rocket Slot.
	if (default.AbilityUnlocksRocketSlot.Length != 0)
	{
		foreach default.AbilityUnlocksRocketSlot(Ability)
		{
			if (UnitState.HasSoldierAbility(Ability, true))
			{
				`LOG(UnitState.GetFullName() @ "has Rocket Slot, because they have a matching Ability:" @ Ability, default.bLog, 'WotC_RocketSlot');
				return true;
			}
		}

		CurrentInventory = UnitState.GetAllInventoryItems(CheckGameState);
		foreach CurrentInventory(InventoryItem)
		{
			EquipmentTemplate = X2WeaponTemplate(InventoryItem.GetMyTemplate());
			if (EquipmentTemplate != none)
			{
				foreach EquipmentTemplate.Abilities(Ability)
				{
					if (default.AbilityUnlocksRocketSlot.Find(Ability) != INDEX_NONE)
					{
						`LOG(UnitState.GetFullName() @ "has Rocket Slot, because they have a matching Ability:" @ Ability @ "on an equipped Item:" @ EquipmentTemplate.DataName @ "in slot:" @ InventoryItem.InventorySlot, default.bLog, 'WotC_RocketSlot');
						return true;
					}
				}
			}
		}

		//	If the config array has at least one ability, we do not add the slot to all soldiers.
		`LOG(UnitState.GetFullName() @ "does not have Rocket Slot, because they do not have any abilities from the configured list.", default.bLog, 'WotC_RocketSlot');
		return false;

	}	//	If there are no entries in the ability config array, allow the Slot for all non-robotic soldiers.
	else if(UnitState.IsSoldier() && !UnitState.IsRobotic())
	{
		`LOG(UnitState.GetFullName() @ "has Rocket Slot, because they are a non-robotic soldier.", default.bLog, 'WotC_RocketSlot');
		return true;
	}
	return false;	
}

static function int RocketGetPriority(CHItemSlot Slot, XComGameState_Unit UnitState, optional XComGameState CheckGameState)
{
	return 110; // Ammo Pocket is 110 
}

static function bool ShowRocketItemInLockerList(CHItemSlot Slot, XComGameState_Unit Unit, XComGameState_Item ItemState, X2ItemTemplate ItemTemplate, XComGameState CheckGameState)
{
	local X2WeaponTemplate WeaponTemplate;

	WeaponTemplate = X2WeaponTemplate(ItemTemplate);
	if(WeaponTemplate != none)
	{
		return default.AllowedItemCategories.Find(WeaponTemplate.WeaponCat) != INDEX_NONE;
	}
	else
	{
		return false;
	}
}

static function string GetRocketDisplayLetter(CHItemSlot Slot)
{
	return default.strRocketFirstLetter;
}

static function RocketValidateLoadout(CHItemSlot Slot, XComGameState_Unit Unit, XComGameState_HeadquartersXCom XComHQ, XComGameState NewGameState)
{
	local XComGameState_Item EquippedRocket;
	local string strDummy;
	local bool HasSlot;
	EquippedRocket = Unit.GetItemInSlot(Slot.InvSlot, NewGameState);
	HasSlot = Slot.UnitHasSlot(Unit, strDummy, NewGameState);

	`LOG(Unit.GetFullName() @ "validating Rocket Slot. Unit has slot:" @ HasSlot @ EquippedRocket == none ? ", slot is empty." : ", slot contains item:" @ EquippedRocket.GetMyTemplateName(), default.bLog, 'WotC_RocketSlot');

	if(EquippedRocket == none && HasSlot && !default.bAllowEmpty)
	{
		EquippedRocket = FindBestRocket(Unit, XComHQ, NewGameState);
		if (EquippedRocket != none)
		{
			`LOG("Empty slot is not allowed, equipping:" @ EquippedRocket.GetMyTemplateName(), default.bLog, 'WotC_RocketSlot');
			Unit.AddItemToInventory(EquippedRocket, eInvSlot_ExtraRocket1, NewGameState);
		}
		else `LOG("Empty slot is not allowed, but the mod was unable to find an infinite item to fill the slot.", default.bLog, 'WotC_RocketSlot');
	}
	else if(EquippedRocket != none && !HasSlot)
	{
		`LOG("WARNING Unit has an item equipped in the Rocket Slot, but they do not have the Rocket Slot. Unequipping the item and putting it into HQ Inventory.", default.bLog, 'WotC_RocketSlot');
		EquippedRocket = XComGameState_Item(NewGameState.ModifyStateObject(class'XComGameState_Item', EquippedRocket.ObjectID));
		Unit.RemoveItemFromInventory(EquippedRocket, NewGameState);
		XComHQ.PutItemInInventory(NewGameState, EquippedRocket);
		EquippedRocket = none;
	}
}

private static function XComGameState_Item FindBestRocket(const XComGameState_Unit UnitState, XComGameState_HeadquartersXCom XComHQ, XComGameState NewGameState)
{
	local X2WeaponTemplate				EquipmentTemplate;
	local XComGameStateHistory				History;
	local int								HighestTier;
	local XComGameState_Item				ItemState;
	local XComGameState_Item				BestItemState;
	local StateObjectReference				ItemRef;

	HighestTier = -999;
	History = `XCOMHISTORY;

	//	Cycle through all items in HQ Inventory
	foreach XComHQ.Inventory(ItemRef)
	{
		ItemState = XComGameState_Item(History.GetGameStateForObjectID(ItemRef.ObjectID));
		if (ItemState != none)
		{
			EquipmentTemplate = X2WeaponTemplate(ItemState.GetMyTemplate());

			if (EquipmentTemplate != none &&	//	If this is an equippable item
				default.AllowedItemCategories.Find(EquipmentTemplate.WeaponCat) != INDEX_NONE &&	//	That has a matching Item Category
				EquipmentTemplate.bInfiniteItem && EquipmentTemplate.Tier > HighestTier &&		//	And is of higher Tier than previously found items
				UnitState.CanAddItemToInventory(EquipmentTemplate, eInvSlot_ExtraRocket1, NewGameState, ItemState.Quantity, ItemState))	//	And can be equipped on the soldier
			{
				//	Remember this item as the currently best replacement option.
				HighestTier = EquipmentTemplate.Tier;
				BestItemState = ItemState;
			}
		}
	}

	if (BestItemState != none)
	{
		//	This will set up the Item State for modification automatically, or create a new Item State in the NewGameState if the template is infinite.
		XComHQ.GetItemFromInventory(NewGameState, BestItemState.GetReference(), BestItemState);
		return BestItemState;
	}
	else
	{
		return none;
	}
}

function ECHSlotUnequipBehavior RocketGetUnequipBehavior(CHItemSlot Slot, ECHSlotUnequipBehavior DefaultBehavior, XComGameState_Unit Unit, XComGameState_Item ItemState, optional XComGameState CheckGameState)
{	
	if (default.bAllowEmpty)
	{
		return eCHSUB_AllowEmpty;
	}
	else
	{
		return eCHSUB_AttemptReEquip;
	}
}