// Generated by LiveScript 1.3.1
var mongoose, conn, debug, log, schema, model, out$ = typeof exports != 'undefined' && exports || this, this$ = this;
mongoose = require('mongoose');
conn = require('./conn');
debug = require('debug');
log = debug("user-model");
schema = new mongoose.Schema({
  _id: String,
  pswd: String,
  privList: [String]
});
model = conn.conn.model('user', schema);
import$(out$, {
  query: function(uid, pswd, salt, done){
    return model.findById(uid, function(err, user){
      if (err) {
        return done(err);
      } else if (!user || user.pswd !== pswd) {
        console.log('No such user');
        return done(null, false);
      } else {
        console.log('authenticate OK');
        return done(null, user);
      }
    });
  },
  show: function*(uid){
    log("uid: " + uid);
    return yield model.findById(uid, "privList").exec();
  },
  modify: function*(user){
    return yield model.update({
      _id: user._id
    }, {
      $set: user
    }, {
      upsert: true,
      overwrite: true
    }).exec();
  },
  register: function*(user){
    user.privList = [''];
    user = new model(user);
    yield user.save();
    return "OK";
  }
});
function import$(obj, src){
  var own = {}.hasOwnProperty;
  for (var key in src) if (own.call(src, key)) obj[key] = src[key];
  return obj;
}