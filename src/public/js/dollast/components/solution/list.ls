require! {
  \react : {create-class}
  \react-redux : {connect}
  \../elements : {icon-text}
  \../format : {code-link, prob-link, user-link, rnd-link}
  \../../actions : {on-get-solutions-list}
  \immutable : I
}

log = debug \dollast:component:solution:list

selector = (state) ->
  sols: state.get-in [\db, \solution, \get], I.from-JS []

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
            _ \tr, class-name: \red, key: sol._id,
              _ \td, null,
                _ code-link, sid: sol._id
              _ \td, null,
                _ prob-link, {sol.prob}
              _ \td, null,
                _ user-link, user: sol.user
              _ \td, null, sol.final.status
              _ \td, null, sol.final.score
              _ \td, null, sol.final.time
              _ \td, null, sol.final.space
              _ \td, null, sol.lang
              _ \td, null,
                if sol.round?
                  _ rnd-link, rnd: sol.round, no-title: true
                else
                  null
      _ icon-text,
        class-name: "floated right primary"
        text: \refresh
        icon: \refresh
        on-click: @refresh
