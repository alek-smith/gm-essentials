/// @func string_token(str, delims)
/// @desc Tokens the specified string using the specified delimeters. The
///		  delimeters should be one string that contains every character that
///		  is to serve as a delimeter. If str is undefined, the function will
///		  continue to token the most recent string passed to it. Returns the next
///		  available token, or an empty string if there is nothing left to token.
///
///		  Works similarly to strtok() in C.
///
/// @param {string|undefined} str the string to token, or undefined to continue
///									tokening the most recent string
/// @param {string} delims a string containing every delimeter character. can differ
///						   between successive calls, even successive calls dealing with
///						   the same string
/// @return {string} Returns the next available token, or an empty string if there is nothing
///					 left to token
function string_token(str, delims) {
	
	static currentStr = "";
	static i = 1;
	if (str != NULL) { // reset
		currentStr = str;
		i = 1;
	}
	if (currentStr == NULL) { // first function call, undefined arg
		throw new RuntimeException(EXC_NULL_POINTER);
	}
	
	var token = "";
	
	while (string_contains_char(string_char_at(currentStr, i), delims)) i++; // skip any leading delims
	while (i <= string_length(currentStr) && !string_contains_char(string_char_at(currentStr, i), delims)) {
		token += string_char_at(currentStr, i++);
	}
	
	return token;

}