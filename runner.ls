
export run = (lang, code) ->
  time: Math.random() * 2
  space: Math.random() * 128
  result: Math.random() > 0.5 ? "AC" : "WA"
