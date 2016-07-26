class Err extends Error
  (_id, type, detail) ->
    @name = \RuntimeError
    @re = true
    @error = {_id, type, detail}

module.exports = 
  assert: (statement, _id, type, detail) ->
    if !statement
      throw new Err _id, type, detail