/**
 * @func
 * @desc Checks if the specified value is an int64. If so, the int64 is returned, otherwise,
 * EXC_INVALID_ARGUMENT is thrown.
 * @param {any} i the value to check
 * @return {real}
 */
function enforce_int64(i) {
	if (!is_int64(i)) throw new RuntimeException(EXC_INVALID_ARGUMENT, $"expected int64, got {typeof(i)}");
	return i;
}