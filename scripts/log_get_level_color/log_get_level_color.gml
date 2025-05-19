/**
 * @func log_get_level_color(level)
 * @desc Returns a color representing the given log level, or 0 if the given
 * level is invalid.
 * @param {real} level the log level (use LOGLEVEL)
 * @return {real|constant.Color}
 */
function log_get_level_color(level) {

	switch (level) {
		
		case LOGLEVEL.INFO: return c_white;
		case LOGLEVEL.WARN: return c_yellow;
		case LOGLEVEL.ALERT: return #ff3f3f;
		case LOGLEVEL.FATAL: return color16_get(12);
		case LOGLEVEL.DEBUG: return color16_get(11);
		default: return #000000;
		
	}

}