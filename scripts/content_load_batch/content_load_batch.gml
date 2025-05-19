/**
 * @desc Loads multiple content instances into the specified chunk. The index of
 * the last instance created is returned if successful, otherwise a negative
 * number is returned.
 * @param {string} chunk the name of the chunk
 * @param {string} path the file path of the instance
 * @return {real}
 */
function content_load_batch(chunk, path) {

    if (!content_is_initialized()) {
        return -1;
    }
    
    var schema = content_init.schema;
    var repo = content_init.repo;
    var json = json_parse_file("content/"+path);
    if (json == NULL) {
        return -2;
    }
    var entity = content_get_entity_info(json.type);
    var prototype = entity.prototype;
    var dtoArray = json.data;
    var prototypeNames = struct_get_names(prototype);
    var mapper = entity.mapper;
    
	for (var i = 0; i < array_length(dtoArray); i++) {
		var dto = dtoArray[i];
	    for (var p = 0; p < array_length(prototypeNames); p++) {
	        var name = prototypeNames[p];
	        if (!struct_exists(dto, name)) {
	            dto[$ name] = prototype[$ name];
	        }
	    }
	}
    
    if (!ds_map_exists(repo.instances, chunk)) {
        ds_map_add(repo.instances, chunk, ds_list_create());
        ds_list_add(repo.chunkNames, chunk);
    }
	
	var instanceList = ds_map_find_value(repo.instances, chunk);
	for (var i = 0; i < array_length(dtoArray); i++) {
		var dto = dtoArray[i];
	    var instance = mapper(dto);
	    ds_list_add(instanceList, instance);
	}
    
    return content_chunk_instance_count(chunk) - 1;
    
}