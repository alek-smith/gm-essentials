/**
 * @desc Parses a JSON file into a collection of arrays and structs.
 * @return {any}
 */
function json_parse_file(file) {

    var buf = buffer_load(file);
    if (buf < 0) {
        return NULL;
    }
    
    var json = buffer_read_string(buf);
    var s = json_parse(json);
    buffer_delete(buf);
    return s;
    
}