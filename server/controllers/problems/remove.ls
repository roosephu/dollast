require! {
  \../../models
  \../validator
}

handler = ->*
  ...

module.exports = 
  method: \DELETE
  path: \/problem/:problem
  validate:
    params:
      problem: validator.problem!
  handler: handler