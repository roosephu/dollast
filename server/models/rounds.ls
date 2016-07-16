require! {
  \mongoose : {Schema}
  \moment
  \debug
  \prelude-ls : {difference}
  \./conn
  \./permit
  \../config
}

log = debug \dollast:rnd-model

schema = new Schema do
  _id: String
  date: type: Date, default: Date.now
  title: String
  begin-time: type: Date, default: Date.now
  end-time: type: Date, default: Date.now
  problems: [type: Number, ref: \problem]
  permit: permit

schema.index do
  begin-time: 1

schema.statics.next-count = conn.make-next-count config.starting-ids.problems

schema.methods.is-started = ->
  moment!.is-after @begin-time

schema.methods.is-ended = ->
  moment!.is-after @end-time
#
# lock-prob = co.wrap (rid, state, problems) ->*
#   log "locking", problems
#   yield for pid in problems
#     db.prob.model.find-by-id-and-update pid, $set: "config.round": rid .exec!
#
# unlock-prob = co.wrap (rid, state, problems) ->*
#   log "unlocking", problems
#   yield for pid in problems
#     db.prob.model.find-by-id-and-update pid, $unset: "config.round": rid .exec!

schema.statics.get-user-owned-rounds = (uid) ->*
  return yield model.find 'permit.owner': uid, '_id title begTime endTime' .exec!

model = conn.conn.model \round, schema
module.exports = model
