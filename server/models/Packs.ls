require! {
  \mongoose : {Schema}
  \moment
  \debug
  \prelude-ls : {difference}
  \co
  \./conn
  \./permit
  \../config
}

log = debug \dollast:model:pack

schema = new Schema do
  _id: String
  date: type: Date, default: Date.now
  title: String
  begin-time: type: Date, default: Date.now
  end-time: type: Date, default: Date.now
  problems: [type: Number, ref: \Problem]
  permit: permit

schema.index do
  begin-time: 1

schema.statics.next-count = conn.make-next-count config.starting-ids.problems

schema.methods.is-started = ->
  moment!.is-after @begin-time

schema.methods.is-ended = ->
  moment!.is-after @end-time

schema.methods.get-display-name = -> \Pack 

# lock-prob = co.wrap (rid, state, problems) ->*
#   log "locking", problems
#   yield for pid in problems
#     db.prob.model.find-by-id-and-update pid, $set: "config.pack": rid .exec!
#
# unlock-prob = co.wrap (rid, state, problems) ->*
#   log "unlocking", problems
#   yield for pid in problems
#     db.prob.model.find-by-id-and-update pid, $unset: "config.pack": rid .exec!

schema.statics.get-packs-by-user = (user) ->*
  return yield model.find 'permit.owner': user, '_id title begTime endTime' .exec!

model = conn.conn.model \pack, schema

co ->*
  if not yield model.find-by-id \0 .count! .exec!
    default-pack = new model do
      _id: \0
      title: \Default
      begin-time: new Date(0)
      end-time: new Date(1e14)
      permit: 
        owner: \admin
        group: \packs
        access: \rwxrw-rw-
    yield default-pack.save!

module.exports = model
