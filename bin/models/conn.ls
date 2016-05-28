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

export make-next-count = (counter) ->
  counter ||= 1
  ->*
    while 1 == yield @find-by-id counter, \_id .count! .exec!
      counter += 1
    return counter
