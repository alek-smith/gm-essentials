/**
 * @func
 * @desc Checks if the specified value is a real number. If so, the real number is returned, otherwise,
 * EXC_INVALID_ARGUMENT is thrown.
 * @param {any} r the value to check
 * @return {real}
 */
function enforce_real(r) {
	if (!is_real(r)) throw new RuntimeException(EXC_INVALID_ARGUMENT, $"expected number, got {typeof(r)}");
	return r;
}