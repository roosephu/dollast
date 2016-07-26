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

schema.methods.set-password = (password) ->
  salt = bcrypt.gen-salt-sync bcrypt.bcrypt-cost
  @password = bcrypt.hash-sync password, salt

schema.methods.check-access = (user, action) ->
  @permit.check-access user, action, @_id, \User

schema.methods.check-owner = (user) ->
  @permit.check-owner user, @_id, \User

schema.methods.check-admin = (user) ->
  @permit.check-admin user, @_id, \User

# TODO CSRF
model = conn.conn.model \user, schema
module.exports = model
