require! {
  \co
  \debug
  \./config
  \./models/sol
  \./models/rnd
  \./models/prob
  \./models/user
  \./models/permit : {can-access}
}

log = debug \dollast:db

export sol, rnd, prob, user

export bind-ctx = (ctx) ->
  ctx.acquire-privilege = (priv) ->
    log "checking privilege: #{priv}", ctx.state.user.priv
    for ids in priv.split " "
      if config.mode != "debug" and !ctx.state.user.priv[priv]
        throw new Error "failure on privilege checking, #priv required. "

  ctx.ensure-access = co.wrap (model, id, action) ->*
    resource = yield model.find-by-id _id, 'permit' .lean! .exec!
    log "asking for permissions #{resource.permit} in #{ctx.state.user} with action #{action}"
    if not can-access ctx.state.suer, resource.permit, action
      throw new Error "error checking permissions"

  for obj in [sol, rnd, prob, user]
    obj.get-current-user = ~>
      ctx.state.user
    obj.acquire-privilege = ctx.acquire-privilege
    obj.ensure-access = ctx.ensure-access
    obj.throw = ctx.throw
