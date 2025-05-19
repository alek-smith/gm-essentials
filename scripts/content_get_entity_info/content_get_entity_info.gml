/**
 * @desc Retrieves information about the specified content entity, or NULL if the
 * entity does not exist or the content repository has not been initialized.
 * @param {string} entityName the name of the entity
 * @return {struct.ContentEntity}
 */
function content_get_entity_info(entityName) {

    if (!content_is_initialized()) {
        return NULL;
    }
    
    var schema = content_init.schema;
    var entity = schema.entities[$ entityName];
    
    /// Feather ignore once GM1045
    return variable_clone(entity);
    
}