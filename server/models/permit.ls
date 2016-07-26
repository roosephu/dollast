require! {
	\mongoose : {Schema}
	\./conn : {conn}
	\debug
	\../controllers/err : {assert}
}

log = debug \dollast:models:permit

schema = new Schema do
	_id: false
	owner: type: String, ref: \user
	group: String
	access: String

schema.methods.check-access = (user, action, _id, type) ->
	log "checking permit:", user, action, {@owner, @group, @access}
	# if user.groups.admin != void
		# return true

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
		| _ => assert false, _id, type, "invalid action `#{action}`"
	
	assert @access[pos] == action, _id, type, "user `#{user._id}` cannot perform `#{action}` for doc `{#{@owner}, #{@group}, #{@access}}`"

schema.methods.check-owner = (user, _id, type) ->
	assert @owner == user._id, _id, type, 'cannot modify groups'

schema.methods.check-admin = (user, _id, type) ->
	assert user.groups.admin, _id, type, "user `#{user._id}` is not an administrator"

# model = conn.model \permit, schema
module.exports = schema
