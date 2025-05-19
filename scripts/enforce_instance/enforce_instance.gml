/// @func enforce_instance(inst, object)
/// @desc Test whether or not the supplied instance is an instance
///		  of the specified object asset, or an instance of a parent
///		  of the specified object asset. This function will continue
///		  continue up the object hierarchy until either a match is
///		  found or the top of the hierarchy is reached without finding
///		  a match. In the latter case, EXC_ILLEGAL_CONTEXT is
///		  thrown based on the assumption that this function is being
///		  used to test for function arguments, initialization structs, etc.
/// @param {id.Instance} inst the instance to test
/// @param {asset.GMObject} object the object to check for instantiation
/// @param {bool} [permitUndef] if true, undefined values will still pass the test
///								(def. false)
/// @return {id.Instance|undefined} Returns the instance passed in for easy use of Feather's typing system
function enforce_instance(inst, object=NULL, permitUndef=false) {
	
	if (permitUndef && is_undefined(inst)) return inst; // inst is NULL and NULL is allowed
	if (typeof(inst) == "ref" && object == NULL) {
		return inst;
	} else if (typeof(inst) == "ref" && object != NULL) {
		var i = inst;
		var io = inst.object_index;
		var o = object;
	
		while (io > -1) {
			if (io != o) {
				io = object_get_parent(io);
			} else {
				return inst;
			}
		}
		throw new RuntimeException(EXC_INVALID_ARGUMENT, $"expected instance of {object_get_name(object)}," +
			$"got instance of {object_get_name(inst.object_index)}");
	}
	throw new RuntimeException(EXC_INVALID_ARGUMENT, $"expected ref, got {typeof(inst)}");

}