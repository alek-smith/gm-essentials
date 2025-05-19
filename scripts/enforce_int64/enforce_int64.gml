/**
 * @func
 * @desc
 * @return {real}
 */
function enforce_int64(i) {
	if (!is_int64(i)) throw new RuntimeException(EXC_INVALID_ARGUMENT, $"expected int64, got {typeof(i)}");
	return i;
}