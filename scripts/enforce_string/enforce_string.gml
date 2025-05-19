/**
 * @func
 * @desc
 * @return {string}
 */
function enforce_string(str) {
	if (!is_string(str)) throw new RuntimeException(EXC_INVALID_ARGUMENT, $"expected string, got {typeof(str)}");
	return str;
}