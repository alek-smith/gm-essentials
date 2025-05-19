/**
  * @func enforce_bounds(value, [low], [high])
  * @desc Calls check_bounds on the specified arguments and throws an exception if
  * check_bounds returns false.
  * @param {Real} value the value to check
  * @param {Real,undefined} [low] the lower bound (def. NULL)
  * @param {Real,undefined} [high] the upper bound (def. NULL)
  * @return {Bool} Returns true if check_bounds returns true
  */
function enforce_bounds(value, low=NULL, high=NULL) {

	if (!check_bounds(value, low, high)) {
		throw new RuntimeException(EXC_INDEX_OUT_OF_BOUNDS, $"index {value} out of bounds for range [{low}, {high}]");
	}
	
	return true;

}