/// @func List([initialCapacity])
/// @desc Does just as it's named and acts as a list. Serves as an alternative
///		  to the built-in DsList.
/// @param {real} [initialCapacity] the initial physical size of the list (def. 8)
function List(initialCapacity=8) constructor {

	data = array_create(initialCapacity); /// @is {array}
	size = 0; /// @is {int}
	
	/// @func add(x)
	/// @desc Appends the specified element to the list.
	/// @param {any} x the element to add
	static add = function(x) {
		if (size == array_length(data)) {
			array_reallocate(data);
		}
		data[size++] = x;
	}
	
	/**
	  * @func clear()
	  * @desc Clears the list.
	  */
	static clear = function() {
		size = 0;
	}
	
	/// @func contains(x)
	/// @desc Returns true if the list contains the element specified.
	/// @param {any} x the element to search for
	/// @return {bool}
	static contains = function(x) {
		for (var i = 0; i < size; i++) {
			if (data[i] == x) return true;
		}
		return false;
	}
	
	/// @func get(i)
	/// @desc Returns the element at the specified index. Throws an exception
	///		  if no such element exists.
	/// @param {real} i the index to retrieve the element from
	/// @return {any}
	static get = function(i) {
		enforce_bounds(i, 0, size-1);
		return data[i];
	}
	
	/// @func getSize()
	/// @desc Returns the size of this List.
	/// @return {real}
	static getSize = function() {
		return size;
	}
	
	/// @func insert(x, index)
	/// @desc Inserts the specified element x at the specified index of the
	///		  list. All elements logically succeeding the new element will be pushed
	///		  back by one.
	/// @param {any} x the new element
	/// @param {real} index the index to place the element at
	static insert = function(x, index) {
		enforce_bounds(index, 0, size-1);
		if (size == array_length(data)) {
			array_reallocate(data);
		}
		for (var i = size; i > index; i--) {
			data[i] = data[i-1];
		}
		data[index] = x;
		size++;
	}

	/// @func remove(i)
	/// @desc Removes the element at the specified index and returns it. Throws
	///		  an exception if no such element exists.
	/// @param {real} i the index of the desired element
	/// @return {any}
	static remove = function(i) {
		enforce_bounds(i, 0, size-1);
		var value/*:any*/ = data[i];
		for (var j = i; j < size; j++) {
			data[j] = data[j+1];
		}
		size--;
		return value;
	}
	
	/// @func set(index, x)
	/// @desc Replaces the element at the specified index with new element x,
	///		  returning the original element.
	/// @param {real} index the index to replace
	/// @param {any} x the new element
	/// @return {any} Returns the original element at index
	static set = function(index, x) {
		enforce_bounds(index, 0, size-1);
		var old = data[index];
		data[index] = x;
		return old;
	}
	
	/// @func shuffle()
	/// @desc Shuffles the list.
	static shuffle = function() {
		var loc;
		var swap;
		for (var i = 0; i < size; i++) {
			loc = irandom_range(0, size-1);
			swap = data[i];
			data[i] = data[loc];
			data[loc] = swap;
		}
	}
	
	static toString = function() {
		var str = "List{";
		for (var i = 0; i < size; i++) {
			str += string(data[i]);
			if (i != size-1) str += ", ";
		}
		str += "}";
		return str;
	}

}