require! {
	array
	date
	io
	logging
	number
	object
	opt
	proxy
	string
	type
}



primitives = {
	number
	num: number
	nb: number
	math: number
	maths: number

	string
	str: string

	array
	arrays: array
	arr: array

	object
	obj: object

	date

	type
}



export {
	primitives
	native: primitives

	io
	input-output: io

	logging
	log: logging

	opt
	optimization: opt

	proxy
} <<< primitives
