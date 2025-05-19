/// @func struct_copy(s)
/// @deprecated This function has been superseded by the variable_clone function implemented
///				by the engine.
/// @desc Creates a deep copy of the specified struct. If the struct is an instance
///		  of a constructor, the new struct also becomes an instance of the constructor.
///		  Note that data structures such as strings and other structs are copied by reference,
///		  not by value.
/// @param {Struct} s the struct to copy
/// @return {Struct} Returns a deep copy of the specified struct
/// Feather ignore GM2022
function struct_copy(s) {
	
	enforce_struct(s);
	
	var s1 = s;
	var s2 = {};
	var s1names = variable_struct_get_names(s1);
	
	for (var i = 0; i < array_length(s1names); i++) {
		variable_struct_set(s2, s1names[i], variable_struct_get(s1, s1names[i]));
	}
	static_set(s2, static_get(s1));
	
	return s2;

}