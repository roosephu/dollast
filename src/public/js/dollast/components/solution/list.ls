require! {
  \react/addons : {create-class}
  \react-redux : {connect}
  \../elements : {icon-text}
  \../../actions : {on-get-solutions-list}
  \immutable : I
}

selector = (state) ->
  sols: state.get-in [\solution, \list], I.from-JS []

module.exports = (connect selector) create-class do
  display-name: \sol-list

  component-will-mount: ->
    @props.dispatch on-get-solutions-list!
  
  render: ->
    sols = @props.sols.to-JS!
    
    _div null, 
      _h1 class-name: "ui dividing header", \status
      _table class-name: "ui table segment large green selectable", 
        _thead null, 
          _tr null,
            _th class-name: "collapsing right", "sol id"
            _th null, \problem
            _th null, \user
            _th null, \status
            _th null, \score
            _th null, "time(s)"
            _th null, "space(MB)"
            _th class-name: "collapsing", \lang
            _th class-name: "collapsing", \round
        _tbody null,
          for sol in sols
            _tr class-name: \red, key: sol._id, 
              _td null, 
                _ icon-text,
                  class-name: "mini green",
                  icon: \code
                  text: sol._id
                  href: "#/solution/#{sol._id}"
              _td null,
                _a href: "#/problem/#{sol.prob._id}", "#{sol.prob._id}. #{sol.prob.outlook.title}"
              _td null, 
                _a href: "#/user/#{sol.user}", sol.user
              _td null, sol.final.status
              _td null, sol.final.score
              _td null, sol.final.time
              _td null, sol.final.space
              _td null, sol.lang
              _td null, sol.round?._id
      _ icon-text, 
        class-name: "floated right primary"
        text: \refresh
        icon: \refresh
        on-click: @refresh
