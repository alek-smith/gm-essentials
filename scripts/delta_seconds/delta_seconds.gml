/**
 * @func delta_seconds()
 * @desc Retrieves delta_time in seconds instead of microseconds.
 * @return {real}
 */
function delta_seconds() {
	return delta_time / 1000000;
}