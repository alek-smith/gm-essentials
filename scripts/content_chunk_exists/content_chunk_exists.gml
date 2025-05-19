/**
 * @desc Checks if the specified chunk exists in the global ContentRepository.
 * @return {bool}
 */
function content_chunk_exists(chunk) {

    if (!content_is_initialized()) {
        return false;
    }
    return ds_map_exists(content_init.repo.instances, chunk);
    
}