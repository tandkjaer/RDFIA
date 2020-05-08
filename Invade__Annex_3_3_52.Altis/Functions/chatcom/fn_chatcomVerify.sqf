/*****************************************************************************
Function name: RWT_fnc_chatcomVerify;
Authors: longbow
License: MIT License

Dependencies:        RWT_fnc_chatcomProcess
Description:
	Function called from event handler attached to main in-game display,
	if chat key was pressed - waits till chat display initializes and
	attaches a new event handler to it

Returns:	BOOLEAN
*/
if (inputAction "Chat" > 0) then{
    rwt_chatcom_spawn = [] spawn {
        waitUntil {shownChat};
        sleep 0.1;
        waitUntil {!isNull (findDisplay 24 displayCtrl 101)};
        rwt_chatcom_chat_eh = (findDisplay 24) displayAddEventHandler["KeyDown","_this call RWT_fnc_chatcomProcess"];
    };
};
false;

