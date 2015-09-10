
export merge-prop = (x, y) ->
  x = {} with x
  for key, val of y
    if x[key]
      x[key] = "#{x[key]} #{val}"
    else
      x[key] = val
    # console.log key, val
  # console.log "merge", x, y
  x

export get-attr = (x, attrs) ->
  z = {}
  for attr in attrs
    if x[attr]
      z[attr] = x[attr]
  # console.log x, attrs, z
  z

export add-attr = (x, y, attrs) ->
  merge-prop x, get-attr y, attrs

export add-class-name = (obj, class-name) ->
  merge-prop obj, class-name: class-name
  # console.log "1", obj
  # obj = {} with obj
  # console.log "2", obj
  # return obj if !class-name
  # if !obj.class-name
  #   obj with class-name: class-name
  # else
  #   obj with class-name: obj.class-name + " " + class-name

export to-server-fmt = (obj) ->
  outlook = obj{title, desc, in-fmt, out-fmt, sample-in, sample-out}
  config  = obj{rid, judger, time-lmt, space-lmt, out-lmt, stk-lmt}
  {outlook, config}

export flatten-object = (obj) ->
  ret = {}
  for key, val of obj
    if 'object' == typeof val
      ret <<< flatten-object val
    else
      ret[key] = val
  ret
