/**
 * @func
 * @desc
 * @return {real}
 */
function enforce_numeric(n) {
	if (!is_numeric(n)) throw new RuntimeException(EXC_INVALID_ARGUMENT, $"expected a numeric type, got {typeof(n)}");
	return n;
}