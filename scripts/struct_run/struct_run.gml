/// @func struct_run(struct)
/// @desc Calls the run() function of the specified struct, if it has one.
///		  The run() function of a struct should be implemented as general use
///		  code. It is meant to be called when a user-defined event occurs.
///		  Throws a StructException if the provided struct has no run() function.
/// @param {Struct} struct the struct to invoke run() on
function struct_run(struct) {

	if (variable_struct_exists(struct, "run") && typeof(struct.run) == "method") {
		return struct.run();
	} else {
		throw new RuntimeException(EXC_STRUCT_NOT_RUNNABLE);
	}

}