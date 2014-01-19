Big overhaul for first verion on which to work.



This commit is completely monolithic, and targeted mainly one thing: make the library ready for a first version.

Following the initial commit which was a straightforward import of my source code - for both history and safety - this commit prepares the library. By the way, when I encountered some things that could be improved, or simply added, I did it.

## Packaging

Added packaging (for use with npm):

- package definition (package.json)
- .gitignore (for 3rd party node_modules)
- package entry point definition
- main README.md

## Packages refactoring

All modules have been moved as submodules of the package (this is pure refactoring). Also, here are the other changes:

Renamed:

- number <- maths

Added:

- packager: a module that other modules can use to export their values. In short, it allows exporting values under different names, it also allows defining submodules, with lazy loading and so on. All modules, including this one itself, define their entry point with it.

Removed:

- server: separate project exists
- oop: separate project exists
- the rendering feature of io: separate project exists
- win32: nothing to do in a generic programming standard library

Thanks to the introduction of a new module, the `packager`, all modules - including this one itself - and also the (npm) package define their entry point with it. Please refer to the `packager` module for more information. In short, it allows exporting values under different names, it also allows defining submodules, with lazy loading and so on.

To fix inter-dependency between the `packager` modules and the other internal modules it uses, the latters have been refactored a little more. Now there is a `core` entry point, that the packager requires explicitely, and which uses a simple `export`. The module still keeps its entry point definition using the `packager` module, and thus only forwarding the values defined in `core`, with more features then.

This also implies modules required indirectly.

## General refactoring

I refactoring the code to meet my quality requirements:

- having submodules (cf previous section)
- having tests
- having documentation
- adding comments (for code sectionning mainly)

## New features

- object.alias: add a value to an object under different names
- array.transform: now able to do it inplace
- string.replace: now exported, replaces a portion of a string with a given one
- string.insert: inserts a string into another one
- array.reverse: equivalent of array.reverse
- string.split
- string.splitAt
- type.typeof
