
const PATH = require("path");
const FS = require("fs");

function requireCommonInterface (basePath) {
    if (!basePath) {
        basePath = __dirname;
        var path = null;
        while (true) {
            path = PATH.join(basePath, "node_modules/.bin/bash.origin.workspace.inf.js");
            if (FS.existsSync(path)) {
                break;
            }
            path = basePath;
            basePath = PATH.dirname(basePath);
            if (basePath === path) {
                throw new Error("[bash.origin.workspace] While resolving 'LIB' cannot find 'node_modules/.bin/bash.origin.workspace.inf.js' from '" + __dirname + "' nor by walking up the tree!");
            }
        }
    }
    return require(PATH.join(basePath, "node_modules/.bin/bash.origin.workspace.inf.js"));
}

module.exports = {

    get version () {
        return requireCommonInterface().version;
    },

    get node_modules () {
        return requireCommonInterface().node_modules;
    },

    get LIB () {
        return requireCommonInterface().LIB;
    },

    forPackage: function (basePath) {
        return requireCommonInterface(basePath).forPackage(basePath);
    }
};
