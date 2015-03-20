// Generated by LiveScript 1.3.1
var koa, koaJson, koaStatic, koaBodyparser, koaGenericSession, koaConditionalGet, koaValidate, koaRouter, koaJade, koaSend, koaEtag, koaJwt, util, path, fs, debug, _, config, db, app, log, routers, out$ = typeof exports != 'undefined' && exports || this;
koa = require('koa');
koaJson = require('koa-json');
koaStatic = require('koa-static');
koaBodyparser = require('koa-bodyparser');
koaGenericSession = require('koa-generic-session');
koaConditionalGet = require('koa-conditional-get');
koaValidate = require('koa-validate');
koaRouter = require('koa-router');
koaJade = require('koa-jade');
koaSend = require('koa-send');
koaEtag = require('koa-etag');
koaJwt = require('koa-jwt');
util = require('util');
path = require('path');
fs = require('fs');
debug = require('debug');
_ = require('prelude-ls');
config = require('./config');
db = require('./db');
out$.app = app = koa();
log = debug('dollast:server');
if (!db) {
  log("No Database found");
}
app.use(koaConditionalGet());
app.use(koaEtag());
app.use(koaJson());
app.use(koaValidate());
app.use(koaBodyparser({
  extendTypes: {
    json: ['application/x-javascript'],
    multipart: ['multipart/form-data']
  }
}));
app.keys = config.keys;
app.use(koaGenericSession({
  cookie: {
    maxAge: 1000 * 60 * 5
  }
}));
app.use(function*(next){
  var e;
  try {
    log(this.req.method + " " + this.req.url);
    yield next;
  } catch (e$) {
    e = e$;
    log("catched.", e);
    this.status = e.status || 400;
    this.body = [{
      error: e.message
    }];
  }
  if (this.errors) {
    this.status = 400;
    this.body = this.errors;
  }
});
app.use(function*(next){
  this.check = function(obj, key, errMsg){
    if (!obj) {
      if (!this.errors) {
        this.errors = [];
      }
      this.errors.push(errMsg + "");
      return new koaValidate.Validator(this, null, null, false, null, false);
    } else {
      return new koaValidate.Validator(this, key, obj[key], obj[key] != null, obj);
    }
  };
  yield next;
});
app.use(function*(next){
  var ref$, i$, len$, folders;
  db.bindCtx(this);
  (ref$ = this.session).theme || (ref$.theme = config['default'].theme);
  (ref$ = this.session).priv || (ref$.priv = config['default'].priv);
  if ((ref$ = this.method) === 'HEAD' || ref$ === 'GET') {
    for (i$ = 0, len$ = (ref$ = ["public", "theme/" + this.session.theme]).length; i$ < len$; ++i$) {
      folders = ref$[i$];
      if (yield koaSend(this, this.path, {
        index: 'index.html',
        maxAge: 864000000,
        root: path.resolve(folders)
      })) {
        return;
      }
    }
  }
  yield next;
});
app.use(koaJade.middleware({
  viewPath: "theme/dollast",
  pretty: true,
  compileDebug: false
}));
app.use(function*(next){
  var extname;
  extname = path.extname(this.req.url);
  if (this.req.url === "/") {
    yield this.render("index.html", {}, true);
  } else if (extname === ".html") {
    yield this.render(this.req.url, {}, true);
  } else {
    yield next;
  }
});
routers = require('./routers');
app.use(routers.pubRouter);
app.use(koaJwt({
  secret: config.secret,
  passthrough: false
}));
app.use(function*(next){
  log("request", this.request.body, "jwt", this.user, "query", this.query);
  yield next;
});
app.use(routers.privRouter);
console.log("Listening port 3000");
app.listen(3000);