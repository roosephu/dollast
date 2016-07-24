<template lang="jade">
view
  .ui.form.basic.segment#form-data(:class="{loading: $loadingRouteData}", slot="main")
    h2.ui.dividing.header Problem {{problem._id}}. {{problem.outlook.title}}

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
      //- .ui.field.four.wide#dropzone
        //- .dropzoneText drop files here or click
      .ui.field.twelve.wide
        table.ui.table.segment
          thead
            tr
              th input
              th output
              th weight
              th
          tbody
            tr(v-for="atom in problem.config.dataset")
              td {{atom.input}}
              td {{atom.output}}
              td {{atom.weight}}
              td
                a.ui.icon.labeled.button.right.floated.mini(@click="remove(atom)")
                  i.icon.remove
                  | remove
</template>

<script lang="vue-livescript">
require! {
  \vue
  \debug
  \co
  \../view
  \../../actions : {raise-error}
}

log = debug \dollast:components:problems:data

module.exports =
  vuex:
    actions:
      {raise-error}
  
  components:
    {view}

  data: ->
    problem:
      _id: 0
      outlook:
        title: ""
      config:
        dataset: []

  route:
    data: co.wrap (to: params: {problem}) ~>*
      {data: response} = yield vue.http.get "problem/#{problem}"
      if response.errors
        @raise-error response
        return null
      problem = response.data

      {problem}

  methods:
    rebuild: co.wrap ->*
      {data: response} = yield @$http.get "data/#{@problem._id}/rebuild"
      if response.errors
        @raise-error response
      else
        @problem.config.dataset = response.data
    
    remove: co.wrap (atom) ->*
      {data: response} = yield @$http.get "data/#{@problem._id}/remove"
      log atom

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
      
      if response.errors
        @raise-error response
      
      @problem.config.dataset = response.data.dataset

    $ '.form' .form do
      inline: true
      on: \blur
      fields:
        upload:
          identifier: \upload
          rules:
            * type: 'empty'
              prompt: 'please select file first'
            ...
      on-success:
        submit

</script>
