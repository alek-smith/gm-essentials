/// @func string_append(substr, str)
/// @desc Appends the specified substring to the end of the specified
///		  string.
/// @param {string} substr the substring to append
/// @param {string} str the string to append to
/// @return {string} Returns str with substr appended to the end
///
function string_append(substr, str) {

	enforce_string(substr);
	enforce_string(str);
			
	return string_insert(substr, str, string_length(str)+1);

}