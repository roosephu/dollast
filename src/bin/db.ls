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
  for obj in [sol, rnd, prob, user]
    obj.get-current-user = ~>
      ctx.user
    obj.acquire-privilege = (priv) ~>
      log "checking privilege: #{priv}", ctx.user.priv
      if config.mode != "debug" and !ctx.user.priv[priv]
        ctx.throw 400, "failure on privilege checking, #priv required. "
    obj.throw = ctx.throw
