# dollast
the Online Judge for Changjun Middle School 

# installation
1. install nodejs(need ES6 support, ver >= 0.11 required), npm, mongodb by your package manager
2. run `npm install` at current directory
3. run `node --harmony server.js`

To make live easier, you can install some other packages:

1. `LiveScript`: to compile the LiveScript code to JavaScript code. then run `lsc -wco . src` to watch and compile the LiveScript codes.
2. `nodemon`: to automatically restart server. run `nodemon --harmony server.js` instead of `node --harmony server.js`
