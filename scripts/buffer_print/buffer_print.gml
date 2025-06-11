/**
 * @desc Prints the contents of the specified buffer to the debug console.
 * This does not affect the buffer's seek position.
 */
function buffer_print(buf) {

	var mark = buffer_tell(buf);
	var size = buffer_get_size(buf);
	var lineBuffer = buffer_create(52, buffer_fixed, 1);
	
	buffer_seek(buf, buffer_seek_start, 0);
	buffer_seek(lineBuffer, buffer_seek_start, 0);
	for (var i = 0; i < size; i++) {
		var b = buffer_read_ubyte(buf);
		var s = string_upper(hex_string(b, 2)) + " ";
		buffer_write_text(lineBuffer, s);
		if (i%16 == 7) {
			buffer_write_text(lineBuffer, "   ");
		}
		if (i%16 == 15) {
			buffer_write_ubyte(lineBuffer, 0);
			buffer_seek(lineBuffer, buffer_seek_start, 0);
			var line = buffer_read_string(lineBuffer);
			buffer_seek(lineBuffer, buffer_seek_start, 0);
			show_debug_message(line);
		}
	}
	
	if (buffer_tell(lineBuffer) > 0) { // get anything remaining
		buffer_write_ubyte(lineBuffer, 0);
		buffer_seek(lineBuffer, buffer_seek_start, 0);
		var line = buffer_read_string(lineBuffer);
		show_debug_message(line);
	}
	
	buffer_delete(lineBuffer);
	
}