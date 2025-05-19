/// @func struct_step(struct)
/// @desc Calls the step() function of the specified struct, if it has one.
///		  The step() function of a struct should be implemented when a struct
///		  must update every game step. If this function is called outside the step
///		  event, nothing happens, but a warning is printed to the output.
///		  Throws a StructException if the provided struct has no step() function.
/// @param {Struct} struct the struct to invoke step() on
/// @return {Any} Returns whatever the corresponding step() function would return
function struct_step(struct) {

	if (variable_struct_exists(struct, "step") && typeof(struct.step) == "method") {
		return struct.step();
	} else {
		throw new RuntimeException(EXC_STRUCT_NOT_STEPPABLE);
	}

}