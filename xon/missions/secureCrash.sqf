#define DEBUG_MODE_FULL
#include "script_component.hpp"

private["_flatPos","_flatPosCond","_str"];
#ifdef DEBUG_MODE_FULL
	LOG("MISSIONS - secureCrash executing...");
	player sideChat "MISSIONS - secureCrash executing...";
#endif

_flatPos = [0,0,0];
_flatPosCond = true;
while { _flatPosCond } do {
	_pos = [(getMarkerPos QUOTE(TargetAO)),(1500),(round random 360)] call BIS_fnc_relPos;
	_flatPos = _pos isFlatEmpty [5,0,0.2,50,0,false,objNull];
	if (_flatPos isEqualTo []) then {
		_flatPosCond = true;
	} else {
		_flatPosCond = false;
	};
};

_wreck = createVehicle ["Land_UWreck_MV22_F", [0,0,0],[], 0, "NONE"];

_dir = round(random 360);
_wreck setDir _dir;
_wreck setPos _flatPos;

#ifdef DEBUG_MODE_FULL
	_str = [format["wreck%1",(round random 100)],_flatPos,"ICON","hd_dot","ColorRed"] call FMAN(debugMarker);
#endif

//Spawn units to defend the wreck
[_wreck,resistance,(configFile >> "CfgGroups" >> "Indep" >> "rhs_faction_insurgents" >> "Infantry" >> "IRG_InfSentry"),true] call FMAN(spawnObjectiveDefenders);
[_wreck,resistance,(configFile >> "CfgGroups" >> "Indep" >> "rhs_faction_insurgents" >> "Infantry" >> "IRG_InfSentry"),true] call FMAN(spawnObjectiveDefenders);
[_wreck,resistance,(configFile >> "CfgGroups" >> "Indep" >> "rhs_faction_insurgents" >> "Infantry" >> "IRG_InfSquad"),true] call FMAN(spawnObjectiveDefenders);
[_wreck,resistance,(configFile >> "CfgGroups" >> "Indep" >> "rhs_faction_insurgents" >> "Infantry" >> "IRG_InfTeam_AT"),true] call FMAN(spawnObjectiveDefenders);
[_wreck,resistance,(configFile >> "CfgGroups" >> "Indep" >> "rhs_faction_insurgents" >> "Infantry" >> "IRG_InfTeam_AT"),true] call FMAN(spawnObjectiveDefenders);

[-1, {
	private["_wreck"];
	_wreck = _this select 0;
	
	if (side player == west) then {
		_task = player createSimpleTask ["Secure the Crash Site"];
		_task setSimpleTaskDestination position _wreck;
		_task setSimpleTaskDescription ["Secure the wreckage of a downed friendly aircraft","Secure the Crash Site","Secure the Crash Site"];
		_task setTaskState "Assigned";
		player setCurrentTask _task;
		["secureCrashTask",["Secure a friendly downed aircraft crash site."]] call BIS_fnc_showNotification;
		_wreck setVariable ["task",_task,true];
	};
}, [_wreck]] call CBA_fnc_globalExecute;

_wreck setVariable ["objective",true,true];

fnc_secureCrashTriggerHandler = {
	_wreck = _this select 0;
	[_wreck,"Succeeded","secureCrashTask","The crash site has been secured"] call FMAN(handleTask);
};

_trg = createTrigger["EmptyDetector",_flatPos,true];
_trg setTriggerArea[200,200,0,false];
_trg setTriggerActivation["GUER","NOT PRESENT",false];
_trg setTriggerStatements ["this", "diag_log 'trigger activated'; [_wreck] call fnc_secureCrashTriggerHandler;", ""];

#ifdef DEBUG_MODE_FULL
	deleteMarker _str;
#endif

#ifdef DEBUG_MODE_FULL
	player sideChat "MISSIONS - secureCrash done...";
	LOG("MISSIONS - secureCrash done...");
#endif