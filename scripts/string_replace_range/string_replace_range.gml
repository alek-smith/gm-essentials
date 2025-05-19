/**
  * @func string_replace_range(str, first, last, newstr)
  * @desc Replaces the characters within the specified range in str
  * with newstr, and returns the result.
  * @param {String} str the string to modify
  * @param {Real} first the start of the range of characters to replace
  * @param {Real} last the end of the range of characters to replace
  * @param {String} newstr the substring to replace the range with
  * @return {String} Returns the modified string
  */
function string_replace_range(str, first, last, newstr) {

	str = string_delete(str, first, last-first+1);
	return string_insert(newstr, str, first);

}