<template lang="jade">
  .ui.form#form-round
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
          input(name="begTime", placeholder="YYYY-MM-DD HH:mm:ss")
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
        input(type="hidden", name="probs")
        .default.text problems
        i.dropdown.icon
        .menu
          .item(v-for="(key, value) of dropdownProblems", data-value="{{key}}") {{value}}
    br

    .ui.field
      a.icon.ui.labeled.button.floated.red(:click="delete")
        i.icon.delete
        | delete
      a.icon.ui.labeled.button.floated.secondary
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
  \../format : {formatter}
  \prelude-ls : {map}
}

log = debug \dollast:component:round:modify

get-form-values = ->
  $form = $ '#form-round'
  values = $form.form 'get values'

  permit = values{owner, group, access}

  # probs = @props.round.get \probs .to-JS!
  # probs = P.map (._id), probs
  probs = map parse-int, values.probs.split ','

  data = Object.assign values{title, beg-time, end-time},
    {probs, permit}

set-form-values = (round) ->
  #log 'new states. setting new values for form...', to-client-fmt problem.to-JS!
  $form = $ '#form-round'
  {title, beg-time, end-time, permit, probs} = round
  # probs = map (-> prob-fmt it), probs
  # probs .= join!
  probs = map (-> "#{it._id}"), probs
  $form.form 'set values',
    title: title
    beg-time: if beg-time then moment beg-time .format 'YYYY-MM-DD hh:mm:ss' else void
    end-time: if end-time then moment end-time .format 'YYYY-MM-DD hh:mm:ss' else void
    probs: probs
  $form.form 'set values', permit

module.exports =
  data: ->
    rnd:
      _id: void
      probs: []

  computed:
    dropdown-problems: ->
      {[x._id, formatter.problem x] for x in @rnd.probs}
    formatted-title: ->
      if @rnd._id == void
        "Create new Round"
      else
        "Round #{@rnd._id}. #{@rnd.title}"

  vuex:
    getters:
      uid: (.session.uid)

  ready: ->
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
          return results: [value: id, name: formatter.problem response]
        url: "/problem/{query}"
        on-change: (value) ~>
          log {value}

    submit = co.wrap (e) ~>*
      e.prevent-default!
      data = get-form-values!
      response = yield vue.http.post "/round/#{@rnd._id}", data
      # log {response}

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
    if @rnd._id == void
      @rnd.permit =
        owner: @uid
        group: \rounds
        access: \rwxrw-rw-
      set-form-values @rnd
      # $form.form 'set values', @rnd.permit


  route:
    data: co.wrap (to: params: {rid}) ->*
      if rid != void
        {data} = yield vue.http.get "/round/#{rid}"
        {rnd: data}

  watch:
    'rnd._id': ->
      @$next-tick ~>
        $ '.ui.selection.dropdown' .dropdown \refresh
        set-form-values @rnd

</script>
