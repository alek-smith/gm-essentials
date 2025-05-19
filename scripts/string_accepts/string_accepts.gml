/**
  * @func string_accepts(str, lang)
  * @desc 
  * Determines whether or not the specified string lang appears in
  * the specified input string str, returning its index if it does or 0
  * if it doesn't. This function works similarly to the built-in string_pos
  * function, but differs in a major way: the lang string allows for the use
  * of a couple different "wild card" characters. The two wild cards that this
  * function recognizes are the single-character wild card, the caret (^), and
  * the variable-length wild card, the asterisk (*). This is why the lang string
  * is referred to as a language argument, it is used to check the shape of the input string,
  * not necessarily the exact characters in the input string. Non-wild card characters in the
  * lang string are directly checked for in the input string, as they are in string_pos.
  *
  * For example, say this function is called with a language argument "Hello^world".
  * This function will return a non-zero value for any input string that is identical
  * to lang, with the exception of the caret (^), which can represent any character.
  * Thus, the input string can be "Hello world", "Hello_world", "Hello-world", etc., and
  * this function will return a non-zero value in every case.
  * 
  * The asterisk (*) wild card allows for even greater flexibility. Say this function
  * is called with the language argument "Hello*world". This function will return a
  * non-zero value for any input string that is equivalent to "Hello", followed by any
  * amount of any kind of character, followed by "world". The asterisk (*) can represent
  * a substring of length 0. Examples of input strings that will return a non-zero value 
  * in this situation include, but are not limited to, "Hello world", "Hello there, world", 
  * "Hello cruel world", and "Helloworld".
  * 
  * Note: if the language string contain an asterisk (*) immediately followed by a caret (^),
  * the asterisk is nullified entirely. This is due to the way this function processes the
  * asterisk internally.
  *
  * @param {String} str the input string
  * @param {String} lang the language string
  * @return {Real} Returns the index of the substring within the input string that
  * is accepted by the language string
  */
/// @param {string} str
/// @param {string} lang
/// @return {real}
function string_accepts(str, lang) {
	
	var strIndex = 1;
	var langIndex = 1;
	var star = false;
	var returnIndex = 0;
	
	for (; strIndex <= string_length(str); strIndex++) {
		
		while (string_char_at(lang, langIndex) == "*" && langIndex <= string_length(lang)) {
			star = true;
			langIndex++;
			if (returnIndex == 0) returnIndex = strIndex;
		}
		
		if (!star) {
			if (string_char_at(str, strIndex) == string_char_at(lang, langIndex) || string_char_at(lang, langIndex) == "^") {
				langIndex++;
				if (returnIndex == 0) returnIndex = strIndex;
			} else {
				langIndex = 1;
				returnIndex = 0;
			}
		} else {
			if (string_char_at(str, strIndex) == string_char_at(lang, langIndex) || string_char_at(lang, langIndex) == "^") {
				langIndex++;
				star = false;
			}
		}
		
		if (langIndex > string_length(lang)) {
			return returnIndex;
		}
		
	}
	
	return 0;
	
}