/// @func gamespeed_fraction(mult)
/// @desc A quality-of-life function. Returns the current
///		  gamespeed multiplied by the specified multiplier.
///		  Useful if the gamespeed is subject to change throughout
///		  development, especially if any code expects the gamespeed
///		  to remain the same throughout development. The calcuated
///		  value is rounded down if necessary.
/// @param {real} mult the number to multiply the gamespeed by
/// @return {real} Returns the gamespeed multiplied by mult.
///
function gamespeed_fraction(mult) {

	return floor(game_get_speed(gamespeed_fps) * mult);

}