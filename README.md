# dollast
the Online Judge for Changjun Middle School

# installation
1. install nodejs(need ES6 support, ver >= 0.11 required), npm, mongodb by your package manager
2. run `npm install` at current directory. It's recommended since Mongoose/bcrypt need to be compiled
3. run `npm run server`

To make live easier, you can install some other packages:

1. `LiveScript`: to compile the LiveScript code to JavaScript code. then run `lsc -wco . src` to watch and compile the LiveScript codes.
2. `nodemon`: to automatically restart server. run `nodemon --harmony bin/server.js` instead of `node --harmony bin/server.js`

## useful commands
1. `npm run server` to run server
3. `webpack` to watch JS files in client side

# usage
## how to make a round

1. create an empty round without any problems; keep the round id in this step.
2. create problems as you like; remember to set round id when creating;
3. that's it!

## how to reuse a problem
I give up. The solution is... to create the same problem twice!

The problem is that we don't know when to cancel a problem, i.e., when to delete the `rid` attribute of this problem. And I think there should be duplicated problems, even if I add the feature that we can reuse problems in different rounds.

If you want, you can delete this attribute (the `rid` attr for each problem) manually, and then you can reuse it. To make it more handy, there is one API named `round.publish` which releases all problems in this round.

## some general settings

### permission manage
Each resource is managed by a binary code `ABC`, while A indicates the permission of the owner, and B indicates that of the users in this group, and C is that of everyone.

`r`: get descriptions
`w`: change descriptions
`x`: submit

## JSON APIs
Visit http://jsonapi.org/ to find more details.
