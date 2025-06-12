/**
 * @desc Initializes the global ContentRepository. This function does nothing on subsequent calls.
 * By default, the ContentRepository will have no chunks or entities, but will have defined schema.
 * @param {string} schemaFile the location of the schema file
 */
function content_init(schemaFile) {
    
    static schema = NULL;
    static repo = NULL;
    
    if (schema != NULL) {
        return;
    }
    
    // load schema
    schema = json_parse_file(schemaFile);
    if (schema == NULL) {
        throw new RuntimeException(EXC_FILE_NOT_FOUND, $"schema file \"{schemaFile}\" not found");
    }
    repo = new ContentRepository();
    static_set(schema, static_get(ContentSchema));
    
    // process entities and their properties
    var entityNames;
	try {
		entityNames = struct_get_names(schema.entities);
	} catch (e) {
		throw new RuntimeException(EXC_MALFORMED_CONTENT_SCHEMA, "entities field is missing");
	}
	
    for (var i = 0; i < array_length(entityNames); i++) {
        var entity = schema.entities[$ entityNames[i]];
        var mapperIndex = asset_get_index(entity.mapper);
        if (mapperIndex < 0) {
            throw new RuntimeException(EXC_ELEMENT_NOT_FOUND, $"script \"{entity.mapper}\" does not exist");
        } else {
            entity.mapper = mapperIndex;
        }
        static_set(entity, static_get(ContentEntityType));
    }
    
}