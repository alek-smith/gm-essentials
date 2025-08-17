
#macro STRBUF_LENGTH 0
#macro STRBUF_TAIL 4
#macro STRBUF_HEADER_SIZE 8

/**
 * @desc Appends the specified substring to the end of the specified string buffer.
 * @param {id.Buffer} sb the string buffer
 * @param {string} substr the substring
 */
function strbuf_append(sb, substr) {
	
	enforce_buffer(sb);
	enforce_string(substr);
	
	var len = strbuf_length(sb);
	var increase = string_length(substr);
	var tail = __strbuf_tail(sb);
	
	buffer_seek(sb, buffer_seek_start, tail);
	buffer_write_text(sb, substr);
	var newTail = buffer_tell(sb);
	buffer_write_ubyte(sb, 0);
	
	__strbuf_set_length(sb, len+increase);
	__strbuf_set_tail(sb, newTail);
	
}

/**
 * @desc Creates a string buffer with the specified value as the initial
 * data. The value will be converted to a string representation if it is
 * not already a string.
 * @param {any} a the value
 */
function strbuf(a) {
	
	var sb = strbuf_create();
	strbuf_append(sb, string(a));
	return sb;
	
}

/**
 * @desc Returns the raw byte value at the given position in the string buffer.
 * Use strbuf_byte_length() to determine the raw byte length.
 * @param {id.Buffer} sb the string buffer
 * @param {real} index the position of the byte
 */
function strbuf_byte_at(sb, index) {
	enforce_buffer(sb);
    enforce_bounds(index, 0, strbuf_byte_length(sb)-1);
    return buffer_peek_ubyte(sb, STRBUF_HEADER_SIZE+index);
}

/**
 * @desc Returns the raw byte length of the specified string buffer. String buffers
 * are encoded in UTF-8, so characters with a code point of 128 or greater will require
 * multiple bytes to encode.
 * @param {id.Buffer} sb the string buffer
 */
function strbuf_byte_length(sb) {
	enforce_buffer(sb);
    return __strbuf_tail(sb) - STRBUF_HEADER_SIZE;
}

/**
 * @desc Allocates a new string buffer with the given initial capacity. The
 * default initial capacity is 8 if none is specified.
 * @param {real} [initialCapacity] the initial capacity of the string buffer (def. 8)
 * @return {id.Buffer}
 */
function strbuf_create(initialCapacity=8) {

	var sb = buffer_create(initialCapacity+STRBUF_HEADER_SIZE, buffer_grow, 1);
	buffer_initialize(sb);
	__strbuf_set_length(sb, 0);
	__strbuf_set_tail(sb, STRBUF_HEADER_SIZE);
	return sb;

}

/**
 * @desc Returns the character at the specified index in the specified string buffer.
 * String buffers are indexed from 0 (unlike GameMaker strings, which are indexed from 1).
 * Note that, because string buffers are encoded in UTF-8, this is a linear time operation.
 * Thus, when iterating over the string buffer, strbuf_foreach() should be used instead.
 * @param {id.Buffer} sb the string buffer
 * @param {real} index the index
 * @return {string}
 */
function strbuf_char_at(sb, index) {
	
	enforce_buffer(sb);
	enforce_bounds(index, 0, strbuf_length(sb)-1);
	
	__strbuf_seek(sb, index);
	var char = __strbuf_get_current_char(sb);
	
	return char;
	
}

/**
 * @desc Returns a substring of the specified string buffer. 
 * @param {id.Buffer} sb the string buffer
 * @param {real} index the index of the substring
 * @param {real} count the number of characters to copy
 * @return {string}
 */
function strbuf_copy(sb, index, count) {
	
	enforce_buffer(sb);
	enforce_bounds(index, 0, strbuf_length(sb)-1);
	enforce_numeric(count);
	
	var len = strbuf_length(sb);
	if (index+count > len) count = len-index;
	enforce_bounds(index, 0, len-1);
	
	var helper = buffer_create(4, buffer_grow, 1);
	strbuf_copy_to_buffer(sb, index, count, helper, 0);
	buffer_seek(helper, buffer_seek_start, 0);
	var value = buffer_read_string(helper);
	buffer_delete(helper);
	return value;
	
}

/**
 * @func strbuf_copy_to_buffer(sb, index, count, dest, destOffset)
 * @desc Copies the specified amount of characters from a string buffer into
 * another buffer (string buffer or not) at the specified offset. Returns the
 * number of raw bytes copied.
 * @param {id.Buffer} sb the string buffer
 * @param {real} index the index into the buffer to begin copying
 * @param {real} count the number of characters to copy
 * @param {id.Buffer} dest the destination buffer
 * @param {real} destOffset the offset into the destination buffer
 * @return {real}
 */
function strbuf_copy_to_buffer(sb, index, count, dest, destOffset) {
	
	enforce_buffer(sb);
	enforce_bounds(index, 0, strbuf_length(sb)-1);
	enforce_numeric(count);
	enforce_buffer(dest);
	enforce_numeric(destOffset);
	
    var len = strbuf_length(sb);
    __strbuf_seek(sb, index);
	var start = buffer_tell(sb);
    for (var i = 0; i < count; i++) {
        __strbuf_get_current_char(sb);
    }
	var stop = buffer_tell(sb);
	
	buffer_copy(sb, start, stop-start, dest, destOffset);
	
	return stop-start;
    
}

/**
 * @desc Retrieves the number of times the specified substring occurs in the
 * specified string buffer.
 * @param {id.Buffer} sb the string buffer
 * @param {string} substr the substring to check for
 * @return {real}
 */
function strbuf_count(sb, substr) {
	
	enforce_buffer(sb);
	enforce_string(substr);
	
	var count = 0;
	var match = __strbuf_find_match(sb, substr, 0, false);
	var sublen = string_length(substr);
	var rawsublen = string_byte_length(substr);
	
	buffer_seek(sb, buffer_seek_start, STRBUF_HEADER_SIZE);
	while (match > -1) {
		count++;
		buffer_seek(sb, buffer_seek_relative, rawsublen);
		match = __strbuf_find_match(sb, substr, match+sublen, true);
	}
	
	return count;
	
}

/**
 * @desc Removes a part of the specified string buffer.
 * @param {id.Buffer} sb the string buffer
 * @param {real} index the index of the substring to delete
 * @param {real} count the number of characters to delete
 */
function strbuf_delete(sb, index, count) {
	
	enforce_buffer(sb);
	enforce_bounds(index, 0, strbuf_length(sb)-1);
	enforce_numeric(count);
	
    var len = strbuf_length(sb);
    var rawlen = strbuf_byte_length(sb);
    var dest; // destination in the buffer to copy chars to
    var src; // source in the buffer from which to copy chars
    var rawcount; // size of the "gap" left behind by deletion
    var copyCount; // number of chars to copy
    
    if (count == 0) {
        return;
    }
	if (index + count > len) {
		count = len - index;
	}
	
	// delete all special case
	if (index == 0 && count == len-1) {
		__strbuf_set_length(sb, 0);
		__strbuf_set_tail(sb, STRBUF_HEADER_SIZE);
		buffer_seek(sb, buffer_seek_start, STRBUF_HEADER_SIZE);
		buffer_write_ubyte(sb, 0);
		return;
	}
    
    __strbuf_seek(sb, index);
    dest = buffer_tell(sb) - STRBUF_HEADER_SIZE;
    __strbuf_seek_relative(sb, count);
    src = buffer_tell(sb) - STRBUF_HEADER_SIZE;
    rawcount = src - dest;
    copyCount = rawlen - src;
    
    for (var i = 0; i < copyCount; i++) {
        var o = buffer_read_ubyte(sb);
        buffer_seek(sb, buffer_seek_relative, -1-rawcount);
        buffer_write_ubyte(sb, o);
        buffer_seek(sb, buffer_seek_relative, rawcount);
    }
    buffer_seek(sb, buffer_seek_relative, -rawcount);
    buffer_write_ubyte(sb, 0); // write NUL to terminate string properly
    
    buffer_seek(sb, buffer_seek_start, 0);
	__strbuf_set_length(sb, len-count);
	__strbuf_set_tail(sb, rawlen-rawcount+STRBUF_HEADER_SIZE);
    
}

/**
 * @func strbuf_destroy(sb)
 * @desc Frees the specified string buffer. Does the same as buffer_delete().
 * @param {id.Buffer} sb the string buffer to free
 */
function strbuf_destroy(sb) {
	enforce_buffer(sb);
	buffer_delete(sb);
}

/**
 * @desc Converts the specified string buffer to a string with all characters that
 * are not considered numbers (0-9) removed.
 * @param {id.Buffer} sb the string buffer
 * @return {string}
 */
function strbuf_digits(sb) {
	
	enforce_buffer(sb);
	
	var helper = strbuf_create();
	var rawlen = strbuf_byte_length(sb);
	
	buffer_seek(sb, buffer_seek_start, STRBUF_HEADER_SIZE);
	repeat (rawlen) {
		var o = buffer_read_ubyte(sb);
		if (o >= ord("0") && o <= ord("9")) {
			strbuf_append(helper, chr(o));
		}
	}
	
	var str = strbuf_to_string(helper);
	strbuf_destroy(helper);
	return str;
	
}

/**
 * @desc Checks whether the specified string buffer ends with the specified substring.
 * Returns true if so, false otherwise.
 * @param {id.Buffer} sb the string buffer
 * @param {string} substr the substring
 * @return {bool}
 */
function strbuf_ends_with(sb, substr) {
	
	enforce_buffer(sb);
	enforce_string(substr);
	
	var len = strbuf_length(sb);
	var index = len - string_length(substr);
	var subindex = 1;
	
	if (index < 0) {
		return false;
	}
	
	__strbuf_seek(sb, index);
	while (index < len) {
		var char = __strbuf_get_current_char(sb);
		var subchar = string_char_at(substr, subindex);
		if (char != subchar) {
			return false;
		}
		subindex++;
		index++;
	}
	
	return true;
	
}

/**
 * @desc Iterates over the specified string buffer, calling the specified function
 * for each character. The callback function should take two arguments: the character
 * itself, and the index of the character. This should be used to iterate over a string
 * buffer instead of enclosing strbuf_char_at() in a for-loop, as strbuf_char_at() is a
 * linear-time operation. TIP: to pass instance/local variables into callback functions,
 * use the built-in method() function.
 * @param {id.Buffer} sb the string buffer
 * @param {function} func the callback function (char: string, pos: real)
 * @param {real} [pos] the index in the string buffer to start iterating (def. 0)
 * @param {real} [length] the number of characters to iterate over (def. strbuf_length(sb))
 */
function strbuf_foreach(sb, func, pos=0, length=strbuf_length(sb)) {
	
	enforce_buffer(sb);
	enforce_callable(func);
	enforce_bounds(pos, 0, strbuf_length(sb)-1);
	enforce_numeric(length);
	
	var start = pos;
	var mark = -1;
	
	if (pos + length > strbuf_length(sb)) {
		length = strbuf_length(sb) - pos;
	}
	
	__strbuf_seek(sb, pos);
	
	for (; pos < start+length; pos++) {
		var char = __strbuf_get_current_char(sb);
		mark = buffer_tell(sb);
		func(char, pos);
		if (mark != buffer_tell(sb)) { // in case the callback function changed the buffer seek position
			buffer_seek(sb, buffer_seek_start, mark);
		}
	}
	
}

/**
 * @desc Changes all "#" characters in the specified string buffer into a newline
 * character. This function's built-in counterpart, string_hash_to_newline(), is
 * provided for import compatibility with older versions of GameMaker. This function
 * is implemented for string buffers for the sake of completeness.
 * @param {id.Buffer} sb the string buffer
 */
function strbuf_hash_to_newline(sb) {
	
	enforce_buffer(sb);

	var rawlen = strbuf_byte_length(sb);
	buffer_seek(sb, buffer_seek_start, STRBUF_HEADER_SIZE);
	
	for (var i = 0; i < rawlen; i++) {
		var b = buffer_read_ubyte(sb);
		if (b == ord("#")) {
			buffer_seek(sb, buffer_seek_relative, -1);
			buffer_write_ubyte(sb, ord("\n"));
		}
	}

}

/**
 * @desc Calculates the height, in pixels, that the specified string buffer would be if
 * it were drawn on the screen, taking into account any line breaks the string may have.
 * The currently-defined font is used to determine the height of characters.
 * @param {id.Buffer} sb the string buffer
 */
function strbuf_height(sb) {
	
	enforce_buffer(sb);
	
	var fontInfo = font_get_info(draw_get_font());
	var len = strbuf_length(sb);
	var height = 0; // current height
	var baseHeight = 0; // height of all previous lines combined
	
	buffer_seek(sb, buffer_seek_start, STRBUF_HEADER_SIZE);
	for (var i = 0; i < len; i++) {
		var ch = __strbuf_get_current_char(sb);
		var glyphInfo = fontInfo.glyphs[$ ch];
		glyphInfo ??= fontInfo.glyphs[$ UNICODE_UNKNOWN_CHAR];
		if (ch == "\n") {
			baseHeight = height;
		} else {
			height = max(height, baseHeight+glyphInfo.h);
		}
	}
	
	return height;
	
}

/**
 * @desc Inserts the specified substring into the specified string buffer at the specified
 * index.
 * @param {id.Buffer} sb the string buffer
 * @param {string} substr the substring
 * @param {real} index the index
 */
function strbuf_insert(sb, substr, index) {
	
	enforce_buffer(sb);
	enforce_string(substr);
	enforce_bounds(index, 0, strbuf_length(sb));
	
	// if we're inserting at the end, just append instead
	if (index == strbuf_length(sb)) {
		strbuf_append(sb, substr);
		return;
	}
	
    var rawsublen = string_byte_length(substr);
    var sublen = string_length(substr);
    var tail = __strbuf_tail(sb);
    var len = strbuf_length(sb);
    var rawindex;
    
    enforce_bounds(index, 0, len-1);
    if (rawsublen == 0) {
        return;
    }
    
    __strbuf_seek(sb, index);
    rawindex = buffer_tell(sb);
    
    buffer_seek(sb, buffer_seek_start, tail-1);
    while (buffer_tell(sb) >= rawindex) {
        var ch = buffer_read_ubyte(sb);
        buffer_seek(sb, buffer_seek_relative, rawsublen-1);
        buffer_write_ubyte(sb, ch);
        buffer_seek(sb, buffer_seek_relative, -rawsublen-1-1);
    }
    buffer_seek(sb, buffer_seek_relative, 1);
    buffer_write_text(sb, substr);
    buffer_seek(sb, buffer_seek_start, tail+rawsublen);
    buffer_write_ubyte(sb, 0); // write NUL to terminate string properly
	__strbuf_set_length(sb, len+sublen);
	__strbuf_set_tail(sb, tail+rawsublen);
    
}

/**
 * @desc Retrieves the last position of the specified substring in the specified string
 * buffer, and returns it. If the substring doesn't exist in the string buffer, -1 is
 * returned.
 * @param {id.Buffer} sb the string buffer
 * @param {string} substr the substring
 * @return {real}
 */
function strbuf_last_pos(sb, substr) {
	
	enforce_buffer(sb);
	enforce_string(substr);

	var match = __strbuf_find_match(sb, substr, 0);
	var ret = -1;
	var sublen = string_length(substr);
	
	while (match > -1) {
		ret = match;
		match = __strbuf_find_match(sb, substr, match+sublen);
	}
	
	return ret;
    
}

/**
 * @desc Converts the specified string buffer to a string with all characters that
 * are not considered letters (A-Z, a-z) removed.
 * @param {id.Buffer} sb the string buffer
 * @return {string}
 */
function strbuf_letters(sb) {
	
	enforce_buffer(sb);

	var helper = strbuf_create();
	var rawlen = strbuf_byte_length(sb);
	
	buffer_seek(sb, buffer_seek_start, STRBUF_HEADER_SIZE);
	repeat (rawlen) {
		var o = buffer_read_ubyte(sb);
		if ((o >= ord("A") && o <= ord("Z")) || (o >= ord("a") && o <= ord("z"))) {
			strbuf_append(helper, chr(o));
		}
	}
	
	var str = strbuf_to_string(helper);
	strbuf_destroy(helper);
	return str;	
	    
}

/**
 * @desc Converts the specified string buffer to a string with all characters that
 * are not considered letters or numbers (A-Z, a-z, 0-9) removed.
 * @param {id.Buffer} sb the string buffer
 * @return {string}
 */
function strbuf_lettersdigits(sb) {
	
	enforce_buffer(sb);

	var helper = strbuf_create();
	var rawlen = strbuf_byte_length(sb);
	
	buffer_seek(sb, buffer_seek_start, STRBUF_HEADER_SIZE);
	repeat (rawlen) {
		var o = buffer_read_ubyte(sb);
		if ((o >= ord("A") && o <= ord("Z")) || (o >= ord("a") && o <= ord("z")) || (o >= ord("0") && o <= ord("9"))) {
			strbuf_append(helper, chr(o));
		}
	}
	
	var str = strbuf_to_string(helper);
	strbuf_destroy(helper);
	return str;
		
}

/**
 * @desc Returns the length of the specified string buffer.
 * @param {id.Buffer} sb the string buffer
 * @return {real}
 */
function strbuf_length(sb) {
	enforce_buffer(sb);
	return buffer_peek_uint(sb, 0);
}

/**
 * @desc Converts all uppercase letters in the specified string buffer into their lowercase
 * counterparts. Only characters in the English alphabet (A-Z) are converted.
 * @param {id.Buffer} sb the string buffer
 */
function strbuf_lower(sb) {
	
	enforce_buffer(sb);
	
	var rawlen = strbuf_byte_length(sb); // safe to use raw length since utf-8 is ascii compatible
	
	buffer_seek(sb, buffer_seek_start, STRBUF_HEADER_SIZE);
	for (var i = 0; i < rawlen; i++) {
		var o = buffer_read_ubyte(sb);
		if (o >= ord("A") && o <= ord("Z")) {
			o += 32;
			buffer_seek(sb, buffer_seek_relative, -1);
			buffer_write_ubyte(sb, o);
		}
	}
	
}

/**
 * @desc Retrieves the ordinal of the character at the specified index in the specified
 * string buffer. String buffers are indexed from 0 (unlike GameMaker strings, which are 
 * indexed from 1). Note that, because string buffers are encoded in UTF-8, this is a 
 * linear time operation. Thus, when iterating over the string buffer, strbuf_foreach() 
 * should be used instead.
 * @param {id.Buffer} sb the string buffer
 * @param {real} index the index
 * @return {real}
 */
function strbuf_ord_at(sb, index) {
	
	enforce_buffer(sb);
	enforce_bounds(index, 0, strbuf_length(sb)-1);
	
	return ord(strbuf_char_at(sb, index));
	
}

/**
 * @desc Retrieves the first position of the specified substring in the specified string
 * buffer, and returns it. The search begins from the specified starting index, or index 0
 * if no such index is specified. If the substring doesn't exist in the string buffer, or
 * couldn't be found from the starting index, -1 is returned.
 * @param {id.Buffer} sb the string buffer
 * @param {string} substr the substring
 * @param {real} [startIndex] the index to begin searching from
 * @return {real}
 */
function strbuf_pos(sb, substr, startIndex=0) {
	
	enforce_buffer(sb);
	enforce_string(substr);
	enforce_bounds(startIndex, 0, strbuf_length(sb)-1);
	
	var len = strbuf_length(sb);
	var sublen = string_length(substr);
	if (sublen > len - startIndex) {
		return -1;
	}
	
	return __strbuf_find_match(sb, substr, startIndex, false);
	
}

/**
 * @desc Repeats the specified string buffer over itself a certain number of times.
 * @param {id.Buffer} sb the string buffer
 * @param {real} count the number of times to duplicate the string buffer's contents
 */
function strbuf_repeat(sb, count) {
	
	enforce_buffer(sb);
	enforce_bounds(count, 0);
	
	var len = strbuf_length(sb);
	var rawlen = strbuf_byte_length(sb);
	
	buffer_seek(sb, buffer_seek_start, STRBUF_HEADER_SIZE);
	repeat (count) {
		repeat (rawlen) {
			var o = buffer_read_ubyte(sb);
			buffer_seek(sb, buffer_seek_relative, rawlen-1);
			buffer_write_ubyte(sb, o);
			buffer_seek(sb, buffer_seek_relative, -rawlen);
		}
	}
	buffer_seek(sb, buffer_seek_relative, rawlen);
	buffer_write_ubyte(sb, 0);
	
	__strbuf_set_length(sb, len+(len*count));
	__strbuf_set_tail(sb, rawlen + (rawlen*count) + STRBUF_HEADER_SIZE);
	
}

/**
 * @desc Replaces the first instance of the specified substring in the specified string buffer
 * with the specified replacement string. If a successful replacement occured, true is returned.
 * If the substring doesn't exist in the string buffer, false is returned.
 * @param {id.Buffer} sb the string buffer
 * @param {string} substr the substring
 * @param {string} newstr the replacement string
 * @return {bool}
 */
function strbuf_replace(sb, substr, newstr) {
	
	enforce_buffer(sb);
	enforce_string(substr);
	enforce_string(newstr);
	
	return __strbuf_replace_from(sb, substr, newstr, 0) > -1;

}

/**
 * @desc Replaces all instances of the specified substring in the specified string buffer
 * with the specified replacement string. The number of replacements that occured is
 * returned.
 * @param {id.Buffer} sb the string buffer
 * @param {string} substr the substring
 * @param {string} newstr the replacement string
 * @return {real}
 */
function strbuf_replace_all(sb, substr, newstr) {
	
	enforce_buffer(sb);
	enforce_string(substr);
	enforce_string(newstr);
	
	var index = 0;
	var count = 0;
	while (index > -1) {
		index = __strbuf_replace_from(sb, substr, newstr, index);
		show_debug_message(index);
		if (index > -1) {
			count++;
		}
	}
	return count;
	
}

/**
 * @desc Replaces the character at the specified index in the specified string buffer with
 * a new character. Since string buffers are encoded in UTF-8, this is a linear-time operation,
 * so use it with care.
 * @param {id.Buffer} sb the string buffer
 * @param {string} char the replacement character (if multiple chars, uses only the first one)
 * @param {real} index the index of the character to replace
 */
function strbuf_set_char(sb, char, index) {
    
	enforce_buffer(sb);
	enforce_string(char);
	enforce_bounds(index, 0, strbuf_length(sb)-1);
	if (string_length(char) > 1) {
		char = string_char_at(char, 1);
	}
	
    var tail = __strbuf_tail(sb);
    var rawlen;
    var rawsublen = string_byte_length(char);
    var bytediff;
    
    __strbuf_seek(sb, index);
    rawlen = __strbuf_current_char_byte_length(sb);
    bytediff = rawsublen - rawlen;
	
    if (bytediff == 0) {
		
        buffer_write_text(sb, char);
		
    } else if (bytediff < 0) {
		
        buffer_write_text(sb, char);
		var remaining = tail - buffer_tell(sb) - bytediff;
		repeat (remaining) { // for remainder of buffer...
			buffer_seek(sb, buffer_seek_relative, -bytediff);
			var o = buffer_read_ubyte(sb);
			buffer_seek(sb, buffer_seek_relative, bytediff-1);
			buffer_write_ubyte(sb, o);
		}
		buffer_seek(sb, buffer_seek_start, tail+bytediff);
		buffer_write_ubyte(sb, 0);
		__strbuf_set_tail(sb, tail+bytediff);
		
    } else {
		
		var rawindex = buffer_tell(sb);
		buffer_seek(sb, buffer_seek_start, tail-1);
		while (buffer_tell(sb) >= rawindex) {
			var o = buffer_read_ubyte(sb);
			buffer_seek(sb, buffer_seek_relative, -1+bytediff);
			buffer_write_ubyte(sb, o);
			buffer_seek(sb, buffer_seek_relative, -bytediff-1-1);
		}
		buffer_seek(sb, buffer_seek_relative, 1);
		buffer_write_text(sb, char);
		buffer_seek(sb, buffer_seek_start, tail+bytediff);
		buffer_write_ubyte(sb, 0);
		__strbuf_set_tail(sb, tail+bytediff);
		
    }
    
}

/**
 * @desc Tokenizes the specified string buffer using the specified delimeter(s). The separated
 * tokens are returned in an array. Similar to its built-in counterpart, any delimeters that
 * occur after max splits has been reached will become part of the last string in the token
 * array. Unlike its built-in counterpart, this function only accepts single-character delimeters.
 * Support for multi-character delimeters will be implemented sometime in the future.
 * @param {id.Buffer} sb the string buffer
 * @param {string,array<string>} delimeter the delimeter(s)
 * @param {bool} [removeEmpty] whether or not to ignore empty tokens (def. false)
 * @param {real} [maxSplits] the maximum number of tokens, not including the leftover token. -1 means no maximum (def. -1)
 * @return {array<string>}
 */
function strbuf_split(sb, delimeter, removeEmpty=false, maxSplits=-1) {
	
	// strbuf_split_into_buffer type-checks for us, so no need to do it here
	
	var dest = buffer_create(__strbuf_tail(sb), buffer_grow, 1);
	buffer_seek(dest, buffer_seek_start, 0);
	var count = strbuf_split_into_buffer(sb, delimeter, dest, 0, removeEmpty, maxSplits);
	var arr = array_create(count);
	
	for (var c = 0; c < count; c++) {
		var str = buffer_read_string(dest);
		arr[c] = str;
	}
	
	return arr;
	
}

/**
 * @desc Tokenizes the specified string buffer using the specified delimeter(s). The separated
 * tokens are written to the specified buffer. Similar to its built-in counterpart, any delimeters
 * that occur after max splits has been reached will become part of the last string in the token
 * buffer. Unlike its built-in counterpart, this function only accepts single-character delimeters.
 * Support for multi-character delimeters will be implemented sometime in the future. The number of
 * splits that occured is returned (note that this may be bigger than max splits, since the leftover
 * token is counted as a split).
 * @param {id.Buffer} sb the string buffer
 * @param {string,array<string>} delimeter the delimeter(s)
 * @param {id.Buffer} dest the destination buffer
 * @param {real} [destOffset] the offset into the destination buffer (def. 0)
 * @param {bool} [removeEmpty] whether or not to omit empty tokens from the destination buffer (def. false)
 * @param {real} [maxSplits] the maximum number of tokens, not including the leftover token. -1 means no maximum (def. -1)
 */
function strbuf_split_into_buffer(sb, delimeter, dest, destOffset=0, removeEmpty=false, maxSplits=-1) {
	
	enforce_buffer(sb);
	enforce_buffer(dest);
	enforce_numeric(destOffset);
	enforce_bool(removeEmpty);
	enforce_numeric(maxSplits);
	
	var delims;
	if (is_string(delimeter)) {
		delims = [delimeter];
	} else {
		delims = delimeter;
	}
	enforce_array(delims);
	
	var len = strbuf_length(sb);
	var tail = __strbuf_tail(sb);
	var mark = buffer_tell(dest);
	var splits = 0;
	
	if (maxSplits == -1) {
		maxSplits = MAX_UINT;
	}
	
	var i = 0;
	var start = STRBUF_HEADER_SIZE;
	buffer_seek(sb, buffer_seek_start, start);
	buffer_seek(dest, buffer_seek_start, destOffset);
	while (i < len && splits < maxSplits) {
		var charpos = buffer_tell(sb);
		var char = __strbuf_get_current_char(sb);
		for (var d = 0; d < array_length(delims); d++) {
			if (char == delims[d]) {
				var copySize = charpos-start;
				if (removeEmpty && copySize == 0) {
					start = buffer_tell(sb);
					break;
				}
				buffer_copy(sb, start, copySize, dest, buffer_tell(dest));
				buffer_seek(dest, buffer_seek_relative, copySize);
				buffer_write_ubyte(dest, 0);
				start = buffer_tell(sb);
				splits++;
				break;
			}
		}
		i++;
	}
	
	if (start != tail) { // copy the rest, if there is any
		var copySize = tail-start;
		buffer_copy(sb, start, copySize, dest, buffer_tell(dest));
		buffer_seek(dest, buffer_seek_relative, copySize);
		buffer_write_ubyte(dest, 0);
		splits++;
	}
	
	buffer_seek(dest, buffer_seek_start, mark);
	return splits;
	
}

/**
 * @desc Returns true if the specified string buffer starts with the specified substring.
 * @param {id.Buffer} sb the string buffer
 * @param {string} substr the substring
 * @return {bool}
 */
function strbuf_starts_with(sb, substr) {
	
	enforce_buffer(sb);
	enforce_string(substr);
    
	var len = strbuf_length(sb);
	var index = 0;
	var subindex = 1;
	
	if (string_length(substr) > len) {
		return false;
	}
	
	buffer_seek(sb, buffer_seek_start, STRBUF_HEADER_SIZE);
	while (subindex <= string_length(substr)) {
		var char = __strbuf_get_current_char(sb);
		var subchar = string_char_at(substr, subindex);
		if (char != subchar) {
			return false;
		}
		subindex++;
		index++;
	}
	
	return true;
    
}

/**
 * @desc Converts the specified string buffer into a string.
 * @param {id.Buffer} sb the string buffer
 * @return {string}
 */
function strbuf_to_string(sb) {
	buffer_seek(sb, buffer_seek_start, STRBUF_HEADER_SIZE);
	return buffer_read_string(sb);
}

/**
 * @desc Removes certain characters from the beginning and end of the specified string buffer.
 * By default, whitespace characters are removed, but a custom character set may be specified
 * instead.
 * @param {id.Buffer} sb the string buffer
 * @param {array<string>} substrs an array containing characters to trim from the string buffer (def. whitespace chars)
 */
function strbuf_trim(sb, substrs=[" ", "\t", "\r", "\n", "\f", "\v"]) {
	
	// let trim_start and trim_end do type-checking for us
	
	strbuf_trim_start(sb, substrs);
	strbuf_trim_end(sb, substrs);

}

/**
 * @desc Removes certain characters from the end of the specified string buffer. By default,
 * whitespace characters are removed, but a customer character set may be specified instead.
 * @param {id.Buffer} sb the string buffer
 * @param {array<string>} substrs an array containing characters to trim from the string buffer (def. whitespace chars)
 */
function strbuf_trim_end(sb, substrs=[" ", "\t", "\r", "\n", "\f", "\v"]) {
	
	enforce_buffer(sb);
	enforce_array(substrs);
	
	var len = strbuf_length(sb);
	var index = 0;
	var count;
	
	if (len == 0) {
		return;
	}
	
	buffer_seek(sb, buffer_seek_start, STRBUF_HEADER_SIZE);
	var ch = __strbuf_get_current_char(sb);
	for (var i = 0; i < len; i++) {
		if (!array_contains(substrs, ch)) {
			index = i+1;
		}
		ch = __strbuf_get_current_char(sb);
	}
	
	count = len - index;
	if (count > 0) {
		strbuf_delete(sb, index, count);
	}
	
}

/**
 * @desc Removes certain characters from the start of the specified string buffer. By default,
 * whitespace characters are removed, but a customer character set may be specified instead.
 * @param {id.Buffer} sb the string buffer
 * @param {array<string>} substrs an array containing characters to trim from the string buffer (def. whitespace chars)
 */
function strbuf_trim_start(sb, substrs=[" ", "\t", "\r", "\n", "\f", "\v"]) {
    
	enforce_buffer(sb);
	enforce_array(substrs);
	
	var len = strbuf_length(sb);
	var index = 0;
	var count = 0;
	
	if (len == 0) {
		return;
	}
	
	buffer_seek(sb, buffer_seek_start, STRBUF_HEADER_SIZE);
	var ch = __strbuf_get_current_char(sb);
	while (array_contains(substrs, ch)) {
		count++;
		if (count == len) break;
		ch = __strbuf_get_current_char(sb);
	}
	
	strbuf_delete(sb, index, count);
	
}

/**
 * @desc Truncates the specified string buffer, so that only the characters
 * in the range [index, index+count) remain.
 * @param {id.Buffer} sb the string buffer
 * @param {real} index the index of the remaining substring
 * @param {real} count the length of the remaining substring
 */
function strbuf_truncate(sb, index, count) {
	
	enforce_buffer(sb);
	enforce_bounds(index, 0, strbuf_length(sb)-1);
	enforce_numeric(count);
	
	var len = strbuf_length(sb);
	if (index + count > len) {
		count = len - index;
	}
	
	strbuf_delete(sb, 0, index);
	if (index + count < len) {
		strbuf_delete(sb, count, len-(index+count));
	}
	
}

/**
 * @desc Converts all lowercase letters in the specified string buffer into their uppercase
 * counterparts. Only characters in the English alphabet (A-Z) are converted.
 * @param {id.Buffer} sb the string buffer
 */
function strbuf_upper(sb) {
	
	enforce_buffer(sb);
	
	var rawlen = strbuf_byte_length(sb); // safe to use raw length since utf-8 is ascii compatible
	
	buffer_seek(sb, buffer_seek_start, STRBUF_HEADER_SIZE);
	for (var i = 0; i < rawlen; i++) {
		var o = buffer_read_ubyte(sb);
		if (o >= ord("a") && o <= ord("z")) {
			o -= 32;
			buffer_seek(sb, buffer_seek_relative, -1);
			buffer_write_ubyte(sb, o);
		}
	}
	
}

/**
 * @desc Calculates the width, in pixels, that the specified string buffer would be if
 * it were drawn on the screen, taking into account any line breaks the string may have.
 * The currently-defined font is used to determine the width of characters.
 * @param {id.Buffer} sb the string buffer
 */
function strbuf_width(sb) {
	
	enforce_buffer(sb);
	
	var fontInfo = font_get_info(draw_get_font());
	var len = strbuf_length(sb);
	var width = 0;
	var lineWidth = 0;
	
	buffer_seek(sb, buffer_seek_start, STRBUF_HEADER_SIZE);
	for (var i = 0; i < len; i++) {
		var ch = __strbuf_get_current_char(sb);
		var glyphInfo = fontInfo.glyphs[$ ch];
		glyphInfo ??= fontInfo.glyphs[$ UNICODE_UNKNOWN_CHAR];
		if (ch == "\n") {
			lineWidth = 0;
		} else {
			lineWidth += glyphInfo.shift;
			width = max(width, lineWidth);
		}
	}
	
	return width;
    
}

/**
 * @desc String buffer equivalent of `string_wrap`. See the documentation for that function
 * for more information.
 * @param {id.Buffer} sb the string buffer
 * @param {real} width the maximum width -- the wrapped string will never exceed this width
 * @param {string} [delims] a string of characters for this function to ignore (def. "")
 * @param {asset.GMFont} [font] the font to use when calculating character widths (def. draw_get_font())
 */
function strbuf_wrap(sb, width, delims="", font=draw_get_font()) {
	
	enforce_buffer(sb);
	enforce_numeric(width);
	enforce_string(delims);
	enforce_handle(font);
	
	if (!font_exists(font)) {
		throw new RuntimeException(EXC_NO_SUCH_FONT);
	}

	var oldFont = draw_get_font();
	draw_set_font(font);
	
	var len = strbuf_length(sb);
	var cursor = 0;
	var char = NULL;
	var newlineIndex = -1; // index of last known whitespace char; where to place the newline
	var lineWidth = 0;
	var maxWidth = width;
	var tokenWidth = 0;
	var charWidth = 0;
	var token = "";
	
	__strbuf_seek(sb, 0);
	while (cursor <= len) {
		
		var tell = buffer_tell(sb);
		char = __strbuf_get_current_char(sb);
		charWidth = string_width(char);
		
		if (char == " ") { // current char is whitespace
		
			newlineIndex = tell;
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
				buffer_poke_char(sb, newlineIndex, "\n");
				lineWidth = tokenWidth;
			}
			
		}
		
		cursor++;
		
	}
	
	draw_set_font(oldFont);
	
}
/**
 * @desc String buffer equivalent of `string_wrap_ext`. See the documentation for that function
 * for more information.
 * @param {id.Buffer} sb the string buffer
 * @param {real} width the maximum width -- the wrapped string will never exceed this width
 * @param {function} [cmp] a comparison function to determine whether or not certain characters should be ignored (def. NULL)
 * @param {asset.GMFont} [font] the font to use when calculating character widths (def. draw_get_font())
 */
function strbuf_wrap_ext(sb, width, cmp=NULL, font=draw_get_font()) {
	
	enforce_buffer(sb);
	enforce_numeric(width);
	enforce_callable(cmp);
	enforce_handle(font);
	
	if (!font_exists(font)) {
		throw new RuntimeException(EXC_NO_SUCH_FONT);
	}

	var oldFont = draw_get_font();
	draw_set_font(font);
	
	var len = strbuf_length(sb);
	var cursor = 0;
	var char = NULL;
	var newlineIndex = -1; // index of last known whitespace char; where to place the newline
	var lineWidth = 0;
	var maxWidth = width;
	var tokenWidth = 0;
	var charWidth = 0;
	var token = "";
	
	__strbuf_seek(sb, 0);
	while (cursor <= len) {
		
		var tell = buffer_tell(sb);
		char = __strbuf_get_current_char(sb);
		charWidth = string_width(char);
		
		if (char == " " || char == "\n") { // current char is whitespace
		
			newlineIndex = tell;
			token = "";
			tokenWidth = 0;
			lineWidth += charWidth;
			if (char == "\n") { // newline present in original text
				lineWidth = 0;
			}
			
		} else if (cmp != NULL && cmp(char)) { // current char should be ignored according to delims
			
			// do nothing
			
		} else { // current char is NOT whitespace
		
			token += char;
			tokenWidth += charWidth;
			lineWidth += charWidth;
			
			if (lineWidth > maxWidth) { // string too long, insert newline
				buffer_poke_char(sb, newlineIndex, "\n");
				lineWidth = tokenWidth;
			}
			
		}
		
		cursor++;
		
	}
	
	draw_set_font(oldFont);
	
}

/**
 * @desc Internal helper function. Closes a "gap" in the data defined by the
 * specified offset and count. All bytes to the right of the specified range
 * are shifted to the left the number of times specified by count. This function
 * does not modify the length value, tail pointer, or seek position.
 * @param {id.Buffer} sb the string buffer
 * @param {real} offset the gap's raw offset into the buffer
 * @param {real} count the length of the gap
 */
function __strbuf_close_gap(sb, offset, count) {
	
	var mark = buffer_tell(sb);
	var src = offset + count;
	var rawlen = strbuf_byte_length(sb);
	var tocopy = rawlen - src + STRBUF_HEADER_SIZE;
	
	buffer_seek(sb, buffer_seek_start, offset); // default buffer position in case we're not copying anything
	for (var c = 0; c < tocopy; c++) {
		buffer_seek(sb, buffer_seek_start, src+c);
		var o = buffer_read_ubyte(sb);
		buffer_seek(sb, buffer_seek_start, offset+c);
		buffer_write_ubyte(sb, o);
	}
	buffer_write_ubyte(sb, 0); // write new null terminator at end
	
	buffer_seek(sb, buffer_seek_start, mark);
	
}

/**
 * @desc Internal helper function. Gets the byte length of the current
 * character in the specified string buffer.
 */
function __strbuf_current_char_byte_length(sb) {
	var b = buffer_peek_ubyte(sb, buffer_tell(sb));
	if (b <= 0x7f) return 1;
	else if ((b & 0b11100000) == 0xc0) return 2;
	else if ((b & 0b11110000) == 0xe0) return 3;
	else if ((b & 0b11111000) == 0xf0) return 4;
	else return 0;
}

/**
 * @desc Internal helper function. Finds the specified substring in the string buffer.
 * If the substring is in the string buffer, the logical index of the first occurance
 * of the substring is returned, and the buffer seek position is placed just before said
 * first occurance. If the substring is not found, -1 is returned and the buffer seek
 * position remains in its original place.
 * @param {id.Buffer} sb
 * @param {string} substr
 * @param {real} index if dontSeek is true, this is just used as a counter
 * @param {bool} dontSeek prevents seeking from the start of the string to save time
 */
function __strbuf_find_match(sb, substr, index=0, dontSeek=false) {

	var matchIndex = -1;
	var matchRaw = -1;
	var potentialMatchRaw = -1;
	var potentialMatchIndex = -1;
	var matchProgress = 0;
	var len = strbuf_length(sb);
	var tail = strbuf_byte_length(sb) + STRBUF_HEADER_SIZE;
	var sublen = string_length(substr);
	
	if (!dontSeek) __strbuf_seek(sb, index);
	var oldTell = buffer_tell(sb);
	while (index < len) {
		var charpos = buffer_tell(sb);
		var char = __strbuf_get_current_char(sb);
		if (char == string_char_at(substr, matchProgress+1)) {
			if (matchProgress == 0) {
				potentialMatchIndex = index;
				potentialMatchRaw = charpos;
			}
			matchProgress++;
			if (matchProgress == sublen) { // match found
				matchIndex = potentialMatchIndex;
				matchRaw = potentialMatchRaw;
				break;
			}
		} else {
			matchProgress = 0;
		}
		index++;
	}
	
	if (matchIndex == -1) {
		buffer_seek(sb, buffer_seek_start, oldTell);
	} else {
		buffer_seek(sb, buffer_seek_start, matchRaw);
	}
	return matchIndex;
		
}

/**
 * @desc Internal helper function. Reads a single UTF-8 encoded character
 * from the buffer at the current seek position.
 */
function __strbuf_get_current_char(sb) {
	
	var size = __strbuf_current_char_byte_length(sb);
	var temp = buffer_create(4, buffer_fixed, 1);
	buffer_copy(sb, buffer_tell(sb), size, temp, 0);
	buffer_seek(sb, buffer_seek_relative, size);
	buffer_seek(temp, buffer_seek_start, 0);
	var char = buffer_read_string(temp);
	buffer_delete(temp);
	
	return char;
	
}

/**
 * @desc Internal helper function. Creates a "gap" in the data defined by the
 * specified offset and count. All bytes starting at the specified offset are
 * shifted to the right the number of times specified by count. This function
 * does not modify the length value, tail pointer, or seek position.
 * @param {id.Buffer} sb the string buffer
 * @param {real} offset the raw offset into the buffer the gap should be located at
 * @param {real} count the length the gap should be
 */
function __strbuf_make_gap(sb, offset, count) {
	
	var mark = buffer_tell(sb);
	var rawlen = strbuf_byte_length(sb);
	var bsrc = rawlen + STRBUF_HEADER_SIZE;
	var dest = rawlen + STRBUF_HEADER_SIZE + count;
	var tocopy = rawlen - offset + STRBUF_HEADER_SIZE;
	
	buffer_seek(sb, buffer_seek_start, rawlen + STRBUF_HEADER_SIZE - 1);
	for (var c = 0; c < tocopy; c++) {
		buffer_seek(sb, buffer_seek_start, bsrc-c-1);
		var o = buffer_read_ubyte(sb);
		buffer_seek(sb, buffer_seek_start, dest-c-1);
		buffer_write_ubyte(sb, o);
		if (c == 0) { // copying last char in string, need new null terminator
			buffer_write_ubyte(sb, 0);
		}
	}
	
	buffer_seek(sb, buffer_seek_start, mark);
	
}

/**
 * @desc Internal helper function. Replaces the first instance of substr with newstr,
 * starting from the specified raw index into the buffer. Returns the raw index of the
 * end of the newly-inserted substring.
 */
function __strbuf_replace_from(sb, substr, newstr, index) {
	
	var matchIndex = -1;
	var len = strbuf_length(sb);
	var rawlen = strbuf_byte_length(sb);
	var sublen = string_length(substr);
	var rawsublen = string_byte_length(substr);
	var newlen = string_length(newstr);
	var rawnewlen = string_byte_length(newstr);
	var ret = -1;
	
	if (newlen == 0) {
		return ret;
	}
	
	matchIndex = __strbuf_find_match(sb, substr, index);
	
	if (matchIndex == -1) { // no match found
		return ret;
	}
	
	var bytediff = rawnewlen - rawsublen;
	
	var tell = buffer_tell(sb); // this will be at the substring
	if (bytediff > 0) { // newstr longer than substr
		__strbuf_make_gap(sb, tell+rawsublen, bytediff);
	} else if (bytediff < 0) { // newstr shorter than substr
		__strbuf_close_gap(sb, tell+rawnewlen, -bytediff);
	}
	buffer_write_text(sb, newstr);
	ret = matchIndex + newlen;
	__strbuf_set_length(sb, len + (newlen - sublen));
	__strbuf_set_tail(sb, rawlen + bytediff + STRBUF_HEADER_SIZE);
	
	return ret;
	
}

/**
  * @desc Internal helper function. Seeks the buffer to the specified index,
  * accounting for UTF-8 encoded characters.
  */
function __strbuf_seek(sb, index) {
	buffer_seek(sb, buffer_seek_start, STRBUF_HEADER_SIZE);
	for (var i = 0; i < index; i++) {
		__strbuf_get_current_char(sb);
	}
}

/**
  * @desc Internal helper function. Seeks the buffer to the specified index
  * relative to the current index, accounting for UTF-8 encoded characters.
  * The offset value must be positive.
  */
function __strbuf_seek_relative(sb, offset) {
	for (var i = 0; i < offset; i++) {
		__strbuf_get_current_char(sb);
	}
}

/**
 * @desc Internal helper function. Sets the reported length of the specified string
 * buffer. This does not affect the buffer's seek position.
 */
function __strbuf_set_length(sb, len) {
	buffer_poke_uint(sb, STRBUF_LENGTH, len);
}

/**
 * @desc Internal helper function. Sets the tail pointer of the specified string
 * buffer. This does not affect the buffer's seek position.
 */
function __strbuf_set_tail(sb, tail) {
	buffer_poke_uint(sb, STRBUF_TAIL, tail);
}

/**
 * @desc Internal helper function. Returns the tail pointer of the specified string buffer.
 */
function __strbuf_tail(sb) {
	return buffer_peek_uint(sb, 4);
}