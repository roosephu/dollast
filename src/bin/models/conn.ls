require! {
  'mongoose'
  'mongoose-deep-populate'
  'mongoose-auto-increment'
  'moment'
  'bluebird'
}

export conn = mongoose.create-connection 'mongodb://localhost/dollast'
mongoose-auto-increment.initialize conn
mongoose.plugin mongoose-deep-populate

export next-count = (model, count) ->
  ->*
    counter ||= 1
    while yield model.find-by-id counter, '_id' .lean! .exec!
      counter += 1
    return counter
