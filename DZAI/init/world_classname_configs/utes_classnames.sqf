/*
	Utes Loot Configuration
	
	Last updated:
	
*/

private ["_modname"];
_modname = toLower format ["%1",DZAI_modName];

DZAI_gradeChances0 = [0.85,0.13,0.02,0.00];	
DZAI_gradeChances2 = [0.50,0.46,0.10,0.01];						
DZAI_gradeChances2 = [0.20,0.60,0.15,0.05];									
DZAI_gradeChances3 = [0.00,0.60,0.33,0.07];	
for "_i" from 0 to ((count DZAI_Pistols0) - 1) do {DZAI_Rifles0 set [(count DZAI_Rifles0),(DZAI_Pistols0 select _i)];};

diag_log "Utes loot tables loaded.";