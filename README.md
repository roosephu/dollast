# dollast
the Online Judge for Changjun Middle School

# installation
1. install nodejs(need ES6 support, ver >= 0.11 required), npm, mongodb by your package manager
2. run `npm install` at current directory. It's recommended since Mongoose need to be compiled
3. run `node --harmony bin/server.js`

To make live easier, you can install some other packages:

1. `LiveScript`: to compile the LiveScript code to JavaScript code. then run `lsc -wco . src` to watch and compile the LiveScript codes.
2. `nodemon`: to automatically restart server. run `nodemon --harmony bin/server.js` instead of `node --harmony bin/server.js`

# Todo List
1. user profile(done)
2. parameter cheking(done)
3. error message(done)
4. expire
5. statistics on problems
6. toggle solution

# Known bugs
1. relaxed problem list
2. problem content
