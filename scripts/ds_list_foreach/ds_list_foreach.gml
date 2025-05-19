/**
  * @func ds_list_foreach(list, func, [offset], [length])
  * @desc Iterates through a DsList and calls the specified function for each
  * iteration. The callback function should take two arguments: (value, index).
  * Optionally, the starting offset may be specified, as well as the number of
  * iterations.
  * @param {Id.DsList} list the list
  * @param {Function} func (value, index) the callback function
  * @param {Real} [offset] the offset into the list to start at (def. 0)
  * @param {Real} [length] the maximum number of iterations (def. ds_list_size(list))
  */
function ds_list_foreach(list, func, offset=0, length=-1) {

	if (length == -1) length = ds_list_size(list) - offset;
	var limit = offset+length;

	for (var i = offset; i < limit; i++) {
		func(ds_list_find_value(list, i), i);
	}

}