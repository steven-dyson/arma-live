_markers = [];

_markers = ((CAS_JDAM_tracker getVariable "CAS_JDAM_ao1_z1_activeGrids") + _markers);
_markers = ((CAS_JDAM_tracker getVariable "CAS_JDAM_ao1_z2_activeGrids") + _markers);
_markers = ((CAS_JDAM_tracker getVariable "CAS_JDAM_ao1_z3_activeGrids") + _markers);
_markers = ((CAS_JDAM_tracker getVariable "CAS_JDAM_ao1_z1_sectorList") + _markers);
_markers = ((CAS_JDAM_tracker getVariable "CAS_JDAM_mkrs") + _markers);

_z2SectorList = ["CAS_JDAM_ao1_z2_s1", "CAS_JDAM_ao1_z2_s2","CAS_JDAM_ao1_z2_s3","CAS_JDAM_ao1_z2_s4","CAS_JDAM_ao1_z2_s5"];
_z3SectorList = ["CAS_JDAM_ao1_z3_s1", "CAS_JDAM_ao1_z3_s2","CAS_JDAM_ao1_z3_s3","CAS_JDAM_ao1_z3_s4","CAS_JDAM_ao1_z3_s5"];

{

	_x setMarkerColor (getMarkerColor _x);

} forEach (_markers + _z2SectorList + _z3SectorList);