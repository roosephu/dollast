class Err extends Error
  (_id, type, detail, field) ->
    @name = \RuntimeError
    @re = true
    @error = {_id, type, detail, field}

module.exports = 
  assert: (statement, _id, type, detail, field) ->
    if !statement
      throw new Err _id, type, detail, field