#ifdef MAP_ISHIMURA
#define USING_MAP_DATUM /datum/map/ishimura
#endif
//	#include "DeadSpace/job.dm"

/datum/map/ishimura
	name = "Ishimura"
	full_name = "USG Ishimura"
	path = "ishimura"
	station_levels = list(2,3,4,5,6)
	contact_levels = list(2,3,4,5,6,7)
	player_levels = list(2,3,4,5,6)
	sealed_levels = list(1,7)
	admin_levels = list(1)
	empty_levels = list()
	accessible_z_levels = list("2" = 1, "3" = 1, "4" = 1, "5" = 1, "6" = 1)

	using_shuttles = list(
		/datum/shuttle/autodock/ferry/mining_one,
		/datum/shuttle/autodock/ferry/mining_two,
		/datum/shuttle/autodock/ferry/supply/drone,
		/datum/shuttle/autodock/ferry/executive,
		/datum/shuttle/autodock/ferry/escape_pod/ishimurapod/escape_pod1,
		/datum/shuttle/autodock/ferry/escape_pod/ishimurapod/escape_pod2,
		/datum/shuttle/autodock/ferry/escape_pod/ishimurapod/escape_pod3,
		/datum/shuttle/autodock/ferry/escape_pod/ishimurapod/escape_pod4,
		/datum/shuttle/autodock/ferry/escape_pod/ishimurapod/escape_pod5,
		/datum/shuttle/autodock/ferry/escape_pod/ishimurapod/escape_pod6,
		/datum/shuttle/autodock/ferry/escape_pod/ishimurapod/escape_pod7,
		/datum/shuttle/autodock/ferry/escape_pod/ishimurapod/escape_pod8,
		/datum/shuttle/autodock/ferry/escape_pod/ishimurapod/escape_pod9,
		/datum/shuttle/autodock/multi/antag/deliverance,
		/datum/shuttle/autodock/multi/antag/kellion,
		/datum/shuttle/autodock/multi/antag/valor,
		/datum/shuttle/autodock/multi/tram,
	)

	local_currency_name = "credits"
	station_networks = list(
		NETWORK_CARGO,
		NETWORK_COMMAND,
		NETWORK_COMMON,
		NETWORK_CREW,
		NETWORK_ENGINEERING,
		NETWORK_MAINTENANCE,
		NETWORK_MEDICAL,
		NETWORK_MINE,
		NETWORK_RESEARCH,
		NETWORK_SECURITY
	)
	usable_email_tlds = list("cec.corp")
	map_admin_faxes = list("Earth Government Colonial Alliance Headquarters")

	station_name  = "USG Ishimura"
	station_short = "Ishimura"
	dock_name     = "Aegis VII"
	boss_name     = "Concordance Extraction Corporation"
	boss_short    = "CEC"
	company_name  = "EarthGov"
	company_short = "EarthGov"
	system_name = "Cygnus System"


	skybox_foreground_objects = list(/datum/skybox_foreground_object/aegis_vii)

/*
	base_floor_type = /turf/simulated/floor/reinforced/airless
	base_floor_area = /area/maintenance/exterior
*/
	post_round_safe_areas = list (
		/area/shuttle/escape_pod1/station,
		/area/shuttle/escape_pod2/station,
		/area/shuttle/escape_pod3/station,
		/area/shuttle/escape_pod4/station,
		/area/shuttle/escape_pod5/station,
		/area/shuttle/escape_pod6/station,
		/area/shuttle/escape_pod7/station,
		/area/shuttle/escape_pod8/station,
		/area/shuttle/escape_pod9/station,
		/area/ERT/deliverance,
		/area/ERT/kellion,
		/area/ERT/valor,
		/area/ERT/escapebase,
		/area/ishimura/lower/security/escape/adminshuttle
	)

	evac_controller_type = /datum/evacuation_controller/starship

	crew_objectives = list(/datum/crew_objective/ads)

	lobby_tracks = list(/music_track/ds13/twinkle,
/music_track/ds13/nicole,
/music_track/ds13/danik,
/music_track/ds13/pensive,
/music_track/ds13/rock,
/music_track/ds13/violin,
/music_track/ds13/unitology)

/turf/simulated/wall
	name = "bulkhead"

/turf/simulated/floor
	name = "bare deck"

/turf/simulated/floor/tiled
	name = "deck"

/decl/flooring/tiling
	name = "deck"