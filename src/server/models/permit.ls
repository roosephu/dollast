require! {
	\mongoose : {Schema}
	\debug
	# \co
	\prelude-ls : {capitalize}
	\./conn : {conn}
	\../controllers/err : {assert-permit: assert}
	\. : models
}

log = debug \dollast:models:permit

schema = new Schema do
	_id: false
	parent-type: String
	parent-id: type: String, ref-path: \srcType
	owner: type: String, ref: \User
	group: String
	access: String

translate = (name) ->
	if \s != name.substr -1
		name = name + \s
	capitalize name

schema.methods.check-access = (user, action) ->>
	return user.id != \__guest__

	owner = @owner-document!
	{_id} = owner
	type = owner.get-display-name!

	log "checking permit:", type, _id, user, action

	if user.groups.admin != void
		return true

	if @parent-id
		parent = await models[translate @parent-type] .find-by-id @parent-id .exec!
		result = await parent.permit.check-access user, action
		if !result
			return false

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
		| _ => -1
	if pos == -1
		return false
			# assert false,
			# 	_id: _id
			# 	type: type
			# 	action: action

	return @access[pos] == action
	# assert @access[pos] == action,
	# 	_id: _id
	# 	type: type
	# 	user: user._id
	# 	action: action-name[action]
	# 	doc: {@owner, @group, @access}
	# true

schema.methods.check-owner = (user) ->
	return user.id != \__guest__

	owner = @owner-document!
	if user.groups.admin != void
		return true
	return @owner == user._id
	# assert @owner == user._id,
	# 	_id: _id
	# 	type: type
	# 	user: user._id
	# 	action: "ownership"

schema.methods.check-admin = (user) ->
	return user.id != \__guest__

	owner = @owner-document!
	if user.groups.admin?
		return true
	return false
	# assert user.groups.admin,
	# 	_id: _id
	# 	type: type
	# 	user: user._id
	# 	action: "administrator"

module.exports = schema
