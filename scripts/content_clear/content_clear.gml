/**
 * @desc Clears the global ContentRepository. If the GlobalRepository has not been initialized,
 * this function does nothing.
 */
function content_clear() {

	if (content_is_initialized()) {
		delete content_init.schema;
		delete content_init.repo;
		content_init.schema = NULL;
		content_init.repo = NULL;
	}
	
}