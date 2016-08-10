<template lang="jade">
view
  .form.menu#submission(slot="config")
    .ui.header Pagination
    a.icon.labeled.item(:class="{'disabled': query.page == 1}", @click="go(1)")
      i.icon.angle.double.left
      | Top
    a.icon.labeled.item(:class="{'disabled': query.page == 1}", @click="go(query.page - 1)")
      i.icon.angle.left
      | Previous page
    .icon.labeled.item
      i.icon.thin.circle
      | Current: {{query.page}}
    a.icon.labeled.item(@click="go(query.page + 1)") 
      i.icon.angle.right
      | Next page
    .ui.divider
    .ui.header Options
    .ui.left.icon.input
      i.icon.user
      input(name="user", placeholder="user")
    .ui.left.icon.input
      i.icon.browser
      input(name="problem", placeholder="problem")
    .ui.left.icon.input
      i.icon.shopping.bag
      input(name="pack", placeholder="pack")
    .ui.left.icon.input
      i.icon.calendar
      input(name="after", placeholder="submitted after")
    .ui.left.icon.input
      i.icon.calendar
      input(name="before", placeholder="submitted before")
    .ui.input.labeled
      .ui.dropdown.compact.button.label#relationship
        input(type="hidden", name="relationship")
        .default.text ?
        .menu
          .item(data-value="lt") $\leqslant$
          .item(data-value="gt") $\geqslant$
      input(name="threshold", placeholder="threshold")
    .ui.dropdown.selection.item#langauge
      i.dropdown.icon
      input(type="hidden", name="language")
      span Language: 
      span.text
      .menu
        .item(v-for="item in languages", data-value="{{item}}") {{item}}
        .item(data-value="all") all
    .ui.divider
    .ui.header Form Operations
    .ui.item.icon.submit
      i.icon
      | Submit
    .ui.item.icon.button(@click="clear")
      i.icon
      | Clear

  .ui.basic.segment(:class="{loading: $loadingRouteData}", slot="main")
    h1.ui.dividing.header Submissions

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
          th.collapsing pack
      tbody
        tr(v-for="sol in submissions", :class="{'positive': sol.summary.score > 0.999, 'negative': sol.summary.score < 0.001}")
          td
            code-link(:sid="sol._id")
          td
            .ui.label.mini {{sol.date | concise-time}}
          td
            problem(:prob="sol.problem")
          td
            user(:user="sol.user")
          td(v-if="sol.summary.status != 'running'") {{sol.summary.score | decimal 3}}
          td(v-else) running
          td(v-if="sol.summary.status != 'running'") {{sol.summary.time | decimal 3}}
          td(v-else)
          td(v-if="sol.summary.status != 'running'") {{sol.summary.space | decimal 3}}
          td(v-else)
          td {{sol.language}}
          td(v-if="sol.pack")
            pack(:pack="sol.pack")
          td(v-else)
    // .ui.icon.labeled.button.floated.right.primary
    //   i.icon.refresh
    //   | refresh
</template>

<script>
require! {
  \debug
  \co
  \vue
  \prelude-ls : {Obj}
  \moment
  \../view
  \../format
  \../elements/pack-selector
  \../../actions : {check-response-errors}
}

log = debug \dollast:component:submission:list

get-form-values = (values) ->
  ret = Obj.reject (== ""), values
  if ret.threshold
    ret.threshold |>= parse-float
  if ret.before
    ret.before = new moment ret.before .value-of!
  if ret.after
    ret.after = new moment ret.after .value-of!
  return ret

set-form-values = (values) ->
  values = ^^values
  if values.before
    values.before = new moment values.before .format 'YYYY-MM-DD HH:mm:ss'
  if values.after
    values.after = new moment values.after .format 'YYYY-MM-DD HH:mm:ss'
  log 'setting form values', values
  $ \#submission .form 'set values', values

module.exports =
  vuex:
    actions:
      {check-response-errors}

  data: ->
    submissions: []
    languages: [\cpp, \java, \pas]
    query:
      page: 1

  route:
    data: co.wrap ->* 
      {query} = @$route
      if not query.pack
        query.pack = \0
      if query.page
        query.page |>= parse-int
      else
        query.page = 1
      if query.threshold
        query.threshold |>= parse-float
      if query.before
        query.before |>= parse-int
      if query.after
        query.after |>= parse-int

      @$next-tick ->
        set-form-values query

      {data: response} = yield @$http.get \submission, params: query
      if @check-response-errors response
        return null
      submissions = response.data

      {submissions, query}

  components:
    {view, pack-selector} <<< format
  
  methods:
    go: (page) ->
      @query.page = page
      @$route.router.go name: \submissions, query: @query

    clear: ->
      $ \#submission .form \clear

  ready: ->
    submit = co.wrap (e, values) ~>*
      values = get-form-values values
      log {values}
      @$route.router.go name: \submissions, query: values

    $ \#submission .form do
      inline: false
      on-success: submit
      on-failure: (errors, fields) ->
        log errors, fields
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
              prompt: "problem id must be a positive integer"
            ...
        pack:
          identifier: \pack
          optional: true
          rules:
            * type: "integer[0..]"
              prompt: "pack id must be a positive integer"
            ...
        language:
          identifier: \language
          optional: true
        before:
          identifier: \before
          optional: true
        after:
          identifier: \after
          optional: true

    $ '#relationship, #language, #search' .dropdown on: \hover
    if MathJax
      MathJax.Hub.Queue [\Typeset, MathJax.Hub]

</script>
