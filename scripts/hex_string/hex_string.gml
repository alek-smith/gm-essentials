/// @func hex_string(num)
/// @desc Returns a string representation of a real number
///		  in hexadecimal form. Only positive integers are
///		  accepted; decimal values will be floored and
///		  negative numbers will be underflowed.
/// @param {real} num the number to convert into a hex string
/// @param {real} [minDigits] the minimum number of digits to include in the string
/// @return {string} Returns the number in hex form as a string (prefixed by "0x")
///
function hex_string(num, minDigits=1) {

	enforce_bounds(minDigits, 1, NULL);

	num = int64(num);
	var buf = buffer_create(16, buffer_fixed, 1);
	buffer_seek(buf, buffer_seek_start, 15);
	
	for (var i = 0; i < 16; i++) {
		var digitValue = num & 0xf;
		var digitString = NULL;
		switch (digitValue) {
			case 10: digitString = "A"; break;
			case 11: digitString = "B"; break;
			case 12: digitString = "C"; break;
			case 13: digitString = "D"; break;
			case 14: digitString = "E"; break;
			case 15: digitString = "F"; break;
			default: digitString = string(digitValue); break;
		}
		buffer_write_ubyte(buf, ord(digitString));
		buffer_seek(buf, buffer_seek_relative, -2);
		num = num >> 4;
	}
	buffer_seek(buf, buffer_seek_end, 0);
	
	buffer_seek(buf, buffer_seek_relative, -minDigits);
	while (buffer_tell(buf) > 0 && buffer_peek_ubyte(buf, buffer_tell(buf)-1) != ord("0")) {
		buffer_seek(buf, buffer_seek_relative, -1);
	}
	
	var str = buffer_read(buf, buffer_text);
	
	buffer_delete(buf);
	return str;

}