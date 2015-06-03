#include "script_component.hpp"

diag_log [diag_frameno, diag_ticktime, time, "Executing HEADLESSCLIENT init.sqf"];

if (isServer) then {
	//------Call to Move Units to the Headless Clients
	if ((paramsArray select 4) != 0) then {
		execVM QUOTE(PREFIX\COMPONENT\passToHCs.sqf);
	};
};

diag_log [diag_frameno, diag_ticktime, time, "HEADLESSCLIENT init.sqf processed"];