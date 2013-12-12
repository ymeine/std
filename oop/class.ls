require! {
	oop
	'./id'
}

Class = oop.Class {
	name: 'Class'

	desc: '''A class like in classical OOP. But for JavaScript, so expect prototype stuff, and meta-programming capabilities!'''

	traits: [
		id.Identifiable
	]

	schema:
		inputToSpec:
			'String': 'name'
			'Function': 'init'
		properties: [
			{names: <[id]>}
		]

}