/**
  * @desc Retrieves a content instance. If the global ContentRepository is not initialized, the
  * specified chunk does not exist, or the specified index is out of bounds, NULL is returned.
  * @param {string} chunk the instance's chunk
  * @param {real} index the instance's index
  * @return {struct|undefined}
  */
function content_get(chunk, index) {

    if (!content_is_initialized()) {
        return NULL;
    }
    if (!content_chunk_exists(chunk)) {
        return NULL;
    }
	if (!check_bounds(index, 0, content_chunk_instance_count(chunk)-1)) {
		return NULL;
	}
    
    var instanceList = ds_map_find_value(content_init.repo.instances, chunk);
    var instance = ds_list_find_value(instanceList, index);
    /// Feather ignore once GM1045
    return instance;
    
}