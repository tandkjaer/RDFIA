/*
Description:
	Things that have to run on both server and client
*/
missionActive = true;
enableSaving false;

//---------------------------------- Mission vars (for all clients)
derp_PARAM_AOSize = "AOSize" call BIS_fnc_getParamValue;
mainFaction = "CSAT";

if (isClass (configFile >> "CfgPatches" >> "task_force_radio")) then {
    TF_terrain_interception_coefficient = 5;
    TF_give_microdagr_to_soldier = false;
    tf_give_personal_radio_to_regular_soldier = false;
    tf_no_auto_long_range_radio = true;
    tf_same_sw_frequencies_for_side = true;
    tf_radio_channel_name = "EU2 Zeus Operations [TFAR]";

    TFAR_MICRODAGR = "tf_microdagr";
    TFAR_PR_RADIO_BF = "tf_rf7800str";
    TFAR_PR_RADIO_OF = "tf_pnr1000a";
    TFAR_SR_RADIO_BF = "tf_anprc152";
    TFAR_SR_RADIO_OF = "tf_fadak";
    TFAR_LR_RADIO_BF = "tf_rt1523g_rhs";
    TFAR_LR_RADIO_OF = "tf_mr3000_bwmod";
    TFAR_LR2_RADIO_BF = "tf_anarc210";
    TFAR_LR2_RADIO_OF = "tf_mr6000l";
};

[] execVM "scripts\misc\sharedFnc.sqf";