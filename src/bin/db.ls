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
      log "checking privilege: #{priv}"
      if config.mode != "debug" and !ctx.session.priv[priv]
        ctx.body = status: "failure on privilege checking, #priv required. "
        ctx.throw 403, "unauthorized: #priv required. "
    obj.throw = ctx.throw
