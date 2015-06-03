/*
adminTeleport.sqf
Written by dixon13 aka D.Begay 71st Special Operations Group
*/
if !(local ACE_Player) exitWith {};
//#define DEBUG_MODE_FULL
#include "script_component.hpp"

PARAMS_1(_debug);
private["_condition","_statement"];

//_admin addAction["<t color='#0e72bd'>Teleport</t>", {[(_this select 1)] call FMAN(adminTeleport);}, nil, 6, false, false, "",""];;

//_adminTeleport_AGM_SelfInteractionID = ["Teleport",{true},{player spawn FMAN(adminTeleport);}, true] call AGM_Interaction_fnc_addInteractionSelf;


/*_unit = _this; player spawn FMAN(adminTeleport);*/
//_unit = _this select 0; _unit call FMAN(adminTeleport);

_condition = {[ACE_Player] call ace_common_fnc_canInteract;};
_statement = {[ACE_Player] spawn FMAN(adminTeleport);};

if (_debug) then {
	_adminTeleport_ACE_SelfInteract = ["Teleport","Teleport","",_statement,_condition] call ace_interact_menu_fnc_createAction;
	[ACE_Player,1,["ACE_SelfActions"],_adminTeleport_ACE_SelfInteract] call ace_interact_menu_fnc_addActionToObject;

	ACE_Player addEventHandler ["Respawn",{
		_adminTeleport_ACE_SelfInteract = ["Teleport","Teleport","",_statement,_condition] call ace_interact_menu_fnc_createAction;
		[ACE_Player,1,["ACE_SelfActions"],_adminTeleport_ACE_SelfInteract] call ace_interact_menu_fnc_addActionToObject;
	}];
} else {
	while {true} do {
		waitUntil {sleep 0.1; serverCommandAvailable "#logout"};
		
		_adminTeleport_ACE_SelfInteract = ["Teleport","Teleport","",_statement,_condition] call ace_interact_menu_fnc_createAction;
		[ACE_Player,1,["ACE_SelfActions"],_adminTeleport_ACE_SelfInteract] call ace_interact_menu_fnc_addActionToObject;
		_adminTPrespawnEH = ACE_Player addEventHandler ["Respawn",{
			_adminTeleport_ACE_SelfInteract = ["Teleport","Teleport","",_statement,_condition] call ace_interact_menu_fnc_createAction;
			[ACE_Player,1,["ACE_SelfActions"],_adminTeleport_ACE_SelfInteract] call ace_interact_menu_fnc_addActionToObject;
		}];

		waitUntil {sleep 0.1; !serverCommandAvailable "#logout"};
		ACE_Player removeEventHandler ["Respawn",_adminTPrespawnEH];
	};
};