require! {
  \../../config : {prob-list-opts}
  \../../models
}

handler = ->*
  opts = prob-list-opts
  @body = yield models.problems
    .find {}, \outlook.title # "config.pack": $exists: true,
    .skip opts.skip
    .limit opts.limit
    .exec!
  # log \problem-list, @body

module.exports = 
  method: \GET
  path: \/problem
  handler: handler
