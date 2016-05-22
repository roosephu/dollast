require! {
  \mongoose
#   'mongoose-deep-populate'
  \moment
  \bluebird
  \debug
}
mongoose.Promise = bluebird

export conn = mongoose.create-connection 'mongodb://localhost/dollast'
# mongoose-auto-increment.initialize conn
# mongoose.plugin mongoose-deep-populate

log = debug \dollast:conn

export make-next-count = (model, counter) ->
  counter ||= 1
  ->*
    log "database counter", counter, typeof counter
    while yield model.find-by-id counter, \_id .lean! .exec!
      counter += 1
    return counter
