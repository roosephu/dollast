require! {
  \react : {create-class}
  \../elements : {label-field, icon-text, icon-input}
  \react-redux : {connect}
  \immutable : I
  \../../actions : {on-get-round, on-add-prob-to-round}
}

log = debug \dollast:component:round:modify

selector = (state) ->
  round: state.get-in [\round, \update], I.Map do
    probs: []

module.exports = (connect selector) create-class do
  display-name: \rnd-modify

  component-will-mount: ->
    if @props.params.rid 
      @props.dispatch on-get-round @props.params.rid, \update, \total

  insert-prob: (pid) ->
    pid = parse-int pid
    if Number.is-integer pid
      @props.dispatch on-add-prob-to-round pid
      
  handle-input: (evt) ->
    #log evt
    if evt.which == 13
      @insert-prob evt.target.value
      evt.target.value = ''
  
  on-add-prob: ->
    $input = $ \#pid
    @insert-prob $input[0].value

  render: ->
    round = @props.round.to-JS!
    _ \div, class-name: "ui form segment", 
      _ \h1, class-name: "ui header dividing", "Round"
      _ \div, class-name: "ui fields three",
        _ label-field, text: \title,
          _ \div, class-name: "ui input",
            _ \input, name: \title
        _ label-field, text: "start from",
          _ \div, class-name: "ui input",
            _ \input, name: \begTime
        _ label-field, text: "end at",
          _ \div, class-name: "ui input",
            _ \input, name: \endTime
      _ \h2, class-name: "ui header dividing", \problemset
      _ \div, class-name: "ui two fields",
        _ \div, class-name: "field",
          _ \table, class-name: "ui table segment definition",
            _ \thead, null, 
              _ \tr, null, 
                _ \th, class-name: \collapsing, ""
                _ \th, null, \pid
            _ \tbody, null, 
              for prob in round.probs
                _ \tr, key: prob,
                  _ \td, null,
                    _ \div, class-name: "ui icon button",
                      _ \i, class-name: "icon mini remove"
                  _ \td, null, 
                    "#{prob._ \i,d}. #{prob.outlook.title}"
            _ \tfoot, null,
              _ \tr, null,
                _ \th, null, ""
                _ \th, null,
                  _ \div, class-name: "ui input action",
                    _ \input, name: \pid, id: \pid, on-change: @handle-input
                    _ icon-text,
                      class-name: "floated right"
                      icon: "chevron right"
                      text: \add
                      on-click: @on-add-prob

      _ \div, class-name: \field,
        _ icon-text,
          class-name: "floated right red"
          text: \delete
          icon: \delete
          on-click: @delete
        _ icon-text,
          class-name: "floated right secondary"
          text: \cancel
          icon: \cancel
        _ icon-text,
          class-name: "floated right primary"
          text: \save
          icon: \save
          on-click: @submit

      #.ui.input.action.left.icon
        #i.icon.tasks
        #input(type="number" ng-model="pid")
        #button.icon.labeled.right.purple.ui.button(ng-click="insert()") 
          #| insert
          #i.icon.chevron.right
