<template lang="jade">
  .ui.basic.segment(:class="{loading: $loadingRouteData}")
    h1.ui.dividing.header Submissions

    .error.message
    .ui.menu.pagination
      .ui.item.icon#options
        i.icon.wrench
      .ui.fluid.popup
        .ui.form#submission
          .ui.field
            label user
            .ui.input
              input(name="user", placeholder="user")
          .ui.field
            label problem
            .ui.input
              input(name="problem", placeholder="problem")
          .ui.field
            label result
            .ui.input.labeled
              .ui.dropdown.compact.button.label#relationship
                input(type="hidden", name="relationship")
                .default.text ?
                .menu
                  .item(data-value="lt") $\leqslant$
                  .item(data-value="gt") $\geqslant$
              input(name="threshold", placeholder="threshold")
          .ui.field
            label round
            .ui.input
              input(name="round", placeholder="round")
          .ui.field
            label language
            .ui.dropdown.selection
              i.dropdown.icon
              input(type="hidden", name="language")
              span.text all
              .menu
                .item(v-for="item in languages", data-value="{{item}}") {{item}}
                .item(data-value="")
                  .default.text all
          .ui.button.primary.submit submit
          .ui.button(@click="clear") clear

      a.item(v-bind:class="{'disabled': query.page == 1}", @click="go(1)")
        i.icon.angle.double.left
      a.item(v-bind:class="{'disabled': query.page == 1}", @click="go(query.page - 1)")
        i.icon.angle.left
      a.active.item {{query.page}}
      a.item(@click="go(query.page + 1)") 
        i.icon.angle.right

    table.ui.table.large.green.selectable.center.aligned.single.line
      thead
        tr
          th.collapsing.right id
          th.collapsing time
          th problem
          th user
          th score
          th time
          th space
          th.collapsing lang
          th.collapsing round
      tbody
        tr(v-for="sol in submissions", v-bind:class="{'positive': sol.summary.score > 0.999, 'negative': sol.summary.score < 0.001}")
          td
            code-link(:sid="sol._id")
          td
            .ui.label.mini {{sol.date | concise-time}}
          td
            problem(:prob="sol.problem")
          td
            user(:uid="sol.user")
          td(v-if="sol.summary.status != 'running'") {{sol.summary.score | decimal 3}}
          td(v-else) running
          td(v-if="sol.summary.status != 'running'") {{sol.summary.time | decimal 3}}
          td(v-else)
          td(v-if="sol.summary.status != 'running'") {{sol.summary.space | decimal 3}}
          td(v-else)
          td {{sol.language}}
          td(v-if="sol.round")
            round(:rnd="sol.round")
          td(v-else)
    // .ui.icon.labeled.button.floated.right.primary
    //   i.icon.refresh
    //   | refresh
</template>

<script lang="vue-livescript">
require! {
  \debug
  \co
  \vue
  \prelude-ls : {Obj}
  \../format
  \../../actions : {raise-error}
}

log = debug \dollast:component:submission:list

get-form-values = ->
  values = $ \#submission .form 'get values'
  ret = Obj.reject (== ""), values
  if ret.threshold
    ret.threshold |>= parse-float
  return ret

set-form-values = (values) ->
  log 'setting form values', values
  $ \#submission .form 'set values', values

module.exports =

  vuex:
    actions:
      {raise-error}

  data: ->
    submissions: []
    languages: [\cpp, \java, \pas]
    query:
      page: 1

  route:
    data: co.wrap ->* 
      {query} = @$route
      if query.page
        query.page |>= parse-int
      else
        query.page = 1
      if query.threshold
        query.threshold |>= parse-float

      @$next-tick ->
        set-form-values query

      {data: response} = yield vue.http.get \submission, query
      if response.errors
        @raise-error response
        return null
      submissions = response.data

      {submissions, query}

  components:
    format
  
  methods:
    go: (page) ->
      @query.page = page
      @$route.router.go name: \submissions, query: @query

    clear: ->
      $ \.form .form \clear

  ready: ->
    submit = co.wrap ~>*
      values = get-form-values!
      @$route.router.go name: \submissions, query: values

    $ \#submission .form do
      inline: true
      on: \blur
      on-success: submit
      fields:
        user:
          identifier: \user
          optional: true
          rules:
            * type: \isUserId
              prompt: "invalid user"
            ...
        threshold:
          identifier: \threshold
          optional: true
          rules:
            * type: "number[0..1]"
              prompt: "a number between [0, 1]"
            ...
        relationship:
          identifier: \relationship
          depends: \threshold
          rules: 
            * type: \empty
              prompt: "cannot be empty"
            ...
        problem:
          identifier: \problem
          optional: true
          rules:
            * type: "integer[1..]"
              prompt: "must be a positive integer"
            ...
        round:
          identifier: \round
          optional: true
          rules:
            * type: "integer[1..]"
              prompt: "must be a positive integer"
            ...
        langauge:
          identifier: \language
          optional: true

    $ \.dropdown .dropdown!
    $ \#relationship .dropdown on: \hover
    $ \#options .popup inline: true, hoverable: true, position: 'bottom left'
    MathJax.Hub.Queue [\Typeset, MathJax.Hub]

</script>
