/**
  * @func os_get_name()
  * @desc Retrieves the name of the OS that the game is running on.
  * @return {String} Returns the name
  */
/// @return {string}
function os_get_name() {

	static map = os_name_build_map();
	return ds_map_find_value(map, os_type);

}

/**
  * @func os_name_build_map()
  * @desc Builds a ds_map of OS constants to their OS names.
  * @return {Id.DsMap<String, Constant.OsType>} Returns a ds_map
  */
function os_name_build_map() {
	
	var map = ds_map_create();
	ds_map_add(map, os_windows, "Windows");
	ds_map_add(map, os_uwp, "Universal Windows Platform");
	ds_map_add(map, os_macosx, "macOS X");
	ds_map_add(map, os_linux, "Linux");
	ds_map_add(map, os_gxgames, "GX.games");
	ds_map_add(map, os_ios, "iOS");
	ds_map_add(map, os_tvos, "Apple tvOS");
	ds_map_add(map, os_android, "Android");
	ds_map_add(map, os_winphone, "Windows Phone");
	ds_map_add(map, os_psvita, "Sony Playstation Vita");
	ds_map_add(map, os_ps3, "Sony Playstation 3");
	ds_map_add(map, os_ps4, "Sony Playstation 4");
	ds_map_add(map, os_ps5, "Sony Playstation 5");
	ds_map_add(map, os_xboxone, "Xbox One");
	ds_map_add(map, os_xboxseriesxs, "Xbox Series X/S");
	ds_map_add(map, os_gdk, "Xbox");
	ds_map_add(map, os_switch, "Nintendo Switch");
	ds_map_add(map, os_unknown, "Unknown");
	
	return map;
	
}