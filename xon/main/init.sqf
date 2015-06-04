//////////////////////////////////////////////////////////////////
//    71st Special Operations Group Default xon\main\init.sqf   //
//    Created by the 71st SOG Development Team           		//
//    Visit us on the web http://71stsog.com             		//      
//    Teamspeak 3:  ts3.71stsog.com                     		//
//////////////////////////////////////////////////////////////////

waitUntil{!(isNil "BIS_fnc_init")};
//#define DEBUG_MODE_FULL
#include "script_component.hpp"

diag_log [diag_frameno, diag_ticktime, time, "Executing MAIN init.sqf"];

//------Required for Headless Client
if (!hasInterface && !isDedicated) then {
	headlessClients = [];
	headlessClients set [(count headlessClients), player];
	publicVariable "headlessClients";
	isHC = true;
};
/*
_posReturnPointTrigger = position return_point_trigger;
return_arrow = "Sign_Arrow_F" createVehicle _posReturnPointTrigger;
publicVariable "return_arrow";
*/
LOADCP(zbe_cache);
LOADCP(headlessClient);
LOADCP(client);
if ((paramsArray select 3) == 1) then {
	LOADCP(squad_teleport);
};

//  Call to R3F Logistics
execVM "R3F_LOG\init.sqf";


diag_log [diag_frameno, diag_ticktime, time, "MAIN init.sqf processed"];
