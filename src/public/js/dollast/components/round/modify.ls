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

selector = (state, props) ->
  round: state.get-in [\db, \round, props.params.rid, \get], I.Map do
    probs: []
    permit:
      owner: state.get-in [\session, \uid]
      group: \rounds
      access: 8~644

module.exports = (connect selector) create-class do
  display-name: \rnd-modify

  component-did-mount: ->
    if @props.params.rid
      @props.dispatch on-get-round @props.params.rid

    $form = $ '#form-round'
    $form.form do
      on: \blur
      on-success: @submit
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
        owner:
          identifier: \owner
          rules:
            * type: \isUserId
              prompt: 'owner should be valid'
            ...
        group:
          identifier: \group
          rules:
            * type: \isUserId
              prompt: 'group should be valid'
            ...
        access:
          identifier: \access
          rules:
            * type: \isAccess
              prompt: 'access code should be /^[0-7]{3}$/'
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

  update-forms: (round) ->
    #log 'new states. setting new values for form...', to-client-fmt problem.to-JS!
    $form = $ '#form-round'
    {title, beg-time, end-time, permit} = round.to-JS!
    if permit?.access
      permit.access .= to-string 8
    $form.form 'set values',
      title: title
      beg-time: moment beg-time .format 'YYYY-MM-DD hh:mm:ss'
      end-time: moment end-time .format 'YYYY-MM-DD hh:mm:ss'
    $form.form 'set values', permit
    log {permit}

  component-will-update: (next-props, next-states) ->
    @update-forms next-props.round

  submit: ->
    $form = $ '#form-round'
    values = $form.form 'get values'
    permit = values{owner, group, access}
    permit.access = parse-int permit.access, 8

    probs = @props.round.get \probs .to-JS!
    probs = P.map (._id), probs

    data = Object.assign values{title, beg-time, end-time},
      {@rid, probs, permit}

    @props.dispatch on-round-modify data

  render: ->
    round = @props.round.to-JS!
    @rid = @props.params.rid
    if @rid
      title = "Round #{@rid}"
    else
      title = "Create new round"
      @rid = 0

    _ \div, class-name: "ui form segment", id: 'form-round',
      _ \h1, class-name: "ui header dividing", title
      _ \div, class-name: "ui error message"

      _ \h2, class-name: "ui dividing header", \configuration
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

      _ \h2, class-name: "ui header dividing", \permission
        _ \div, class-name: "ui three fields",
          _ label-field, text: \owner,
            _ \div, class-name: "ui input",
              _ \input, name: \owner, type: \string
          _ label-field, text: \group,
            _ \div, class-name: "ui input",
              _ \input, name: \group, type: \string
          _ label-field, text: \access,
            _ \div, class-name: "ui input",
              _ \input, name: \access, type: \string

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

      _ \div, class-name: "ui field",
        _ icon-text,
          class-name: "floated red"
          text: \delete
          icon: \delete
          on-click: @delete
        _ icon-text,
          class-name: "floated secondary"
          text: \cancel
          icon: \undo
        _ icon-text,
          class-name: "floated primary submit"
          text: \save
          icon: \save
