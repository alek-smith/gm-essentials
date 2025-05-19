/**
 * @func
 * @desc Checks if the specified value is a handle. If so, the handle is returned, otherwise,
 * EXC_INVALID_ARGUMENT is thrown.
 * @param {any} h the value to check
 * @return {id}
 */
function enforce_handle(h) {
	if (!is_handle(h)) throw new RuntimeException(EXC_INVALID_ARGUMENT, $"expected ref, got {typeof(h)}");
	return h;
}