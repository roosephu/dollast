require! {
  \vue : {default: vue}
  \axios
  \debug
  \./auth
}

log = debug \dollast:mutations

export login = (state, token) ->
  if not token
    {token} = local-storage
  return if not token

  payload = auth.jwt.dec token
  client-info = JSON.parse payload.client
  local-storage.token = token
  axios.defaults.headers.common.Authorization = "Bearer #{token}"
  vue.set state, \session,
    guest: false
    user: client-info.user
    token: token

export logout = (state) ->
  delete local-storage.token
  axios.defaults.headers.common.Authorization = ""
  vue.set state, \session, guest: true

export resolve-error = (state) ->
  vue.set state, \error, void

export wait-for = (state, progress) ->
  vue.set state, \isLoading, progress

export raise-error = (state, {response, closable}) ->
  log \raise, {response}
  error = response.errors[0]
  if closable
    error.closable = true
  vue.set state, \error, error

export check-response-errors = (state, {response, $form}) ->
  return unless response?.errors?
  if $form
    $form.form 'add errors', []

  {name, details} = response.errors[0]
  switch name
    | \ValidationError =>
      if $form
        for error in details
          $form.form 'add prompt', error.path, error.message

    | \PermissionDenied =>
      if $form
        $form.form 'add errors', ["Permission denied"]

      vue.set state, \error,
        object: "Permission"
        message: "user `#{details.user}` cannot perform action `#{details.action}` on document #{details.type}. #{details._id} whose permission is {#{details.doc.owner}, #{details.doc.group}, #{details.doc.access}}"

    | \LoginError =>
      if $form
        # $form.form 'add errors', [""]
        $form.form 'add prompt', \password, "wrong username/password combination"

    | \Nonexistence =>
      log \???
      vue.set state, \error,
        object: \Existence
        message: "document #{details.type}. #{details._id} doesn't exist"

    | _ =>
      vue.set state, \error,
        object: "#{name} (unknown)"
        message: JSON.stringify details
