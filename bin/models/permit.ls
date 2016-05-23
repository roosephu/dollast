require! {
	\mongoose : {Schema}
}

export schema =
	owner: type: String, ref: \user
	group: String
	access: String

export can-access = (user, permit, action) ->
	if user == null or permit == null
		return false

	offset = if permit.owner == user._id
		6
	else if permit.group in user.groups
		3
	else
		0

	pos = offset + switch action
		| 'r' => 2
		| 'w' => 1
		| 'x' => 0
		| _ => throw new Error 'invalid action'

	return permit[pos] != action
