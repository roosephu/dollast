require! {
  \koa-joi-router : {Joi}
  \debug
  \flat
  \sanitize-html
  \../../../common/judgers
  \../../models
  \../validator
}

log = debug \dollast:ctrl:problem:save

handler = ->*
  problem = @request.body

  if problem._id == void
    problem._id = yield models.problems.next-count!
    log "saving new problem using id #{problem._id}"

    # TODO: check whether user can create a problem here
  else

    existed = yield models.problems.find-by-id problem._id, \permit .exec!
    @assert existed, id: problem._id, type: \problem, detail: "cannot find the original problem"

    existed.permit.check-access @state.user, \w

    # TODO: check permit is not modified here
    # only owner can transfer owner

    # we are updating!
    problem |>= flat
    log {problem}

  yield models.problems.update _id: problem._id, problem, upsert: true .exec!
  @body = problem

module.exports = 
  method: \POST
  path: \/problem
  validate:
    type: \json
    body:
      _id: validator.problem!
      outlook:
        title: Joi .string! .min 1 .max 63
      config:
        stack-limit: Joi .number! .greater 0
        time-limit: Joi .number! .greater 0
        output-limit: Joi .number! .greater 0
        space-limit: Joi .number! .greater 0
        judger: Joi .string! .valid Object.keys judgers
      permit: validator.permit!
  handler: handler