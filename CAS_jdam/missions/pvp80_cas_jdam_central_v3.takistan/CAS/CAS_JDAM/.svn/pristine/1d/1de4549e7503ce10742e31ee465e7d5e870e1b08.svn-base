private ["_text"];

CAS_JDAM_hints_completed = [];

while {sleep 1; true} do {

	{

		if (((player distance _x) <= 1) && !(_x in CAS_JDAM_hints_completed)) then {
		
			switch (_x) do {

				case CAS_JDAM_hints_obj_kits: {_text = ["Select a kit before you head into the AO.", "These kits have better equipment and accessories then the default kit.", "Some kits have special abilities like medic or engineer."];};
				case CAS_JDAM_hints_obj_vehRearm: {_text = ["Rearm your vehicle here."]};
				case CAS_JDAM_hints_obj_air: {_text = ["You must get a pilot kit."]};
				case CAS_JDAM_hints_obj_deploy: {_text = ["Deploy to positions here."]};
				
			};
			
			"JDAM Tutorial Hint" hintC _text;

			CAS_JDAM_hints_completed = (CAS_JDAM_hints_completed + [_x]);
		
		};

	} forEach [CAS_JDAM_hints_obj_kits, CAS_JDAM_hints_obj_vehRearm, CAS_JDAM_hints_obj_air, CAS_JDAM_hints_obj_deploy];
	
};