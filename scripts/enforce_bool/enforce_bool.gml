/**
 * @func
 * @desc
 * @return {bool}
 */
function enforce_bool(b) {
	if (!is_bool(b)) throw new RuntimeException(EXC_INVALID_ARGUMENT, $"expected bool, got {typeof(b)}");
	return b;
}