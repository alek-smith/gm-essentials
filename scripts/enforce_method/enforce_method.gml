/**
 * @func
 * @desc
 * @return {function}
 */
function enforce_method(m) {
	if (!is_method(m)) throw new RuntimeException(EXC_INVALID_ARGUMENT, $"expected method, got {typeof(m)}");
	return m;
}