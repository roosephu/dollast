require! {
  \./custom
  \co
  \redux
  \react-dom : {render}
  \react-router : {Router}
  \react-redux : {Provider}
  \./components/routes
  \./components/app
  \./components/devtools
  \./store : {configure-store}
  \./actions
}

log = debug 'dollast:app'

store = configure-store!
render do
  _ \div, null,
    _ Provider, store: store,
      _ \div, null,
        _ Router, null,
          routes app
        _ devtools
  document.get-element-by-id \content
