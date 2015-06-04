if !(local player) exitWith{};

diag_log [diag_frameno, diag_ticktime, time, "Executing backpackOnChest init.sqf"];

if (hasInterface || local player) then {
	#define DEBUG_MODE_FULL
	#include "script_component.hpp"
	
	#ifdef DEBUG_MODE_FULL
		player sideChat "backpackOnChest - init executing...";
	#endif

	call ZADE_BOC_fnc_init;
	
	#ifdef DEBUG_MODE_FULL
		player sideChat "backpackOnChest - init done...";
	#endif
};

diag_log [diag_frameno, diag_ticktime, time, "backpackOnChest init.sqf processed"];