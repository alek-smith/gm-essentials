/**
  * @func apply_vector(v, o)
  * @desc Applies vector v to object instance o.
  * @param {Struct.Vector} v the vector
  * @param {Id.Instance} o the object instance
  * @param {Bool} [r] r whether or not to round the vector's components to the nearest whole number
  * before applying the vector. helps prevent potentially jittery movement when working with non-whole (def. false)
  * numbers, at the expense of accuracy
  */
function apply_vector(v, o, r=false) {

	enforce_struct(v, Vector);
	enforce_instance(o);
	if (!instance_exists(o)) throw new RuntimeException(EXC_NULL_POINTER, $"instance {o} no longer exists");
	
	var addX;
	var addY;
	if (r) {
		addX = round(v.x);
		addY = round(v.y);
	} else {
		addX = v.x;
		addY = v.y;
	}
	o.x += addX;
	o.y += addY;

}