/**
 * @desc Copies characters from the specified string and index until the next occurance of
 * the specified delimeter character. If no such character exists, this function copies until
 * the end of the string is reached, or throws an exception if `crashOnFalloff` is set to `true`.
 * The delimeter is not included in the copied string by default unless `includeDelim` is set to
 * `true`.
 * @param {string} str the string to copy from
 * @param {real} index the index into the string to begin copying
 * @param {string} delim the **single-character** delimeter to check for
 * @param {bool} [includeDelim] whether or not to include the delimeter character in the copied string
 * @param {bool} [crashOnFalloff] whether or not to throw an exception if the delimeter character couldn't be found
 */
function string_copy_until(str, index, delim, includeDelim=false, crashOnFalloff=false) {
	
	enforce_string(str);
	enforce_bounds(index, 1, string_length(str));
	enforce_string(delim);
	if (string_length(delim) != 1) {
		throw new RuntimeException(EXC_ILLEGAL_ARGUMENT, "delimeter must be a single character");
	}
	enforce_bool(includeDelim);
	enforce_bool(crashOnFalloff);
	
	var delimIndex = -1;
	
	for (var i = index+1; i <= string_length(str); i++) {
		var curr = string_char_at(str, i);
		if (curr == delim) {
			delimIndex = i;
			break;
		}
	}
	
	var copy;
	if (delimIndex == -1 && crashOnFalloff) {
		throw new RuntimeException(EXC_ILLEGAL_ARGUMENT, "unexpected end of string");
	} else if (delimIndex == -1) {
		copy = string_copy(str, index, string_length(str)-index+1);
	} else {
		var add = includeDelim ? 1 : 0;
		copy = string_copy(str, index, delimIndex-index+add);
	}
	
	return copy;
	
}