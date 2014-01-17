require 'packager' .export {
	module

	desc: '''
		Package entry point
	'''

	submodules:
		# Primitives -----------------------------------------------------------

		number: <[
			num
			nb
			math
			maths
		]>
		string: <[
			str
		]>
		array: <[
			arrays
			arr
		]>
		object: <[
			obj
		]>

		date: <[]>
		type: <[
			types
			typing
		]>

		# Other ----------------------------------------------------------------

		packager: <[
			package
			pack
		]>

		io: <[
			i-o
			i_o
			i/o
			input-output
			input_output
			input/output
			inputOutput
			input output
		]>

		logging: <[
			log
			logger
		]>
		opt: <[
			optimization
			optimizer
			perf
			performance
			performances
		]>
		proxy: <[]>
}
