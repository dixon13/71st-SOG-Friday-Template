/*
 * Author: DerZade
 * Edits: dixon13 aka D.Begay 71st SOG
 * Description: adds a backpack with specfic iventory on the Chest of a unit  
 *
 * Arguments:
 * 0: Unit <OBJECT>
 * 1: Backpack <STRING>
 * 2: Backpack Items <ARRAY>
 * 3: Force Backpack <BOOL> (optional) (Default value: false)
 * Return Value:
 * added Backpack <BOOL>
 *
 * Example:
 * _addedBackpack = [player,"B_Kitbag_mcamo",["FirstAidKit","FirstAidKit","MineDetector"],true] call ZADE_BOC_fnc_AddChestBackpack;
 *
 * Public: No
 */
#include "script_component.hpp"
PARAMS_4(_caller,_pack,_cargo,_force);
_added = false;

if (isNil "_force") then {
	_force = false;
};

if (_caller getVariable ["Zade_ChestBackpack",""] != "" and _force) then {
	[_caller] call ZADE_BOC_fnc_removeChestBackpack;
};

if (_caller getVariable ["Zade_ChestBackpack",""] == "") then {

	_caller setVariable ["Zade_ChestBackpack",_pack];
	_caller setVariable ["Zade_ChestBackpack_Cargo",_cargo];
	_caller forceWalk true;

	[_pack,_caller] call Zade_BOC_fnc_AttachTo;
	_added = true;

};

_added