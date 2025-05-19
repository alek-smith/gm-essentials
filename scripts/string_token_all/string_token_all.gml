/// @func string_token_all(str, delims);
/// @desc Same as string_token(), except this function returns an array
///		  of all tokens (as defined by delims) in str. See the documentation
///		  of string_token for more information.
/// @param {string|undefined} str the string to token
/// @param {string} delims the delimeters
/// @return {array<string>} Returns an array of tokens extracted from str
function string_token_all(str, delims) {

	var arr = array_create(1); arr[0] = "";
	var val = string_token(str, delims);
	var count = 0;
	
	while (val != "") {
		if (count == array_length(arr)) {
			array_reallocate(arr);
		}
		arr[count++] = val;
		val = string_token(undefined, delims);
	}
	
	if (count < array_length(arr)) {
		array_resize(arr, count);
	}
	
	return arr;

}