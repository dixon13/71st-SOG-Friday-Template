#define DEBUG_MODE_FULL
#include "script_component.hpp"

diag_log [diag_frameno, diag_ticktime, time, "Executing MISSIONS init.sqf"];

if (isServer) then {
	private["_size","_buildingPos","_buildingPositions","_building","_task","_buildings","_pos","_posX","_posY"];
	
	_mkrPos = getMarkerPos QUOTE(TargetAO);
	_mkrSize = getMarkerSize QUOTE(TargetAO);
	_mkrSizeA = _mkrSize select 0;
	_mkrSizeB = _mkrSize select 1;

	if (_mkrSizeA > _mkrSizeB) then {
		_diff = _mkrSizeA - _mkrSizeB;
		_size = (_diff/2) + _mkrSizeB;
	} else {
		_diff = _mkrSizeB - _mkrSizeA;
		_size = (_diff/2) + _mkrSizeA;
	};
	_buildings = [_mkrPos,_size] call FMAN(findBuildings);
	XON_sizeAO = _size;
	XON_cachedBuildings = _buildings;

	#ifdef DEBUG_MODE_FULL
		{
			[format["%1",random 1000],position _x,"ICON","hd_dot","ColorBlack"] call FMAN(debugMarker);
		} forEach _buildings;
	#endif

	//First mission
	CALLC(PREFIX\COMPONENT\hvt.sqf);
	
};
diag_log [diag_frameno, diag_ticktime, time, "MISSIONS init.sqf processed"];
