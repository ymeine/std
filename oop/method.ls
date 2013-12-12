require! {
	oop
	'./id'
}


MethodInputSpec = oop.Class {
	name: 'Method Input Specifications'

	desc: '''Represents a method input specifications. It is an object describing what kind of inputs a method can receive, and how to process it.'''

	traits: [
		id.Identifiable
	]

	schema:
		properties: [
			{
				names: <[ args ]>
				desc: '''Args map'''
			}
			{
				names: <[ values ]>
				desc: '''Values map'''
			}
			{
				names: <[ schema ]>
				desc: '''A cschema for classic input -> spec'''
			}
		]
}

MethodInput = oop.Class {
	name: 'Method Input'

	desc: '''Might be used to represent an actual input to the method. Not to the real Function object passed as the callback of the method, but of the generated wrapper.'''


}

Method = oop.Class {
	name: 'Method'

	desc: '''A method, function. It is a piece of executable code, executing in a given context, and accepting different kind of inputs. It also returns different kind of outputs. It can even trigger some events.'''

	schema:
		inputToSpec:
			'Function': 'def'
		properties: [
			{names: <[ id ]>, type: id.ID}
			{names: <[ def definition ]>, type: oop.types.Function}
			{names: <[ input schema in ]>, type: MethodInputSpec}
		]

}
