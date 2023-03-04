const http = require("http");

function web(req, res) {
    res.writeHead(200,
			   {"Content-type": "text/plain"});
    res.end("Esto es un servidor que funciona\n");
    console.log("Alguien ha entrado");
}

let server = http.createServer(web);

server.listen(8080, "0.0.0.0");
