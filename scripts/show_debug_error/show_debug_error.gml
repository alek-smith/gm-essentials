/// @func show_debug_error(e)
/// @desc Prints an exception message and stacktrace to the compiler output.
/// @param {struct.Exception} e the exception
function show_debug_error(e) {

	show_debug_message(date_datetime_filename()+"\n");
	show_debug_message(e.message+"\n");
	array_foreach(e.stacktrace, function(value, index) {
		show_debug_message(value+"\n");
		return true;
	});

}