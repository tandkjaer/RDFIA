class AW {
	tag = "AW";
	class functions
	{
		file = "functions";
	};

	class vehicleFunctions
	{
		file = "functions\Vehicle";
		class vsetup02 {};
		class vBasemonitor {};
		class SMhintSUCCESS {};
		class vehicleInventory {};
	};

	class unitFunctions
	{
		file = "functions\Units";
		class setskill1 {};
		class setskill2 {};
		class setskill3 {};
		class setskill4 {};
        class buildingDefenders {};
		class smenemyeast {};
		class smenemyeastintel {};
		class smenemyeastrescuepilot {};
		class airCav {};
        class sideMissionEnemy {};
		class taskCircPatrol {};
		class spawnAOVehicle {};
	};

	class supportFunctions
	{
		file = "functions\Supports";
		class airfieldJet {};
		class ArtyStrike {};
		class enemyAirEngagement {};
	};

	class locationFunctions
	{
		file = "functions\Location";
		class getAo {};
	};

	class messageFunctions
	{
		file = "functions\Messages";
		class globalHint {};
		class globalnotification {};
		class killMessage {};
	};

	class cleanupFunctions
	{
		file = "functions\Cleanup";
		class smdelete {};
	};
	
	class CustomPlayerActions {
		file = "functions\CustomPlayerActions";
		class clearVehicleInventory {};
		class helicopterDoors {};
		class slingWeapon {};
	};

	class baseFunctions
	{
		file = "functions\Base";
		class BaseManager {};
        class baseTeleport {};
        class baseTeleportSetup {};
        class cvnCIWS {};
		class mainBaseAA {};
		class baseHeal {};
	};

	class miscFunctions
	{
		file = "functions\Misc";
		class addaction {};
		class addactiongetintel {};
		class addactionsurrender {};
        class addToAllCurators {};
	};
	
	class inventoryFunctions {
		file = "functions\Inventory";
		class cleanInventory {};
		class inventoryInformation {};
	};
	
	class seatRestrictionFunctions {
		file = "functions\seatRestrictions";
		class restrictedAircraftSeatsCheck {};
	};
};

class RYK {
	tag = "RYK";
	class tfarFunctions
	{
		file = "functions\TFAR";
		class TFAR_SR {};
		class TFAR_LR {};
	};
	class zeusFunctions {
	    file = "functions\zeus";
	    class initiateZeusByUID;
	};
};


class derp
{
	tag = "derp";

    class CBA {
        file = "functions\portedFuncs\cba";
        class pfhPreInit { preInit = 1; };
        class addPerFrameHandler {};
        class removePerFrameHandler {};
        class execNextFrame {};
        class waitAndExecute {};
        class waitUntilAndExecute {};
        class pfhPostInit { postInit = 1; };
        class getTurret {};
        class directCall {};
    };

	class AI {
        file = "functions\AI";
        class mainAOSpawnHandler {};
        class AISkill {};
		class arrayShuffle {};
    };

	class Revive {
        file = "functions\revive";
        class syncAnim {};
    };
};

class derp_revive {

    class Revive {
        file = "functions\revive";
        class onPlayerKilled {};
        class onPlayerRespawn {};
        class executeTemplates {};
        class switchState {};
        class reviveTimer {};
        class reviveActions {};
        class startDragging {};
        class startCarrying {};
        class dragging {};
        class carrying {};
        class dropPerson {};
        class hotkeyHandler {};
        class uiElements {};
        class animChanged {};
        class drawDowned {};
        class handleDamage {};
        class ace3Check {};
        class diaryEntries {};
        class adjustForTerrain {};
        class syncAnim {};
        class heartBeatPFH {};
    };
};

class CHVD
{
	tag = "CHVD";
	class functions
	{
		file = "functions\CHVD";
		class onCheckedChanged {};
		class onSliderChange {};
		class onLBSelChanged {};
		class onEBinput {};
		class onEBterrainInput {};
		class selTerrainQuality {};
		class updateTerrain {};
		class updateSettings {};		
		class openDialog {};
		class init {postInit = 1;};
	};
};

class chatcom
{
    tag = "RWT";
    class functions
    {
        file = "functions\chatcom";
        class chatcomExec {};
        class chatcomProcess {};
        class chatcomVerify {};
    };
};