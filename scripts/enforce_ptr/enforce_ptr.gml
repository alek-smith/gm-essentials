/**
 * @func
 * @desc Checks if the specified value is a pointer. If so, the pointer is returned, otherwise,
 * EXC_INVALID_ARGUMENT is thrown.
 * @return {pointer}
 */
function enforce_ptr(p) {
	if (!is_ptr(p)) throw new RuntimeException(EXC_INVALID_ARGUMENT, $"expected ptr, got {typeof(p)}");
	return p;
}