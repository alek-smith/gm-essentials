/**
 * @func log_fatal(msg)
 * @desc Logs a FATAL message.
 */
function log_fatal(msg) {
	
	var lmsg = new LogMessage(LOGLEVEL.FATAL, msg);
	ds_list_add(LogMessage.list, lmsg);
	show_debug_message(lmsg);

}