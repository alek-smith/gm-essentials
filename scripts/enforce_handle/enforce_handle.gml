/**
 * @func
 * @desc
 * @return {id}
 */
function enforce_handle(h) {
	if (!is_handle(h)) throw new RuntimeException(EXC_INVALID_ARGUMENT, $"expected ref, got {typeof(h)}");
	return h;
}