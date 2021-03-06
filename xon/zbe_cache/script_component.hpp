#define PREFIX XON
#define COMPONENT ZBE_CACHE

#ifdef DEBUG_ENABLED_XON_ZBE_CACHE
	#define DEBUG_MODE_FULL
#endif

#ifdef DEBUG_SETTINGS_XON_ZBE_CACHE
	#define DEBUG_SETTINGS DEBUG_SETTINGS_XON_ZBE_CACHE
#endif

#include "\x\cba\addons\main\script_macros_mission.hpp"

//#include "script_settings.hpp"

#define FMAN(var1) TRIPLES(XON_MAIN,fnc,var1)

#define CALLC(var1) call compileFinal preprocessFileLineNumbers 'var1'

#define LOADCP(var1) call compileFinal preprocessFileLineNumbers 'xon\var1\init.sqf'
