private "_fnc_title";
_fnc_title = {
	private ["_uid", "_msg"];
	PARAMS_2(_uid,_msg);
	if (_uid == getPlayerUID player) then {
		titleText [_msg, "plain down"];
		titleFadeOut 5;
	};
}; //alternative is ace_fnc_visual
["T_E_M_T", _fnc_title] call CBA_fnc_addEventHandler;

private "_fnc_vehchat";
_fnc_vehchat = {
	PARAMS_2(_veh,_msg);
	if (!isDedicated) then {
		_veh vehicleChat _msg;
	};
};
["MTEMCV", _fnc_vehchat] call CBA_fnc_addEventHandler;