
console.log("Starting server:", __filename);

const path = require("path");
const fs = require("fs");

console.log("server.js:", fs.readFileSync(path.join(__dirname, "server.js"), "utf8"));

const http = require('http');

const hostname = '0.0.0.0';
const port = process.env.PORT || 8080;

http.createServer(function (req, res) {

    if (/^\/status(?:\?|$)/.test(req.url)) {
        res.end("OK:" + req.url.replace(/^.+?(?:\?|&)rid=([^=]+)(?:&|$)/, "$1"));
        return;
    }

    console.log("Request:", req.url);
    res.writeHead(200, {
        'Content-Type': 'text/plain'
    });
    res.end('Hello World from Workspace in dockerized NodeJS process [' + fs.readFileSync(path.join(__dirname, "file.txt"), "utf8") + ']!');

}).listen(port, hostname, function () {
    console.log(`Server running at http://${hostname}:${port}/`);
});
