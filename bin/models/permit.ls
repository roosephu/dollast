require! {
	\mongoose : {Schema}
	\./conn : {conn}
	\debug
}

log = debug \dollast:models:permit

schema = new Schema do
	_id: false
	owner: type: String, ref: \user
	group: String
	access: String

schema.methods.check-access = (user, action) ->
	log "checking permit:", user, {@owner, @group, @access}
	if user.groups.admin != void
		return true

	offset = if @owner == user._id
		0
	else if user.groups[@group] != void
		3
	else
		6

	pos = offset + switch action
		| 'r' => 0
		| 'w' => 1
		| 'x' => 2
		| _ => throw new Error 'invalid action'

	if @access[pos] != action
		throw new Error "user `#{user._id}` cannot perform `#{action}` for doc `{#{@owner}, #{@group}, #{@access}}`"

schema.methods.check-owner = (user) ->
	if @owner != user._id
		throw new Error 'cannot modify groups'

schema.methods.check-admin = (user) ->
	if user.groups.admin == void
		throw new Error "user `#{user._id}` is not an administrator"

# model = conn.model \permit, schema
module.exports = schema
