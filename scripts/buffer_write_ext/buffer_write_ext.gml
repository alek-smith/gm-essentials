
/// @param {Id.Buffer} buf
/// @param {Real} b
function buffer_write_ubyte(buf, b) {
	return buffer_write(buf, buffer_u8, b);
}

/// @param {Id.Buffer} buf
/// @param {Real} b
function buffer_write_byte(buf, b) {
	return buffer_write(buf, buffer_s8, b);
}

/// @param {Id.Buffer} buf
/// @param {String} c
function buffer_write_char(buf, c) {
    if (string_length(c) > 1) {
        return buffer_write_string(buf, c);
    }
    var len = string_byte_length(c);
    for (var i = 0; i < len; i++) {
        var res = buffer_write(buf, buffer_u8, string_byte_at(c, i));
        if (res < 0) return res;
    }
	return 0;
}

/// @param {Id.Buffer} buf
/// @param {Real} s
function buffer_write_ushort(buf, s) {
	return buffer_write(buf, buffer_u16, s);
}

/// @param {Id.Buffer} buf
/// @param {Real} s
function buffer_write_short(buf, s) {
	return buffer_write(buf, buffer_s16, s);
}

/// @param {Id.Buffer} buf
/// @param {Real} i
function buffer_write_uint(buf, i) {
	return buffer_write(buf, buffer_u32, i);
}

/// @param {Id.Buffer} buf
/// @param {Real} i
function buffer_write_int(buf, i) {
	return buffer_write(buf, buffer_s32, i);
}

/// @param {Id.Buffer} buf
/// @param {Real} l
function buffer_write_ulong(buf, l) {
	return buffer_write(buf, buffer_u64, l);
}

/// @param {Id.Buffer} buf
/// @param {Real} h
function buffer_write_half(buf, h) {
	return buffer_write(buf, buffer_f16, h);
}

/// @param {Id.Buffer} buf
/// @param {Real} f
function buffer_write_float(buf, f) {
	return buffer_write(buf, buffer_f32, f);
}

/// @param {Id.Buffer} buf
/// @param {Real} d
function buffer_write_double(buf, d) {
	return buffer_write(buf, buffer_f64, d);
}

/// @param {Id.Buffer} buf
/// @param {Bool} bo
function buffer_write_bool(buf, bo) {
	return buffer_write(buf, buffer_bool, bo);
}

/// @param {Id.Buffer} buf
/// @param {String} str
function buffer_write_string(buf, str) {
	return buffer_write(buf, buffer_string, str);
}

/// @param {Id.Buffer} buf
/// @param {String} str
function buffer_write_text(buf, str) {
	return buffer_write(buf, buffer_text, str);
}

/**
  * @func buffer_write_array(buf, arr)
  * @desc Writes the specified array to the specified buffer. All values
  * in the buffer must be of the same type.
  * @param {Id.Buffer} buf the buffer to write to
  * @param {Constant.BufferDataType} type the type of the data to write
  * @param {Array} arr the array to write
  */
function buffer_write_array(buf, type, arr) {
	buffer_write_uint(buf, array_length(arr));
	for (var i = 0; i < array_length(arr); i++) {
		buffer_write(buf, type, arr[i]);
	}
}

/// @param {Id.Buffer} buf
/// @param {Real} offset
/// @param {Real} b
function buffer_poke_ubyte(buf, offset, b) {
	return buffer_poke(buf, offset, buffer_u8, b);
}

/// @param {Id.Buffer} buf
/// @param {Real} offset
/// @param {Real} b
function buffer_poke_byte(buf, offset, b) {
	return buffer_poke(buf, offset, buffer_s8, b);
}

/// @param {Id.Buffer} buf
/// @param {Real} offset
/// @param {String} c
function buffer_poke_char(buf, offset, c) {
	return buffer_poke(buf, offset, buffer_u8, ord(c));
}

/// @param {Id.Buffer} buf
/// @param {Real} offset
/// @param {Real} s
function buffer_poke_ushort(buf, offset, s) {
	return buffer_poke(buf, offset, buffer_u16, s);
}

/// @param {Id.Buffer} buf
/// @param {Real} offset
/// @param {Real} s
function buffer_poke_short(buf, offset, s) {
	return buffer_poke(buf, offset, buffer_s16, s);
}

/// @param {Id.Buffer} buf
/// @param {Real} offset
/// @param {Real} i
function buffer_poke_uint(buf, offset, i) {
	return buffer_poke(buf, offset, buffer_u32, i);
}

/// @param {Id.Buffer} buf
/// @param {Real} offset
/// @param {Real} i
function buffer_poke_int(buf, offset, i) {
	return buffer_poke(buf, offset, buffer_s32, i);
}

/// @param {Id.Buffer} buf
/// @param {Real} offset
/// @param {Real} l
function buffer_poke_ulong(buf, offset, l) {
	return buffer_poke(buf, offset, buffer_u64, l);
}

/// @param {Id.Buffer} buf
/// @param {Real} offset
/// @param {Real} h
function buffer_poke_half(buf, offset, h) {
	return buffer_poke(buf, offset, buffer_f16, h);
}

/// @param {Id.Buffer} buf
/// @param {Real} offset
/// @param {Real} f
function buffer_poke_float(buf, offset, f) {
	return buffer_poke(buf, offset, buffer_f32, f);
}

/// @param {Id.Buffer} buf
/// @param {Real} offset
/// @param {Real} d
function buffer_poke_double(buf, offset, d) {
	return buffer_poke(buf, offset, buffer_f64, d);
}

/// @param {Id.Buffer} buf
/// @param {Real} offset
/// @param {Bool} bo
function buffer_poke_bool(buf, offset, bo) {
	return buffer_poke(buf, offset, buffer_bool, bo);
}

/// @param {Id.Buffer} buf
/// @param {Real} offset
/// @param {String} str
function buffer_poke_string(buf, offset, str) {
	return buffer_poke(buf, offset, buffer_string, str);
}

/// @param {Id.Buffer} buf
/// @param {Real} offset
/// @param {String} str
function buffer_poke_text(buf, offset, str) {
	return buffer_poke(buf, offset, buffer_text, str);
}