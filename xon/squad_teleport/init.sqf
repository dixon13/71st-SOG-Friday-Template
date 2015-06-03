//#define DEBUG_MODE_FULL
#include "script_component.hpp"

if !(local player) exitWith {};
diag_log [diag_frameno, diag_ticktime, time, "Executing SQUAD_TELEPORT init.sqf"];

//["interactMenuOpened", {_this call FUNC(interactEH)}] call ace_common_fnc_addEventHandler;

if (local ace_player || hasInterface) then {
	private"_helper";
	
	_helper = "Sign_Sphere25cm_F" createVehicleLocal (getPos teleportFlag);
	_helper hideObject true;
	_helper attachTo [teleportFlag,[-0.1,-0.4,-3]];

	_action = ["Teleport_to_Squad","Teleport to Squad","",{CALLC(PREFIX\COMPONENT\teleport_squadmember.sqf);},{true},{}, _helper, [0,0,0], 5] call ace_interact_menu_fnc_createAction;
	[_helper,0,[],_action] call ace_interact_menu_fnc_addActionToObject;
	diag_log format["_action = %1",_action];

	ace_player addEventHandler ["Respawn",{
		_action = ["Teleport_to_Squad","Teleport to Squad","",{CALLC(PREFIX\COMPONENT\teleport_squadmember.sqf);},{true},{}, _helper, [0,0,0], 5] call ace_interact_menu_fnc_createAction;
		[_helper,0,[],_action] call ace_interact_menu_fnc_addActionToObject;
		diag_log format["_action = %1",_action];
	}];
};

diag_log [diag_frameno, diag_ticktime, time, "SQUAD_TELEPORT init.sqf processed"];
