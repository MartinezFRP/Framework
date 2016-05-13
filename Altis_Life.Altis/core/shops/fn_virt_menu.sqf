#include "..\..\script_macros.hpp"
/*
    File: fn_virt_menu.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    Initialize the virtual shop menu.
*/
private["_exit","_shopSide","_license","_levelAssert","_levelName","_levelType","_levelValue","_levelMsg","_flag"];
if(isNil {SEL(_this,3)}) exitWith {};
_exit = false;
_shopSide = M_CONFIG(getText,"VirtualShops",(SEL(_this,3)),"side");
_license = M_CONFIG(getText,"VirtualShops",(SEL(_this,3)),"license");
_levelAssert = M_CONFIG(getArray,"VirtualShops",(SEL(_this,3)),"level");
_levelName = SEL(_levelAssert,0);
_levelType = SEL(_levelAssert,1);
_levelValue = SEL(_levelAssert,2);
_levelMsg = SEL(_levelAssert,3);
life_shop_type = SEL(_this,3);
life_shop_npc = SEL(_this,0);

if(!(_shopSide isEqualTo "")) then {
    _flag = switch(playerSide) do {case west: {"cop"}; case independent: {"med"}; default {"civ"};};
    if(!(EQUAL(_flag,_shopSide))) then {_exit = true;};
};
if(_exit) exitWith {};

if(!(_license isEqualTo "")) then {
    _flag = M_CONFIG(getText,"Licenses",_license,"side");
    if(!(LICENSE_VALUE(_license,_flag))) exitWith {hint localize "STR_Shop_Veh_NoLicense"; _exit = true;};
};
if(_exit) exitWith {};

if(!(_levelValue isEqualTo -1)) then {
    _level = missionNamespace getVariable _levelName;
    if(_level isEqualType {}) then {_level = FETCH_CONST(_level);};

    _flag = switch(_levelType) do {
        case "SCALAR": {_level >= _levelValue};
        case "BOOL": {_level};
        case "EQUAL": {_level isEqualTo _levelValue};
        default {false};
    };
    if(!(_flag)) then {
        _exit = true;
        if(_levelMsg isEqualTo "") then {
            _levelMsg = (localize "STR_Shop_Veh_NotAllowed");
        } else {
            if(isLocalized _levelMsg) then {
                _levelMsg = (localize _levelMsg);
            };
        };
    };
};
if(_exit) exitWith {hint _levelMsg;};

createDialog "shops_menu";

[] call life_fnc_virt_update;
