/// @func string_leading_zeroes(num, digits)
/// @desc Returns a string representation of the specified
///		  Real that fills in exactly the amount of specified
///		  digits. If num < digits, the string will be filled
///		  up with leading zeroes. If num > digits, leftover digits
///		  in num will be cut off.
/// @param {real} num the number to format
/// @param {real} digits the number of digits in the formatting
/// @return {string} Returns the formatted string
///
function string_leading_zeroes(num, digits) {

	enforce_numeric(num);
	enforce_numeric(digits);
	enforce_bounds(digits, 0, NULL);
	
	num = floor(num);
	digits = floor(digits);
	var str = "";
	
	for (var i = 1; i < power(10, digits); i *= 10) {
		var value = floor((num % (i*10)) / i);
		str = string_insert(string(value), str, 0);
	}
	
	return str;
	
}