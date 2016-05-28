require! {
  \mongoose : {Schema}
  \moment
  \debug
  \prelude-ls : {difference}
  \./conn
  \./permit
}

log = debug \dollast:rnd-model

schema = new Schema do
  _id: Number
  date: type: Date, default: Date.now
  title: String
  beg-time: type: Date, default: Date.now
  end-time: type: Date, default: Date.now
  probs: [type: Number, ref: \problem]
  permit: permit

schema.statics.next-count = conn.make-next-count 1

schema.methods.is-started = ->
  moment!.is-after @beg-time

schema.methods.is-ended = ->
  moment!.is-after @end-time
#
# lock-prob = co.wrap (rid, state, probs) ->*
#   log "locking", probs
#   yield for pid in probs
#     db.prob.model.find-by-id-and-update pid, $set: "config.round": rid .exec!
#
# unlock-prob = co.wrap (rid, state, probs) ->*
#   log "unlocking", probs
#   yield for pid in probs
#     db.prob.model.find-by-id-and-update pid, $unset: "config.round": rid .exec!

schema.statics.get-user-owned-rounds = (uid) ->*
  return yield model.find 'permit.owner': uid, '_id title begTime endTime' .exec!

model = conn.conn.model \round, schema
module.exports = model
