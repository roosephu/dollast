require! {
  \koa-joi-router : {Joi}
  \../../config : {prob-list-opts}
  \../../../common/options
  \../../models
  \../validator
}

handler = async (ctx) ->
  opts = prob-list-opts
  ctx.body = await models.Problems
    .find {}, \outlook.title # "config.round": $exists: true,
    .skip opts.skip
    .limit opts.limit
    .exec!
  # log \problem-list, ctx.body

module.exports =
  method: \GET
  path: \/problem
  handler: handler
