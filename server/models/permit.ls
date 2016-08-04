require! {
	\mongoose : {Schema}
	\debug
	\co
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

action-name = 
	r: \read
	w: \write
	x: \execute

schema.methods.check-access = co.wrap (user, action) ->*
	log "checking permit:", user, action, {@owner, @group, @access}

	if @parent-id
		parent = yield models[translate @parent-type] .find-by-id @parent-id .exec!
		yield parent.permit.check-access user, action

	owner = @owner-document!
	{_id} = owner
	type = owner.get-display-name!
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
		| _ => 
			assert false,
				_id: _id
				type: type
				action: action

	assert @access[pos] == action, 
		_id: _id
		type: type
		user: user._id
		action: action-name[action]
		doc: {@owner, @group, @access}

schema.methods.check-owner = (user) ->
	owner = @owner-document!
	{_id} = owner
	type = owner.get-display-name!
	assert @owner == user._id, 
		_id: _id
		type: type
		user: user._id
		action: "ownership"

schema.methods.check-admin = (user) ->
	owner = @owner-document!
	{_id} = owner
	type = owner.get-display-name!
	assert user.groups.admin, 
		_id: _id
		type: type
		user: user._id
		action: "administrator"

module.exports = schema
