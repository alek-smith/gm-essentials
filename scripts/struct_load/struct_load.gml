/// @func struct_load(struct, buffer)
/// @desc Calls the load(buffer) function of the specified struct, if it has one.
///		  The load(buffer) function of a struct should be implemented when the data
///		  of the struct can be loaded from a file. It is implied that the supplied
///		  buffer was itself loaded from a file. The load(buffer) function should be
///		  complementary to the save(buffer) function. That is, struct.load() can be
///		  called on data produced by struct.save() and result in an identical struct.
///		  This should not be confused for a general use deserialization function.
/// 	  Throws a StructException if the provided struct has no load() function.
/// @param {Struct} struct the struct to invoke load(buffer) on
/// @param {Id.Buffer} buffer the buffer to load data from
function struct_load(struct, buffer) {

	if (variable_struct_exists(struct, "load") && typeof(struct.load) == "method") {
		return struct.load(buffer);
	} else {
		throw new RuntimeException(EXC_STRUCT_NOT_LOADABLE);
	}

}