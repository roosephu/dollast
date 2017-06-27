<template lang="jade">
window
  .menu(slot="config")
    .ui.header links
    a.item(:href="'#/round/' + round._id")
      i.icon.left.arrow
      | Go to Round
    .ui.divider
    .ui.header operations
    .item(@click="del")
      i.icon.delete
      | Delete

  .ui.form.segment.basic#form-round(slot="main")
    h2.ui.dividing.header {{formattedTitle}}
    .ui.success.message
      .header Changes saved.
    .ui.error.message

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

    permit

    // h3.ui.dividing.header Problemset
    // .ui.field
    //   .ui.dropdown.icon.selection.fluid.multiple.search
    //     input(type="hidden", name="problems")
    //     .default.text problems
    //     i.dropdown.icon
    //     .menu
    //       .item(v-for="(value, key) of dropdownProblems", :data-value="key") {{value}}
    // br

    .ui.field
      a.icon.ui.labeled.button.floated.primary.submit
        i.icon.save
        | Save
</template>

<script lang="livescript">
require! {
  \vuex : {default: {map-getters, map-actions}}
  \moment
  \debug
  \prelude-ls : {map, pairs-to-obj, obj-to-pairs, flatten}
  \../elements/permit
  \../window
}

log = debug \dollast:component:round:modify

get-form-values = (values) ->
  permit = values{owner, group, access}

  # problems = if values.problems != "" then map parse-int, values.problems.split ',' else []
  begin-time = moment values.begin-time .value-of!
  end-time = moment values.end-time .value-of!

  {permit, begin-time, end-time} <<<< values{title}

set-form-values = (round) ->
  #log 'new states. setting new values for form...', to-client-fmt problem.to-JS!
  $form = $ '#form-round'
  {title, begin-time, end-time, permit, problems} = round
  # probs = map (-> prob-fmt it), probs
  # probs .= join!
  problems = map ((problem) -> "#{problem._id}"), problems
  $form.form 'set values',
    title: title
    begin-time: if begin-time then new moment begin-time .format 'YYYY-MM-DD HH:mm:ss' else void
    end-time: if end-time then new moment end-time .format 'YYYY-MM-DD HH:mm:ss' else void
    problems: problems
  $form.form 'set values', permit

module.exports =
  data: ->
    round:
      _id: void
      problems: []

  computed:
    dropdown-problems: ->
      {[x._id, vue.filter(\problem) x] for x in @round.problems}
    formatted-title: ->
      if not @round._id?
        "Create new Round"
      else
        "Round #{@round._id}. #{@round.title}"

  components:
    {window, permit}

  methods: (map-actions [\$fetch]) <<<
    fetch: ->>
      {round} = @$route.params
      if round?
        @round = await @$fetch method: \GET, url: "round/#{round}"

    del: ->>
      log \delete
      await @$fetch method: \DELETE, url: "round/#{@round._id}"
      @$router.go "/round"

  mounted: ->
    @$next-tick ->
      submit = (e, values) ~>>
        e.prevent-default!
        round = get-form-values values
        if @$route.params.round != void
          round._id = @$route.params.round
        await @$fetch method: \POST, url: "round", data: round

      $ '#form-round' .form on-success: submit

      if not @round._id?
        @round.permit =
          owner: @user
          group: \rounds
          access: \rwxr--r--
        set-form-values @round

  created: ->
    @fetch!

  watch:
    'round._id': ->
      @$next-tick ~>
        $ '.ui.selection.dropdown' .dropdown \refresh
        set-form-values @round

    $route: ->
      @fetch!

</script>
