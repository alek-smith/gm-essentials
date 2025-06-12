
#macro CONTENT_ERR_NOT_INITIALIZED -1
#macro CONTENT_ERR_JSON -2
#macro CONTENT_ERR_ENTITY_NOT_SPECIFIED -3
#macro CONTENT_ERR_NO_SUCH_ENTITY -4
#macro CONTENT_ERR_DATA_NOT_SPECIFIED -5
#macro CONTENT_ERR_MALFORMED_DATA -6
#macro CONTENT_ERR_MAPPER_FAILED -7

/**
 * @desc Loads a content instance into the specified chunk. The index of the
 * newly loaded intstance is returned, or a negative number if an error occured.
 * @param {string} chunk the name of the chunk
 * @param {string} path the file path of the instance
 * @return {real}
 */
function content_load(chunk, path) {

    if (!content_is_initialized()) {
        return CONTENT_ERR_NOT_INITIALIZED;
    }
    
    var schema = content_init.schema;
    var repo = content_init.repo;
    var json = json_parse_file("content/"+path);
    if (json == NULL) {
        return CONTENT_ERR_JSON;
    }
    var entity;
	try {
		entity = content_get_entity_info(json.type);
	} catch (e) {
		return CONTENT_ERR_ENTITY_NOT_SPECIFIED;
	}
	if (entity == NULL) {
		return CONTENT_ERR_NO_SUCH_ENTITY;
	}
    var prototype = entity.prototype;
    var dto;
	try {
		dto  = json.data;
	} catch (e) {
		return CONTENT_ERR_DATA_NOT_SPECIFIED;
	}
	if (!is_struct(dto)) {
		return CONTENT_ERR_MALFORMED_DATA;
	}
    var prototypeNames = struct_get_names(prototype);
    var mapper = entity.mapper;
    
    for (var i = 0; i < array_length(prototypeNames); i++) {
        var name = prototypeNames[i];
        if (!struct_exists(dto, name)) {
            dto[$ name] = prototype[$ name];
        }
    }
    
    if (!ds_map_exists(repo.instances, chunk)) {
        ds_map_add(repo.instances, chunk, ds_list_create());
        ds_list_add(repo.chunkNames, chunk);
    }
	
    var instanceCount = content_chunk_instance_count(chunk);
    var instance;
	try {
		instance = mapper(dto);
	} catch (e) {
		return CONTENT_ERR_MAPPER_FAILED;
	}
    var instanceList = ds_map_find_value(repo.instances, chunk);
    ds_list_add(instanceList, instance);
    
    return instanceCount;
    
}