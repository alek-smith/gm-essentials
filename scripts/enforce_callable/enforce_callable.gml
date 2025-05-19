/**
 * @func
 * @desc Checks if the specified value is callable. If so, the callable is returned, otherwise,
 * EXC_INVALID_ARGUMENT is thrown.
 * @param {any} call the value to check
 * @return {function}
 */
function enforce_callable(call) {
	if (!is_callable(call)) throw new RuntimeException(EXC_INVALID_ARGUMENT, $"got {typeof(call)}, which is not callable");
	return call;
}