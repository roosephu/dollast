<template lang="jade">
  .ui.form.segment.basic#form-round
    h2.ui.dividing.header {{formattedTitle}}
    .ui.success.message
      .header Changes saved.

    h3.ui.dividing.header Configuration
    .ui.fields.three
      .ui.field
        label title
        .ui.input
          input(name="title")
      .ui.field
        label start from
        .ui.input
          input(name="beginTime", placeholder="YYYY-MM-DD HH:mm:ss")
      .ui.field
        label end at
        .ui.input
          input(name="endTime", placeholder="YYYY-MM-DD HH:mm:ss")

    h3.ui.dividing.header Permission
    .ui.four.fields
      .ui.field
        label owner
        .ui.input
          input(name="owner")
      .ui.field
        label group
        .ui.input
          input(name="group")
      .ui.field
        label access
        .ui.input
          input(name="access")

    h3.ui.dividing.header Problemset
    .ui.field
      .ui.dropdown.icon.selection.fluid.multiple.search
        input(type="hidden", name="problems")
        .default.text problems
        i.dropdown.icon
        .menu
          .item(v-for="(key, value) of dropdownProblems", data-value="{{key}}") {{value}}
    br

    .ui.field
      a.icon.ui.labeled.button.floated(:click="delete")
        i.icon.delete
        | delete
      a.icon.ui.labeled.button.floated
        i.icon.cancel
        | undo
      a.icon.ui.labeled.button.floated.primary.submit
        i.icon.save
        | save
</template>

<script lang="vue-livescript">
require! {
  \vue
  \co
  \moment
  \debug
  \prelude-ls : {map, pairs-to-obj, obj-to-pairs, flatten}
  \../../actions : {raise-error}
}

log = debug \dollast:component:round:modify

get-form-values = ->
  $form = $ '#form-round'
  values = $form.form 'get values'

  permit = values{owner, group, access}

  problems = if values.problems != "" then map parse-int, values.problems.split ',' else []

  data = Object.assign values{title, begin-time, end-time},
    {problems, permit}

set-form-values = (round) ->
  #log 'new states. setting new values for form...', to-client-fmt problem.to-JS!
  $form = $ '#form-round'
  {title, begin-time, end-time, permit, problems} = round
  # probs = map (-> prob-fmt it), probs
  # probs .= join!
  problems = map ((problem) -> "#{problem._id}"), problems
  $form.form 'set values',
    title: title
    begin-time: if begin-time then moment begin-time .format 'YYYY-MM-DD HH:mm:ss' else void
    end-time: if end-time then moment end-time .format 'YYYY-MM-DD HH:mm:ss' else void
    problems: problems
  $form.form 'set values', permit

module.exports =
  data: ->
    rid: 0
    rnd:
      _id: void
      problems: []

  computed:
    dropdown-problems: ->
      {[x._id, vue.filter(\problem) x] for x in @rnd.problems}
    formatted-title: ->
      if @rnd._id == void
        "Create new Round"
      else
        "Round #{@rnd._id}. #{@rnd.title}"

  vuex:
    getters:
      uid: (.session.uid)
    actions:
      {raise-error}

  ready: ->
    $dropdown = $ '.ui.selection.dropdown'
    # log {$dropdown}
    $dropdown.dropdown do
      data-type: \jsonp
      api-settings:
        save-remove-data: false
        on-response: (response) ->
          if !response.data?._id
            return success: false, results: []
          # log {response}
          problem = response.data
          {_id, outlook: {title}} = problem
          return results: [value: _id, name: vue.filter(\problem) problem]
        url: "/api/problem/{query}"
        on-change: (value) ~>
          log {value}

    submit = co.wrap (e) ~>*
      e.prevent-default!
      data = get-form-values!
      {data: response} = yield vue.http.post "round/#{@rid}", data
      if response.errors
        log {response.errors}

    $form = $ '#form-round'
    $form.form do
      on: \blur
      inline: true
      on-success: submit
      fields:
        title:
          identifier: \title
          rules:
            * type: 'minLength[4]'
              prompt: 'title has minimum length of 4'
            * type: 'maxLength[63]'
              prompt: 'title has maximum length of 63'
        beg-time:
          identifier: \beginTime
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
    if @rnd._id == void
      @rnd.permit =
        owner: @uid
        group: \rounds
        access: \rwxr--r--
      set-form-values @rnd
      # $form.form 'set values', @rnd.permit

  route:
    data: co.wrap (to: params: {rid}) ->*
      if rid != void
        {data: response} = yield vue.http.get "round/#{rid}"
        if response.errors
          @raise-error response
          return null
        round = response.data

        {rid, rnd: round}

  watch:
    'rnd._id': ->
      @$next-tick ~>
        $ '.ui.selection.dropdown' .dropdown \refresh
        set-form-values @rnd

</script>
