/**
 * @func
 * @desc
 * @param {any} arr
 * @return {array<any>}
 */
function enforce_array(arr, permitUndef=false) {
	if (permitUndef) {
		if (!is_array(arr) && !is_undefined(arr)) {
			throw new RuntimeException(EXC_INVALID_ARGUMENT, $"expected array, got {typeof(arr)}");
		}
	} else {
		if (!is_array(arr)) {
			throw new RuntimeException(EXC_INVALID_ARGUMENT, $"expected array, got {typeof(arr)}");
		}
	}
	
	return arr;

}