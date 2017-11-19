
function getModuleForPath (path) {
    return require(path);
}

module.exports = {

    get LIB () {
        return getModuleForPath(
            require.resolve("./node_modules/.bin/bash.origin.workspace.inf.js")
        ).LIB;
    },

    forPackage: function (basePath) {
        return getModuleForPath(
            basePath + "/node_modules/.bin/bash.origin.workspace.inf.js"
        ).forPackage(basePath);
    }
};
