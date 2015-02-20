
export run = (lang, code) ->
  time: Math.random! * 2
  space: Math.random! * 128
  result: if Math.random! > 0.5 then "AC" else "WA"

export judge = (lang, code, time-lmt, space-lmt) ->
  
