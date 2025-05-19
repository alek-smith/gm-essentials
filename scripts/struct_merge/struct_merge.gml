/// @func struct_merge(s1, s2)
/// @desc Merges the two structs and returns the resulting new struct. Members of both s1
///		  and s2 will become members of the new struct. If there are identically-named members
///		  in both s1 and s2, the value from s2 is prioritized. If one of either s1 or s2 are an
///		  instance of a constructor, but the other is not, the new struct will become an instance
///		  of said constructor. If both s1 and s2 are instances of different constructors, the
///		  constructor of s2 is prioritized.
/// @param {Struct} s1 the first struct
/// @param {Struct} s2 the second struct
/// @return {Struct} Returns a new struct that is s1 and s2 merged
///
/// Feather ignore GM2022
function struct_merge(s1, s2) {

	var s3 = {};
	
	var static1 = static_get(s1);
	var static2 = static_get(s2);
	if (is_undefined(static2) && !is_undefined(static1)) { // s1 instanceof nothing, s2 instanceof constructor
		static_set(s3, static1);
	} else {
		static_set(s3, static2);
	}
	
	var m1 = variable_struct_get_names(s1);
	var m2 = variable_struct_get_names(s2);
	for (var i = 0; i < array_length(m1); i++) {
		variable_struct_set(s3, m1[i], variable_struct_get(s1, m1[i]));
	}
	for (var i = 0; i < array_length(m2); i++) {
		variable_struct_set(s3, m2[i], variable_struct_get(s2, m2[i]));
	}

	return s3;

}