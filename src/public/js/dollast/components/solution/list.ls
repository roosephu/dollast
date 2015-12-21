require! {
  \react : {create-class}
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
    
    _ \div, null, 
      _ \h1, class-name: "ui dividing header", \status
      _ \table, class-name: "ui table segment large green selectable", 
        _ \thead, null, 
          _ \tr, null,
            _ \th, class-name: "collapsing right", "sol id"
            _ \th, null, \problem
            _ \th, null, \user
            _ \th, null, \status
            _ \th, null, \score
            _ \th, null, "time(s)"
            _ \th, null, "space(MB)"
            _ \th, class-name: "collapsing", \lang
            _ \th, class-name: "collapsing", \round
        _ \tbody, null,
          for sol in sols
            _ \tr, class-name: \red, key: sol._ \i,d, 
              _ \td, null, 
                _ icon-text,
                  class-name: "mini green",
                  icon: \code
                  text: sol._ \i,d
                  href: "#/solution/#{sol._ \i,d}"
              _ \td, null,
                _ \a, href: "#/problem/#{sol.prob._ \i,d}", "#{sol.prob._ \i,d}. #{sol.prob.outlook.title}"
              _ \td, null, 
                _ \a, href: "#/user/#{sol.user}", sol.user
              _ \td, null, sol.final.status
              _ \td, null, sol.final.score
              _ \td, null, sol.final.time
              _ \td, null, sol.final.space
              _ \td, null, sol.lang
              _ \td, null, sol.round?._ \i,d
      _ icon-text, 
        class-name: "floated right primary"
        text: \refresh
        icon: \refresh
        on-click: @refresh
