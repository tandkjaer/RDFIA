/*Author: Quiksilver*/

hint "Receiving data...Verifying...";
sleep 1;

private _sidecompleted = format["<t align='center'><t size='2.2'>Side-mission update</t><br/>____________________<br/>%1 recovered the intel.</t>",name player];
[_sidecompleted] remoteExec ["AW_fnc_globalHint",0,false];
sleep 1;

SM_SUCCESS = true;
publicVariableServer "SM_SUCCESS";
