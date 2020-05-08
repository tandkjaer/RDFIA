/*
author: stanhope, AW community member.
description: Adds given param as an editable object to all curators
*/

params ["_toAdd"];
    
{_x addCuratorEditableObjects [_toAdd, true];} forEach allCurators;
