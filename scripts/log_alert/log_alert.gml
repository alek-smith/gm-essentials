/**
 * @func log_alert(msg)
 * @desc Logs an ALERT message.
 */
function log_alert(msg) {
	
	var lmsg = new LogMessage(LOGLEVEL.ALERT, msg);
	ds_list_add(LogMessage.list, lmsg);
	show_debug_message(lmsg);

}