#!/usr/bin/env node

const PATH = require("path");
const FS = require("fs");

const BASE_PATH = PATH.dirname(FS.realpathSync(__filename));


exports.version = require(PATH.join(
    BASE_PATH,
    "package.json"
)).version;

exports.node_modules = PATH.join(
    BASE_PATH,
    "dependencies/.node-" + process.version.split(".")[0],
    "node_modules"
);


var code = [
    'LIB = {'
];
FS.readdirSync(exports.node_modules).map(function (filename) {
    var name = filename.toUpperCase().replace(/[\.-]/g, "_");
    code.push([
        'get ' + name + '() {',
        '    delete this.' + name + ';',
        '    return (this.' + name + ' = require("' + PATH.join(exports.node_modules, filename) + '"));',
        '},'
    ].join("\n"));
});
code.push('};');
var LIB = null;
eval(code.join("\n"));
exports.LIB = LIB;
