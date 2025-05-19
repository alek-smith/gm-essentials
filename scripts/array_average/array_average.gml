/// @func array_average(array)
/// @self array_average
/// @pure
/// @desc Computes the average of the values in the specified array.
/// @param {array<real>} array the array of real numbers to compute the average of
/// @param {real} [limit] if desired, binds the calculation to indeces [0, limit)
/// @return {real} Returns the average of the values in the arary (or partition of array)
function array_average(array, limit=0) {
	
	enforce_array(array);
	
	var arr = array;
	var len = 0;
	var sum = 0;
	var avg = 0;
	
	for (var i = 0; i < array_length(arr); i++) {
		sum += arr[i];
		len++;
		if (i == limit-1) i = array_length(arr);
	}
	
	avg = sum / len;
	
	return avg;
	
}