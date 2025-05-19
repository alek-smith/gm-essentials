/**
 * @desc Retrieves all content instances in the specified chunk.
 * @param {string} chunk the chunk name
 * @return {array|array<any>} what's the difference gamemaker ???????????????????
 */
function content_get_all(chunk) {

	if (!content_is_initialized()) {
		return [];
	}
	if (!content_chunk_exists(chunk)) {
		return [];
	}
	
	var list = ds_list_create();
	var count = content_chunk_instance_count(chunk);
	
	for (var i = 0; i < count; i++) {
		ds_list_add(list, content_get(chunk, i));
	}
	
	return ds_list_to_array(list);
	
}