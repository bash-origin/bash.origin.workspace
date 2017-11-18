
module.exports = {

    get LIB () {
        return require("./node_modules/.bin/bash.origin.workspace.inf.js").LIB;        
    },

    forPackage: function (basePath) {
        return require(
            require("fs").readFileSync(
                require.resolve(basePath + "/node_modules/.bin/.bash.origin.workspace.inf.js.path")
            ).toString()
        ).forPackage(basePath);
    }
};
