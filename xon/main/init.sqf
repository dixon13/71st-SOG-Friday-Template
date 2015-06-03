//////////////////////////////////////////////////////////////////
//    71st Special Operations Group Default xon\main\init.sqf   //
//    Created by the 71st SOG Development Team           		//
//    Visit us on the web http://71stsog.com             		//      
//    Teamspeak 3:  ts3.71stsog.com                     		//
//////////////////////////////////////////////////////////////////

waitUntil{!(isNil "BIS_fnc_init")};
//#define DEBUG_MODE_FULL
if (missionNamespace getVariable ["XON_MISSIONS",nil] == nil) then {
	missionNamespace setVariable ["XON_MISSIONS",0,true];
	XON_MISSIONS = 0;
};
#include "script_component.hpp"
//#include "script_events.hpp"
#include "script_functions.hpp"

diag_log [diag_frameno, diag_ticktime, time, "Executing MAIN init.sqf"];

QUOTE(TargetAO) setMarkerAlpha 0;

//------Required for Headless Client
if (!hasInterface && !isDedicated) then {
	headlessClients = [];
	headlessClients set [(count headlessClients), player];
	publicVariable "headlessClients";
	isHC = true;
};

_posReturnPointTrigger = position return_point_trigger;
return_arrow = "Sign_Arrow_F" createVehicle _posReturnPointTrigger;
publicVariable "return_arrow";

LOADCP(zbe_cache);
LOADCP(headlessClient);
LOADCP(client);
//LOADCP(missions);
if ((paramsArray select 3) == 1) then {
	LOADCP(squad_teleport);
};

//  Call to R3F Logistics
execVM "R3F_LOG\init.sqf";


diag_log [diag_frameno, diag_ticktime, time, "MAIN init.sqf processed"];
