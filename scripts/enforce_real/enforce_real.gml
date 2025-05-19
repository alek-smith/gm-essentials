/**
 * @func
 * @desc
 * @return {real}
 */
function enforce_real(r) {
	if (!is_real(r)) throw new RuntimeException(EXC_INVALID_ARGUMENT, $"expected number, got {typeof(r)}");
	return r;
}