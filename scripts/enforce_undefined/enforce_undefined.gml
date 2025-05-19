/**
 * @func
 * @desc
 * @return {undefined}
 */
function enforce_undefined(und) {
	if (!is_undefined(und)) throw new RuntimeException(EXC_INVALID_ARGUMENT, $"expected undefined, got {typeof(und)}");
	return und;
}