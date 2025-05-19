/**
 * @desc Returns the number of instances in the specified chunk in the global
 * ContentRepository. If the chunk doesn't exist, or the global ContentRepository
 * hasn't been initialized, -1 is returned.
 * @return {real}
 */
function content_chunk_instance_count(chunk) {

    if (!content_is_initialized()) {
        return -1;
    }
    
    var instanceList = ds_map_find_value(content_init.repo.instances, chunk);
    if (instanceList == NULL) {
        return -1;
    } else {
        return ds_list_size(instanceList);
    }
    
}