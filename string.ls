require! {
# ---------------------------------------------------------------------- Own STD
	'std/maths'
}



/** Capitalizes the first letter of the word, leaving the rest as is */
capitalize = ->
	if not it? => throw {msg: 'No value given'}

	if it.length > 0 => it.0.toUpperCase! + it.slice(1) else ''

/** Splits a string on capital letters, keeping them */
getCamelCaseParts = ->
	if not it? => throw {msg: 'No value given'}

	allParts = it.split /([A-Z])/g

	splitParts = allParts[1 to]
	joinedParts = [[part, splitParts[index + 1]].join '' for part, index in splitParts by 2]

	if allParts.0.length > 0 => [allParts.0] ++ joinedParts
	else joinedParts


escape = (input, chars, char = '\\') ->
	if not input? => throw {msg: 'No input given'}

	re = new RegExp "[#{["\\#{..}" for chars] * ''}]" \g
	input.replace re, "#{char}$&"



surround = (str, input) -->
	if not str? => throw {msg: 'No string given'}
	if not input? => throw {msg: 'No input given'}

	"#str#input#str"

wrap = (str, input) -->
	if not str? => throw {msg: 'No string given'}
	if not input? => throw {msg: 'No input given'}

	"#str#input#{str.reverse!}"

replace = (str, start, content) ->
	(str.substring 0, start) + content + (str.substring start + content.length, str.length)



module.exports = {
	capitalize

	getCamelCaseParts
	camelCaseParts: getCamelCaseParts
	camelcaseparts: getCamelCaseParts
	camelCase: getCamelCaseParts
	camelcase: getCamelCaseParts

	escape

	surround
}
