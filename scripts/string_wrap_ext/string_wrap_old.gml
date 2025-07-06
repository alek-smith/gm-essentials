/// @func string_wrap(text, width, [ignore], [font])
/// @desc Modifies the specified string non-destructively so that its
///		  physical width on the screen is <= the specified width. This is
///		  accomplished by inserting a line feed ('\n') at the appropriate
///		  places. An array of strings may be passed to act as a list of 
///		  string shapes that this function will ignore entirely. This is useful
///		  if the string uses any programmer-defined scancodes (e.g. %c for color).
///		  The contents of the string shapes array will be passed into string_accepts
///		  as the language argument, so see the string_accepts documentation for more
///		  information. Optionally, a font asset may be provided, which this function
///		  will use to pull data from; specifically, data related to the dimensions, in
///		  pixels, of each symbol.
/// @param {String} text the string to wrap
/// @param {Real} width the desired physical width of the string
/// @param {Array<String>} [ignore] an optional array of string shapes that
///									the function will ignore
/// @param {Asset.GMFont} [font] the font to assume when determining symbol dimensions (def. draw_get_font())
function string_wrap(text, width, ignore=[], font=draw_get_font()) {
	
	var oldFont = draw_get_font();
	draw_set_font(font);
	var fontInfo = font_get_info(font);
	
	var char = 0; // current char (as code point)
	var cursor = 0; // index of current char
	var ignorelen = array_length(ignore);
	var lineFeedIndex = -1; // index of last know whitespace char; where to place the newline
	var lineWidth = 0; // physical width of current line
	var maxWidth = width; // maximum physical width permitted per line
	var tokenWidth = 0; // physical width of current token
	var charWidth = fontInfo.glyphs[$ "H"].shift;
	var token = new StringBuilder(4); // current token
	var builder = new StringBuilder(text); // builder for modified string
	
	while (cursor < builder.length) { // loop char-by-char
		
		char = builder.codePointAt(cursor);
		if (char_is_whitespace(char)) { // current char whitespace
			lineFeedIndex = cursor;
			token.setLength(0);
			tokenWidth = 0;
			lineWidth += charWidth;
			if (chr(char) == "\n") { // manual newline
				lineWidth = 0;
			}
		} else { // current char NOT whitespace
			token.append(chr(char));
			tokenWidth += charWidth;
			lineWidth += charWidth;
			for (var i = 0; i < ignorelen; i++) { // loop through ignore strings
				var straccept = string_accepts(token.toString(), ignore[i]);
				if (straccept > 0) { // ignore string found?
					var oldWidth = token.length * charWidth;
					token.setLength(straccept-1);
					tokenWidth = token.length * charWidth;
					lineWidth -= oldWidth - tokenWidth;
					break;
				}
			}
			if (lineWidth > maxWidth) { // current line width exceed maximum width? insert line feed
				builder.setCharAt(lineFeedIndex, "\n");
				lineWidth = tokenWidth;
			}
		}
		
		cursor++;
		
	}
	
	draw_set_font(oldFont);
	return builder.toString();
	
}