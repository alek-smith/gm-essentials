/**
 * @desc The singleton struct used for the global content repository. Stores chunks and the
 * entities within those chunks.
 */
function ContentRepository() constructor {

    chunkNames = ds_list_create();
    instances = ds_map_create();
    
}