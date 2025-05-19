/**
 * @func
 * @desc Checks if the specified value is a method. If so, the method is returned, otherwise,
 * EXC_INVALID_ARGUMENT is thrown.
 * @param {any} m the value to check
 * @return {function}
 */
function enforce_method(m) {
	if (!is_method(m)) throw new RuntimeException(EXC_INVALID_ARGUMENT, $"expected method, got {typeof(m)}");
	return m;
}