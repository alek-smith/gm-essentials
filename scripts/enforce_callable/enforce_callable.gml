/**
 * @func
 * @desc
 */
function enforce_callable(call) {
	if (!is_callable(call)) throw new RuntimeException(EXC_INVALID_ARGUMENT, $"got {typeof(call)}, which is not callable");
}