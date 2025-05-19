/**
 * @func log_info(msg)
 * @desc Logs an INFO message.
 */
function log_info(msg) {

	var lmsg = new LogMessage(LOGLEVEL.INFO, msg);
	ds_list_add(LogMessage.list, lmsg);
	show_debug_message(lmsg);

}