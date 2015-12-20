require! {
  \./custom
  \co
  \redux
  \react/addons : {render}
  \react-router : {Router}
  \react-redux : {Provider}
  \redux-devtools/lib/react : {DevTools, DebugPanel, LogMonitor}
  \./components/routes
  \./components/app
  \./store : {configure-store}
  \./actions
}

log = debug 'dollast:app'

store = configure-store!
render do
  _div null, 
    _ Provider, store: store, ->
      _ Router, null,
        routes app
    _ DebugPanel, top: true, right: true, bottom: true,
      _ DevTools, store: store, monitor: LogMonitor
  document.get-element-by-id \content
