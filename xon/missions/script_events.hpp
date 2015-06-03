FUNC(handleTask) = {
	PARAMS_4(_object,_taskState,_notification,_description);
	
	_task = _object getVariable "task";
	_task setTaskState _taskState;
	[_notification,[_description]] call BIS_fnc_showNotification;
};

private "_fnc_hvtKilled";
_fnc_hvtKilled = {
	PARAMS_1(_hvt);
	
	switch (_hvt getVariable ["objCompleted",false]) do {
		case true: {
			[_hvt,"Succeeded","HvtWin","HVT was secured and is being questioned..."] call FUNC(handleTask);
			deleteVehicle _hvt;
		};
		case false: {
			[_hvt,"Failed","HvtDead","HVT was killed. You have FAILED. RTB"] call FUNC(handleTask);
			deleteVehicle _hvt;
		};
	};
	
};
["hvtKilled", _fnc_hvtKilled] call CBA_fnc_addEventHandler;

private "_fnc_cacheKilled";
_fnc_cacheKilled = {
	PARAMS_1(_cache);
	
	[_cache,"Succeeded","CacheWin","Cache was destroyed"] call FUNC(handleTask);
	sleep 5;
	deleteVehicle _cache;
};
["cacheKilledEH", _fnc_cacheKilled] call CBA_fnc_addEventHandler;