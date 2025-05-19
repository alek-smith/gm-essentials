/**
 * @func log_get_messages()
 * @desc Retrieves the handle for the list of log messages.
 * @return {id.DsList}
 */
function log_get_messages() {

	var st = static_get(LogMessage);
	var list = st[$ "list"];
	
	if (list == NULL) {
		LogMessage.list = ds_list_create();
		list = LogMessage.list;
	}
	
	return list;

}