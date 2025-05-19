/**
 * @func LogMessage(level, msg)
 * @desc Represents a logger message, with a log level, message, and timestamp.
 * @param {real} level the log level
 * @param {string} msg the message
 * @param {real} [timestamp] the timestamp for the message (def. date_current_datetime())
 */
function LogMessage(level, msg, timestamp=date_current_datetime()) constructor {

	static list = ds_list_create();

	self.level = level;
	self.msg = msg;
	self.timestamp = timestamp;

	static toString = function() {
		return $"[{date_datetime_string(timestamp)}] [{log_get_level_name(level)}] {msg}";
	}

}

enum LOGLEVEL {
	DEBUG,
	INFO,
	WARN,
	ALERT,
	FATAL
}