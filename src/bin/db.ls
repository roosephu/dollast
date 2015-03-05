require! {
  "debug"
  "./models/sol"
  "./models/rnd"
  "./models/prob"
  "./models/user"
}

log = debug "db"

export sol, rnd, prob, user

export bind-ctx = (ctx) ->
  for obj in [sol, rnd, prob, user]
    obj.get-current-user = ~>
      ctx.session.passport
    obj.acquire-privilege = (priv) ~>
      log "checking privilege: #{priv}"
      if !ctx.session.priv[priv]
        ctx.body = status: "failure on privilege checking, #priv required. "
        throw new Error "unauthorized: #priv required. "
