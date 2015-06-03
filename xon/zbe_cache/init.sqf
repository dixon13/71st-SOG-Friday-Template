//#define DEBUG_MODE_FULL
#include "script_component.hpp"

//[AiCacheDistance(players),TargetFPS(-1 for Auto),Debug,CarCacheDistance,AirCacheDistance,BoatCacheDistance]execvm "zbe_cache\main.sqf";

if (isServer) then {[2000,5,true,1500,1500,1000]execVM QUOTE(PREFIX\COMPONENT\main.sqf)};