export class Err extends Error
  (@_id, @type, @detail) ->
    @name = \RuntimeError
    @re = true