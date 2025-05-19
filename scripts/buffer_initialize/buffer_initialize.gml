/**
 * @desc Initializes the specified buffer with all zeroes.
 * @param {id.Buffer} buf the buffer
 */
function buffer_initialize(buf) {
    
    buffer_fill(buf, 0, buffer_u8, 0, buffer_get_size(buf));
    
}