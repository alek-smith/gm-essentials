
/// @param {string} text
/// @param {real} width
/// @param {string} delims
/// @param {asset.GMFont} [font]
/// @return {string}
function string_wrap(text, width, delims="", font=draw_get_font()) {

	if (string_length(delims) != 0 && string_length(delims) != 2) {
		throw new RuntimeException(EXC_ILLEGAL_ARGUMENT, "length of delims must be 0 or 2");
	}

	var oldFont = draw_get_font();
	draw_set_font(font);
	var fontInfo = font_get_info(font);
	
	var char/*:string?*/ = NULL;
	var cursor/*:int*/ = 1;
	var newlineIndex/*:int*/ = -1; // index of last known whitespace char; where to place the newline
	var lineWidth/*:int*/ = 0;
	var maxWidth/*:int*/ = width;
	var tokenWidth/*:int*/ = 0;
	var charWidth/*:int*/ = fontInfo.glyphs[$ "H"].shift;
	var token/*:string*/ = "";
	
	while (cursor < string_length(text)) {
		
		char = string_char_at(text, cursor);
		
		if (char_is_whitespace(char)) { // current char is whitespace
		
			newlineIndex = cursor;
			token = "";
			tokenWidth = 0;
			lineWidth += charWidth;
			if (char == "\n") { // newline present in original text
				lineWidth = 0;
			}
			
		} else if (string_length(delims) > 0 && char == string_char_at(delims, 1)) {
			
			while (cursor <= string_length(text) && char != string_char_at(delims, 2)) {
				cursor++;
				char = string_char_at(text, cursor);
			}
			
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