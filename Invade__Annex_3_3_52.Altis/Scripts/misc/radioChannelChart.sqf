// radioChannelChart.sqf
// drops a bunch of markers top left to create a dynamic radio channel chart.
private ["_y"];

private _boxPosition = [-1000, (worldSize-3000)];
private _box = createMarker ["radioBox", _boxPosition];
_box setMarkerShape "RECTANGLE";
_box setMarkerSize [1000,3000];
_box setMarkerBrush "SolidBorder";
_box setMarkerColor "ColorRed";

private _rfTitle = createMarker ["rfTitle", [-1700, (worldSize-300)]];
_rfTitle setMarkerType "mil_triangle";
_rfTitle setMarkerText "Radio Frequency Table";

private _rfSRM = createMarker ["rfSRM", [-900, (worldSize-600)]];
_rfSRM setMarkerType "mil_marker";
_rfSRM setMarkerText "SR";

private _rfLRM = createMarker ["rfLRM", [-400, (worldSize-600)]];
_rfLRM setMarkerType "mil_marker";
_rfLRM setMarkerText "LR";

private _y = 600;
private ["_rf"];
{	_y = _y + 200;
	_rf = createMarker [str (_x select 0), [-1700, (worldSize-_y)]];
	_rf setMarkerType "mil_dot";
	_rf setMarkerText (_x select 0);
	_rf setMarkerSize [0,0];
	
	_rf = createMarker [format ["srch_%1", str (_x select 0)], [-900, (worldSize-_y)]];
	_rf setMarkerType "mil_dot";
	_rf setMarkerText (str (_x select 1));
	_rf setMarkerSize [0,0];
	
    _rf = createMarker [(str (_x select 0) + "_lr"), [-400, (worldSize-_y)]];
    _rf setMarkerType "mil_dot";
    private _txt = _x select 2;
    if (isNil "_txt") then {
        _rf setMarkerText "30";
    } else {
        _rf setMarkerText _txt;
    };
    _rf setMarkerSize [0,0];

} forEach [
    ["Alpha", 50], ["Bravo", 51], ["Charlie", 52], ["Delta", 53], ["Echo", 54], ["Foxtrot", 55],
    ["FSG", 70, "30/31"], ["Recon", 71], ["Sniper", 72],["Vortex", 80, "30/31"]
];
_y = _y + 200;
private _rfNote = createMarker ["rfNote", [-1700, (worldSize-_y)]];
_rfNote setMarkerType "mil_marker";
_rfNote setMarkerText "note: when FAC present, AIR should switch to LR31";
_rfNote setMarkerSize [0,0];