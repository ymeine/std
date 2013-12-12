require! {
# -------------------------------------------------------------------------- STD
	fs
# -------------------------------------------------------------------------- 3rd
	moment
# ---------------------------------------------------------------------- Own STD
	'std/string'
	'std/conf'
# ----------------------------------------------------------- Dynamically loaded
	# xml2js
	# csv
}


################################################################################
# TODO Be able to pass an object with a single key to 'write' methods. This way, the key is the file name and the property the data. This allows to use the LiveScript shorthand while calling, like this: `io.write {data}` (writing to the filename)
# It is more likely to be done for JSON writing, which has a default extension
# TODO Change the way conf is used
################################################################################
class IO
	(spec = {}) ~> @conf = conf.io with spec



	############################################################################
	# Basic IO
	############################################################################

	read: (path, encoding) ->
		encoding ?= @conf.encoding

		fs.readFileSync path, encoding

	write: fs.writeFileSync



	############################################################################
	# File stats
	############################################################################

	@fileDatesMapping = {
		'modification': 'mtime'
		'creation': 'ctime'
		'access': 'atime'
	}

	getDate: (type, path) --> (fs.statSync path)[@@fileDatesMapping[type] ? @@fileDatesMapping[@conf.defaultFileDate]]

	modificationDate: ::getDate 'modification'
	creationDate: ::getDate 'creation'
	accessDate: ::getDate 'access'

	############################################################################
	# LiveScript Serialization
	############################################################################

	lsc:~ -> require 'LiveScript/lib/livescript'

	/** The evaluated code must return the object to be imported */
	loadLscJSON: (code) -> @lsc.run code


	############################################################################
	# JSON Serialization
	############################################################################

	serializeJSON: (data, indent) ->
		indent ?= @conf.indent

		JSON.stringify data, null indent

	readJSON: (path, extension) ->
		if @conf.useReadJSONDefaultExtension => extension ?= ".json"
		extension ?= ''
		JSON.parse @read "#path#extension"

	importJSON: ::readJSON

	writeJSON: (path, data, extension = 'json') ~>
		if extension? => path = "#path.#extension"
		@write path, @serializeJSON data

	persistJSON: ::writeJSON



	serialize: ::serializeJSON
	import: ::importJSON
	persist: ::persistJSON


	############################################################################
	# XML Serialization
	#
	# XXX Maybe put some of it in the core 'data' library, if I'm able to work only with data (string, object, ...) and no file anymore
	#
	# FIXME The adapter is not good: I think it should recursively convert any 'xml lists'
	############################################################################

	xml2js:~ -> require 'xml2js'

	xml2json: (options, data, cb) -->
		{Parser} = new @xml2js
		parser = Parser options
		(err, result) <- parser.parseString data
		if not err? => cb(result.xml ? result) # [..$ for result.xml.entries.0.entry]



	############################################################################
	# CSV Serialization
	############################################################################

	csv:~ ->require 'csv'

	/**
	 * A record is equivalent to an object, a line inside the csv file.
	 * It is represented as an array.
	 * The provided headers configuration is an array mapping record indexes to key names for the resulting object: provide the names of the keys in the order they should 'appear' in the csv file.
	 */
	csv2json: ({input, options, headers}, cb) ->
		obj = []
		@csv!
			..from
				..options options
				..path input
			..on \record (record) -> obj.push {[key, record[index]] for key, index in headers}
			..on \end -> cb obj



	############################################################################
	# Rendering
	#
	# FIXME Be able to declare supported features, notably for now
	# - file protocol in link: no
	# - ...
	# This is relevant only for simple rendering, otherwise a node could know its context.
	############################################################################

	stampDate: -> moment!format 'DD-MM-YYYY_hh-mm-ss.SSSa'

	/**
	 * Convert an object mimicking a document structure to a string in the language of the specified renderer.
	 *
	 * This is for simple inputs, as otherwise one would provide a real document model.
	 *
	 * The passed object represents sections. Each key is a section name, and the associated value is the content of the section. Objects can be nested, to allow subsections.
	 *
	 * A section content, other than section-objects themselves, is an array of paragraph. Each paragraph is separated by a blank line.
	 *
	 * Items of a list can be either a string in language of the renderer or a nested array, corresponding to a nested list.
	 *
	 * @todo Allow meta-data on 'native' objects (like to indicate of arrays are ordered or unordered lists)
	 * @todo Introduce an intermediate object, wrapping thoses sections, to enable header and footer for each.
	 * @todo Be able to search for the renderer with a fuzzy search, and also don't use pre-built instances, just create them when needed, and cache them
	 */
	render: (renderer, input) -->
		if @[renderer]? => that.render input
		else throw {
			msg: 'No such renderer'
			renderer
		}

	class Renderer
		render: (input) ->
			render-paragraphs = (list) ~>
				output = for item in list
					switch typeof! item
					| 'String' => item
					| 'Array' => @list item
					| _ => throw {
						msg: 'Unsupported paragraph type in section content'
						type: typeof! item
						item
					}
				output.join '\n\n'

			render-section = (object, level = 1) ~>
				output = for section, content of object
					[
						@section section, level
						''

						switch typeof! content
						| 'Object' => [
							render-section content, level + 1
						] * '\n'
						| 'Array' => render-paragraphs content
						| _ => throw {
							msg: 'Unsupported section content'
							type: typeof! content
							content
						}

						''
					] * '\n'
				output.join '\n'

			render-section input

		list: (list, level = 1) ->
			output = for item in list
				switch typeof! item
				| 'String', 'Number' => @list-item item, level
				| 'Array' => @list item, level + 1
				| _ => throw {
					msg: 'Unsupported list item'
					type: typeof! item
					item
				}
			output.join '\n'

		emphase: (input, {i = on, b = on} = {}) ->
			if i? => input = @italic input
			if b? => input = @bold input
			input

		italic: -> string.surround "#{@emphaseChar}" * @italicX, it
		bold: -> string.surround "#{@emphaseChar}" * @boldX, it



	############################################################################
	# Markdown rendering
	############################################################################

	class Markdown extends Renderer
		~>
			@emphaseChar = '_'
			@italicX = 1
			@boldX = 2
		section: (title, level = 1) -> "#{'#' * level} #title"
		list-item: (item, level = 1) -> "#{'\t' * (level - 1)}* #item"
		url: (url, text = url, title) ->
			# URL Encoding
			/*
			 * This is how Markdown SEEMS to handle urls.
			 *
			 * The problem: I put urls inside parentheses, interpreted by markdown.
			 *
			 * The url itself can contain raw (not encoded) parentheses, conflicting with that in some cases.
			 *
			 * However, Markdown seems to count the opening and closing parentheses before detecting the one closing the url container.
			 *
			 * I'll do the same, and for each encountered parenthesis which would close the container, I'll encode it.
			 */
			opening = 0
			encoded = for char in url
				switch char
				| '(' => opening++
				| ')' => opening--
				if opening < 0
					char = '%29' # It can only be a ')'
					opening++
				char
			encoded .= join ''

			# Title - no need to escape apparently
			# if title? => title = string.escape title, '"'

			"[#{string.escape text, '[]'}](#encoded#{if title? => " \"#title\"" else ''})"



	markdown: Markdown
	mw:~ ->	@_mw ?= new Markdown!



	############################################################################
	# MediaWiki rendering
	############################################################################

	class MediaWiki extends Renderer

		~> @ <<< {
			emphaseChar: '\''
			italicX: 2
			boldX: 3
		}
		section: (title, level = 1) ->
			marks = '=' * level
			"#marks #title #marks"
		url: (url, text = url) ->
			url .= replace /\ /g '%20'
			url .= replace /\=/g '%3D'
			url .= replace /\[/g '%5B'
			url .= replace /\]/g '%5D'
			"[#url #text]"
		list-item: (item, level = 1) -> "#{'*' * level} #item"



	mediawiki: MediaWiki
	mw:~ ->	@_mw ?= new MediaWiki!






/** Use the constructor link (@@) if you want to build other instances after a require */
module.exports = new IO!
