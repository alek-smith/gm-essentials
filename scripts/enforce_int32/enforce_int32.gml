/**
 * @func
 * @desc
 * @return {real}
 */
function enforce_int32(i) {
	if (!is_int32(i)) throw new RuntimeException(EXC_INVALID_ARGUMENT, $"expected int32, got {typeof(i)}");
	return i;
}