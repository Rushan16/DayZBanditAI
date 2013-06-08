/*
	spawnBandits_random_NR

	Usage: Called by an activated dynamic trigger when a player unit enters the trigger area.
	
	Description: Spawns a group of AI units some distance from a dynamically-spawned trigger. These units do not respawn after death.
	
	Last updated: 4:36 PM 6/8/2013
*/
private ["_minAI","_addAI","_patrolDist","_trigger","_unitGroupArray","_triggerPos","_totalAI","_maxDist","_unitGroup","_pos","_nearbyPlayers","_targetPlayer","_unitArray","_playerArray","_playerPos","_minDist","_formation","_wp"];
if (!isServer) exitWith {};

//Check if there are too many AI units in the game.
if (DZAI_numAIUnits >= DZAI_maxAIUnits) exitWith {diag_log format["DZAI Warning: Maximum number of AI reached! (%1)",DZAI_numAIUnits];};

_minAI = _this select 0;									//Mandatory minimum number of AI units to spawn
_addAI = _this select 1;									//Maximum number of additional AI units to spawn
_patrolDist = _this select 2;
_trigger = _this select 3;
_unitArray = _this select 4;

_unitGroupArray = _trigger getVariable ["GroupArray",[]];			
if (count _unitGroupArray > 0) exitWith {if (DZAI_debugLevel > 0) then {diag_log "DZAI Debug: Active groups found. Exiting spawn script (spawnBandits_random_NR)";};};						

_totalAI = (_minAI + round(random _addAI));					
if (_totalAI == 0) exitWith {};								

_playerArray = [];
{
	if (isPlayer _x) then {
		_playerArray set [(count _playerArray),_x];	//build list of player units within trigger area.
	};
} forEach _unitArray;
diag_log format ["%1 units within trigger area. %2 are players.",(count _unitArray),(count _playerArray)];

_targetPlayer = _playerArray call BIS_fnc_selectRandom; 	//select random player to use as reference point for spawning.
_playerPos = getPosATL _targetPlayer;

//_triggerPos = getPos _trigger;	

_minDist = 125;
_maxDist = (_minDist + random(125));
_pos = [_playerPos,_minDist,_maxDist,5,0,2000,0] call BIS_fnc_findSafePos;

if (DZAI_debugLevel > 0) then {diag_log format["DZAI Debug: %1 AI spawns triggered (spawnBandits_random_NR).",_totalAI];};

_unitGroup = grpNull;
if ((random 1) < 0.5) then {				//50% chance to choose East or Resistance as AI side to avoid reaching 140 group/side limit.
	_unitGroup = createGroup east;
} else {
	_unitGroup = createGroup resistance;
};
for "_i" from 1 to _totalAI do {
	private ["_unit"];
	_unit = [_unitGroup,_pos,_trigger] call fnc_createAI_NR;
	if (DZAI_debugLevel > 1) then {diag_log format["DZAI Extended Debug: AI %1 of %2 spawned (spawnBandits_random_NR).",_i,_totalAI];};
};
_unitGroup selectLeader ((units _unitGroup) select 0);
_unitGroup allowFleeing 0;

0 = [_unitGroup,_playerPos,_patrolDist,DZAI_debugMarkers] spawn fnc_BIN_taskPatrol;

{
	_unitGroup reveal [_x,4];
} forEach _playerArray;

_unitGroupArray set [count _unitGroupArray,_unitGroup];
0 = [_trigger,_unitGroupArray,_totalAI] call fnc_initTrigger;

true
