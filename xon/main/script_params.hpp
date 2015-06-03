#include "script_settings.hpp"
	class MGO_SrvScript {
		title = "MilGO Server Scripts:";
		values[] = {0,1};
		default = 1;
		texts[] = {"Not Configured","In Place"};
	};
#ifdef MGO_ACRE_ENAB
	class MGO_AcreEnabled {
		title = "     ACRE Connect:";
		values[] = {0,1};
		default = 1;
		texts[] = {"Disabled", "Enabled"};
	};
	class MGO_AcreSlots {
		title = "     ACRE Required Slots:";
		values[] = {0,1};
		default = 0;
		texts[] = {"Disabled", "Enabled"};
	};
#endif
#ifdef MGO_REPAIR_ENAB
	class MGO_RepairEnabled {
		title = "     Repair Points:";
		values[] = {0,1};
		default = 1;
		texts[] = {"Disabled", "Enabled"};
	};
	class MGO_RepairFactor {
		title = "          Repair Times:";
		values[] = {1,3,5,10,15};
		default = 10;
		texts[] = {"Immediate","Short", "Medium", "Long", "Very Long"};
	};
#endif
#ifdef MGO_RESTRICT_ENAB
	class MGO_RestrictEnabled {
		title = "     Restrict Vehicles:";
		values[] = {0,1};
		default = 1;
		texts[] = {"Disabled", "Enabled"};
	};
	class MGO_RestrictPilot {
		title = "          Check for pilot:";
		values[] = {0,1};
		default = 1;
		texts[] = {"No", "Yes"};
	};
	class MGO_RestrictAcre {
		title = "          Check for ACRE:";
		values[] = {0,1};
		default = 0;
		texts[] = {"No", "Yes"};
	};
#endif