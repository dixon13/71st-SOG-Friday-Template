/*
 * Author: DerZade
 * Edits: dixon13 aka D.Begay 71st SOG
 * Description: Initalize the BOC-Mod  
 *
 * Arguments:
 * 0: Unit to call the init on (OBJECT)
 *
 * Return Value:
 * NONE
 *
 * Example:
 *  call ZADE_BOC_fnc_Initialization;
 *
 * Public: No
 */
#include "script_component.hpp"

 PARAMS_1(_unit);
 
_action = ["Zade_Backpack_onChest", "Backpack on Chest", "", {[_this select 0] call Zade_BOC_fnc_BackpackOnChest;}, {(_this select 0) getVariable ["Zade_ChestBackpack",""] == "" and backpack (_this select 0) != ""}] call ace_interact_menu_fnc_createAction;
[_unit, 1, ["ACE_SelfActions", "ACE_Equipment"], _action] call ace_interact_menu_fnc_addActionToObject;
_action = ["Zade_Backpack_onBack", "Backpack on Back", "", {[_this select 0] call Zade_BOC_fnc_BackpackOnBack;}, {(_this select 0) getVariable ["Zade_ChestBackpack",""] != "" and backpack (_this select 0) == ""}] call ace_interact_menu_fnc_createAction;
[_unit, 1, ["ACE_SelfActions", "ACE_Equipment"], _action] call ace_interact_menu_fnc_addActionToObject;

_unit addEventHandler ["Respawn",{[_unit] call ZADE_BOC_fnc_init;}];