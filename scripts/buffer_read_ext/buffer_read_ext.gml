/// Feather ignore GM1045

/// @return {Real}
function buffer_read_ubyte(buf) {
	return buffer_read(buf, buffer_u8);
}

/// @return {Real}
function buffer_read_byte(buf) {
	return buffer_read(buf, buffer_s8);	
}

/// @return {String}
function buffer_read_char(buf) {
	return buffer_read_char_utf8(buf);
}

/// @return {String}
function buffer_read_char_utf8(buf) {
	var helper = buffer_create(4, buffer_fixed, 1);
	var first = buffer_peek_ubyte(buf, buffer_tell(buf));
	var byteCount = 0;
	first &= 0b11110000;
	first = first >> 4;
	while (first != 0) {
		if (first & 1 > 0) {
			byteCount++;
		}
		first = first >> 1;
	}
	if (byteCount == 0) byteCount = 1;
	buffer_copy(buf, buffer_tell(buf), byteCount, helper, 0);
	buffer_seek(buf, buffer_seek_relative, byteCount);
	var ch = buffer_read_string(helper);
	buffer_delete(helper);
	return ch;
}

/// @return {Real}
function buffer_read_ushort(buf) {
	return buffer_read(buf, buffer_u16);
}

/// @return {Real}
function buffer_read_short(buf) {
	return buffer_read(buf, buffer_s16);
}

/// @return {Real}
function buffer_read_uint(buf) {
	return buffer_read(buf, buffer_u32);
}

/// @return {Real}
function buffer_read_int(buf) {
	return buffer_read(buf, buffer_s32);
}

/// @return {Real}
function buffer_read_ulong(buf) {
	return buffer_read(buf, buffer_u64);
}

/// @return {Real}
function buffer_read_long(buf) {
	var l = buffer_read_ulong(buf);
	if (l > MAX_LONG) l -= MAX_ULONG;
	return l;
}

/// @return {Real}
function buffer_read_half(buf) {
	return buffer_read(buf, buffer_f16);
}

/// @return {Real}
function buffer_read_float(buf) {
	return buffer_read(buf, buffer_f32);
}

/// @return {Real}
function buffer_read_double(buf) {
	return buffer_read(buf, buffer_f64);
}

/// @return {Bool}
function buffer_read_bool(buf) {
	return buffer_read(buf, buffer_bool);
}

/// @return {String}
function buffer_read_string(buf) {
	return buffer_read(buf, buffer_string);
}

/**
  * @func buffer_read_text(buf, count)
  * @desc Attempts to read the specified amount of data from the buffer and
  * returns the results as a string.
  * @param {Id.Buffer} buf the buffer to read from
  * @param {Real} count the amount of data, in bytes, to read
  */
/*function buffer_read_text(buf, count) {
	var sb = new StringBuilder(4);
	for (var i = 0; i < count; i++) {
		sb.append(buffer_read_char(buf));
	}
	var str = sb.toString();
	struct_finalize(sb);
	delete sb;
	return str;
}*/

function buffer_read_text(buf, count) {
	var helper = buffer_create(count, buffer_fixed, 1);
	buffer_copy(buf, buffer_tell(buf), count, helper, 0);
	var text = buffer_read_string(helper);
	buffer_delete(helper);
	buffer_seek(buf, buffer_seek_relative, count);
	return text;
}

/**
  * @func buffer_read_array(buf, type)
  * @desc Reads an array from the specified buffer. All values in the array
  * must be of the same type. This function reads an unsigned int to get the
  * number of elements in the array, then reads that much data from the buffer
  * depending on the type provided.
  * @param {Id.Buffer} buf the buffer to read from
  * @param {Constant.BufferDataType} type the type of all elements in the array
  */
function buffer_read_array(buf, type) {
	var arr = array_create(buffer_read(buf, buffer_u32));
	for (var i = 0; i < array_length(arr); i++) {
		arr[i] = buffer_read(buf, type);
	}
	return arr;
}

/// @return {Real}
function buffer_peek_ubyte(buf, offset) {
	return buffer_peek(buf, offset, buffer_u8);
}

/// @return {Real}
function buffer_peek_byte(buf, offset) {
	return buffer_peek(buf, offset, buffer_s8);	
}

/// @return {String}
function buffer_peek_char(buf, offset) {
	return chr(buffer_peek(buf, offset, buffer_u8));
}

/// @return {String}
function buffer_peek_char_utf8(buf) {
	var helper = buffer_create(4, buffer_fixed, 1);
	var first = buffer_peek_ubyte(buf, buffer_tell(buf));
	var byteCount = 0;
	first &= 0b11110000;
	first = first >> 4;
	while (first != 0) {
		if (first & 1 > 0) {
			byteCount++;
		}
		first = first >> 1;
	}
	if (byteCount == 0) byteCount = 1;
	buffer_copy(buf, buffer_tell(buf), byteCount, helper, 0);
	var ch = buffer_read_string(helper);
	buffer_delete(helper);
	return ch;
}

/// @return {Real}
function buffer_peek_ushort(buf, offset) {
	return buffer_peek(buf, offset, buffer_u16);
}

/// @return {Real}
function buffer_peek_short(buf, offset) {
	return buffer_peek(buf, offset, buffer_s16);
}

/// @return {Real}
function buffer_peek_uint(buf, offset) {
	return buffer_peek(buf, offset, buffer_u32);
}

/// @return {Real}
function buffer_peek_int(buf, offset) {
	return buffer_peek(buf, offset, buffer_s32);
}

/// @return {Real}
function buffer_peek_ulong(buf, offset) {
	return buffer_peek(buf, offset, buffer_u64);
}

/// @return {Real}
function buffer_peek_half(buf, offset) {
	return buffer_peek(buf, offset, buffer_f16);
}

/// @return {Real}
function buffer_peek_float(buf, offset) {
	return buffer_peek(buf, offset, buffer_f32);
}

/// @return {Real}
function buffer_peek_double(buf, offset) {
	return buffer_peek(buf, offset, buffer_f64);
}

/// @return {Bool}
function buffer_peek_bool(buf, offset) {
	return buffer_peek(buf, offset, buffer_bool);
}

/// @return {String}
function buffer_peek_string(buf, offset) {
	return buffer_peek(buf, offset, buffer_string);
}