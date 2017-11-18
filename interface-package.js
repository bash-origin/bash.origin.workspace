
function getModuleForPath (path) {
    return require(require("fs").readFileSync(path).toString().replace(/\n$/, ""));
}

module.exports = {

    get LIB () {
        return getModuleForPath(
            require.resolve("./node_modules/.bin/.bash.origin.workspace.inf.js.path")
        ).LIB;
    },

    forPackage: function (basePath) {
        return getModuleForPath(
            basePath + "/node_modules/.bin/.bash.origin.workspace.inf.js.path"
        ).forPackage(basePath);
    }
};
