/*
Authors: longbow
License: MIT License

Description:
        Functions parses a chat message and checks if it starts with a
	special character, which is followed by chat command.
	Executed from event handler attached to chat's display

Arguments:
        ARRAY [_COM,_ARG1,..,_ARG_N]
                _COM - STRING, name of command from rwt_chatcom class
                _ARG1-_ARGN - STRING, optional arguments to command

Returns:        BOOLEAN
*/
if ((_this select 1) != 28) exitWith {false};
private _chatmsg = ctrlText (findDisplay 24 displayCtrl 101);
if (_chatmsg find "#" != -1) then { _chatmsg call RWT_fnc_chatcomExec; };

closeDialog 0;
(findDisplay 24) displayRemoveEventHandler ["KeyDown", rwt_chatcom_chat_eh];
false;