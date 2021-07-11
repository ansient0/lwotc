class XComGameState_LWAIUnitData extends XComGameState_AIUnitData;

static function bool IsCauseSuspicious(EAlertCause AlertCause)
{
	local bool bResult;

	bResult = false;
	switch( AlertCause )
	{
	case eAC_MapwideAlert_Hostile:
	case eAC_XCOMAchievedObjective:
	case eAC_AlertedByCommLink:
	case eAC_DetectedNewCorpse:
	case eAC_DetectedAllyTakingDamage:
	case eAC_DetectedSound:
	case eAC_AlertedByYell:
	case eAC_SeesExplosion:
	case eAC_SeesSmoke:
	case eAC_SeesFire:
	//case eAC_SeesAlertedAllies:
		bResult = true;
		break;
	}

	return bResult;
}
static function bool IsCauseAggressive(EAlertCause AlertCause)
{
	local bool bResult;
	
	bResult = false;
	switch( AlertCause )
	{
	case eAC_TookDamage:
	case eAC_TakingFire:
	case eAC_SeesSpottedUnit:
    case eAC_SeesAlertedAllies:

		bResult = true;
		break;
	}

	return bResult;
}

static function bool ShouldEnemyFactionsTriggerAlertsOutsidePlayerVision(EAlertCause AlertCause)
{
	local bool bResult;
	local XComLWTuple OverrideTuple;
	bResult = false;
	switch( AlertCause )
	{
	case eAC_MapwideAlert_Hostile:
	case eAC_MapwideAlert_Peaceful:
	case eAC_AlertedByCommLink:
	case eAC_AlertedByYell:
	case eAC_TakingFire:
	case eAC_TookDamage:
	case eAC_DetectedAllyTakingDamage:
    case eAC_SeesSpottedUnit:
		bResult = true;
		break;
	}
	return bResult;

}

    function OnBeginTacticalPlay(XComGameState NewGameState)
{
	local Object ThisObj;
	local X2EventManager EventManager;

	super.OnBeginTacticalPlay(NewGameState);

	ThisObj = self;
	EventManager = `XEVENTMGR;
	EventManager.UnRegisterFromEvent( ThisObj, 'UnitMoveFinished' );

	EventManager.RegisterForEvent( ThisObj, 'UnitMoveFinished', OnUnitMoveFinished, ELD_OnStateSubmitted );
}

    function EventListenerReturn OnUnitMoveFinished(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData)
{
	local XComGameState_Unit AlertedUnit, MovedUnit;
	local XComGameState_Player MovedUnitPlayer;
	local XComGameStateHistory History;
	local int AlertDataIndex, i;
	local XComGameStateContext_Ability MoveContext;
	local XComGameState NewGameState;
	local XComGameState_AIUnitData NewAIUnitData;
	local AlertAbilityInfo AlertInfo;
	local TTile TestTile;
	local int PathIndex;
    local XComGameState_AIGroup AIGroupState;

	`BEHAVIORTREEMGR.bWaitingOnEndMoveEvent = false;

	History = `XCOMHISTORY;
	AlertedUnit = XComGameState_Unit(History.GetGameStateForObjectID(m_iUnitObjectID));

	// Create new game state, add the alert data, submit
	MovedUnit = XComGameState_Unit(EventData);
	if( MovedUnit == none || AlertedUnit == none || AlertedUnit.IsDead() )
	{
		return ELR_NoInterrupt;
	}

	MovedUnitPlayer = XComGameState_Player(History.GetGameStateForObjectID(MovedUnit.ControllingPlayer.ObjectID));

	// Is the moved unit XCom
	if (MovedUnitPlayer.TeamFlag == eTeam_XCom)
	{
		// If the AI Unit can see the moved unit, then normal spotting updates will handle the post move update
		// If the unit is not visible, the AI must have known about it at some point prior so that it will
		// have tracked it
		if (!class'X2TacticalVisibilityHelpers'.static.CanUnitSeeLocation(m_iUnitObjectID, MovedUnit.TileLocation)
			&& IsKnowledgeAboutUnitAbsolute(MovedUnit.ObjectID, AlertDataIndex))
		{
			// The unit is not visible to the this AI's unit and previously had Absolute knowledge
			// Process the moved unit's path backwards until it can see a tile that the moved
			// unit passed through
			MoveContext = XComGameStateContext_Ability(GameState.GetContext());
			if( (MoveContext != None) && (MoveContext.GetMovePathIndex(MovedUnit.ObjectID) >= 0)) 
			{
				// If the unit is not visible, currently the last known position was at the
				// previous Absolute AlertData location
				AlertInfo.AlertTileLocation = GetAlertLocation(AlertDataIndex);
				AlertInfo.AlertUnitSourceID = MovedUnit.ObjectID;
				AlertInfo.AnalyzingHistoryIndex = GameState.HistoryIndex;

				PathIndex = MoveContext.GetMovePathIndex(MovedUnit.ObjectID);

				// TODO: Might need to check for interruption and use the InterruptionStep
				// Find the last tile along the movement path that the AI could have seen the
				// moving Unit
				i = (MoveContext.InputContext.MovementPaths[PathIndex].MovementTiles.Length - 1);
				while( i >= 0 )
				{
					TestTile = MoveContext.InputContext.MovementPaths[PathIndex].MovementTiles[i];
					if( class'X2TacticalVisibilityHelpers'.static.CanUnitSeeLocation(m_iUnitObjectID, TestTile) )
					{
						AlertInfo.AlertTileLocation = TestTile;
						i = INDEX_NONE;
					}

					--i;
				}
			}
			else // Move finished can happen from other contexts, like XComGameStateContext_Falling
			{
				// For all other contexts that cause a UnitMoveFinished, just assume the AI can figure out where the unit would be.
				// Set the alert info with the current moved unit location.  
				AlertInfo.AlertUnitSourceID = MovedUnit.ObjectID;
				AlertInfo.AnalyzingHistoryIndex = GameState.HistoryIndex;
				AlertInfo.AlertTileLocation = MovedUnit.TileLocation;
			}

			NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState(string(GetFuncName()));
			NewAIUnitData = XComGameState_AIUnitData(NewGameState.ModifyStateObject(class'XComGameState_AIUnitData', ObjectID));
			if( NewAIUnitData.AddAlertData(m_iUnitObjectID, eAC_SeesSpottedUnit, AlertInfo, NewGameState) )
			{
				`TACTICALRULES.SubmitGameState(NewGameState);
			}
			else
			{
				NewGameState.PurgeGameStateForObjectID(NewAIUnitData.ObjectID);
				History.CleanupPendingGameState(NewGameState);
			}
		}
	}
    else if (MovedUnit.GetCurrentStat(eStat_AlertLevel) > 1 && AlertedUnit.GetCurrentStat(eStat_AlertLevel) < 2)
    {

        if(class'X2TacticalVisibilityHelpers'.static.CanUnitSeeLocation(m_iUnitObjectID, MovedUnit.TileLocation) || IsKnowledgeAboutUnitAbsolute(MovedUnit.ObjectID, AlertDataIndex))
        {
            AlertInfo.AlertUnitSourceID = MovedUnit.ObjectID;
            AlertInfo.AnalyzingHistoryIndex = GameState.HistoryIndex;
            AlertInfo.AlertTileLocation = MovedUnit.TileLocation;
			NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState(string(GetFuncName()));
			NewAIUnitData = XComGameState_AIUnitData(NewGameState.ModifyStateObject(class'XComGameState_AIUnitData', ObjectID));
			if( NewAIUnitData.AddAlertData(m_iUnitObjectID, eAC_SeesSpottedUnit, AlertInfo, NewGameState) )
			{
                AIGroupState = AlertedUnit.GetGroupMembership();
                if(AIGroupState != none && !AIGroupState.bProcessedScamper && AlertedUnit.bTriggerRevealAI)
                {
                    AIGroupState = XComGameState_AIGroup(NewGameState.ModifyStateObject(class'XComGameState_AIGroup', AIGroupState.ObjectID));
                    AIGroupState.InitiateReflexMoveActivate(AlertedUnit, eAC_SeesSpottedUnit);

                }
                `TACTICALRULES.SubmitGameState(NewGameState);
			}
			else
			{
				NewGameState.PurgeGameStateForObjectID(NewAIUnitData.ObjectID);
				History.CleanupPendingGameState(NewGameState);
			}
        }

    }

	return ELR_NoInterrupt;
}
