
const PATH = require("path");
const FS = require("fs");


const INTERFACE = require("./node_modules/.bin/bash.origin.workspace.inf.js");

exports.LIB = INTERFACE.LIB;

console.log("exports.LIB", exports.LIB);

console.log("exports.LIB.LODASH 11", exports.LIB.LODASH.merge);
