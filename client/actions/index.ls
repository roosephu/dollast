require! {
  \vue
  \co
  \debug
  \prelude-ls : {group-by}
  \../store
}

log = debug \dollast:actions

export login = ({dispatch}) ->
  if local-storage.token
    dispatch \login, local-storage.token

export logout = ({dispatch}) ->
  delete local-storage.token
  dispatch \logout

export raise-error = ({dispatch}, response, closable) ->
  log \raise, {response}
  error = response.errors[0]
  if closable
    error.closable = true
  dispatch \raiseError, error

export check-response-errors = ({dispatch}, response, $form) ->
  return false unless response.errors
  {name, details} = response.errors[0]
  switch name
    | \ValidationError =>
      $form.form 'add errors', [""]
      for error in details
        $form.form 'add prompt', error.path, error.message 

    | \PermissionDenied =>
      dispatch \raiseError, 
        object: "Permission"
        message: "user `#{details.user}` cannot perform action `#{details.action}` on document #{details.type}. #{details._id} whose permission is {#{details.doc.owner}, #{details.doc.group}, #{details.doc.access}}"

    | \LoginError =>
      $form.form 'add errors', [""]
      $form.form 'add prompt', \password, "wrong username/password combination"

    | \Nonexistence => 
      dispatch \raiseError,
        object: \Existence
        message: "document #{details.type}. #{details._id} doesn't exist"

    | _ =>
      dispatch \raiseError,
        object: "#{name} (unknown)"
        message: JSON.stringify details
  true

export resolve-error = ({dispatch}) ->
  dispatch \resolveError
