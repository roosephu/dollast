require! {
  \react/addons : {create-class}
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
    _div class-name: "ui form segment", 
      _h1 class-name: "ui header dividing", "Round"
      _div class-name: "ui fields three",
        _ label-field, text: \title,
          _div class-name: "ui input",
            _input name: \title
        _ label-field, text: "start from",
          _div class-name: "ui input",
            _input name: \begTime
        _ label-field, text: "end at",
          _div class-name: "ui input",
            _input name: \endTime
      _h2 class-name: "ui header dividing", \problemset
      _div class-name: "ui two fields",
        _div class-name: "field",
          _table class-name: "ui table segment definition",
            _thead null, 
              _tr null, 
                _th class-name: \collapsing, ""
                _th null, \pid
            _tbody null, 
              for prob in round.probs
                _tr key: prob,
                  _td null,
                    _div class-name: "ui icon button",
                      _i class-name: "icon mini remove"
                  _td null, 
                    "#{prob._id}. #{prob.outlook.title}"
            _tfoot null,
              _tr null,
                _th null, ""
                _th null,
                  _div class-name: "ui input action",
                    _input name: \pid, id: \pid, on-change: @handle-input
                    _ icon-text,
                      class-name: "floated right"
                      icon: "chevron right"
                      text: \add
                      on-click: @on-add-prob

      _div class-name: \field,
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
