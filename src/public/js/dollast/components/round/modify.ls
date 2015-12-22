require! {
  \react : {create-class}
  \immutable : I
  \moment
  \prelude-ls : P
  \../elements : {label-field, icon-text, icon-input}
  \react-redux : {connect}
  \../../actions : {on-get-round, on-add-prob-to-round, on-round-modify}
}

log = debug \dollast:component:round:modify

selector = (state) ->
  round: state.get-in [\round, \update], I.Map do
    probs: []

module.exports = (connect selector) create-class do
  display-name: \rnd-modify

  component-will-mount: ->
    if @props.params.rid
      @props.dispatch on-get-round @props.params.rid, \update, \total

  component-did-mount: ->
    $form = $ '#form-round'
    $form.form do
      on: \blur
      fields:
        title:
          identifier: \title
          rules:
            * type: 'minLength[4]'
              prompt: 'title has minimum length of 4'
            * type: 'maxLength[63]'
              prompt: 'title has maximum length of 63'
        beg-time:
          identifier: \begTime
          rules:
            * type: \isTime
              prompt: 'start time should be valid'
            ...
        end-time:
          identifier: \endTime
          rules:
            * type: \isTime
              prompt: 'start time should be valid'
            ...

  insert-prob: (pid) ->
    pid = parse-int pid
    if Number.is-integer pid
      @props.dispatch on-add-prob-to-round pid

  handle-input: (evt) ->
    #log evt
    if evt.which == 13
      @insert-prob evt.target.value
      evt.target.value = ''

  on-add-prob: ->
    $input = $ '#pid'
    @insert-prob $input[0].value

  submit: ->
    $form = $ '#form-round'
    {title, beg-time, end-time} = $form.form 'get values'
    probs = @props.round.get \probs .to-JS!
    probs = P.map (._id), probs
    log {probs}

    @props.dispatch on-round-modify {@rid, title, beg-time, end-time, probs}

  render: ->
    round = @props.round.to-JS!
    @rid = @props.params.rid
    if @rid
      title = "Round #{rid}"
    else
      title = "Create new round"
      @rid = 0

    _ \div, class-name: "ui form segment", id: 'form-round',
      _ \h1, class-name: "ui header dividing", title
      _ \div, class-name: "ui fields three",
        _ label-field, text: \title,
          _ \div, class-name: "ui input",
            _ \input, name: \title
        _ label-field, text: "start from",
          _ \div, class-name: "ui input",
            _ \input, name: \begTime, placeholder: "YYYY-MM-DD HH:mm:ss"
        _ label-field, text: "end at",
          _ \div, class-name: "ui input",
            _ \input, name: \endTime, placeholder: "YYYY-MM-DD HH:mm:ss"
      _ \h2, class-name: "ui header dividing", \problemset
      _ \div, class-name: "ui two fields",
        _ \div, class-name: "field",
          _ \table, class-name: "ui table segment definition",
            _ \thead, null,
              _ \tr, null,
                _ \th, class-name: \collapsing, ""
                _ \th, null, \pid
            _ \tbody, null,
              for prob in round.probs
                _ \tr, key: prob._id,
                  _ \td, null,
                    _ \div, class-name: "ui icon button",
                      _ \i, class-name: "icon mini remove"
                  _ \td, null,
                    "#{prob._id}. #{prob.outlook.title}"
            _ \tfoot, null,
              _ \tr, null,
                _ \th, null, ""
                _ \th, null,
                  _ \div, class-name: "ui input action",
                    _ \input, name: \pid, id: \pid, on-change: @handle-input
                    _ icon-text,
                      class-name: "floated right"
                      icon: "chevron right"
                      text: \add
                      on-click: @on-add-prob

      _ \div, class-name: \field,
        _ icon-text,
          class-name: "floated right red"
          text: \delete
          icon: \delete
          on-click: @delete
        _ icon-text,
          class-name: "floated right secondary"
          text: \cancel
          icon: \cancel
        _ icon-text,
          class-name: "floated right primary submit"
          text: \save
          icon: \save
          on-click: @submit
