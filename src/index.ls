require! {
	packager
}

packager.export {
	module

	submodules: {
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

		packager: <[]>

		io: <[
			i-o
			i_o
			i/o
			input-output
			input_output
			input/output
			inputOutput
		]>

		logging: <[log]>
		opt: <[optimization]>
		proxy: <[]>
	}
}
