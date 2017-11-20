
const PATH = require("path");
const FS = require("fs");

module.exports = {

    get LIB () {
        var basePath = __dirname;
        var path = null;
        while (true) {
            path = PATH.join(basePath, "node_modules/.bin/bash.origin.workspace.inf.js");
            if (FS.existsSync(path)) {
                return require(basePath).LIB;
            }
            path = basePath;
            basePath = PATH.dirname(basePath);
            if (basePath === path) {
                throw new Error("[bash.origin.workspace] While resolving 'LIB' cannot find 'node_modules/.bin/bash.origin.workspace.inf.js' from '" + __dirname + "' nor by walking up the tree!");
            }
        }
    },

    forPackage: function (basePath) {
        return require(PATH.join(basePath, "node_modules/.bin/bash.origin.workspace.inf.js")).forPackage(basePath);
    }
};
