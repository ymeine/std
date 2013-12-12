function generateDoc(classes)
	renderer = new Renderer 'markdown'

	for klass in classes => generateClassDoc renderer.main!, klass

function generateClassDoc(section, klass)
	section = section.section klass.name
	section.addParagraph klass.desc
	for method in klass.methods => generateMethodDoc section, method

function generateMethodDoc(section, method)
	section = section.section method.name
	"""
	Name: #{method.names.0}
	#{if method.names.length > 1
		"Aliases: #{method.names[1 to] * ', '}"
	else ''
	}
	"""
	section.renderer.list method.