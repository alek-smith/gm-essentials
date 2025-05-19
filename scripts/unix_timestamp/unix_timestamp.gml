/**
  * @func unix_timestamp(dt)
  * @desc Converts the specified datetime into a Unix Epoch timestamp.
  * @param {Real} [dt] the datetime to convert (def. current datetime)
  * @return {Real} Returns the corresponding Unix timestamp
  */
function unix_timestamp(dt=date_current_datetime()) {

	var years = date_get_year(dt) - 1970;
	var leap = ceil((years-2)/4);
	var timestamp = years*31536000 + leap*86400;
	timestamp += date_get_second_of_year(dt);
	
	return timestamp;

}