/**
 * @func log_warn(msg)
 * @desc Logs a WARN message.
 */
function log_warn(msg) {
	
	var lmsg = new LogMessage(LOGLEVEL.WARN, msg);
	ds_list_add(LogMessage.list, lmsg);
	show_debug_message(lmsg);
	
}