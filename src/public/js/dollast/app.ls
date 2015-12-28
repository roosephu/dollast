require! {
  \./custom
  \co
  \redux
  \react : {create-class}
  \react-dom : {render}
  \react-router : {Router}
  \react-redux : {Provider}
  # \history : {create-history}
  # \redux-simple-router : {sync-redux-and-router}
  \./components/routes
  \./components/app
  \./components/devtools
  \./store : {configure-store}
  \./actions
}

log = debug 'dollast:app'

store = configure-store!

# history = create-history!
# sync-redux-and-router history, store

render do
  _ \div, null,
    _ Provider, store: store,
      _ \div, null,
        _ Router, null,
          routes app
        _ devtools
  document.get-element-by-id \content
