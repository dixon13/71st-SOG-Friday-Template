#define DEBUG_MODE_FULL
#include "script_component.hpp"

private["_building","_buildingPositions","_buildingPos","_cacheMkr","_mkr"];
#ifdef DEBUG_MODE_FULL
	LOG("MISSIONS - cacheMission executing...");
	player sideChat "MISSIONS - cacheMission executing...";
#endif
_buildings = XON_cachedBuildings;

_shuffledBuildings = _buildings call BIS_fnc_arrayShuffle;
_building = _shuffledBuildings call BIS_fnc_selectRandom;
_buildingPositions = _building call FMAN(buildingPositions);
if (_buildingPositions isEqualTo []) then {
	_buildingPos = getPosATL _building;
} else {
	_tempArray = _buildingPositions call BIS_fnc_arrayShuffle;
	_buildingPos = _tempArray call BIS_fnc_selectRandom;
};

TRACE_1("CACHE POSITION",_buildingPos);

private["_cache","_indexEH","_indexMPEH"];

_cache = createVehicle ["Box_East_WpsSpecial_F", [-10,-10,0], [], 0, "NONE"];
_cache allowDamage false;
clearWeaponCargoGlobal _cache;
clearMagazineCargoGlobal _cache;
clearItemCargoGlobal _cache;

_cache setPos _buildingPos;
_cache allowDamage true;
XON_CACHE = _cache;
publicVariable "XON_CACHE";

#ifdef DEBUG_MODE_FULL
	_cacheMkr = [format["Cache%1",random 1000],getPosATL _cache,"ICON","hd_dot","ColorRed"] call FMAN(debugMarker);
#endif

//Spawn units to defend the cache
[_building,resistance,(configFile >> "CfgGroups" >> "Indep" >> "rhs_faction_insurgents" >> "Infantry" >> "IRG_InfSentry"),false] call FMAN(spawnObjectiveDefenders);
[_building,resistance,(configFile >> "CfgGroups" >> "Indep" >> "rhs_faction_insurgents" >> "Infantry" >> "IRG_InfSentry"),false] call FMAN(spawnObjectiveDefenders);
[_building,resistance,(configFile >> "CfgGroups" >> "Indep" >> "rhs_faction_insurgents" >> "Infantry" >> "IRG_InfSquad"),true] call FMAN(spawnObjectiveDefenders);
[_building,resistance,(configFile >> "CfgGroups" >> "Indep" >> "rhs_faction_insurgents" >> "Infantry" >> "IRG_InfTeam_AT"),true] call FMAN(spawnObjectiveDefenders);

_relPos = [_building,(random 300),(round random 360)] call FMAN(relativePos);
[-1, {
	PARAMS_3(_building,_cache,_relPos);
	
	if (side player == west) then {
		_task = player createSimpleTask ["Destroy Cache"];
		_task setSimpleTaskDestination _relPos;
		_task setSimpleTaskDescription ["Destroy the cache with satchels. The cache will be withing 300 meters of the the task marker.","Destroy Cache","Destroy Cache"];
		_task setTaskState "Assigned";
		player setCurrentTask _task;
		["CacheTask",["Destroy the cache"]] call BIS_fnc_showNotification;

		_cache setVariable ["task",_task,true];
		_cache setVariable ["objective",true,true];
	};
}, [_building,_cache,_relPos]] call CBA_fnc_globalExecute;

_mkr = createMarker [format["cache%1",round (random 100)],_relPos];
_mkr setMarkerShape "ELLIPSE";
_mkr setMarkerColor "ColorRed";
_mkr setMarkerBrush "Solid";
_mkr setMarkerSize [300, 300];

_indexEH = _cache addEventHandler ["handleDamage", {
	private["_cache"];
	_cache = _this select 0;
		
	switch (_this select 4) do {
		case "SatchelCharge_Remote_Mag";
		case "DemoCharge_Remote_Mag": {
			_cache setDamage 1;
			_indexEH = missionNamespace getVariable "CacheEHs";
	
			_cache removeEventHandler["handleDamage",_indexEH];
			_cache setVariable ["objCompleted",true,true];
			deleteMarker _mkr;
	
			#ifdef DEBUG_MODE_FULL
				deleteMarker _cacheMkr;
			#endif
	
			["cacheKilledEH",[_this select 0]] call CBA_fnc_globalEvent;
			if (isServer) then { _cache call FMAN(cacheKilled); };
			[-1,{call FMAN(killedText);}] call CBA_fnc_globalExecute;
			//if (isServer) then { call FMAN(newMission); };
		};
		default {_cache setDamage 0;};
	};
}];

missionNamespace setVariable ["CacheEHs",_indexEH];

#ifdef DEBUG_MODE_FULL
	player sideChat "MISSIONS - cacheMission done...";
	LOG("MISSIONS - cacheMission done...");
#endif