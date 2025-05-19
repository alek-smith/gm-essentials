/// @func color16_get(code)
/// @desc Gets the 24-bit color code corresponding to the provided
///		  16-color code. 0 is black, 1 is dark blue, 2 is green, 3 is teal,
///		  4 is maroon, 5 is purple, 6 is olive, 7 is gray, 8 is silver,
///		  9 is blue, A(10) is lime, B(11) is sky blue, C(12) is red,
///		  D(13) is magenta, E(14) is yellow, F(15) is white.
/// @param {real} code the 16-color code as a real (0-15) or string (0-9, A-F)
/// @return {real|constant.Color} Returns a 24-bit color code
function color16_get(code) {
	
	code &= 15;
	var val/*:int*/ = 127;
	if (code & 0b1000 > 0) val = 255;
	
	if (code == 8) {
		return make_color_rgb(0xcf, 0xcf, 0xcf);
	}
	
	var red/*:int*/ = ((code & 4) >> 2) * val;
	var blue/*:int*/ = ((code & 2) >> 1) * val;
	var green/*:int*/ = ((code & 1)) * val;
	return make_color_rgb(red, blue, green);

}