require! {
	\mongoose : {Schema}
	\./conn : {conn}
	\debug
	\../Exception
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
		| \r => 0
		| \w => 1
		| \x => 2
		| _ => throw new Exception 'invalid action'

	if @access[pos] != action
		throw new Exception "user `#{user._id}` cannot perform `#{action}` for doc `{#{@owner}, #{@group}, #{@access}}`"

schema.methods.check-owner = (user) ->
	if @owner != user._id
		throw new Exception 'cannot modify groups'

schema.methods.check-admin = (user) ->
	if user.groups.admin == void
		throw new Exception "user `#{user._id}` is not an administrator"

# model = conn.model \permit, schema
module.exports = schema
