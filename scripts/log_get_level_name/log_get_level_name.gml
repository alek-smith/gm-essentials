/**
 * @func log_get_level_name(level)
 * @desc Returns the name of the given log level, or an empty string if the given
 * level is invalid.
 * @param {real} level the log level (use LOGLEVEL)
 * @return {string}
 */
function log_get_level_name(level) {

	switch (level) {
		case LOGLEVEL.INFO: return "INFO";
		case LOGLEVEL.WARN: return "WARN";
		case LOGLEVEL.ALERT: return "ALERT";
		case LOGLEVEL.FATAL: return "FATAL";
		case LOGLEVEL.DEBUG: return "DEBUG";
		default: return "";
	}

}