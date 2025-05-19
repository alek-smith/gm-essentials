/**
  * @func dbg_labeled_variable(label, ref)
  * @desc Places two text elemnts back-to-back in the current debug view and section.
  * The first text element is the label, and the second is the variable reference itself.
  * @param {String} label the label
  * @param {Id.DbgRef} ref the variable reference
  */
function dbg_labeled_variable(label, ref) {

	enforce_string(label);
	dbg_text(label);
	dbg_same_line();
	dbg_text(ref);

}