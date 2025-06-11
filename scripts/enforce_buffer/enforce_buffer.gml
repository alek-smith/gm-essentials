/**
 * @desc Checks if the specified value is a valid buffer handle. If so, the handle is returned,
 * otherwise, EXC_INVALID_ARGUMENT is thrown.
 * @param {any} buf the value to check
 * @return {id.Buffer}
 */
function enforce_buffer(buf) {

	enforce_handle(buf);
	if (!buffer_exists(buf)) {
		throw new RuntimeException(EXC_INVALID_ARGUMENT, $"{buf} is not a valid buffer");
	}
	return buf;
	
}