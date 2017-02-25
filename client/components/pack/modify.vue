<template lang="jade">
window
  .menu(slot="config")
    .ui.header links
    a.item(:href="'#!/pack/' + pack._id")
      i.icon.left.arrow
      | Go to Pack
    .ui.divider
    .ui.header operations
    .item(@click="del")
      i.icon.delete
      | Delete

  .ui.form.segment.basic#form-pack(slot="main")
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

<script>
require! {
  \vue
  \vuex : {map-getters, map-actions}
  \moment
  \debug
  \prelude-ls : {map, pairs-to-obj, obj-to-pairs, flatten}
  \../elements/permit
  \../window
}

log = debug \dollast:component:pack:modify

get-form-values = (values) ->
  permit = values{owner, group, access}

  # problems = if values.problems != "" then map parse-int, values.problems.split ',' else []
  begin-time = moment values.begin-time .value-of!
  end-time = moment values.end-time .value-of!

  {permit, begin-time, end-time} <<<< values{title}

set-form-values = (pack) ->
  #log 'new states. setting new values for form...', to-client-fmt problem.to-JS!
  $form = $ '#form-pack'
  {title, begin-time, end-time, permit, problems} = pack
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

  components:
    {window, permit}

  methods: (map-actions [\$fetch]) <<<
    fetch: ->>
      {pack} = @$route.params
      if pack != void
        @pack = await @$fetch method: \GET, url: "pack/#{pack}"

    del: ->>
      log \delete
      await @$fetch method: \DELETE, url: "pack/#{@pack._id}"
      @$router.go "/pack"

  mounted: ->
    @$next-tick ->
      submit = (e, values) ~>>
        e.prevent-default!
        pack = get-form-values values
        if @$route.params.pack != void
          pack._id = @$route.params.pack
        await @fetch method: \POST, url: "pack", data: pack

      $ '#form-pack' .form on-success: submit

      if @pack._id == void
        @pack.permit =
          owner: @user
          group: \packs
          access: \rwxr--r--
        set-form-values @pack

  created: ->
    @fetch!

  watch:
    'pack._id': ->
      @$next-tick ~>
        $ '.ui.selection.dropdown' .dropdown \refresh
        set-form-values @pack

    $route: ->
      @fetch!

</script>
