#!/usr/bin/env node

const PATH = require("path");
const FS = require("fs");

const BASE_PATH = PATH.dirname(FS.realpathSync(__filename));

const NODE_MODULES = PATH.join(
    BASE_PATH,
    "dependencies/.node-" + process.version.split(".")[0],
    "node_modules"
);


if (!process.env.BO_SYSTEM_CACHE_DIR) {
    process.env.BO_SYSTEM_CACHE_DIR = NODE_MODULES;
}

function makeLIB (options) {
    options = options || {};
    var code = [
        'LIB = {'
    ];
    var usedAliases = {};
    function addGetter (name, path) {
        if (usedAliases[name]) {
            return;
        }
        usedAliases[name] = true;
        code.push([
            '"_path_' + PATH.basename(path) + '": "' + path + '",',
            'get ' + name + '() {',
            '    delete this.' + name + ';',
            '    return (this.' + name + ' = require("' + path + '"));',
            '},'
        ].join("\n"));
    }
    var basePaths = [];
    if (options.packageBasePath) {
        basePaths.push(PATH.join(options.packageBasePath, "node_modules"));
    }
    basePaths.push(API.node_modules);
    basePaths.forEach(function (basePath) {
        if (!FS.existsSync(basePath)) {
            return;
        }
        FS.readdirSync(basePath).map(function (filename) {
            var name = filename.toUpperCase().replace(/[\.-]/g, "_");
            if (!/^[A-Z0-9_]+$/.test(name)) {
                return;
            }
            addGetter(name, PATH.join(basePath, filename));
        });
    });
    addGetter('PATH', 'path');
    addGetter('FS', 'fs');
    addGetter('URI', 'uri');
    addGetter('HTTP', 'http');
    addGetter('HTTPS', 'https');
    addGetter('CRYPTO', 'crypto');
    code.push('};');
    var LIB = null;
    eval(code.join("\n"));
    return LIB;
}


function makeAPI (options) {

    var API = {
        
        version: require(PATH.join(
                BASE_PATH,
                "package.json"
            )).version,
    
        node_modules: NODE_MODULES,
    
        get LIB () {
            delete this.LIB;
            const LIB = (this.LIB = makeLIB(options));

            LIB.resolve = function (uri) {
                var uri_parts = uri.split("/");
                if (!LIB["_path_" + uri_parts[0]]) {
                    throw new Error("Cannot resolve uri '" + uri + "'!");
                }
                return PATH.join(LIB["_path_" + uri_parts[0]], uri_parts.slice(1).join("/"));
            };
            return LIB;
        },
        
        forPackage: function (basePath) {
            return makeAPI({
                packageBasePath: basePath
            });
        }
    };

    return API;
}

const API = module.exports = makeAPI();

/*
// NOTE: This is not a good idea. If we run it from here we need to clean the PATH
//       as it may contain commands that are broken (e.g. `node_modules/.bin/touch`)
// The NodeJS version cannot change between install and runtime.
if (!FS.existsSync(API.node_modules)) {

    process.stdout.write("TEST_MATCH_IGNORE>>>\n");
    process.stderr.write("TEST_MATCH_IGNORE>>>\n");
    
    process.stdout.write("[bash.origin.workspace] Install dependencies in '" + BASE_PATH + "':\n");

    var env = process.env;
    delete env.BO_LOADED;
    env.COMMON_PACKAGE_ROOT = BASE_PATH;
    Object.keys(env).forEach(function (name) {
        if (!/^npm_/.test(name)) {
            return;
        }
        delete env[name];
    });
    require("child_process").execSync("npm install --production", {
        cwd: BASE_PATH,
        stdio: "inherit",
        env: env
    });

    process.stdout.write("<<<TEST_MATCH_IGNORE\n");
    process.stderr.write("<<<TEST_MATCH_IGNORE\n");
}
*/