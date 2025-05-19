/// @func Stack()
/// @desc Does just as it's named and acts as a stack. Serves as an alternative to
///		  the built-in DsStack. [FINISH LATER]
/// @return
function Stack() constructor {

	data = array_create(8); /// @is {array}
	size = 0; /// @is {int}
	
	/// @func contains(x)
	/// @desc Returns true if the stack contains the specified element.
	/// @param {any} x the element to search for
	/// @return {bool}
	static contains = function(x/*:any*/) /*-> bool*/ {
		for (var i = 0; i < size; i++) {
			if (data[i] == x) return true;
		}
		return false;
	}
	
	/// @func get(i)
	/// @desc Returns the element at the specified index on the stack without
	///		  modifying the stack in any way. Useful for iteration over the
	///		  stack's contents. Index 0 is the bottom of the stack; index size-1
	///		  is the top of the stack. Throws an excpetion if the index is out of
	//		  range.
	/// @param {real} i the index of the element to retrieve
	/// @return {any} Returns the element
	static get = function(i) {
		enforce_bounds(i, 0, size-1);
		return data[i];
	}
	
	/// @func getSize()
	/// @desc Returns the logical size of the stack.
	/// @return {real}
	static getSize = function() {
		return size;
	}
	
	/// @func isEmpty()
	/// @desc Returns true if the stack is empty, false otherwise.
	/// @return {bool}
	static isEmpty = function() {
		return size == 0;
	}
	
	/// @func peek()
	/// @desc Returns the topmost element of the stack but does not pop it off
	///		  of the stack. The stack remains unchanged after this operation.
	///		  If the stack is empty, an exception is thrown.
	/// @return {any} Returns the topmost element, or undefined if the stack
	///				  is empty
	static peek = function() {
		return get(size-1);
	}
	
	/// @func pop()
	/// @desc Pops the topmost element off of the stack and returns it.
	/// @return {any} Returns the topmost element
	static pop = function() {
		enforce_bounds(size, 1, NULL);
		return data[--size];
	}
	
	/// @func push(x)
	/// @desc Pushes the specified element of any type onto the stack.
	/// @param {any} x the element to push
	static push = function(x) {
		if (size == array_length(data)) { // is stack full?
			array_reallocate(data);
		}
		data[size++] = x;
	}
	
	static toString = function() {
		var str = "Stack{";
		for (var i = 0; i < size; i++) {
			str += string(data[i]);
			if (i != size-1) str += ", ";
		}
		str += "}";
		return str;
	}

}