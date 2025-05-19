/**
 * @func RuntimeException(code, [msg])
 * @desc Represents a runtime exception.
 * @param {real} code a status code
 * @param {string} [msg] the explanation message
 */
function RuntimeException(code, msg="") constructor {

	self.code = code;
	self.msg = msg;
	
	if (code_is_compiled()) { // YYC doesn't provide a stacktrace for user-thrown exceptions
		var st = debug_get_callstack();
		var stackList = ds_list_create();
		self.stacktrace = array_create(array_length(st) - 2);
		for (var i = 1; i < array_length(st)-1; i++) {
			stacktrace[i-1] = st[i];
		}
	} else { // VM handles the stacktrace for us, so it's not needed in this case
		self.stacktrace = array_create(0);
	}
	
	static toString = function() {
		if (string_length(msg) > 0) {
			return $"0x{hex_string(code, 8)} ({msg})";
		} else {
			return $"0x{hex_string(code, 8)}";
		}
	}

}