/// @func char_is_whitespace(char)
/// @desc Determines whether the specified character (string of length 1) is
///		  considered white-space by the engine.
/// @param {string|real} char the character to check (as a string or code point)
/// @return {bool} Returns true if char is white-space, false otherwise
function char_is_whitespace(char) {
			
	return (char == " "  || // space
			char == ord(" ") ||
			char == "\n" || // line feed
			char == ord("\n") ||
			char == "\r" || // carriage return
			char == ord("\r") ||
			char == "\t" || // character tab
			char == ord("\t") ||
			char == "\v" || // line lab
			char == ord("\v") ||
			char == "\f" || // form feed
			char == ord("\f")
			);

}