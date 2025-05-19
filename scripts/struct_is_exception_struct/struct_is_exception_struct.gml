/**
 * @desc Checks if the specified struct is a GameMaker Exception struct. This is
 * done by checking the struct's fields and the types of their values.
 * @param {struct.Exception} e
 */
function struct_is_exception_struct(e) {
	
	if (!struct_exists(e, "line") || !is_real(e[$ "line"])) return false;
	if (!struct_exists(e, "message") || !is_string(e[$ "message"])) return false;
	if (!struct_exists(e, "longMessage") || !is_string(e[$ "longMessage"])) return false;
	if (!struct_exists(e, "script") || !is_string(e[$ "script"])) return false;
	if (!struct_exists(e, "stacktrace") || !is_array(e[$ "stacktrace"])) return false;
		
	return true;

}