require! {
  \../../models
}

handler = ->*
  ...

module.exports = 
  method: \DELETE
  path: \/problem/:problem
  handler: handler