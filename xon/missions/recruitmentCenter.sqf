#define DEBUG_MODE_FULL
#include "script_component.hpp"

private["_building","_buildingPositions","_str","_fnc_triggerHandler","_objective","_objectsChance","_intelChance"];
#ifdef DEBUG_MODE_FULL
	LOG("-------------- MISSIONS - recruitmentCenter executing... --------------");
	player sideChat "MISSIONS - recruitmentCenter executing...";
#endif
_buildings = XON_cachedBuildings;

_shuffledBuildings = _buildings call BIS_fnc_arrayShuffle;
_building = _shuffledBuildings call BIS_fnc_selectRandom;
_buildingPositions = _building call FMAN(buildingPositions);

#ifdef DEBUG_MODE_FULL
	LOG("MISSIONS - recruitmentCenter - spawning enemy units...");
	player sideChat "MISSIONS - recruitmentCenter - spawning enemy units...";
#endif

//Spawn units to defend the cache
[_building,resistance,(configFile >> "CfgGroups" >> "Indep" >> "rhs_faction_insurgents" >> "Infantry" >> "IRG_InfSentry"),false] call FMAN(spawnObjectiveDefenders);
[_building,resistance,(configFile >> "CfgGroups" >> "Indep" >> "rhs_faction_insurgents" >> "Infantry" >> "IRG_InfSentry"),false] call FMAN(spawnObjectiveDefenders);
[_building,resistance,(configFile >> "CfgGroups" >> "Indep" >> "rhs_faction_insurgents" >> "Infantry" >> "IRG_InfSquad"),true] call FMAN(spawnObjectiveDefenders);
[_building,resistance,(configFile >> "CfgGroups" >> "Indep" >> "rhs_faction_insurgents" >> "Infantry" >> "IRG_InfTeam_AT"),true] call FMAN(spawnObjectiveDefenders);

#ifdef DEBUG_MODE_FULL
	LOG("MISSIONS - recruitmentCenter - spawning objects...");
	player sideChat "MISSIONS - recruitmentCenter - spawning objects...";
#endif

_objectsChance = 75;
_intelChance = 35;
for "_i" from 0 to ((count _buildingPositions) - 1) do {
	if ((Ceil random 100) < _objectsChance) then {
		_array = ["Land_CampingChair_V2_F","Land_CampingTable_small_F","Land_MapBoard_F","Land_Bench_F","Land_ChairPlastic_F","Land_ChairWood_F","Land_FMradio_F"] call BIS_fnc_arrayShuffle;
		_object = _array call BIS_fnc_selectRandom;
		_veh = createVehicle [_object,(_buildingPositions select _i),[],0,"NONE"];
	} else {
		if ((Ceil random 100) < _intelChance) then {
			_array = ["Land_File1_F","Land_File2_F","Land_FilePhotos_F","Land_Map_F","Land_Map_unfolded_F","Land_Notepad_F","Land_HandyCam_F","Land_Laptop_F","Land_Laptop_unfolded_F","Land_MobilePhone_old_F","Land_MobilePhone_smart_F","Land_PortableLongRangeRadio_F","Land_SatellitePhone_F","Land_Suitcase_F"] call BIS_fnc_arrayShuffle;
			_object = _array call BIS_fnc_selectRandom;
			_veh = createVehicle [_object,(_buildingPositions select _i),[],0,"NONE"];
		};
	};
};

#ifdef DEBUG_MODE_FULL
	_str = [format["recCenter%1",(round random 100)],(position _building),"ICON","hd_dot","ColorRed"] call FMAN(debugMarker);
#endif

#ifdef DEBUG_MODE_FULL
	LOG("MISSIONS - recruitmentCenter - spawning objective...");
	player sideChat "MISSIONS - recruitmentCenter - spawning objective...";
#endif

_objective = createVehicle ["Land_BottlePlastic_V2_F", position _building,[],0,"CAN_COLLIDE"];

#ifdef DEBUG_MODE_FULL
	LOG("MISSIONS - recruitmentCenter - creating task...");
	player sideChat "MISSIONS - recruitmentCenter - creating task...";
#endif

[-1, {
	_building = _this select 0;
	_objective = _this select 1;
	
	if (side player == west) then {
		_task = player createSimpleTask ["Clear Out Recruitment Center"];
		_task setSimpleTaskDestination position _building;
		_task setSimpleTaskDescription ["Clear out an insurgent recruitment center","Clear Out Recruitment Center","Clear Out Recruitment Center"];
		_task setTaskState "Assigned";
		player setCurrentTask _task;
		["recCenterTask",["Clear out an insurgent recruitment center"]] call BIS_fnc_showNotification;
		_objective setVariable ["task",_task,true];
	};
}, [_building,_objective]] call CBA_fnc_globalExecute;

_objective setVariable ["objective",true,true];

fnc_recTriggerHandler = {
	_objective = _this select 0;
	[-1, {[_objective,"Succeeded","recCenterWin","The insurgent recruitment center was destroyed."] call FMAN(handleTask);}] call CBA_fnc_globalExecute;
	[0,{call FMAN(secureCrash);}] call CBA_fnc_globalExecute;
};

sleep 10;

#ifdef DEBUG_MODE_FULL
	LOG("MISSIONS - recruitmentCenter - creating trigger...");
	player sideChat "MISSIONS - recruitmentCenter - creating trigger...";
#endif

_trg = createTrigger ["EmptyDetector", getPos _building,true];
sleep 1;
_trg setTriggerArea [200, 200, 0, false];
_trg setTriggerActivation ["GUER", "NOT PRESENT", false];
_trg setTriggerStatements ["this", "diag_log 'trigger activated'; [_objective] call fnc_recTriggerHandler;", ""];

#ifdef DEBUG_MODE_FULL
	deleteMarker _str;
#endif

#ifdef DEBUG_MODE_FULL
	player sideChat "MISSIONS - recruitmentCenter done...";
	LOG("-------------- MISSIONS - recruitmentCenter done... --------------");
#endif