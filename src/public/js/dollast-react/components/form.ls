require! {
  \react : {create-class, PropTypes}
}

export form = create-class do
  display-name: \form

  prop-types:
    submit: PropTypes.func.is-required
    id: PropTypes.string.is-required
    fields: PropTypes.object.is-required

  submit: (e) ->
    e.prevent-default!
    $form = $ "\##{@props.id}"
    all-values = $form.form 'get values'
    @props.submit all-values

  component-did-update: ->
    $form = $ "\##{@props.id}"
    $form.form do
      submit: @submit
      on: \blur
      fields: @props.fields

  render: ->
    _ \form, class-name: "ui form segment", id: @props.id,
      _ \div, class-name: "ui error message"
      @props.children

export chapter = create-class do
  display-name: \fields

  render: ->
    _ \div, null,
      _ \h2, class-name: "ui dividing header", @props.title
      @props.children
