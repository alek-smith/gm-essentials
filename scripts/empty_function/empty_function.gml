/**
  * @func empty_function()
  * @desc Returns a statically-declared empty method. Serves
  * as a means of deduplication when dealing with "null" methods
  * or functions. This is useful when using Feather, as a variable
  * can be explicitly typed as a function rather than as a general undefined
  * variable.
  * @return {Function}
  */
function empty_function() {
	
	static empty = function() {}
	return empty;
	
}