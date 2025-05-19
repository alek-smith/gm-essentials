/**
 * @func
 * @desc
 * @return {pointer}
 */
function enforce_ptr(p) {
	if (!is_ptr(p)) throw new RuntimeException(EXC_INVALID_ARGUMENT, $"expected ptr, got {typeof(p)}");
	return p;
}