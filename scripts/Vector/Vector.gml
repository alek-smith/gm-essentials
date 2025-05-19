/**
  * @func Vector(x, y)
  * @desc It's a vector.
  * @param {real} x the x component
  * @param {real} y the y component
  */
function Vector(x, y) constructor {

	self.x = x; /// @is {number}
	self.y = y; /// @is {number}
	
	/**
	  * @func add(v)
	  * @desc Adds this vector and vector v together. The result is stored in this vector.
	  * @param {Struct.Vector} v the other addend vector
	  */
	static add = function(v) {
		x += v.x;
		y += v.y;
	}
	
	/**
	 * @func isZero()
	 * @desc Returns true if this vector has zero magnitude, false otherwise.
	 * @return {bool}
	 */
	static isZero = function() {
		return x == 0 && y == 0;
	}
	
	/**
	  * @func magnitude()
	  * @desc Calculates the magnitude of this vector.
	  * @return {Real} Returns the magnitude
	  */
	static magnitude = function() {
		return sqrt(power(x, 2) + power(y, 2));
	}
	
	/**
	  * @func normalize([factor])
	  * @desc Normalizes this vector. Useful for calculating accurate diagonal movement.
	  * @param {Real} [factor] the factor to multiply each component in the
	  * new vector by (def. 1)
	  */
	static normalize = function(factor=1) {
		var mag = self.magnitude();
		if (mag == 0) return; // normalizing with a mag of 0 makes no sense
		x = factor*(x/mag);
		y = factor*(y/mag);
	}
	
	/**
	  * @func product(v)
	  * @desc Calculates the dot product of this vector and vector v, and returns it.
	  * @param {Struct.Vector} v the other vector
	  * @return {Real} Returns the dot product
	  */
	static product = function(v) {
		return (x*v.x) + (y*v.y);
	}
	
	static toString = function() {
		return string("({0},{1})", x, y);
	}

}