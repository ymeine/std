Package sources root.

# File system layout

* [`README.md`](./README.md): this current file
* [`index.ls`](./index.ls): package entry point (LiveScript)
* [`index.js`](./index.js): package entry point (JavaScript)
* [`node_modules`](./node_modules): contains submodules, exported by the entry points

# Versioning

To version: _everything_.

# Documentation

The goal of this folder is to have this package's entry points definition.

[`index.js`](./index.js) is the file pointed by the npm package definition (`package.json`). Therefore when the package is required in Node.js (`require(std)`), this is actually the content of this file which is loaded and returned.

However, this file is just a _hack_ to make sure that the package will work whatever which language is used underneath. In our case, the package is coded in LiveScript, and the real entry points are defined in a LiveScript file. That means that this JavaScript index file must do two things:

* load the LiveScript engine (make `require` work with it)
* load and forward the entry points

[`index.ls`](./index.ls) thus defines the entry points of the package.

It uses the [packager module](./node_modules/packager) for that, please see its documentation to know wich features it provides.

In practice all modules contained in [`node_modules`](./node_modules) are exported. They are accessible through different names (aliases), and they are lazily loaded.
