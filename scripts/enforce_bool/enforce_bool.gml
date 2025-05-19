/**
 * @func
 * @desc Checks if the specified value is a boolean. If so, the boolean is returned, otherwise,
 * EXC_INVALID_ARGUMENT is thrown.
 * @param {any} b the value to check
 * @return {bool}
 */
function enforce_bool(b) {
	if (!is_bool(b)) throw new RuntimeException(EXC_INVALID_ARGUMENT, $"expected bool, got {typeof(b)}");
	return b;
}