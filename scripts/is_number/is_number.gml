/**
  * @func is_number(a)
  * @desc Returns true if the specified value is of any numerical data type (real, bool, int32, int64).
  * @param {Any} a the value
  * @return {Bool}
  */
function is_number(a) {

	return is_real(a) || is_bool(a) || is_int64(a) || is_int32(a);

}