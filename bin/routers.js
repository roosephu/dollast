// Generated by LiveScript 1.3.1
var koaRouter, koaJwt, koaValidate, debug, util, path, coBusboy, bluebird, _, config, core, db, tmp, log, image, data, prob, sol, rnd, site, user, paramsValidator, router, out$ = typeof exports != 'undefined' && exports || this;
koaRouter = require('koa-router');
koaJwt = require('koa-jwt');
koaValidate = require('koa-validate');
debug = require('debug');
util = require('util');
path = require('path');
coBusboy = require('co-busboy');
bluebird = require('bluebird');
_ = require('prelude-ls');
config = require('./config');
core = require('./core');
db = require('./db');
tmp = bluebird.promisifyAll(require('tmp'));
log = debug('dollast:router');
image = {
  upload: function*(){
    var parts, part;
    parts = coBusboy(this, {
      autoFields: true
    });
    while (part = yield parts) {
      this.body = {
        link: yield core.uploadImage(part)
      };
    }
    log(this.body);
  }
};
data = require('./ctrls/data');
prob = require("./ctrls/prob");
sol = require('./ctrls/sol');
rnd = require('./ctrls/rnd');
site = require('./ctrls/site');
user = require('./ctrls/user');
paramsValidator = {
  pid: function*(pid, next){
    this.params.pid = pid;
    this.checkParams('pid').toInt().ge(1);
    if (this.errors) {
      return;
    }
    yield next;
  },
  sid: function*(sid, next){
    this.params.sid = sid;
    this.checkParams('sid').toInt().ge(1);
    if (this.errors) {
      return;
    }
    yield next;
  },
  rid: function*(rid, next){
    this.params.rid = rid;
    this.checkParams('rid').toInt().ge(1);
    if (this.errors) {
      return;
    }
    yield next;
  },
  uid: function*(uid, next){
    this.params.uid = uid;
    this.checkParams('uid').len(6, 15);
    if (this.errors) {
      return;
    }
  }
};
router = new koaRouter();
router.param('pid', paramsValidator.pid).param('sid', paramsValidator.sid).param('rid', paramsValidator.rid).param('uid', paramsValidator.uid).get('/problem', prob.list).get('/problem/next-count', prob.nextCount).get('/problem/:pid', prob.show).get('/problem/:pid/brief', prob.brief).get('/problem/:pid/total', prob.total).get('/problem/:pid/repair', prob.repair).get('/problem/:pid/stat', prob.stat).post('/problem/:pid', prob.save)['delete']('/problem/:pid', prob['delete']).get('/data/:pid', data.show).post('/data/:pid/upload', data.upload)['delete']('/data/:pid/:file', data['delete']).post('/solution/submit', sol.submit).get('/solution', sol.list).get('/solution/:sid', sol.show).post('/solution/:sid/toggle', sol.toggle).get('/round', rnd.list).get('/round/next-count', rnd.nextCount).get('/round/:rid', rnd.show).post('/round/:rid', rnd.save).get('/round/:rid/total', rnd.total)['delete']('/round/:rid', rnd['delete']).get('/round/:rid/board', rnd.board).get('/site/theme/:theme', site.theme).get('/site/session', site.session).get('/site/session/login-token', site.loginToken).post('/site/login', site.login).post('/site/logout', site.logout).get('/user/:uid/profile', user.show).post('/user/register/', user.register).post('/user/:uid/modify', user.save).post('/image/upload', image.upload);
out$.router = router = router.middleware();