MGO_PHON = ["Alpha", "Bravo", "Charlie", "Delta", "Echo", "Foxtrot", "Golf", "Hotel",
 "India", "Juliet", "Kilo", "Lima", "Mike", "November", "Oscar", "Papa", "Quebec", 
"Romeo","Sierra", "Tango", "Uniform", "Victor", "Whiskey", "Xray", "Yankee", "Zulu"];

FUNC(XON_HINT) = {
	PARAMS_3(_type,_message,_locality);
	
	switch (toUpper _type) do {
		case "HINT" : { [parseText format["%1",_message],"hint",_locality,false,true] call BIS_fnc_MP; };
		case "HINTC" : { [parseText format["%1",_message],"hintC",_locality,false,true] call BIS_fnc_MP; };
		case "HINTS";
		case "HINTSILENT" : { [parseText format["%1",_message],"hintSilent",_locality,false,true] call BIS_fnc_MP; };
		default { [parseText format["%1",_message],"hint",_locality,false,true] call BIS_fnc_MP; };
	};
};

FUNC(adminTeleport) = {
	PARAMS_1(_admin);
	
	openMap true;
	["Click on map to teleport.","hint",_admin,false,true] call BIS_fnc_MP;
	//hint "Click on map to teleport.";
	sleep 1;
	private ["_id"]; 
	_id = [format["%1",71 + random 1000], "onMapSingleClick", { _this setPos _pos; openMap false;}, _admin] call BIS_fnc_addStackedEventHandler;
	//_admin onMapSingleClick {(_this select 0) setPos _pos; onMapSingleClick ''; openMap false; true;};
	waitUntil{!(visibleMap)};
	[_id, "onMapSingleClick"] call BIS_fnc_removeStackedEventHandler;
	["","hintSilent",_admin,false,true] call BIS_fnc_MP;
};

FUNC(canGhost) = {
	PARAMS_1(_unit,_bool);
	
	if !([_unit] call ace_common_fnc_canInteract) exitWith {false};
	_return = _unit getVariable ["XON_ghost",_bool];
	_return;
};

FUNC(ghostMode) = {
	PARAMS_2(_unit,_bool);
	
	[0,{(_this select 0) hideObjectGlobal (_this select 1);},[_unit,_bool]] call CBA_fnc_globalExecute;
	_unit setVariable ["XON_ghost",_bool];
};

FUNC(WarnMsg) = {
	PARAMS_1(_msg);
	DEFAULT_PARAM(1,_beep,true);

	if (_beep) then {
		hint _msg;
	} else {
		hintSilent _msg;
	};

	_msg = _msg call FUNC(RemoveLineBreak);

	[playerSide, "HQ"] sideChat _msg;
};

FUNC(TitleMsg) = {
	PARAMS_1(_msg);
	DEFAULT_PARAM(1,_time,10);
	titleText [_msg, "plain down"];
	titleFadeOut _time;
};

FUNC(RemoveLineBreak) = { // code by Xeno
	private ["_msg", "_msg_chat_a", "_i", "_c"];
	_msg = _this;
	_msg_chat_a = toArray (_msg);
	for "_i" from 0 to (count _msg_chat_a - 2) do {
		_c = _msg_chat_a select _i;
		if (_c == 92) then {
			if ((_msg_chat_a select (_i + 1)) in [78,110]) then {
				_msg_chat_a set [_i, 32];
				_i = _i + 1;
				_msg_chat_a set [_i, -1];
			};
		};
	};
	_msg_chat_a = _msg_chat_a - [-1];
	toString (_msg_chat_a)
};

FUNC(EngineOff) = {
	PARAMS_1(_veh);
	//if (isEngineOn _veh) then {_veh engineOn false}; //CIT #22360
	if (isNil {_veh getVariable QGVAR(org_fuel)}) then {
		_veh setVariable [QGVAR(org_fuel), fuel _veh];
		if (_veh getVariable [QGVAR(org_fuel), 0] > 0) then {
			_veh setFuel 0;
			_veh spawn {
				sleep 1;
				_this setFuel (_this getVariable [QGVAR(org_fuel), 0]);
				_this setVariable [QGVAR(org_fuel), nil];
			};
		};
	};
};

// by Xeno
// get displayname of an object
// parameters: type of object (string), what (0 = CfgVehicles, 1 = CfgWeapons, 2 = CfgMagazines)
// example: _dispname = ["UAZ", 0] call FUNC(GetDisplayName);
FUNC(GetDisplayName) = {
	private ["_obj_name", "_obj_kind", "_cfg", "_drop_dn"];
	PARAMS_2(_obj_name,_obj_kind);
	_cfg = switch (_obj_kind) do {case 0: {"CfgVehicles"};case 1: {"CfgWeapons"};case 2: {"CfgMagazines"};};

	_drop_dn = getText (configFile >> _cfg >> _obj_name >> "displayNameShort");
	if (_drop_dn == "") then {
		_drop_dn = getText (configFile >> _cfg >> _obj_name >> "displayName");
		if (_drop_dn == "") then {
			_drop_dn = _obj_name;
		};
	};

	_drop_dn
};

FUNC(VehicleChat) = {
	PARAMS_2(_veh,_msg);
	if (typeName _veh != "OBJECT") exitWith {};
	if (typeName _msg != "STRING") exitWith {};
	["MTEMCV", [_veh,_msg]] call CBA_fnc_globalEvent;
};

FUNC(returnConfigEntry) = {
	/*
		File: returnConfigEntry.sqf
		Author: Joris-Jan van 't Land

		Description:
		Explores parent classes in the run-time config for the value of a config entry.

		Parameter(s):
		_this select 0: starting config class (Config)
		_this select 1: queried entry name (String)

		Returns:
		Number / String - value of the found entry
	*/
	if (count _this < 2) exitWith {nil};
	private ["_config", "_entryName"];
	PARAMS_2(_config,_entryName);
	if (typeName _config != typeName configFile) exitWith {nil};
	if (typeName _entryName != typeName "") exitWith {nil};
	private ["_entry", "_value"];
	_entry = _config >> _entryName;
	if (configName (_config >> _entryName) == "" && !((configName _config) in ["CfgVehicles", "CfgWeapons", ""])) then {
		[inheritsFrom _config, _entryName] call FUNC(returnConfigEntry);
	} else {
		if (isNumber _entry) then {
			_value = getNumber _entry;
		} else {
			if (isText _entry) then {_value = getText _entry};
		};
	};
	if (isNil "_value") exitWith {nil};
	_value
};

FUNC(debugMarker) = {
	PARAMS_5(_str,_pos,_shape,_type,_color);
	
	_mkr = createMarker[_str,_pos];
	_mkr setMarkerShape _shape;
	_mkr setMarkerType _type;
	_mkr setMarkerColor _color;
	_str;
};

FUNC(killedText) = {
	hint parseText format["<t align='center' color='#e5b348' size='1.2'><t shadow='1'shadowColor='#000000'>Friday Night Ops</t></t>
	<img color='#ffffff' image='xon\Images\img_line_ca.paa' align='center' size='0.79' />
	<t color='#80FF00'> An Ammo Cache</t><t color='#eaeaea'> has been destroyed</t>
	<img color='#ffffff' image='xon\Images\img_line_ca.paa' align='center' size='0.79' />"]
};

FUNC(pickedUpIntel) = {
	hint parseText format["<t align='center' color='#e5b348' size='1.2'><t shadow='1'shadowColor='#000000'>Friday Night Ops</t></t>
	<img color='#ffffff' image='xon\Images\img_line_ca.paa' align='center' size='0.79' />
	<t color='#eaeaea'>New intel received on the location of an ammo cache. A marker has been added to the map.</t>
	<img color='#ffffff' image='xon\Images\img_line_ca.paa' align='center' size='0.79' />"]
};

FUNC(cacheKilled) = {
	private ["_pos","_x"];
	
	_cache = _this;
	
	_pos = getPos _cache;
	_x = 0;

	while { _x <= 20 } do {
		"M_Mo_82mm_AT_LG" createVehicle _pos;
		_x = _x + 1 + random 4;
		sleep 1;
	};
};

FUNC(createIntel) = {
	private ["_i","_sign","_sign2","_radius","_cache","_pos","_mkr","_range","_intelRadius"];

    _cache = _this;
	_intelRadius = 500;
    _i = 0;

	while{ (getMarkerPos format["%1intel%2", _cache, _i] select 0) != 0} do {
		_i = _i + 1;
	};

	_sign = 1;

	if (random 100 > 50) then {
		_sign = -1;
	};

	_sign2 = 1;

	if (random 100 > 50) then {
		_sign2 = -1;
	};

	_radius = _intelRadius - _i * 50;

	if (_radius < 50) then {
		_radius = 50;
	};

	_pos = [(getPosATL _cache select 0) + _sign *(random _radius),(getPosATL _cache select 1) + _sign2*(random _radius)];
	_mkr = createMarker[format["%1intel%2", _cache, _i], _pos];
	_mkr setMarkerType "hd_unknown";
	_range = round sqrt(_radius^2*2);
	_range = _range - (_range % 50);
	_mkr setMarkerText format["%1m", _range];
	_mkr setMarkerColor "ColorRed";
	_mkr setMarkerSize [0.5,0.5];
	_mkr_array = [_mkr];
	INS_marker_array = INS_marker_array + _mkr_array;
};

FUNC(intelPickup) = {
	if (side player == east) exitWith{};
	_intel = _this select 0;
	_used = _this select 1;
	_ID = _this select 2;
	
	_intel removeAction _ID;
	
	_cases = nearestObjects[getPos player, intelItems, 10];

	if (count _cases == 0) exitWith {};

	_case = _cases select 0;

	if (isNull _case) exitWith {};

	deleteVehicle _case;
	player groupChat "You retrieved some INTEL on the general location of an ammo cache";

	_cache = cache;

	if (isNil "_cache") exitWith {
		hint "There is no spawned cache. This is game breaking. Please contact the admin to restart and report this issue";
	};

	[-1, { call FUNC(pickedUpIntel)}, nil] call CBA_fnc_globalExecute;
	[0, { _this call FUNC(createIntel)}, _cache] call CBA_fnc_globalExecute;
	//[nil, "pickedUpIntel", true, false] spawn BIS_fnc_MP;
	//[_cache, "createIntel", false, false] spawn BIS_fnc_MP;
};

FUNC(addActionMP) = {
	private["_object","_screenMsg"];
	PARAMS_2(_object,_screenMsg);

	if(isNull _object) exitWith {};

	_object addaction [_screenMsg,QUOTE(call FUNC(intelPickup))];
};

FUNC(UrbanAreas) = {
	private ["_locations","_cityTypes","_randomLoc","_x","_i","_cities"];
	_i = 0;
	_cities = [];

	_locations = configfile >> "CfgWorlds" >> worldName >> "Names";
	_cityTypes = ["NameVillage","NameCity","NameCityCapital","CityCenter"];

	for "_x" from 0 to (count _locations - 1) do {
		_randomLoc = _locations select _x;
		// get city info
		private["_cityName","_cityPos","_cityRadA","_cityRadB","_cityType","_cityAngle"];
		_cityName = getText(_randomLoc >> "name");
		_cityPos = getArray(_randomLoc >> "position");
		_cityRadA = getNumber(_randomLoc >> "radiusA");
		_cityRadB = getNumber(_randomLoc >> "radiusB");
		_cityType = getText(_randomLoc >> "type");
		_cityAngle = getNumber(_randomLoc >> "angle");
		if (_cityType in _cityTypes && (_cityName != "Jaza" && _cityName != "LoyManara" && _cityName != "Stratis Air Base") ) then {
			_cities set [_i,[_cityName, _cityPos, _cityRadA, _cityRadB, _cityType, _cityAngle]];
			_i = _i + 1;
		};
	};
	_cities;
};

FUNC(findBuildings) = {
	private ["_center","_radius","_buildings"];
	PARAMS_2(_center,_radius);
	//_buildingTypes = ["Land_House_L_1_EP1","Land_House_L_3_EP1","Land_House_L_4_EP1","Land_House_L_6_EP1","Land_House_L_7_EP1","Land_House_L_8_EP1","Land_House_L_9_EP1","Land_House_K_1_EP1","Land_House_K_3_EP1","Land_House_K_5_EP1","Land_House_K_6_EP1","Land_House_K_7_EP1","Land_House_K_8_EP1","Land_House_C_1_EP1","Land_House_C_1_v2_EP1","Land_House_C_2_EP1","Land_House_C_3_EP1","Land_House_C_4_EP1","Land_House_C_5_EP1","Land_House_C_5_V1_EP1","Land_House_C_5_V2_EP1","Land_House_C_5_V3_EP1","Land_House_C_9_EP1","Land_House_C_10_EP1","Land_House_C_11_EP1","Land_House_C_12_EP1","Land_A_Villa_EP1","Land_A_Mosque_small_1_EP1","Land_A_Mosque_small_2_EP1","Land_Ind_FuelStation_Build_EP1","Land_Ind_FuelStation_Shed_EP1","Land_Ind_Garage01_EP1"];
	//_buildingTypes = ["Church","House_Small_F","Land_BellTower_01_V1_F","Land_BellTower_01_V2_F","Land_Calvary_01_V1_F","Land_Calvary_02_V1_F","Land_Calvary_02_V2_F","Land_Lighthouse_small_F","Land_u_Addon_01_V1_F","Land_d_Addon_02_V1_F","Land_u_Addon_02_V1_F","Land_i_Addon_03_V1_F","Land_i_Addon_03mid_V1_F","Land_i_Addon_04_V1_F","Land_i_Garage_V1_F","Land_Metal_Shed_F","Land_i_House_Small_02_V1_F","Land_d_House_Small_02_V1_F","Land_cargo_addon01_V1_F","Land_cargo_addon01_V2_F","Land_cargo_addon02_V1_F","Land_cargo_addon02_V2_F","Land_cargo_house_slum_F","Land_Slum_House01_F","Land_Slum_House02_F","Land_i_Stone_Shed_V1_F","Land_Factory_Conv1_10_F","Land_Factory_Conv1_End_F","Land_FuelStation_Build_F","Land_fs_feed_F","Land_TTowerSmall_1_F","Land_TTowerSmall_2_F","Cargo_House_base_F","Land_Radar_Small_F","Land_Research_house_V1_F","Land_Offices_01_V1_F","Land_Amphitheater_F","Land_Castle_01_tower_F","Land_Cstle_01_house_ruin_F","Land_Castle_01_church_a_ruin_F","Land_Castle_church_b_ruin_F","Land_Castle_01_church_ruin_F","Land_Hospital_main_F","Land_Hospital_side1_F","Land_Hospital_side2_F","Land_LightHouse_F","Land_i_House_Big_01_V2_F","Land_i_House_Big_01_V3_F","Land_d_House_Big_01_V1_F","Land_i_House_Big_02_V2_F","Land_i_House_Big_02_V3_F","Land_d_House_Big_02_V1_F","Land_i_Shop_01_V1_F","Land_d_Shop_01_V1_F","Land_i_Shop_02_V1_F","Land_d_Shop_02_V1_F","Land_i_House_Small_01_V1_F","Land_d_House_Small_01_V1_F","Land_i_House_Small_03_V1_F","Land_i_Stone_HouseBig_V1_F","Land_d_Stone_HouseBig_V1_F","Land_i_Stone_HouseSmall_V1_F","Land_d_Stone_HouseSmall_V1_F","Land_Unfinished_Building_01_F","Land_Unfinished_Building_02_F","Land_Airport_center_F","Land_Airport_Tower_F","Land_LandMark_F","Land_CarService_F","Land_cmp_Hopper_F","Land_cmp_Shed_F","Land_cmp_Shed_dam_F","Land_cmp_Tower_F","Land_dp_mainFactory_F","Land_dp_smallFactory_F","Land_Factory_Conv1_Main_F","Land_Factory_Conv2_F","Land_Factory_Hopper_F","Land_Factory_Main_F","Land_Factory_Tunnel_F","Land_FuelStation_Shed_F","Land_Shed_Big_F","Land_Shed_Small_F","Land_i_Shed_Ind_F","Land_u_Shed_Ind_F","Land_spp_Panel_F","Land_spp_Tower_F","Land_TTowerBig_1_F","Land_TTowerBig_2_F","Land_i_Barracks_V1_F","Land_Bunker_F","Cargo_HQ_base_F","Cargo_Patrol_base_F","Cargo_Tower_base_F","Land_MilOffices_V1_F"];
	
    if (_radius < 200) then {_radius = 400;};
    _buildings = nearestObjects [_center, ["Jbad_House","Jbad_House_c","Jbad_House_old","jbad_misc_market","Land_Jbad_A_Mosque_small_1","Land_Jbad_A_Mosque_small_2","Land_Jbad_A_Minaret"], _radius];
	_buildings;
};

FUNC(buildingPositions) = {
	private ["_building","_positions"];
	_building = _this;

	_positions = [_building] call BIS_fnc_buildingPositions;
    _positions;
};

FUNC(handleTask) = {
	PARAMS_4(_object,_taskState,_notification,_description);
	
	_task = _object getVariable "task";
	_task setTaskState _taskState;
	[_notification,[_description]] call BIS_fnc_showNotification;
};

FUNC(relativePos) = {
	PARAMS_3(_object,_dist,_dir);
	_pos = [_object,_dist,_dir] call BIS_fnc_relPos;
	_pos;
};

FUNC(spawnObjectiveDefenders) = {
	PARAMS_4(_building,_side,_configFile,_outsideBuilding);
	private["_buildingPositions","_buildingPos","_pos","_pos1","_pos2"];
	
	switch (_outsideBuilding) do {
		case true: {
			_relPos = [_building,(round random 100),(round random 360)] call FUNC(relativePos);
			_grp = [_relPos,_side,_configFile] call BIS_fnc_spawnGroup;
			[_grp,_relPos,(round((random 50) + 100)),((ceil random 4) + 2),"MOVE","CARELESS","RED","LIMITED",format["%1",["COLUMN","STAG COLUMN"]call BIS_fnc_selectRandom],""] call CBA_fnc_taskPatrol;
			_grp;
		};
		case false: {
			_buildingPositions = _building call FUNC(buildingPositions);
			if (_buildingPositions isEqualTo []) then {
				_buildingPos = getPosATL _building;
			} else {
				_tempArray = _buildingPositions call BIS_fnc_arrayShuffle;
				_buildingPos = _tempArray call BIS_fnc_selectRandom;
			};
			_grp = [_buildingPos,_side,_configFile] call BIS_fnc_spawnGroup;
			_grp;
		};
	};
};

FUNC(cacheMission) = {
	call compile preprocessFileLineNumbers "xon\missions\cacheMission.sqf";
};

FUNC(recCenter) = {
	call compile preprocessFileLineNumbers "xon\missions\recruitmentCenter.sqf";
};

FUNC(secureCrash) = {
	call compile preprocessFileLineNumbers "xon\missions\secureCrash.sqf";
};