/**
 * @func
 * @desc Checks if the specified value is a string. If so, the string is returned, otherwise,
 * EXC_INVALID_ARGUMENT is thrown.
 * @param {any} str the value to check
 * @return {string}
 */
function enforce_string(str) {
	if (!is_string(str)) throw new RuntimeException(EXC_INVALID_ARGUMENT, $"expected string, got {typeof(str)}");
	return str;
}