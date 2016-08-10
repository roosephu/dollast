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
    problem._id = yield models.Problems.next-count!
    log "saving new problem using id #{problem._id}"

    # TODO: check whether user can create a problem here

    problem.permit <<<< {parent-type: \Pack, parent-id: problem.config.pack}
  else

    existed = yield models.Problems.find-by-id problem._id, \permit .exec!
    yield @assert-exist existed, \w, problem._id, \Problem

    # TODO: check permit is not modified here
    # only owner can transfer owner
    delete problem.permit

    # we are updating!
    problem |>= flat
    log {problem}

  yield models.Problems.update _id: problem._id, problem, upsert: true .exec!
  @body = problem

module.exports = 
  method: \POST
  path: \/problem
  validate:
    type: \json
    body:
      _id: validator.problem!.optional!
      outlook:
        title: Joi .string! .min 1 .max 63
        description: Joi .string! .min 1 .max 65535
        sample-input: Joi .string! .min 1 .max 65535
        sample-output: Joi .string! .min 1 .max 65535
        input-format: Joi .string! .min 1 .max 65535
        output-format: Joi .string! .min 1 .max 65535
      config:
        pack: validator .pack!
        stack-limit: Joi .number! .greater 0
        time-limit: Joi .number! .greater 0
        output-limit: Joi .number! .greater 0
        space-limit: Joi .number! .greater 0
        judger: Joi .string! .valid Object.keys judgers
      permit: validator.permit!
  handler: handler
