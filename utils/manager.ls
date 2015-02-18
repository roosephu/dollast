require! mongoose

ObjectId = mongoose.Schema.Types.ObjectId

db = mongoose.create-connection 'mongodb://localhost/dollast'

problem = db.model 'problem',
  _id: Number
  desc: String
  title: String
  time-lmt: Number
  space-lmt: Number
  in-fmt: String
  out-fmt: String
  sample-in: String
  sample-out: String
  stat: {}

user-model = db.model 'user',
    _id: String
    pswd: String
# problem.remove!.exec!
# quit!

db.on 'error', console.error.bind console, 'connection error'
  .once 'open', (cb) ->
    console.log 'connection succeed...'

first-prob = new problem(
  _id: 0
  desc: 'Given A, B output A+B'
  title: 'A+B problem'
  in-fmt: 'A B'
  out-fmt: 'A+B'
  time-lmt: 1
  space-lmt: 128
  sample-in: "2 3\n"
  sample-out: "5\n"
)

second-prob = new problem(
  _id: 1
  desc: 'Given A, B output A*B'
  title: 'A*B problem'
  in-fmt: 'A B'
  out-fmt: 'A*B'
  time-lmt: 1
  space-lmt: 128
  sample-in: "2 3\n"
  sample-out: "6\n"
)

sol-model = db.model 'solution',
  _id: Number
  code: String
  user:
    type: String
    ref: "user"
  prob:
    type: Number
    ref: "problem"

for prob in [] # [first-prob, second-prob]
  prob.save (err) ->
    if err
      return console.log 'cannot save...'
    console.log 'save ok...'

problem.find (err, all) ->
  for eg in all
    console.log "eg: #{JSON.stringify eg.toJSON!}"

lyp = new user-model(
  _id: 'roosephu'
  pswd: 'drdrd'
)
# user-model.remove!.exec!
# lyp.save!

/*user-model.find-by-id 'roosephu' .populate 'sol' .exec (err, lyp) ->
  console.log "adfs: #{JSON.stringify lyp}"
  # lyp.save!*/

first-sol = new sol-model(
  _id: 0
  code: 'hello world'
  user: 'roosephu'
  prob: 0
)
# first-sol.save!

sol-model.find (err, all) ->
  for eg in all
    console.log "eg: #{JSON.stringify(eg.toJSON!)}" # "#{eg.desc} #{eg.choice}"

user-model.find (err, all) ->
  if err
    return console.log 'cannot find'
  for eg in all
    console.log "eg: #{JSON.stringify(eg.toJSON!)}" # "#{eg.desc} #{eg.choice}"


sol-model .find-by-id 0 .populate 'user prob' .exec (err, pop) ->
  console.log "populated: #{JSON.stringify pop}"
