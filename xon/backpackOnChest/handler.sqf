//Edits: dixon13 aka D.Begay 71st SOG
#include "script_component.hpp"
PARAMS_3(_pack,_caller,_weapholder);

waitUntil {sleep 0.5; vehicle _caller != _caller or _pack != _caller getVariable "Zade_ChestBackpack"};

if (_pack != _caller getVariable "Zade_ChestBackpack") exitWith {true};

detach _weapholder;
deleteVehicle _weapholder;

waitUntil {sleep 0.5; vehicle _caller == _caller or _pack != _caller getVariable "Zade_ChestBackpack"};

if (_pack != _caller getVariable "Zade_ChestBackpack") exitWith {true};

[_pack,_caller] call Zade_BOC_fnc_AttachTo;

if (true) exitWith {true};