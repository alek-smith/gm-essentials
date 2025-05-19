/**
 * @func dbg_section_generate(struct)
 * @desc Generates a read-only debug section for the specified struct. By default, only
 * reals and strings are added, but all values may be included if desired.
 * @param {struct} struct the struct
 * @param {string} name the name of the section
 * @param {bool} open true if section is opened when created, false otherwise (def. true)
 * @param {bool} [includeAll] whether or not to include all fields
 * @return {pointer.Section}
 */
function dbg_section_generate(struct, name, open=true, includeAll=false) {

	enforce_struct(struct, NULL);

	var section = dbg_section(name, open);
	var names = struct_get_names(struct);
	
	for (var i = 0; i < array_length(names); i++) {
		if (includeAll || (!includeAll && (is_real(struct[$ names[i]]) || is_string(struct[$ names[i]])))) {
			dbg_labeled_variable(names[i], ref_create(struct, names[i]));
		}
	}

	return section;

}