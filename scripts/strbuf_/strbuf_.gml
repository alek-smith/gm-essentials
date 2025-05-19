
#macro STRBUF_HEADER_SIZE 8

function strbuf_append(sb, substr) {
	
	var len = strbuf_length(sb);
	var increase = string_length(substr);
	buffer_seek(sb, buffer_seek_start, 4);
	var offset = buffer_read_int(sb);
	buffer_seek(sb, buffer_seek_start, offset);
	buffer_write_text(sb, substr);
	var newOffset = buffer_tell(sb);
	buffer_seek(sb, buffer_seek_start, 0);
	buffer_write_int(sb, len+increase);
	buffer_write_int(sb, newOffset);
	
}

/**
  * @desc Creates a string buffer with the specified value as the initial
  * data. The value will be converted to a string representation.
  * @param {any} x the value
  */
function strbuf(x) {
	
	var sb = strbuf_create();
	strbuf_append(sb, string(x));
	return sb;
	
}

function strbuf_byte_at(sb, index) {
    enforce_bounds(index, 0, strbuf_byte_length(sb)-1);
    return buffer_peek_ubyte(sb, STRBUF_HEADER_SIZE+index);
}

function strbuf_byte_length(sb) {
    return buffer_peek_uint(sb, 4) - STRBUF_HEADER_SIZE;
}

/**
 * @func
 * @desc Allocates a new string buffer with the given initial capacity. The
 * default initial capacity is 8 if none is specified.
 */
function strbuf_create(initialCapacity=8) {

	var sb = buffer_create(initialCapacity+STRBUF_HEADER_SIZE, buffer_grow, 1);
	buffer_initialize(sb);
	buffer_seek(sb, buffer_seek_start, 4);
	buffer_write_int(sb, 0x8);
	return sb;

}

function strbuf_char_at(sb, index) {
	
	__strbuf_seek(sb, index);
	var char = __strbuf_get_current_char(sb);
	
	return char;
	
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

function __strbuf_current_char_byte_length(sb) {
	var b = buffer_peek_ubyte(sb, buffer_tell(sb));
	if (b <= 0x7f) return 1;
	else if ((b & 0b11100000) == 0xc0) return 2;
	else if ((b & 0b11110000) == 0xe0) return 3;
	else if ((b & 0b11111000) == 0xf0) return 4;
	else return 0;
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
	var tocopy = rawlen - (src + STRBUF_HEADER_SIZE);
	
	for (var c = 0; c < tocopy; c++) {
		buffer_seek(sb, buffer_seek_start, src+c);
		var o = buffer_read_ubyte(sb);
		buffer_seek(sb, buffer_seek_start, offset+c);
		buffer_write_ubyte(sb, o);
	}
	
	buffer_seek(sb, buffer_seek_start, mark);
	
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
	var tocopy = rawlen - (offset + STRBUF_HEADER_SIZE);
	
	buffer_seek(sb, buffer_seek_start, rawlen + STRBUF_HEADER_SIZE - 1);
	for (var c = 0; c < tocopy; c++) {
		buffer_seek(sb, buffer_seek_start, bsrc-c-1);
		var o = buffer_read_ubyte(sb);
		buffer_seek(sb, buffer_seek_start, dest+c);
		buffer_write_ubyte(sb, o);
	}
	
	buffer_seek(sb, buffer_seek_start, mark);
	
}

function strbuf_copy(sb, index, count) {
	
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
 */
function strbuf_count(sb, substr) {
	
	var count = 0;
	var len = strbuf_length(sb);
	var sublen = string_length(substr);
	var progress = 0;
	var index = 0;
	var curr = NULL;
	var subcurr = NULL;
	
	if (sublen == 0) {
		return 0;
	}
	
	buffer_seek(sb, buffer_seek_start, STRBUF_HEADER_SIZE);
	while (index < len) {
		curr = __strbuf_get_current_char(sb);
		subcurr = string_char_at(substr, progress+1);
		if (curr == subcurr) {
			progress++;
			if (progress == string_length(substr)) {
				count++;
				progress = 0;
			}
		} else {
			progress = 0;
		}
		index++;
	}
	
	return count;
	
}

function strbuf_delete(sb, index, count) {
	
    var len = strbuf_length(sb);
    var rawlen = strbuf_byte_length(sb);
    var dest; // destination in the buffer to copy chars to
    var src; // source in the buffer from which to copy chars
    var rawcount; // size of the "gap" left behind by deletion
    var copyCount; // number of chars to copy
    
    if (count == 0) {
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
    buffer_write_uint(sb, len-count);
    buffer_write_uint(sb, rawlen-rawcount+STRBUF_HEADER_SIZE);
    
}

/**
 * @func strbuf_destroy(sb)
 * @desc Frees the specified string buffer. Does the same as buffer_delete().
 * @param {id.Buffer} sb the string buffer to free
 */
function strbuf_destroy(sb) {
	buffer_delete(sb);
}

function strbuf_digits(sb) {
	
	var helper = strbuf_create();
	var rawlen = strbuf_byte_length(sb);
	
	buffer_seek(sb, buffer_seek_start, STRBUF_HEADER_SIZE);
	repeat (rawlen) {
		var o = buffer_read_ubyte(sb);
		if (o >= ord("0") && o <= ord("9")) {
			strbuf_append(sb, chr(o));
		}
	}
	
	return strbuf_to_string(helper);
	
}

function strbuf_ends_with(sb, substr) {
	
	var len = strbuf_length(sb);
	var index = len - string_length(substr);
	var subindex = 0;
	
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

function strbuf_foreach(sb, func, pos=0, length=strbuf_length(sb)) {
	
	__strbuf_seek(sb, pos);
	
	for (; pos < pos+length; pos++) {
		var char = __strbuf_get_current_char(sb);
		func(char, pos);
	}
	
}

function strbuf_hash_to_newline(sb) {

	var rawlen = buffer_peek_uint(sb, 4) - STRBUF_HEADER_SIZE;
	buffer_seek(sb, buffer_seek_start, STRBUF_HEADER_SIZE);
	
	for (var i = 0; i < rawlen; i++) {
		var b = buffer_read_ubyte(sb);
		if (b == ord("#")) {
			buffer_seek(sb, buffer_seek_relative, -1);
			buffer_write_ubyte(sb, ord("\n"));
		}
	}

}

function strbuf_height(sb) {
	
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

function strbuf_insert(sb, substr, index) {
	
    var rawsublen = string_byte_length(substr);
    var sublen = string_length(substr);
    var tail = buffer_peek_uint(sb, 4);
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
    buffer_seek(sb, buffer_seek_start, 0);
    buffer_write_uint(sb, len+sublen);
    buffer_write_uint(sb, tail+rawsublen);
    
}

function strbuf_last_pos(sb, substr) {

	var len = strbuf_length(sb);
	var sublen = string_length(substr);
	var progress = 0;
	var index = 0;
	var ret = -1;
    var loc = 0;
	var curr = NULL;
	var subcurr = NULL;
	
	if (sublen == 0 || sublen > len) {
		return -1;
	}
	
	__strbuf_seek(sb, index);
	while (index < len) {
		curr = __strbuf_get_current_char(sb);
		subcurr = string_char_at(substr, progress+1);
		if (curr == subcurr) {
			progress++;
			if (progress == string_length(substr)) {
				ret = loc;
                loc = index + 1;
                progress = 0;
			}
		} else {
			progress = 0;
			loc = index + 1;
		}
		index++;
	}
	
	return ret;
    
}

function strbuf_letters(sb) {

	var helper = strbuf_create();
	var rawlen = strbuf_byte_length(sb);
	
	buffer_seek(sb, buffer_seek_start, STRBUF_HEADER_SIZE);
	repeat (rawlen) {
		var o = buffer_read_ubyte(sb);
		if ((o >= ord("A") && o <= ord("Z")) || (o >= ord("a") && o <= ord("z"))) {
			strbuf_append(helper, chr(o));
		}
	}
	
	return strbuf_to_string(helper);	
	    
}

function strbuf_lettersdigits(sb) {

	var helper = strbuf_create();
	var rawlen = strbuf_byte_length(sb);
	
	buffer_seek(sb, buffer_seek_start, STRBUF_HEADER_SIZE);
	repeat (rawlen) {
		var o = buffer_read_ubyte(sb);
		if ((o >= ord("A") && o <= ord("Z")) || (o >= ord("a") && o <= ord("z")) || (o >= ord("0") && o <= ord("9"))) {
			strbuf_append(helper, chr(o));
		}
	}
	
	return strbuf_to_string(helper);		
		
}

function strbuf_length(sb) {
	return buffer_peek_uint(sb, 0);
}

function strbuf_lower(sb) {
	
	var rawlen = buffer_peek_uint(sb, 4) - 8; // safe to use raw length since utf-8 is ascii compatible
	
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

function strbuf_ord_at(sb, index) {
	
	return ord(strbuf_char_at(sb, index));
	
}

function strbuf_pos(sb, substr, startIndex=0) {
	
	var len = strbuf_length(sb);
	var sublen = string_length(substr);
	var progress = 0;
	var index = startIndex
	var ret = index;
	var curr = NULL;
	var subcurr = NULL;
	
	if (sublen == 0 || sublen > len - startIndex) {
		return -1;
	}
	
	enforce_bounds(startIndex, 0, len-1);
	
	__strbuf_seek(sb, index);
	while (index < len) {
		curr = __strbuf_get_current_char(sb);
		subcurr = string_char_at(substr, progress+1);
		if (curr == subcurr) {
			progress++;
			if (progress == string_length(substr)) {
				return ret;
			}
		} else {
			progress = 0;
			ret = index + 1;
		}
		index++;
	}
	
	return -1;	
	
}

function strbuf_repeat(sb, count) {
	
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
	buffer_seek(sb, buffer_seek_start, 0);
	buffer_write_uint(sb, len+(len*count));
	buffer_write_uint(sb, rawlen + (rawlen*count) + STRBUF_HEADER_SIZE);
	
}

function strbuf_replace(sb, substr, newstr) {
	// TODO implement
}

function strbuf_replace_all(sb, substr, newstr) {
	// TODO implement
}

function strbuf_set_char(sb, char, index) {
    
    var tail = strbuf_byte_length(sb) + STRBUF_HEADER_SIZE;
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
		buffer_poke_uint(sb, 4, tail+bytediff);
		
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
		buffer_poke_uint(sb, 4, tail+bytediff);
		
    }
    
}

// @param {string|array<string>} delimeter
function strbuf_split(sb, delimeter, removeEmpty=false, maxSplits=-1) {
	
	// TODO implement
	
}

/**
 * @func strbuf_split_into_buffer(sb, delimeter, [removeEmpty], [maxSplits])
 * @desc Stores the results of a string split into a buffer. Each token is separated
 * by a single NUL character. Thus, successive buffer_read_string() calls on the
 * destination buffer will return each token, one at a time.
 * @param {id.Buffer} sb the string buffer
 * @param {string|array<string>} delimeter the delimeter string, or an array of delimeter strings
 * @param {id.Buffer} dest the destination buffer
 * @param {real} [destOffset] the offset into the destination buffer (def. 0)
 * @param {bool} [removeEmpty] whether or not to omit empty tokens from the destination buffer (def. false)
 * @param {real} [maxSplits] the maximum number of tokens -- see string_split() for more info
 */
function strbuf_split_into_buffer(sb, delimeter, dest, destOffset=0, removeEmpty=false, maxSplits=-1) {
	// TODO implement
}

function strbuf_starts_with(sb, substr) {
    
	var len = strbuf_length(sb);
	var index = 0
	var subindex = 0;
	
	if (index < 0) {
		return false;
	}
	
	buffer_seek(sb, buffer_seek_start, STRBUF_HEADER_SIZE);
	while (subindex < string_length(substr)) {
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

function strbuf_to_string(sb) {
	buffer_seek(sb, buffer_seek_start, STRBUF_HEADER_SIZE);
	return buffer_read_string(sb);
}

function strbuf_trim(sb, substrs=[" ", "\t", "\r", "\n", "\f", "\v"]) {
	strbuf_trim_start(sb, substrs);
	strbuf_trim_end(sb, substrs);
}

function strbuf_trim_end(sb, substrs=[" ", "\t", "\r", "\n", "\f", "\v"]) {
	
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
	strbuf_delete(sb, index, count);
	
}

function strbuf_trim_start(sb, substrs=[" ", "\t", "\r", "\n", "\f", "\v"]) {
    
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
 * @func strbuf_truncate(sb, index, count)
 * @desc Truncates the specified string buffer, so that only the characters
 * in the range [index, index+count) remain.
 */
function strbuf_truncate(sb, index, count) {
	var len = strbuf_length(sb);
	strbuf_delete(sb, 0, index-1);
	strbuf_delete(sb, index+count, len-(index+count));
}

function strbuf_upper(sb) {
	
	var rawlen = buffer_peek_uint(sb, 4) - 8; // safe to use raw length since utf-8 is ascii compatible
	
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

function strbuf_width(sb, sep=-1, w=-1) {
	
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