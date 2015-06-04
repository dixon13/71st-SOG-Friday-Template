if !(local player) exitWith{};

if (hasInterface || local player) then {
	//#define DEBUG_MODE_FULL
	#include "script_component.hpp"

	[ACE_Player] call ZADE_BOC_fnc_init;
};