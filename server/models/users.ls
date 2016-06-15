require! {
  \mongoose : {Schema}
  \debug
  \bcrypt
  \./conn
  \./permit
}

log = debug \dollast:models:user

schema = new Schema do
  _id: type: String, required: true, trim: true
  password: String
  description: String
  date: type: Date, default: Date.now
  groups: [String]
  permit: permit

schema.methods.check-password = (candidate) ->
  bcrypt.compare-sync candidate, @password

# TODO CSRF
model = conn.conn.model \user, schema
module.exports = model
