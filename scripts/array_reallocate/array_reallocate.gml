/// @func array_reallocate(arr)
/// @desc Reallocates the specified array to double its original
///		  size. The array data is kept in the same order it was
///		  prior to reallocation. This function is shorthand for
///		  array_resize(arr, array_length(arr)*2).
/// @param {array<any>} arr the array to reallocate
///
function array_reallocate(arr) {

    if (array_length(arr) == 0) { 
        array_resize(arr, 1);
    } else {
	    array_resize(arr, array_length(arr)*2);
    }

}