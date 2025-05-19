/**
 * @func scope_get()
 * @desc Returns a string representation of the current scope.
 * @return {string}
 */
function scope_get() {

	var type = instanceof(self);
	
	if (type == "instance") {
		return $"{self.id} ({object_get_name(self.object_index)})";
	} else if (type == "struct") {
		return "<anonymous struct>";
	} else {
		return type;
	}

}