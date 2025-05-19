/**
 * @func dbg_view_generate(struct, name, [includeAll], [x], [y], [width], [height])
 * @desc Generates a read-only debug view for the specified struct. By default, only
 * reals and strings are added, but all values may be included if desired.
 * @param {struct} struct the struct
 * @param {string} name the name of the view
 * @param {bool} [includeAll] whether or not to include all fields
 * @param {real} [x] x position to place the view window (def. -1)
 * @param {real} [y] y position to place the view window (def. -1)
 * @param {real} [width] width of the view window (def. 500)
 * @param {real} [height] height of the view window (def. 400)
 * @return {pointer.View}
 */
function dbg_view_generate(struct, name, includeAll=false, x=-1, y=-1, width=500, height=400) {

	enforce_struct(struct, NULL);

	var view = dbg_view(name, true, x, y, width, height);
	var section = dbg_section("Struct");
	var names = struct_get_names(struct);
	
	for (var i = 0; i < array_length(names); i++) {
		if (includeAll || (!includeAll && (is_real(struct[$ names[i]]) || is_string(struct[$ names[i]])))) {
			dbg_labeled_variable(names[i], ref_create(struct, names[i]));
		}
	}

	return view;

}