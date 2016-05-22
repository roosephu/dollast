require! {
  \co
  \debug
  \./config
  \./models/solutions
  \./models/rounds
  \./models/problems
  \./models/users
  \./models/permit : {can-access}
}

log = debug \dollast:db

export solutions, rounds, problems, users

export bind-ctx = (ctx) ->
  ctx.acquire-privilege = (priv) ->
    log "checking privilege: #{priv}", ctx.state.user.priv
    for ids in priv.split " "
      if config.mode != "debug" and !ctx.state.user.priv[priv]
        throw new Error "failure on privilege checking, #priv required. "

  ctx.ensure-access = co.wrap (model, id, action) ->*
    resource = yield model.find-by-id _id, 'permit' .lean! .exec!
    log "asking for permissions #{resource.permit} in #{ctx.state.user} with action #{action}"
    if not can-access ctx.state.user, resource.permit, action
      throw new Error "error checking permissions"

  for obj in [solutions, rounds, problems, users]
    obj.get-current-user = ~>
      ctx.state.user
    obj.acquire-privilege = ctx.acquire-privilege
    obj.ensure-access = ctx.ensure-access
    obj.throw = ctx.throw
