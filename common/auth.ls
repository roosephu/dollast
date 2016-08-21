require! {
  \jsrsasign : {jws}
}

export decode = (token) ->
  if not token
    return null
  console.log jws
  if not jws.JWS.verify-JWT token, config.jwt.key, alg: [config.jwt.alg]
    return null
  {payload-obj: payload} = jws.JWS.parse token
  
  payload