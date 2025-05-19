/// @func hex_string_to_real(str)
/// @desc Retrieves an Int64 from the specified hex string. Any occurances of
///		  0x, $, etc., are ignored. The hex string will be interpreted as
///		  big endian (left-most digit is most significant). Up to 8 bytes worth
///		  of data (16 nybbles) are supported.
/// @param {string} str the hex string to parse
/// @return {real} see description
function hex_string_to_real(str) {

	var num = int64(0);
	str = string_replace_all(str, "0x", "");
	str = string_replace_all(str, "$", "");
	str = string_replace_all(str, "#", "");
	var len = string_length(str);
	enforce_bounds(len, NULL, 16);
	
	var mask = 0;
	for (var i = 1; i <= len; i++) {
		var char = string_char_at(str, i);
		num = num << 4;
		if (ord(char) >= ord("0") && ord(char) <= ord("9")) {
			mask = real(char);
		} else {
			switch (char) {
				case "a": case "A": mask = 10; break;
				case "b": case "B": mask = 11; break;
				case "c": case "C": mask = 12; break;
				case "d": case "D": mask = 13; break;
				case "e": case "E": mask = 14; break;
				case "f": case "F": mask = 15; break;
				default: throw new RuntimeException(EXC_ILLEGAL_ARGUMENT, $"'{char}' is not a valid hexadecimal digit");
			}
		}
		num |= mask;
	}
	
	return num;

}