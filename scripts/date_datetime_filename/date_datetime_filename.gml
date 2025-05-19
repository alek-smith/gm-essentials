/// @func date_datetime_filename()
/// @desc Formats the specified datetime into a string
///		  with no spaces, which is friendlier for file
///		  names.
/// @param {datetime} [dt] the datetime to format (def. date_current_datetime())
/// @return {string} Returns a string with the formatted datetime
///
function date_datetime_filename(dt=date_current_datetime()) {
	
	var second = string_leading_zeroes(date_get_second(dt), 2);
	var minute = string_leading_zeroes(date_get_minute(dt), 2);
	var hour = string_leading_zeroes(date_get_hour(dt), 2);
	var day = string_leading_zeroes(date_get_day(dt), 2);
	var month = string_leading_zeroes(date_get_month(dt), 2);
	var year = string_leading_zeroes(date_get_year(dt), 4);
	var str = string_join("_", string_join("-", year, month, day), string_join("-", hour, minute, second));
			  
	return str;
			  
}