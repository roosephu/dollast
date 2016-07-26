<template lang="jade">
view
  .menu(slot="config")
    .item(@click="del")
      i.icon.delete
      | Delete
    .item(href="#!/pack/{{pack._id}}")
      i.icon.left.arrow
      | Back to Pack

  .ui.form.segment.basic#form-pack(slot="main")
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
      a.icon.ui.labeled.button.floated.primary.submit
        i.icon.save
        | Save
</template>

<script lang="vue-livescript">
require! {
  \vue
  \co
  \moment
  \debug
  \prelude-ls : {map, pairs-to-obj, obj-to-pairs, flatten}
  \../view
  \../../actions : {raise-error}
}

log = debug \dollast:component:pack:modify

get-form-values = ->
  $form = $ '#form-pack'
  values = $form.form 'get values'

  permit = values{owner, group, access}

  problems = if values.problems != "" then map parse-int, values.problems.split ',' else []

  data = Object.assign values{title, begin-time, end-time},
    {problems, permit}

set-form-values = (pack) ->
  #log 'new states. setting new values for form...', to-client-fmt problem.to-JS!
  $form = $ '#form-pack'
  {title, begin-time, end-time, permit, problems} = pack
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
    pack:
      _id: void
      problems: []

  computed:
    dropdown-problems: ->
      {[x._id, vue.filter(\problem) x] for x in @pack.problems}
    formatted-title: ->
      if @pack._id == void
        "Create new Pack"
      else
        "Pack #{@pack._id}. #{@pack.title}"

  vuex:
    getters:
      user: (.session.user)
    actions:
      {raise-error}

  components:
    {view}

  methods:
    del: co.wrap ->*
      log \delete
      {data: response} = yield vue.http.delete "pack/#{@pack._id}"
      log {response}
      @$route.router.go "/pack" 

  ready: ->
    submit = co.wrap (e) ~>*
      e.prevent-default!
      pack = get-form-values!
      if @$route.params.pack != void
        pack._id = @$route.params.pack
      {data: response} = yield vue.http.post "pack", pack
      if response.errors
        log {response.errors}

    $form = $ '#form-pack'
    $form.form do
      on: \blur
      inline: true
      on-success: submit

    if @pack._id == void
      @pack.permit =
        owner: @user
        group: \packs
        access: \rwxr--r--
      set-form-values @pack

  route:
    data: co.wrap (to: params: {pack}) ->*
      if pack != void
        {data: response} = yield vue.http.get "pack/#{pack}"
        if response.errors
          @raise-error response
          return null
        pack = response.data

        {pack}

  watch:
    'pack._id': ->
      @$next-tick ~>
        $ '.ui.selection.dropdown' .dropdown \refresh
        set-form-values @pack

</script>
