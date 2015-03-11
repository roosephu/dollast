// Generated by LiveScript 1.3.1
var mongoose, moment, debug, co, _, conn, db, log, schema, lockProb, unlockProb, model, count, out$ = typeof exports != 'undefined' && exports || this, this$ = this;
mongoose = require('mongoose');
moment = require('moment');
debug = require('debug');
co = require('co');
_ = require('prelude-ls');
conn = require('./conn');
db = require('../db');
log = debug("dollast:rnd-model");
schema = new mongoose.Schema({
  _id: Number,
  title: String,
  begTime: Date,
  endTime: Date,
  probs: [{
    type: Number,
    ref: "problem"
  }]
});
schema.methods.isStarted = function(){
  return moment().isAfter(this.begTime);
};
schema.methods.isEnded = function(){
  return moment().isAfter(this.endTime);
};
lockProb = co.wrap(function*(rid, state, probs){
  var pid;
  log("locking", probs);
  yield (function(){
    var i$, ref$, len$, results$ = [];
    for (i$ = 0, len$ = (ref$ = probs).length; i$ < len$; ++i$) {
      pid = ref$[i$];
      results$.push(db.prob.model.findByIdAndUpdate(pid, {
        $set: {
          "config.round": rid
        }
      }).exec());
    }
    return results$;
  }());
});
unlockProb = co.wrap(function*(rid, state, probs){
  var pid;
  log("unlocking", probs);
  yield (function(){
    var i$, ref$, len$, results$ = [];
    for (i$ = 0, len$ = (ref$ = probs).length; i$ < len$; ++i$) {
      pid = ref$[i$];
      results$.push(db.prob.model.findByIdAndUpdate(pid, {
        $unset: {
          "config.round": rid
        }
      }).exec());
    }
    return results$;
  }());
});
model = conn.conn.model('round', schema);
count = 0;
import$(out$, {
  modify: function*(rid, rnd){
    var that, doc, oldProbs, newProbs;
    this$.acquirePrivilege('rnd-all');
    if (that = rnd.begTime) {
      rnd.begTime = new Date(that);
    }
    if (that = rnd.endTime) {
      rnd.endTime = new Date(that);
    }
    doc = yield model.findById(rid).exec();
    doc || (doc = new model);
    if (rnd.probs) {
      oldProbs = (that = doc.probs)
        ? that
        : [];
      newProbs = rnd.probs;
      log(oldProbs, newProbs);
      yield unlockProb(rid, false, _.difference(oldProbs, newProbs));
      yield lockProb(rid, true, _.difference(newProbs, oldProbs));
    }
    import$(doc, rnd);
    yield doc.save();
    return true;
  },
  show: function*(rid, opts){
    var rnd;
    opts == null && (opts = {});
    opts.mode || (opts.mode = "view");
    if (opts.mode === "total") {
      this$.acquirePrivilege('rnd-all');
    }
    rnd = yield model.findById(rid, '-__v').populate('probs', '_id outlook.title').lean().exec();
    if (opts.mode === "view" && moment().isBefore(rnd.begTime)) {
      rnd.probs = [];
      rnd.started = false;
    } else {
      rnd.started = true;
    }
    return rnd;
  },
  board: function*(rid, opts){
    var sols, results, i$, len$, sol, key$, ref$, cur, user, value;
    opts == null && (opts = {});
    log('board...');
    sols = yield db.sol.model.find({
      round: rid
    }, 'final.score prob user').lean().exec();
    results = {};
    for (i$ = 0, len$ = sols.length; i$ < len$; ++i$) {
      sol = sols[i$];
      results[key$ = sol.user] || (results[key$] = {});
      (ref$ = results[sol.user])[key$ = sol.prob] || (ref$[key$] = {});
      cur = results[sol.user][sol.prob];
      log(cur, sol);
      if (cur._id == null || cur._id < sol._id) {
        cur._id = sol._id;
        cur.score = sol.final.score;
      }
    }
    for (user in results) {
      value = results[user];
      results[user].total = _.sum(
      _.map(fn$)(
      _.values(
      value)));
    }
    log(results);
    return results;
    function fn$(it){
      return it.score;
    }
  },
  list: function*(){
    return yield model.find({}, '_id title').lean().exec();
  },
  'delete': function*(rid){
    this$.acquirePrivilege('rnd-all');
    return yield model.findByIdAndRemove(rid).lean().exec();
  },
  nextCount: function*(){
    this.acquirePrivilege('rnd-all');
    return yield conn.nextCount(model, count);
  }
});
function import$(obj, src){
  var own = {}.hasOwnProperty;
  for (var key in src) if (own.call(src, key)) obj[key] = src[key];
  return obj;
}