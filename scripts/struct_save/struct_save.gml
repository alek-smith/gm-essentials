/// @func struct_save(struct, buffer)
/// @desc Calls the save(buffer) function of the specified struct, if it has one.
///		  The save(buffer) function of a struct should be implemented when the data
///		  of the struct should be saved to a file. It is implied that the supplied
///		  buffer will eventually be written to a file. The save(buffer) function should
///		  be complementary to the load(buffer) function. That is, data produced by struct.save()
///		  should be able to be processed by struct.load() and produce an identical struct.
///		  This should not be confused for a general use serialization function.
///		  Throws a StructException if the provided struct has no save() function.
/// @param {Struct} struct the struct to invoke save(buffer) on
/// @param {Id.Buffer} buffer the buffer to write data to
function struct_save(struct, buffer) {
	
	if (variable_struct_exists(struct, "save") && typeof(struct.save) == "method") {
		return struct.save(buffer);
	} else {
		throw new RuntimeException(EXC_STRUCT_NOT_SAVEABLE);
	}
	
}