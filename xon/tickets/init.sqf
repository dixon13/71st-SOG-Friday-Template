//#define DEBUG_MODE_FULL
#include "script_component.hpp"
//#include "script_events.hpp"
//#include "script_functions.hpp"

if ((missionNamespace getVariable ["ticketParam",nil]) == nil) then {
	_OGTicketParam = paramsArray select 2;
	missionNamespace setVariable ["ticketParam",_OGTicketParam,true];
};

if !(local player) exitWith {};

diag_log [diag_frameno, diag_ticktime, time, "Executing TICKETS init.sqf"];

if (hasInterface || local player) then {
	player addEventHandler ["killed",
		_tickets = missionNamespace getVariable "ticketParam";
		_newTickets = _tickets - 1;
		missionNamespace setVariable ["ticketParam",_newTickets,true];
		
		["HINTSILENT",format["Blufor Tickets left: %1",_newTickets]] call FMAN(XON_HINT);
		
		if ((missionNamespace getVariable "ticketParam") == 0) then {
			[{-2,{
				playSound "news";
				[parseText format["US/NATO forces have been routed out of %1",worldName],parseText format["US/NATO forces are currently taking heavy losses in %1 | AMERICA!!!! | This is random rolling text...",worldName]] call BIS_fnc_AAN;
				sleep 15;
				endMission "END1"
			}] call CBA_fnc_globalExecute;
		};
	];
};

diag_log [diag_frameno, diag_ticktime, time, "TICKETS init.sqf processed"];
