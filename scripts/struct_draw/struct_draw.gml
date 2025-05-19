/// @func struct_draw(struct)
/// @desc Calls the draw() function of the specified struct, if it has one.
///		  The draw() function of a struct should be implemented when the struct must
///		  draw something to the screen. If this function is called outside the draw event,
///		  no drawing occurs, and a warning is printed to the output.
///		  Throws a StructException if the provided struct has no draw() function.
/// @param {Struct} struct the struct to invoke draw() on
/// @return {Any} Returns whatever the corresponding draw() function would return
function struct_draw(struct, x, y) {

	if (event_type != ev_draw) {
		show_debug_message("WARNING: struct_draw() called from outside draw event");
		return -1;
	}

	if (variable_struct_exists(struct, "draw") && typeof(struct.draw) == "method") {
		return struct.draw(x, y);
	} else {
		throw new RuntimeException(EXC_STRUCT_NOT_DRAWABLE);
	}

}