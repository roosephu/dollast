<template lang="jade">
view
  .menu(slot="config")
    .ui.header links
    a.item(href="#/problem/{{problem._id}}")
      i.icon.reply
      | Go to Problem

  .ui.form.basic.segment#form-data(:class="{loading: $loadingRouteData}", slot="main")
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
  \vue
  \debug
  \co
  \javascript-natural-sort : natural-sort
  \../view
  \../../actions : {check-response-errors}
}

log = debug \dollast:components:problems:data

module.exports =
  vuex:
    actions:
      {check-response-errors}
  
  components:
    {view}

  data: ->
    problem:
      _id: ""
      outlook:
        title: ""
      config:
        dataset: []

  route:
    data: co.wrap (to: params: {problem}) ->*
      {data: response} = yield @$http.get "problem/#{problem}"
      if @check-response-errors response
        return null
      problem = response.data

      {problem}

  computed:
    dataset: ->
      @problem.config.dataset .sort (a, b) ->
        natural-sort a.input, b.input

  methods:
    rebuild: co.wrap ->*
      {data: response} = yield @$http.get "data/#{@problem._id}/rebuild"
      if not @check-response-errors response
        @problem.config.dataset = response.data
    
    remove: co.wrap (atom) ->*
      {data: response} = yield @$http.delete "data/#{@problem._id}/#{atom.input}"
      @check-response-errors response
      @problem.config.dataset = response.data

  ready: ->
    $ 'input:text, #select' .on \click, (e) ->
      $ '#upload', $(e.target).parents! .click!
    
    $ 'input:file' .on \change, (e) ->
      if e.target?.files?.0?.name
        name = e.target.files[0].name 
        $ '#filename', $(e.target).parents! .val name

    submit = co.wrap (e) ~>*
      files = $ '#upload' .0 .files

      form-data = new FormData!
      for file in files
        form-data.append file.name, file
      
      $progress = $ \.ui.progress
      $progress.progress do
        text:
          ratio: '{value} of {total}'
          success: 'uploaded!'
      {data: response} = yield @$http.post "data/#{@problem._id}/upload", form-data, progress: (e) ->
        if e.length-computable
          $progress.progress value: e.loaded, total: e.total
      
      @check-response-errors response
      
      @problem.config.dataset = response.data.dataset

    $ '.form' .form on-success: submit

</script>
