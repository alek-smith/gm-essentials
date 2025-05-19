/**
 * @func enforce_struct(ref, [con], [permitUndef])
 * @desc Checks if the specified variable is a struct, and possibly whether or not
 * it's an instance of the specified constructor.
 * @param {any} ref the variable to check
 * @param {function} [con] the constructor to check, or undefined for no constructor (def. undefined)
 * @param {bool} [permitUndef] whether or not an undefined variable will pass the check or not
 * @return {struct}
 */
function enforce_struct(ref, con=NULL, permitUndef=false) {
	
	if (is_undefined(ref) && !permitUndef) { // ref is NULL, which is not allowed
		throw new RuntimeException(EXC_NULL_POINTER);
	} else if (is_struct(ref) && con != NULL && !is_instanceof(ref, con)) { // ref is a struct, but not an instance of con
		throw new RuntimeException(EXC_BAD_CONSTRUCTOR_TYPE, $"expected instance of {script_get_name(con)}");
	} else if (!is_struct(ref)) { // ref is not a struct
		throw new RuntimeException(EXC_INVALID_ARGUMENT, $"expected struct, got {typeof(ref)}");
	}
	
	return ref;
	
}