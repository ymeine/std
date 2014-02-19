Package's sources root.

# File system layout

* [`README.md`](./README.md): this current main documentation file
* [`index.ls`](./index.ls): package entry point (LiveScript)
* [`index.js`](./index.js): package entry point (JavaScript) - loads LiveScript and uses above entry point
* [`node_modules`](./node_modules): contains the modules of the package, exported by the package's entry point

# Versioning rules

_None_

# Documentation

The goal of this folder is to have the package entry point definition.

[`index.js`](./index.js) is the file pointed by the npm package definition (`package.json`). Therefore when the package is required in Node.js (using `require('...')`), this is actually this file which is loaded and returned.

However, this file is just a convenience to make sure that the package will work in a JavaScript system whatever which language is used underneath. In our case, the package is coded in [LiveScript](http://livescript.net), and the real entry point is defined in a LiveScript file. That's why the JavaScript index file do two things:

* loads the LiveScript engine (make `require` work with it)
* loads and forwards the entry point

[`index.ls`](./index.ls) thus defines the entry point of the package.

It uses the [packager module](./node_modules/packager) for that, please see its documentation to know which features it provides.

In practice all modules contained in [`node_modules`](./node_modules) are exported. They are accessible through different names (aliases), and they are lazily loaded.
