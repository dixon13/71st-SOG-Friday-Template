/*
ghostMode.sqf
Written by dixon13 aka D.Begay 71st Special Operations Group
*/
#define DEBUG_MODE_FULL
#include "script_component.hpp"
if !(local ACE_Player) exitWith {};

#ifdef DEBUG_MODE_FULL
	LOG("CLIENT - ghostMode executing...");
	player sideChat "CLIENT - ghostMode executing...";
#endif

PARAMS_1(_debug);
private["_conditionON","_statementON","_conditionOFF","_statementOFF"];

ACE_Player setVariable ["XON_ghost",false];

_conditionON = {!([ACE_Player,true]call FMAN(canGhost))};
_statementON = {[ACE_Player,true] call FMAN(ghostMode);};

_conditionOFF = {([ACE_Player,false]call FMAN(canGhost))};
_statementOFF = {[ACE_Player,false] call FMAN(ghostMode);};


if (_debug) then {
	_actionOn = ["GhostModeOn","Ghost Mode ON","",_statementON,_conditionON] call ace_interact_menu_fnc_createAction;
	[ACE_Player,1,["ACE_SelfActions"],_actionOn] call ace_interact_menu_fnc_addActionToObject;
	
	_actionOff = ["GhostModeOff","Ghost Mode OFF","",_statementOFF,_conditionOFF] call ace_interact_menu_fnc_createAction;
	[ACE_Player,1,["ACE_SelfActions"],_actionOff] call ace_interact_menu_fnc_addActionToObject;

	ACE_Player addEventHandler ["Respawn",{
		_actionOn = ["GhostModeOn","Ghost Mode ON","",_statementON,_conditionON] call ace_interact_menu_fnc_createAction;
		[ACE_Player,1,["ACE_SelfActions"],_actionOn] call ace_interact_menu_fnc_addActionToObject;
		
		_actionOff = ["GhostModeOff","Ghost Mode OFF","",_statementOFF,_conditionOFF] call ace_interact_menu_fnc_createAction;
		[ACE_Player,1,["ACE_SelfActions"],_actionOff] call ace_interact_menu_fnc_addActionToObject;
	}];
} else {
	while {true} do {
		waitUntil {sleep 0.1; serverCommandAvailable "#logout"};
		
		_actionOn = ["GhostModeOn","Ghost Mode ON","",_statementON,_conditionON] call ace_interact_menu_fnc_createAction;
		[ACE_Player,1,["ACE_SelfActions"],_actionOn] call ace_interact_menu_fnc_addActionToObject;
	
		_actionOff = ["GhostModeOff","Ghost Mode OFF","",_statementOFF,_conditionOFF] call ace_interact_menu_fnc_createAction;
		[ACE_Player,1,["ACE_SelfActions"],_actionOff] call ace_interact_menu_fnc_addActionToObject;
			
		_respawnEH = ACE_Player addEventHandler ["Respawn",{
			_actionOn = ["GhostModeOn","Ghost Mode ON","",_statementON,_conditionON] call ace_interact_menu_fnc_createAction;
			[ACE_Player,1,["ACE_SelfActions"],_actionOn] call ace_interact_menu_fnc_addActionToObject;
	
			_actionOff = ["GhostModeOff","Ghost Mode OFF","",_statementOFF,_conditionOFF] call ace_interact_menu_fnc_createAction;
			[ACE_Player,1,["ACE_SelfActions"],_actionOff] call ace_interact_menu_fnc_addActionToObject;
		}];

		waitUntil {sleep 0.1; !serverCommandAvailable "#logout"};
		ACE_Player removeEventHandler ["Respawn",_respawnEH];
	};
};

#ifdef DEBUG_MODE_FULL
	player sideChat "CLIENT - ghostMode done...";
	LOG("CLIENT - ghostMode done...");
#endif