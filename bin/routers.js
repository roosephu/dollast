// Generated by LiveScript 1.3.1
(function(){
  var koaRouter, koaValidate, debug, util, path, coBusboy, bluebird, _, config, core, db, log, image, data, prob, sol, rnd, site, user, paramsValidator, router, out$ = typeof exports != 'undefined' && exports || this;
  koaRouter = require('koa-router');
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
      this.checkParams('pid').toInt().ge(0);
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
      this.checkParams('rid').toInt().ge(0);
      if (this.errors) {
        return;
      }
      yield next;
    },
    uid: function*(uid, next){
      this.params.uid = uid;
      this.checkParams('uid').len(config.uidMinLen, config.uidMaxLen);
      if (this.errors) {
        return;
      }
      yield next;
    }
  };
  router = new koaRouter();
  router.param('pid', paramsValidator.pid).param('sid', paramsValidator.sid).param('rid', paramsValidator.rid).param('uid', paramsValidator.uid).get('/site/theme/:theme', site.theme).get('/site/token', site.token).post('/site/login', site.login).post('/site/logout', site.logout).post('/user/register', user.register).post('/user/:uid', user.save).get('/user/:uid/profile', user.profile).get('/user/:uid/privileges', user.getPrivileges).get('/round', rnd.list).get('/round/:rid', rnd.show).get('/round/:rid/board', rnd.board).post('/round/:rid', rnd.save).get('/round/:rid/total', rnd.total).get('/round/:rid/publish', rnd.publish)['delete']('/round/:rid', rnd.remove).get('/problem', prob.list).get('/problem/:pid', prob.show).post('/problem/:pid', prob.save)['delete']('/problem/:pid', prob.remove).get('/problem/:pid/brief', prob.brief).get('/problem/:pid/total', prob.total).get('/problem/:pid/repair', prob.repair).get('/problem/:pid/stat', prob.stat).get('/solution', sol.list).get('/solution/:sid', sol.show).post('/solution/submit', sol.submit).post('/solution/:sid/toggle', sol.toggle).get('/data/:pid', data.show).post('/data/:pid/upload', data.upload)['delete']('/data/:pid/:file', data['delete']);
  out$.router = router = router.middleware();
}).call(this);
