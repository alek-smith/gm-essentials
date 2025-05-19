/**
 * @func log_debug(msg)
 * @desc Logs a DEBUG message.
 */
function log_debug(msg) {
	
	var lmsg = new LogMessage(LOGLEVEL.DEBUG, msg);
	ds_list_add(LogMessage.list, lmsg);
	show_debug_message(lmsg);

}