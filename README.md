A standard library.

# Introduction

Please have a look at the different files in [`src`](./src) for documentation: each folder has its own documentation, and can drive you through the other folders.

# File system layout

* [`README.md`](./README.md): this current file
* [`.gitignore`](./.gitignore): Git related file
* [`package.json`](./package.json): npm package definition
* `node_modules`: 3rd party libraries installed through npm

## Folders

* [`src`](./src): sources of the project

# Versioning

To ignore:

* `node_modules`: generated from [`package.json`](./package.json)

# Contribute

## Development

See [issues](https://github.com/ymeine/std/issues).

# Documentation

This library is a set of standard/core function divided into different modules.

We can distinguish two types of modules:

* the one working on specific types, like arrays or numbers. These are the really _native_ ones
* the others focusing on achieving specific tasks

What resides here are things I consider essential, and use almost everywhere.

Also, this must remain basic and efficient, since it's going to be used a lot.
