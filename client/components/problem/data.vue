<template lang="jade">
  .ui.form.basic.segment#form-data
    h2.ui.dividing.header Problem {{problem._id}}. {{problem.outlook.title}}

    h3.ui.dividing.header Dataset Management
    input#upload(type="file", style="display:none", name="upload")
    .ui.field
      a.ui.icon.button.labeled(@click="select")
        i.icon.file
        | select
      a.ui.icon.button.labeled.green(@click="upload")
        i.icon.upload
        | upload
      a.ui.icon.button.labeled.teal(@click="rebuild")
        i.icon.retweet
        | rebuild

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
                a.ui.icon.labeled.button.right.floated.mini(:click="remove")
                  i.icon.remove
                  | remove

</template>

<script lang="vue-livescript">
require! {
  \vue
  \debug
  \co
  \../../actions : {raise-error}
}

log = debug \dollast:components:problems:data

module.exports =
  vuex:
    actions:
      {raise-error}

  data: ->
    problem:
      _id: 0
      outlook:
        title: ""
      config:
        dataset: []

  route:
    data: co.wrap (to: params: {pid}) ~>*
      {data: response} = yield vue.http.get "problem/#{pid}"
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

    select: ->
      $ '#upload' .click!

    upload: co.wrap ->*
      files = $ '#upload' .0 .files
      form-data = new FormData!
      for file in files
        form-data.append file.name, file
      {data} = yield @$http.post "data/#{@problem._id}/upload", form-data
      @problem.config.dataset = data.pairs

</script>
