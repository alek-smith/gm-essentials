
/**
 * @desc Wraps a string to prevent it from exceeding the specified width by placing line break characters
 * ('\n') in the string. This function does not split the same word between lines; if a word would cause
 * the string to exceed the maximum width, it is moved to the next line. This is done by replacing the
 * final whitespace character before the "overflow" word with a line break. This function can also optionally
 * ignore certain chracters in the string, excluding any occurances of them from the width calculation.
 * @param {string} text the string to wrap
 * @param {real} width the maximum width -- the wrapped string will never exceed this width
 * @param {string} [delims] a string of characters for this function to ignore (def. "")
 * @param {asset.GMFont} [font] the font to use when calculating character widths (def. draw_get_font())
 * @return {string}
 */
function string_wrap(text, width, delims="", font=draw_get_font()) {
	
	enforce_string(text);
	enforce_numeric(width);
	enforce_string(delims);
	enforce_handle(font);
	
	if (!font_exists(font)) {
		throw new RuntimeException(EXC_NO_SUCH_FONT);
	}

	var oldFont = draw_get_font();
	draw_set_font(font);
	
	var char = NULL;
	var cursor = 1;
	var newlineIndex = -1; // index of last known whitespace char; where to place the newline
	var lineWidth = 0;
	var maxWidth = width;
	var tokenWidth = 0;
	var charWidth = 0;
	var token = "";
	
	while (cursor <= string_length(text)) {
		
		char = string_char_at(text, cursor);
		charWidth = string_width(char);
		
		if ((char == " ")) { // current char is whitespace
		
			newlineIndex = cursor;
			token = "";
			tokenWidth = 0;
			lineWidth += charWidth;
			if (char == "\n") { // newline present in original text
				lineWidth = 0;
			}
			
		} else if (string_pos(char, delims) > 0) { // current char should be ignored according to delims
			
			// do nothing
			
		} else { // current char is NOT whitespace
		
			token += char;
			tokenWidth += charWidth;
			lineWidth += charWidth;
			
			if (lineWidth > maxWidth) { // string too long, insert newline
				text = string_insert("\n", text, newlineIndex);
				text = string_delete(text, newlineIndex+1, 1);
				lineWidth = tokenWidth;
			}
			
		}
		
		cursor++;
		
	}
	
	draw_set_font(oldFont);
	return text;

}