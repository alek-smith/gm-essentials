/**
 * @func
 * @desc Checks if the specified value is numeric. If so, the value is returned, otherwise,
 * EXC_INVALID_ARGUMENT is thrown.
 * @param {any} n the value to check
 * @return {real}
 */
function enforce_numeric(n) {
	if (!is_numeric(n)) throw new RuntimeException(EXC_INVALID_ARGUMENT, $"expected a numeric type, got {typeof(n)}");
	return n;
}