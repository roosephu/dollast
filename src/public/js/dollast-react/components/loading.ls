require! {
	\react : {create-class}
}

export loading = create-class do
	display-name: \loading

	render: ->
		_ \div, null, "loading"
