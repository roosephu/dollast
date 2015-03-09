// Generated by LiveScript 1.3.1
var mongoose, mongooseAutoIncrement, debug, conn, db, core, config, atomResultSchema, schema, model, count, log, out$ = typeof exports != 'undefined' && exports || this, this$ = this;
mongoose = require('mongoose');
mongooseAutoIncrement = require('mongoose-auto-increment');
debug = require('debug');
conn = require('./conn');
db = require('../db');
core = require('../core');
config = require('../config');
atomResultSchema = new mongoose.Schema({
  _id: false,
  time: Number,
  space: Number,
  message: String,
  score: Number,
  status: String,
  input: String,
  output: String,
  weight: Number
});
schema = new mongoose.Schema({
  open: Boolean,
  code: String,
  lang: String,
  prob: {
    type: Number,
    ref: "problem"
  },
  user: {
    type: String,
    ref: "user"
  },
  round: {
    type: Number,
    ref: "round"
  },
  final: {
    time: Number,
    space: Number,
    message: String,
    score: Number,
    status: String,
    input: String,
    output: String,
    weight: Number
  },
  results: [atomResultSchema]
});
schema.plugin(mongooseAutoIncrement.plugin, {
  model: "solution"
});
out$.model = model = conn.conn.model('solution', schema);
count = 0;
log = debug('dollast:sol');
import$(out$, {
  submit: function*(req, uid){
    var sol, prob, that, body;
    this.acquirePrivilege('login');
    sol = new model({
      code: req.code,
      lang: req.lang,
      prob: req.pid,
      user: uid,
      final: {
        status: "running"
      }
    });
    prob = yield db.prob.model.findById(req.pid, 'config').exec();
    if (!prob) {
      throw new Error('no problem found. ');
    }
    if (that = prob.config.round) {
      sol.round = that;
      yield prob.populate('config.round', 'begTime').execPopulate();
      if (!prob.config.round.isStarted()) {
        this.acquirePrivilege('prob-all');
      }
    }
    yield sol.save();
    body = {
      status: 'OK'
    };
    core.judge(req.lang, req.code, prob.config, sol);
  },
  list: function*(opts){
    var solList;
    opts = import$(clone$(config.solListOpts), opts);
    solList = yield model.find({}, '-code -results').populate('prob', 'outlook.title').sort('-_id').skip(opts.skip).limit(opts.limit).lean().exec();
    return solList;
  },
  show: function*(sid){
    var sol;
    log(sid);
    sol = yield model.findById(sid).populate('prob', 'outlook.title').lean().exec();
    if (!sol.open && sol.user !== this$.getCurrentUser._id) {
      this$.acquirePrivilege('sol-all');
    }
    return sol;
  },
  toggle: function*(sid){
    var sol;
    sol = yield model.findById(sid).exec();
    if (sol.user !== this.getCurrentUser._id) {
      this.acquirePrivilege('sol-all');
    }
    sol.open = !sol.open;
    yield sol.save();
    return {
      open: sol.open
    };
  }
});
function import$(obj, src){
  var own = {}.hasOwnProperty;
  for (var key in src) if (own.call(src, key)) obj[key] = src[key];
  return obj;
}
function clone$(it){
  function fun(){} fun.prototype = it;
  return new fun;
}