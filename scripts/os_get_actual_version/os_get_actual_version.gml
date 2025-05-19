/**
 * @func os_get_actual_version()
 * @desc Retrieves the actual version number of the OS instead of the encoded
 * version number used by os_version. If an actual version number cannot be
 * determined, then string(os_version) is returned as a fallback.
 * @return {string}
 */
function os_get_actual_version() {

	var ver = int64(os_version);
	var major;
	var minor;
	var build;

	switch (os_type) {
		
		case os_windows:
		major = (ver >> 16) & 0xff;
		minor = ver & 0xffff;
		return $"{major}.{minor}";
		
		case os_macosx:
		case os_ios:
		major = (ver >> 24) & 0xff;
		minor = (ver >> 12) & 0xfff;
		build = ver & 0xfff;
		
		default:
		return string(os_version);
		
	}

}