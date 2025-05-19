/**
 * @func
 * @desc Checks if the specified value is NULL (undefined). If so, NULL is returned, otherwise,
 * EXC_INVALID_ARGUMENT is thrown.
 * @param {any} und the value to check
 * @return {undefined}
 */
function enforce_undefined(und) {
	if (!is_undefined(und)) throw new RuntimeException(EXC_INVALID_ARGUMENT, $"expected undefined, got {typeof(und)}");
	return und;
}