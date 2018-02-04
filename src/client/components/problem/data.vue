<template lang="jade">
window
  .menu(slot="config")
    .ui.header links
    a.item(:href="'#/problem/' + problemId")
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

    .ui.two.fields(v-if="problem")
      .ui.field.twelve.wide
        table.ui.table.segment
          thead
            tr
              th input
              th answer
              th weight
              th
          tbody
            tr(v-for="atom in dataset")
              td {{atom.input}}
              td {{atom.answer}}
              td {{atom.weight}}
              td
                a.ui.icon.labeled.button.right.floated.mini(@click="remove(atom)")
                  i.icon.remove
                  | remove
</template>

<script>
import { debug } from 'debug'
import { mapGetters } from 'vuex'
import naturalSort from 'javascript-natural-sort'
import window from '@/components/window'
import gql from 'graphql-tag'

const log = debug('dollast:components:problems:data')

export default {
  components: {
    window
  },

  data () {
    return {
      problem: null
    }
  },

  computed: {
    dataset () {
      return this.problem.dataset.sort((a, b) => {
        naturalSort(a.input, b.input)
      })
    },

    problemId () {
      return this.$route.params.problemId
    },

    ...mapGetters(['isLoading'])
  },

  apollo: {
    problem: {
      query: gql`query Problem($problemId: String) {
        problem(_id: $problemId) {
          _id
          title
          dataset {
            input
            answer
            weight
          }
        }
      }`,
      variables () {
        return {
          problemId: this.problemId
        }
      }
    }
  },

  methods: {
    rebuild () {

    }
    // rebuild: ->>
    //   @problem.config.dataset = await @$fetch method: \GET, url: "data/#{@problem._id}/rebuild"

    // remove: (atom) ->>
    //   @problem.config.dataset = await @$fetch method: \DELETE, url: "data/#{@problem._id}/#{atom.input}"

    // fetch: ->>
    //   @problem = await @$fetch method: \GET, url: "problem/#{@$route.params.problem}"

  },

  mounted () {
    this.$nextTick(() => {
      $('input:text, #select').on('click', (e) => {
        $('#upload', $(e.target).parents()).click()
      })

      $('input:file').on('change', (e) => {
        if (e.target.files[0].name) {
          const name = e.target.files[0].name
          $('#filename', $(e.target).parents()).val(name)
        }
      })

      const $progress = $('.ui.progress')
      $progress.progress({
        text: {
          ratio: '{value} of {total}',
          success: 'uploaded!'
        }
      })

      const submit = async (e) => {
        const { files: file } = $('#upload')[0]

        // TODO progress
        await this.$apollo.mutate({
          mutation: gql`mutation ($file: Upload, $_id: String) {
            uploadData(file: $file, _id: $_id) {
              input
              answer
              weight
            }
          }`,
          variables: { file, _id: this.problemId }
          // update (store, { data: dataset }) {
          //   const data = store.readQuery({
          //     query:
          //   })
          // }
        })

        // this.problem.config.dataset = await @$fetch method: \POST, url: "data/#{@problem._id}/upload", data: form-data, progress: (e) ->
        //   if e.length-computable
            // $progress.progress value: e.loaded, total: e.total
      }

      $('.form').form({
        onSuccess: submit,
        fields: { upload: 'empty' }
      })
    })
  }
}
</script>
