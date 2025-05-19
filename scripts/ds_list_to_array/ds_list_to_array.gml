/**
  * @func ds_list_to_array(list)
  * @desc Returns an array representation of the specified DsList.
  * @param {Id.DsList<Any>} list the list
  * @return {Array<Any>}
  */
function ds_list_to_array(list) {
	
	if (!ds_exists(list, ds_type_list)) {
		throw new RuntimeException(EXC_NO_SUCH_LIST);
	}
	
	var arr = array_create(ds_list_size(list));
	for (var i = 0; i < ds_list_size(list); i++) {
		arr[i] = ds_list_find_value(list, i);
	}
	
	return arr;
	
}