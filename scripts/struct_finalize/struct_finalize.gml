/// @func struct_finalize(struct)
/// @desc Calls finalize() on the specified struct, if it has a finalize() function,
///		  The finalize() function
///		  of a struct should be implemented when a struct has overhead resources attached
///		  to it, such as built-in data structures, that would not be garbage collected
///		  automatically upon the struct's deletion.
/// @param {Struct} struct the struct to delete
/// @return {Any} Returns whatever the corresponding finalize() function would return,
///				  or -1 if no finalize() function exists in this struct. Regardless of
///				  return value, any valid struct will still be deleted.
function struct_finalize(struct) {

	var r = -1;

	if (variable_struct_exists(struct, "finalize") && typeof(struct.finalize) == "method") {
		r = struct.finalize();
	}
	
	delete struct;
	return r;

}