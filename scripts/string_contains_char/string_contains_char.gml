/// @func string_contains_char(str, chars)
/// @desc Checks if string str contains ANY character in string chars.
///		  Earlier characters in chars take priority. Returns the index
///		  of the first found index of a character in chars, or 0 if none
///		  of the characters could be found.
/// @param {string} str the string to check
/// @param {string} chars the character set to check for
/// @return {real} Returns the index of the first found index of a character
///				   in chars, or 0 if none of the characters could be found
function string_contains_char(str, chars) {

	for (var i = 1; i <= string_length(str); i++) {
		for (var j = 1; j <= string_length(chars); j++) {
			if (string_char_at(str, i) == string_char_at(chars, j)) {
				return i;
			}
		}
	}
	
	return 0;

}