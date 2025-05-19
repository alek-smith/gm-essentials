/**
 * @desc Returns true if the global ContentRepository is initialized, false otherwise.
 * @return {bool}
 */
function content_is_initialized() {

    var s = static_get(content_init);
    return struct_exists(s, nameof(schema)) && s[$ nameof(schema)] != NULL;
    
}