/**
 * @desc Retrieves a list of entity names.
 * @return {array<string>}
 */
function content_get_entity_names() {

    if (!content_is_initialized()) {
        return [];
    } else {
        return struct_get_names(content_init.schema.entities);
    }
    
}