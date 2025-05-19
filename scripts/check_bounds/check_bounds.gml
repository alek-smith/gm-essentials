/// @func check_bounds(value, [low], [high])
/// @desc Checks whether or not the specified value falls within
///		  the specified bounds, inclusive. If high < low, this always
///		  returns false. A NULL value for either bound is permitted and
///		  represents an unbounded range of values in either direction.
///	@param {real} value the value to check
/// @param {real,undefined} [low] the lower bound, NULL means unbounded (def. NULL)
/// @param {real,undefined} [high] the upper bound, NULL means unbounded (def. NULL)
/// @return {bool} Returns true if the value falls within the bounds, false otherwise
function check_bounds(value, low=NULL, high=NULL) {
	
	if (low == NULL && high == NULL) {
		return true;
	} else if (low == NULL && high != NULL) {
		return value <= high;
	} else if (low != NULL && high == NULL) {
		return value >= low;
	} else {
		return value >= low && value <= high;
	}
	
	// TODO optimize a little more
	
}