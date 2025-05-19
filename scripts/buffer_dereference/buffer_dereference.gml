/**
  * @func buffer_dereference()
  * @desc Reads the next buffer value as a pointer and returns the value
  * that it is pointing to in the buffer. The type of the data being pointed
  * to must be specified, and the type of the pointer itself may also be specified.
  * @param {Id.Buffer} buf the buffer to read from
  * @param {Constant.BufferDataType} dataType the type of the data being pointed to
  * @param {Constant.BufferDataType} [ptrType] the type of the pointer itself. must
  * be an unsigned integer type (def. buffer_u32)
  * @return {Any} Returns the data being pointed to
  */
function buffer_dereference(buf, dataType, ptrType=buffer_u32) {

	if (ptrType != buffer_u32 && ptrType != buffer_u16 && ptrType != buffer_u8 && ptrType != buffer_u64) {
		throw new RuntimeException(EXC_ILLEGAL_ARGUMENT, "pointer type must be an unsigned integer of any size");
	}
	
	return buffer_peek(buf, buffer_read(buf, ptrType), dataType);

}