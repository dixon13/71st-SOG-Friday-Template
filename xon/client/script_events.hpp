/*private "_fnc_ghostModeChangeHandler";
_fnc_ghostModeChangeHandler = {
	PARAMS_1(_unit,_bool);
	
	switch (_bool) do {
		case true: { [ghostModeOn_AGM_SelfInteractionID] call AGM_Interaction_fnc_removeInteractionSelf; _ghostMode = _unit setVariable ["ghostMode",[_unit,true]]; ["ghostModeHandler",_ghostMode] call CBA_fnc_localEvent; };
		case false: { [ghostModeOff_AGM_SelfInteractionID] call AGM_Interaction_fnc_removeInteractionSelf; _ghostMode = _unit setVariable ["ghostMode",[_unit,false]]; ["ghostModeHandler",_ghostMode] call CBA_fnc_localEvent; };
	};
};
["ghostModeChangeHandler",_fnc_ghostModeChangeHandler] call CBA_fnc_addLocalEventHandler;
*/
private "_fnc_ghostModeHandler";
_fnc_ghostModeHandler = {
	PARAMS_2(_unit,_bool);
	//private["_ghostMode_AGM_SelfInteractionID"];
	diag_log format["_unit = %1 | _this select 0 = %2",_unit,(_this select 0)];
	switch (_bool) do {
		case true: { ghostModeOn_AGM_SelfInteractionID = ["Ghost Mode On",{!(((_this select 0) getVariable ["ghostMode",false]) select 1)},{ [(_this select 0),true] call FMAN(ghostMode); (_this select 0) setVariable ["ghostMode",[(_this select 0),true]]; }, false] call AGM_Interaction_fnc_addInteractionSelf; };
		case false: { ghostModeOff_AGM_SelfInteractionID = ["Ghost Mode Off",{(((_this select 0) getVariable ["ghostMode",false]) select 1)},{ [(_this select 0),false] call FMAN(ghostMode); (_this select 0) setVariable ["ghostMode",[(_this select 0),false]]; }, true] call AGM_Interaction_fnc_addInteractionSelf; };
	};
};
["ghostModeHandler", _fnc_ghostModeHandler] call CBA_fnc_addLocalEventHandler;