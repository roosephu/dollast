<template lang="jade">
window
  .menu(slot="config")
    .ui.header links
    a.item(:href="'#/problem/' + problem._id")
      i.icon.reply
      | Go to Problem

  .ui.form.basic.segment#form-data(:class="{loading: isLoading}", slot="main")
    h2.ui.dividing.header Problem {{problem | problem}}

    h3.ui.dividing.header Dataset Management
    .ui.field
      .ui.fluid.action.input
        input#filename(type='text', readonly)
        input#upload(type='file', hidden, name="upload")
        .ui.button#select
          | select
    .ui.field
      a.ui.icon.button.labeled.submit
        i.icon.upload
        | upload
      a.ui.icon.button.labeled(@click="rebuild")
        i.icon.retweet
        | rebuild

    .ui.progress.indicating
      .bar
        .progress

    .ui.two.fields
      .ui.field.twelve.wide
        table.ui.table.segment
          thead
            tr
              th input
              th output
              th weight
              th
          tbody
            tr(v-for="atom in dataset")
              td {{atom.input}}
              td {{atom.output}}
              td {{atom.weight}}
              td
                a.ui.icon.labeled.button.right.floated.mini(@click="remove(atom)")
                  i.icon.remove
                  | remove
</template>

<script>
require! {
  \vuex : {default: {map-getters, map-actions}}
  \debug
  \javascript-natural-sort : natural-sort
  \../window
}

log = debug \dollast:components:problems:data

module.exports =

  components:
    {window}

  data: ->
    problem:
      _id: ""
      outlook:
        title: ""
      config:
        dataset: []

  computed: (map-getters [\isLoading]) <<<
    dataset: ->
      @problem.config.dataset .sort (a, b) ->
        natural-sort a.input, b.input

  methods: (map-actions [\$fetch]) <<<
    rebuild: ->>
      @problem.config.dataset = await @$fetch method: \GET, url: "data/#{@problem._id}/rebuild"

    remove: (atom) ->>
      @problem.config.dataset = await @$fetch method: \DELETE, url: "data/#{@problem._id}/#{atom.input}"

    fetch: ->>
      @problem = await @$fetch method: \GET, url: "problem/#{@$route.params.problem}"

  watch:
    $route: ->
      @fetch!

  created: ->
    @fetch!

  mounted: ->
    @$next-tick ->
      $ 'input:text, #select' .on \click, (e) ->
        $ '#upload', $(e.target).parents! .click!

      $ 'input:file' .on \change, (e) ->
        if e.target?.files?.0?.name
          name = e.target.files[0].name
          $ '#filename', $(e.target).parents! .val name

      submit = (e) ~>>
        files = $ '#upload' .0 .files

        form-data = new FormData!
        for file in files
          form-data.append file.name, file

        $progress = $ \.ui.progress
        $progress.progress do
          text:
            ratio: '{value} of {total}'
            success: 'uploaded!'
        @problem.config.dataset = await @$fetch method: \POST, url: "data/#{@problem._id}/upload", data: form-data, progress: (e) ->
          if e.length-computable
            $progress.progress value: e.loaded, total: e.total

      $ '.form' .form on-success: submit

</script>
