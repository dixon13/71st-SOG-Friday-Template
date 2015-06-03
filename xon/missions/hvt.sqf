#define DEBUG_MODE_FULL
#include "script_component.hpp"

#ifdef DEBUG_MODE_FULL
	LOG("MISSIONS - hvt executing...");
	player sideChat "MISSIONS - hvt executing...";
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
_centerSide = createCenter resistance;
_group = createGroup resistance;
_hvt = _group createUnit ["rhs_g_Soldier_SL_F",_buildingPos,[],0,"CAN_COLLIDE"];
_hvt disableAI "MOVE";
_hvt disableAI "AUTOTARGET";
#ifdef DEBUG_MODE_FULL
	["hvt",_buildingPos,"ICON","hd_dot","ColorRed"] call FMAN(debugMarker);
#endif

removeAllWeapons _hvt;
sleep 0.8;
removeAllItems _hvt;
sleep 0.8;
removeAllAssignedItems _hvt;
sleep 0.8;
removeGoggles _hvt;
sleep 0.8;
removeHeadgear _hvt;
sleep 0.8;
removeBackpack _hvt;
sleep 0.8;
removeVest _hvt;
sleep 0.8;
removeUniform _hvt;
sleep 1;
_hvt addHeadgear "rhs_fieldcap_ml";
sleep 1;
_hvt forceAddUniform "U_BG_leader";

[-1, {
	private["_building","_hvt"];
	_building = _this select 0;
	_hvt = _this select 1;
	if (side player == west) then {
		_task = player createSimpleTask ["Capture HVT"];
		_task setSimpleTaskDestination position _building;
		_task setSimpleTaskDescription ["Capture the HVT and detain him. We need him alive. Then proceed to get him back to the OP for questioning. Return him to the 'Return Point'","Capture HVT","Capture HVT"];
		_task setTaskState "Assigned";
		player setCurrentTask _task;
		["HvtTask",["Capture the HVT and detain him."]] call BIS_fnc_showNotification;
		_hvt setVariable ["task",_task,true];
		_hvt setVariable ["objective",true,true];
	};
}, [_building,_hvt]] call CBA_fnc_globalExecute;

_hvt addEventHandler["killed", {
	[(_this select 0)] spawn {
		["hvtKilled",[_this select 0]] call CBA_fnc_globalEvent;
		[-2,{
			#ifdef DEBUG_MODE_FULL
				deleteMarker "hvt";
			#endif
		}] call CBA_fnc_globalExecute;
		sleep 2;
		//call FMAN(cacheMission);
		call compile preprocessFileLineNumbers "xon\missions\cacheMission.sqf";
		sleep 2;
		call FMAN(recCenter);
	};
}];

//Spawn units to defend the HVT
[_building,resistance,(configFile >> "CfgGroups" >> "Indep" >> "rhs_faction_insurgents" >> "Infantry" >> "IRG_InfSentry"),false] call FMAN(spawnObjectiveDefenders);
[_building,resistance,(configFile >> "CfgGroups" >> "Indep" >> "rhs_faction_insurgents" >> "Infantry" >> "IRG_InfSentry"),false] call FMAN(spawnObjectiveDefenders);
[_building,resistance,(configFile >> "CfgGroups" >> "Indep" >> "rhs_faction_insurgents" >> "Infantry" >> "IRG_InfSquad"),true] call FMAN(spawnObjectiveDefenders);
[_building,resistance,(configFile >> "CfgGroups" >> "Indep" >> "rhs_faction_insurgents" >> "Infantry" >> "IRG_InfTeam_AT"),true] call FMAN(spawnObjectiveDefenders);


#ifdef DEBUG_MODE_FULL
	player sideChat "MISSIONS - hvt done...";
	LOG("MISSIONS - hvt done...");
#endif