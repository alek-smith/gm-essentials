/**
  * @func bool_string(b)
  * @desc Interprets the specified real as a boolean, and returns a corresponding
  * string.
  * @param {Real} b the boolean
  * @return {String} Returns "true" if b == true, "false" otherwise
  */
/// @param {bool} b
/// @return {string}
function bool_string(b) {

	return b ? "true" : "false";

}