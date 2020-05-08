/*
Description:  Script that will service planes, UAVs and helis.  Inted for use on the USS freedom.
Based off of existing service scripts from I&A 3.1.5

author:  unknown

To be called from a trigger like this:
activation: BLUFOR
Repeatable: yes

condition:
this and ((getPos (thisList select 0)) select 2 < 1)

on activation:
_handle = [(thisList select 0)] execVM "scripts\vehicle\rearmcarrier.sqf";
*/
private _veh = _this select 0;
//=====================================service helicopter================================
if (_veh isKindOf "Helicopter" || ((typeOf _veh) find "VTOL" != -1)) exitWith {
    if (!alive _veh) exitWith {};

    _veh vehicleChat "Servicing aircraft, please wait ...";
    _veh setFuel 0;

    //---------- REPAIRING
     _veh vehicleChat "Repairing ...";
    sleep 10;
    if (isEngineOn _veh || !alive _veh) exitWith {
        _veh vehicleChat "Service aborting because engine is on.";
    };
    _veh setDamage 0;
    _veh vehicleChat "Repaired (100%).";


    //---------- RE-ARMING
    _veh vehicleChat "Re-arming ...";
    sleep 10;
    if (isEngineOn _veh || !alive _veh) exitWith {
        _veh vehicleChat "Service aborting because engine is on.";
    };

    _veh setVehicleAmmo 1;
    _veh vehicleChat "Re-armed (100%).";

    //---------- REFUELING
    _veh vehicleChat "Refueling ...";
    sleep 10;
    if (isEngineOn _veh || !alive _veh) exitWith {
        _veh vehicleChat "Service aborting because engine is on.";
    };
    _veh setFuel 1;
    _veh vehicleChat "Refuelled (100%).";

    //---------- FINISHED
    sleep 0.5;
    _veh vehicleChat "Service complete.";
};

//========================service UAVs=====================
if ((_veh isKindOf "UAV")) exitWith {
    if (!alive _veh) exitWith {};
    _veh vehicleChat "Servicing aircraft, please wait ...";
    _veh setFuel 0;


    //---------- REPAIRING
     _veh vehicleChat "Repairing ...";
    sleep 20;
    if (isEngineOn _veh || !alive _veh) exitWith {
        _veh vehicleChat "Service aborting because engine is on.";
    };
    _veh setDamage 0;
    _veh vehicleChat "Repaired (100%).";

    //---------- RE-ARMING
    _veh vehicleChat "Re-arming ...";
    sleep 60;
    if (isEngineOn _veh || !alive _veh) exitWith {
        _veh vehicleChat "Service aborting because engine is on.";
    };

    _veh setVehicleAmmo 1;

    //---------- REFUELING
    _veh vehicleChat "Refueling ...";
    sleep 30;
    if (isEngineOn _veh || !alive _veh) exitWith {
        _veh vehicleChat "Service aborting because engine is on.";
    };
    _veh setFuel 1;
    _veh vehicleChat "Refuelled (100%).";

    //---------- FINISHED
    sleep 0.5;
    _veh vehicleChat "Service complete.";
};



//=========================service planes====================
if ((_veh isKindOf "Plane")&& !(_veh isKindOf "UAV")) exitWith {
    if (!alive _veh) exitWith {};
    _veh vehicleChat "Servicing aircraft, this will take about 10 minutes. Please wait ...";
    _veh setFuel 0;


    //---------- REPAIRING
     _veh vehicleChat "Repairing ...";
    sleep 200;
    if (isEngineOn _veh || !alive _veh) exitWith {
        _veh vehicleChat "Service aborting because engine is on.";
    };
    _veh setDamage 0;
    _veh vehicleChat "Repaired (100%).";

    //---------- RE-ARMING
    _veh vehicleChat "Re-arming ...";
    sleep 200;
    if (isEngineOn _veh || !alive _veh) exitWith {
        _veh vehicleChat "Service aborting because engine is on.";
    };

    _veh setVehicleAmmo 1;
    _veh vehicleChat "Re-armed (100%).";

    //---------- REFUELING
    _veh vehicleChat "Refueling ...";
    sleep 200;
    if (isEngineOn _veh || !alive _veh) exitWith {
        _veh vehicleChat "Service aborting because engine is on.";
    };
    _veh setFuel 1;
    _veh vehicleChat "Refuelled (100%).";

    //---------- FINISHED
    sleep 0.5;
    _veh vehicleChat "Service complete.";
};

if (!(_veh isKindOf "Plane")|| !(_veh isKindOf "UAV")||!(_veh isKindOf "Helicopter")) exitWith {
    _veh vehicleChat "Your vehicle cannot be serviced here soldier";
};


