/**
 * @func
 * @desc Checks if the specified value is an int32. If so, the int32 is returned, otherwise,
 * EXC_INVALID_ARGUMENT is thrown.
 * @param {any} i the value to check
 * @return {real}
 */
function enforce_int32(i) {
	if (!is_int32(i)) throw new RuntimeException(EXC_INVALID_ARGUMENT, $"expected int32, got {typeof(i)}");
	return i;
}