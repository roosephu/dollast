require! {
  "debug"
  "./config"
  "./models/sol"
  "./models/rnd"
  "./models/prob"
  "./models/user"
}

log = debug "dollast:db"

export sol, rnd, prob, user

export bind-ctx = (ctx) ->
  ctx.acquire-privilege = (priv) ->
    log "checking privilege: #{priv}", ctx.user.priv
    for ids in priv.split " "
      if config.mode != "debug" and !ctx.user.priv[priv]
        throw new Error "failure on privilege checking, #priv required. "

  for obj in [sol, rnd, prob, user]
    obj.get-current-user = ~>
      ctx.user
    obj.acquire-privilege = ctx.acquire-privilege
    obj.throw = ctx.throw
