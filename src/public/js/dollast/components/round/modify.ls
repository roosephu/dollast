require! {
  \react : {create-class}
  \immutable : I
  \moment
  \prelude-ls : {map}
  \../elements : {label-field, icon-text, icon-input, dropdown}
  \react-redux : {connect}
  \../../actions : {on-get-round, on-add-prob-to-round, on-round-modify}
  \../format : {prob-fmt}
}

log = debug \dollast:component:round:modify

selector = (state, props) ->
  round: state.get-in [\db, \round, props.params.rid, \get], I.Map do
    probs: []
    permit:
      owner: state.get-in [\session, \uid]
      group: \rounds
      access: 8~644

probs-selection = create-class do
  display-name: \problem-selection

  component-did-mount: ->
    $dropdown = $ '.ui.selection.dropdown'
    # log {$dropdown}
    $dropdown.dropdown do
      data-type: \jsonp
      api-settings:
        on-response: (response) ->
          if !response.outlook
            return results: []
          # log {response}
          title = response.outlook.title
          id = response._id
          return results: [value: id, name: prob-fmt response]
        url: "/problem/{query}"
        on-change: (value) ~>
          log {value}

  component-did-update: ->
    $ '.ui.selection.dropdown' .dropdown \refresh

  render: ->
    _ dropdown,
      class-name: "ui fluid multiple search selection icon"
      name: @props.name
      default: ""
      options: {[x._id, prob-fmt x] for x in @props.defaults}

module.exports = (connect selector) create-class do
  display-name: \rnd-modify

  component-did-mount: ->
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
    if @props.params.rid
      @props.dispatch on-get-round @props.params.rid
    else
      @update-forms @props.round

  # insert-prob: (pid) ->
  #   pid = parse-int pid
  #   if Number.is-integer pid
  #     @props.dispatch on-add-prob-to-round pid

  # handle-input: (evt) ->
  #   #log evt
  #   if evt.which == 13
  #     @insert-prob evt.target.value
  #     evt.target.value = ''

  # on-add-prob: ->
  #   $input = $ '#pid'
  #   @insert-prob $input[0].value

  update-forms: (round) ->
    #log 'new states. setting new values for form...', to-client-fmt problem.to-JS!
    $form = $ '#form-round'
    {title, beg-time, end-time, permit, probs} = round.to-JS!
    if permit?.access
      permit.access .= to-string 8
    # probs = map (-> prob-fmt it), probs
    # probs .= join!
    probs = map (-> "#{it._id}"), probs
    $form.form 'set values',
      title: title
      beg-time: moment beg-time .format 'YYYY-MM-DD hh:mm:ss'
      end-time: moment end-time .format 'YYYY-MM-DD hh:mm:ss'
      probs: probs
    $form.form 'set values', permit

  component-did-update: (prev-props, prev-states) ->
    # log {round: next-props.round.to-JS!, next-states}
    @update-forms @props.round

  submit: ->
    $form = $ '#form-round'
    values = $form.form 'get values'

    permit = values{owner, group, access}
    permit.access = parse-int permit.access, 8

    # probs = @props.round.get \probs .to-JS!
    # probs = P.map (._id), probs
    probs = map parse-int, values.probs.split ','
    # log {probs}

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
            _ \input, name: \owner
        _ label-field, text: \group,
          _ \div, class-name: "ui input",
            _ \input, name: \group
        _ label-field, text: \access,
          _ \div, class-name: "ui input",
            _ \input, name: \access

      _ \h2, class-name: "ui header dividing", \problemset
      _ \div, class-name: "ui field",
        _ probs-selection,
          defaults: round.probs
          name: \probs

      # _ \div, class-name: "ui two fields",
      #   _ \div, class-name: "field",
      #     _ \table, class-name: "ui table segment definition",
      #       _ \thead, null,
      #         _ \tr, null,
      #           _ \th, class-name: \collapsing, ""
      #           _ \th, null, \pid
      #       _ \tbody, null,
      #         for prob in round.probs
      #           _ \tr, key: prob._id,
      #             _ \td, null,
      #               _ \div, class-name: "ui icon button",
      #                 _ \i, class-name: "icon mini remove"
      #             _ \td, null,
      #               "#{prob._id}. #{prob.outlook.title}"
      #       _ \tfoot, null,
      #         _ \tr, null,
      #           _ \th, null, ""
      #           _ \th, null,
      #             _ \div, class-name: "ui input action",
      #               _ \input, name: \pid, id: \pid, on-change: @handle-input
      #               _ icon-text,
      #                 class-name: "floated right"
      #                 icon: "chevron right"
      #                 text: \add
      #                 on-click: @on-add-prob

      _ \br
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
